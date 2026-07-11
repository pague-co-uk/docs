# SMS gateway — component design

## Ground rule: single writer principle

The most important architectural decision here is **who is allowed to write to the database**. With portal, two API services, N consumers, a DLQ consumer, and an SMPP server all in play, it's easy to end up with several things writing to `messages`, `clients`, and `float_ledger` and no single source of truth for business rules (float deduction, refunds, status transitions).

**Only the two API services ever touch the database.** Nothing else does — not the MNO consumers, not the status-update consumer, not the dead-letter consumer, not the SMPP server. Each of those calls one of the two APIs, which perform the actual write:

- **Control-plane API** — sole writer for clients, users, API keys, SMPP accounts, and the float ledger.
- **Ingestion API** — sole writer for messages and message status, via an internal status-update endpoint that the status-update consumer calls (not a direct DB write).

The status-update consumer, dead-letter consumer, and every MNO consumer are all, in this sense, just API clients — none of them holds a DB connection.

---

## 1. Portal (Next.js)

**Responsibilities:** admin/client-facing UI only. No direct DB access — everything goes through the control-plane API's admin/reporting endpoints.

- **Two views, one app:**
  - _Platform admin_ view — create clients, assign float, create SMPP accounts, view all-client stats.
  - _Client self-service_ view — a client's own users, API keys, usage, message logs. Same components, scoped by role.
- **Auth:** portal users (admin staff and client staff) log in against the control-plane API's session/JWT endpoint. Uses httpOnly, secure cookies for session tokens — never store tokens in localStorage. CSRF protection on top since cookies are involved.
- **Data fetching:** server components fetch on page load for initial render (dashboards, tables); client-side polling or SSE/WebSocket for live-updating stats (messages sent today, current float balance, queue health) so the admin isn't manually refreshing.
- **RBAC in the UI:** don't just hide buttons — the API must independently enforce that a client-scoped token can never read another client's data. The UI hiding elements is a UX nicety, not a security boundary.
- **Reporting queries hit pre-aggregated data, not raw messages.** At any real volume, "messages sent this month by client X" run against a raw `messages` table gets slow fast — served from the rollup tables the control-plane API's reporting module maintains.
- **Audit trail visibility:** admins assigning float or generating API keys is sensitive — the portal shows an audit log (who did what, when) for these actions, not just performs them.

---

## 2. Control-plane API (NestJS)

Used by the portal. Owns clients, users, float, API keys, SMPP accounts, and reporting.

- **Auth module:** issues sessions/JWTs for portal users; issues and validates API keys for client-side message submission. API keys stored hashed (never plaintext), scoped to a client, with rotation and revocation support.
- **User & client management:** CRUD for clients, portal users, roles (platform admin / client admin / client user).
- **Float / billing module:**
  - **Ledger table** (append-only debit/credit entries), not a mutable balance column — a mutable balance invites race conditions under concurrent sends and makes disputes impossible to audit.
  - **Debit at submission** (optimistic), with automatic **refund on permanent failure** (invalid number, blocked content) — decided in favor of this over charging only on confirmed delivery, since the alternative extends unbounded credit while a message sits in a queue.
  - Atomic decrement with a floor check (`balance - cost >= 0`) to prevent overspend from concurrent requests.
- **SMPP account management:** creating an SMPP client account here is only half the job. On create/update/revoke, the account is pushed to a **shared Redis cache** that the SMPP server reads from directly — the SMPP server never calls the control-plane API on bind, so bind auth has no dependency on API uptime.
- **Reporting module:** serves the portal's dashboards from pre-aggregated rollup tables (per client, per hour/day: sent, delivered, failed, cost), populated by a scheduled aggregation job — never computed live from raw message rows.
- **Audit logging:** a dedicated `audit_log` table records every admin mutation (float assignment, client/user creation, API key issuance/revocation), in addition to structured application logs. The audit table is the source of truth for disputes; app logs are for debugging.

---

## 3. Ingestion API (NestJS)

Used by clients (HTTP + SMPP path) submitting messages. Deployed independently from the control-plane API so ingestion's bursty, high-volume traffic can scale separately from portal/admin traffic.

- Validate the request (number format, length, sender ID).
- **Idempotency:** the client-supplied message ID is the idempotency key. If that message ID has already been pushed and delivered, it is not redelivered.
- **Rate limiting:** per-client, enforced via a Redis token bucket. The intent is that a client's effective limit never exceeds the lowest MNO-side rate limit relevant to their traffic mix
- Debit float (via the control-plane's ledger ).
- Persist the message record (status: `queued`).
- Determine route via the routing/rules engine (cost, failover, MNO capacity) and publish to the **specific queue for that aggregator/MNO**.
- Return `202 Accepted` with the message ID immediately.

---

## 4. Consumers (one per aggregator/MNO queue)

- Each consumer binds to exactly one destination queue and knows how to talk to exactly one aggregator/MNO (HTTP aggregator API, or Kannel SMPP bind for MNOs).
- **Retry policy:** exponential backoff with jitter, capped attempt count, and failure classification (transient vs permanent) decided at the point of failure — a timeout or 5xx is transient, a rejected/invalid-number response is permanent and skips straight to dead-letter rather than retrying.
- **Consumers never write to the database and hold no DB connection.** They publish a status event (`delivered`, `failed-transient`, `failed-permanent`, with attempt count and error detail) to a status queue. The status-update consumer picks this up and calls the Ingestion API to persist it — the API is what decides what the status change _means_ (triggering a float refund, incrementing a rollup counter, firing a client webhook), not the consumer. Skipping this and letting consumers touch the DB directly would eventually duplicate that business logic in every consumer and risk inconsistent message statuses.
- **Per-MNO rate limiting** sits here too, protecting the SMPP bind from being throttled or dropped by the operator — a second, separate layer from the per-client limiting at the ingestion API.
- Emit per-consumer metrics: throughput, latency to aggregator, error rate, current bind status (for the SMPP/Kannel consumers specifically).

---

## 5. Status-update consumer

- Consumes the status queue populated by every MNO consumer.
- **Holds no DB connection of its own.** For each event, it calls an internal status-update endpoint on the **Ingestion API** (e.g. `PATCH /internal/messages/:id/status`), which performs the actual write and updates rollup counters.
- For permanent failures, either this consumer or the Ingestion API's status-update handler triggers the hand-off to the dead-letter consumer — pick one place for that decision and keep it consistent, since having both check for it risks double-handling.
- This endpoint being internal-only (not exposed to clients) matters: it should be reachable only from inside the private network/service mesh, not through the public-facing ingestion surface.

---

## 6. Dead-letter consumer

- Handles genuinely exhausted or permanent failures only (transient retries happen inside each MNO consumer first).
- Like every other consumer, it holds no DB connection — every write happens through one of the two APIs.
- Responsibilities:
  1. Call the Ingestion API to record the final failure reason against the message.
  2. Trigger the **float refund** for permanent failures, via the control-plane API, keeping the ledger as the single source of truth.
  3. Send the client webhook **once, best-effort** — no retry loop on the callback itself. If it fails, call the Ingestion API to mark the message as notification-failed; the client can poll a status endpoint later once they're back online. This state is surfaced in the portal so it's visible even if the client never checks.
  4. Feed the alerting pipeline — a spike in DLQ arrivals for one MNO route is one of the earliest signals that a bind or aggregator is down.

---

## Cross-cutting decisions

- **Caching layer:** Redis, used for API key validation, float balance reads, SMPP credential lookups, and rate-limit counters.
- **Multi-tenancy:** every non-global table (`messages`, `api_keys`, `smpp_accounts`, `float_ledger`, etc.) carries `client_id`, enforced at the API layer — never trusted from the client.
- **Rollups:** scheduled aggregation jobs (hourly is typically enough) pre-compute per-client, per-route stats so portal dashboards stay fast regardless of raw message volume.

---

## Additional decisions

- **Idempotency boundary state:** If a message exists and not in a failed-terminal state → do not re-enqueue, return the existing status. A message ID that's queued or mid-attempt is treated the same as one already delivered — the client gets the current status back rather than triggering a second send.
- **Rate limit vs MNO limit reconciliation:** each client gets a predefined rate limit set at account creation (starting conservative, ≤ the lowest relevant MNO ceiling). No dynamic per-route calculation for now. This also opens a natural monetization path later — a client needing a higher limit than their default can be offered a paid tier for it, rather than this being purely an engineering constraint.
- **Control-plane / ingestion float boundary:** the ledger keeps no running balance column at all — balance is always derived by summing transactions. To keep the debit path fast, an aggressively cached derived balance sits in Redis: read from cache for the pre-debit check, write the new transaction to the ledger, update the cache. A periodic reconciliation job re-sums the ledger and corrects the cache if it's ever drifted, so the cache is an accelerator, not a second source of truth — the ledger's transaction log remains the only thing that's actually authoritative.
