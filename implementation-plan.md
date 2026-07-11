# SMS gateway — implementation plan

This plan builds the system described in `sms-gateway-architecture.md`, phase by phase. Each phase produces something runnable end-to-end, even if narrow, rather than building all components halfway in parallel. Later phases assume earlier ones are stable. Two people can work in parallel from Phase 3 onward — see sequencing notes at the end.

**Core rule carried through every phase:** only two services ever hold a database connection — the **control-plane API** (clients, users, API keys, SMPP accounts, float ledger) and the **ingestion API** (messages, message status, via an internal endpoint). Every consumer, the dead-letter consumer, the SMPP server, and the portal are all API clients, never direct DB clients.

---

## Phase 0 — Foundations

- Provision the database, Redis, and the queue/broker (RabbitMQ or BullMQ-on-Redis are the common low-friction choices at this scale).
- Set up OTel SDK wiring in a shared internal package so every NestJS/Node service bootstraps telemetry the same way from day one — retrofitting this later across 6+ services is painful.
- Stand up the OTel Collector plus a chosen backend (SigNoz or the Grafana OSS stack), even minimally, so there's visibility from the first deployed service onward.
- Define the core schema. Every non-global table carries `client_id`.
  - `clients`, `users`, `api_keys`, `smpp_accounts`
  - `float_ledger` — **append-only transactions only, no stored balance column.** Balance is always derived by summing entries.
  - `messages`, `message_status_events`
  - `audit_log`, `rollup_stats`
- Set up the Redis-cached derived float balance (per client) alongside the ledger table, plus a scheduled reconciliation job that re-sums the ledger and corrects the cache if it drifts. Build this now, not as an afterthought in Phase 3 — it's load-bearing for every debit from day one of ingestion.

**Milestone:** infrastructure, schema, and telemetry are live; a manual script can write a ledger transaction and confirm the cached balance and the summed balance agree.

---

## Phase 1 — Control-plane API

- Auth module: portal user login (JWT/session), API key issuance/validation, hashed storage, rotation/revocation.
- Client & user CRUD, roles (platform admin / client admin / client user).
- Float ledger: balance reads (from cache, falling back to summed ledger), manual top-up (admin-assigned) as ledger entries. No automated debit/refund yet — that's ingestion's job, starting Phase 3.
- SMPP account CRUD, with create/update/revoke pushing the credential to the shared Redis cache the SMPP server will read from (built in Phase 6, but the push logic belongs here).
- Audit logging wired into every admin mutation from the start — don't bolt this on later.

**Milestone:** an admin can log in, create a client with a predefined rate limit, create a user, assign float, and generate an API key — all visible in the audit log, and the balance read reflects the cache-plus-ledger design.

---

## Phase 2 — Portal (thin slice against control-plane)

- Admin login, client list/detail, float assignment UI, user management, API key generation UI.
- Audit log viewer.

**Milestone:** the whole "operate the platform" workflow works end-to-end without any message sending existing yet.

---

## Phase 3 — Ingestion API + one MNO route

- Message submission endpoint:
  - Validate the request (format, length, sender ID).
  - **Idempotency check:** if the message ID exists and is not in a failed-terminal state — queued, mid-attempt, or already delivered — do not re-enqueue; return the existing status.
  - **Rate limit check** against the client's predefined limit (Redis token bucket).
  - Debit float against the cached derived balance, write the ledger transaction.
  - Persist the message as `queued`, publish to a single hardcoded queue.
- Build the **internal status-update endpoint** on the ingestion API now (e.g. `PATCH /internal/messages/:id/status`) — this is what every consumer will call instead of touching the DB. Network-isolate it from the public submission endpoints; it should only be reachable from inside the service network, never from a client API key.
- One consumer for one aggregator/MNO — pick the simplest integration first (the HTTP aggregator, not Kannel/SMPP, to avoid two new integrations at once). It holds no DB connection; on success or failure it publishes a status event.
- Build the **status-update consumer**: consumes the status queue, calls the internal ingestion API endpoint above. It also holds no DB connection of its own.

**Milestone:** a client can submit a message and see it delivered end-to-end through one real aggregator, with status correctly persisted via the status-update consumer calling the ingestion API — confirm this by inspecting logs/traces that no service other than the two APIs ever issues a DB write.

---

## Phase 4 — Retry, dead-letter, and refund

- Add backoff-with-jitter retry inside the consumer, with transient/permanent failure classification.
- Build the dead-letter consumer. Like every other consumer, it calls APIs rather than writing directly:
  - Calls the ingestion API to record the final failure reason.
  - Calls the control-plane API to trigger the float refund for permanent failures.
  - Sends the client webhook **once, best-effort** — no retry loop on the callback itself.
  - On webhook failure, calls the ingestion API to mark the message notification-failed.
- Add the client-facing status-polling endpoint, for when the webhook failed or the client was offline.

**Milestone:** inject a deliberate permanent failure (bad number) and a deliberate transient failure (mock timeout); confirm refund, single-attempt webhook, and polling all behave as designed, and confirm the float cache and ledger sum still agree after the refund.

---

## Phase 5 — Routing engine + additional MNO routes

- Add the second aggregator/MNO route and the routing/rules engine that picks between them (cost, failover, capacity).
- Add the Kannel SMPP client to MNO here — a genuinely different integration shape than the HTTP aggregator path.
- Add per-MNO rate limiting at the consumer/Kannel layer, separate from the per-client limiting already live at the ingestion API.

**Milestone:** messages route correctly across at least two real destinations, and a simulated MNO outage correctly fails over.

---

## Phase 6 — Client-facing SMPP ingestion

- Build the standalone Node SMPP server.
- Confirm it authenticates binds against the Redis credential cache only — it should never call the control-plane API directly at bind time, so SMPP ingestion has no dependency on API uptime.

**Milestone:** an external SMPP client can bind, submit, and receive delivery reports through the same pipeline as the HTTP path.

---

## Phase 7 — Reporting and polish

- Rollup/aggregation jobs and the reporting endpoints they feed on the control-plane API.
- Portal: usage dashboards, message logs, per-client stats — now backed by real data from Phases 3–6.
- Confirm each client's predefined rate limit is visible and adjustable from the admin portal, with a note in the UI that higher limits are available as a paid tier (the monetization path decided earlier, even if billing for it isn't built yet).

**Milestone:** the portal shows accurate, fast usage dashboards under realistic message volume, not just the admin CRUD screens from Phase 2.

---

## Phase 8 — Hardening

- Load test the ingestion path specifically — this is where bursty client traffic and the float cache/ledger path will find weaknesses first.
- Chaos-test the dead-letter and retry paths (kill an aggregator mid-flight, saturate a queue).
- Deliberately desync the float cache from the ledger sum and confirm the reconciliation job corrects it within its scheduled interval.
- Confirm alerting fires correctly on DLQ spikes and SMPP bind drops, not just that dashboards look right.
- Security review: API key handling, rate-limit bypass attempts, multi-tenancy isolation (verify a client token genuinely cannot read another client's data), and confirm the internal status-update endpoint is unreachable from outside the service network.

---

## Sequencing notes

- The control-plane/ingestion split (Phase 1 vs Phase 3) means two people can work in parallel from Phase 3 onward — one on ingestion, consumers, and the status-update path; one on portal and reporting — without stepping on each other, since they share a schema but not a deployable.
- Don't build the SMPP server (Phase 6) before the HTTP-aggregator path (Phases 3–4) is solid. It's a second, different integration surface, and the retry/DLQ/refund pattern should be proven once before a second ingestion channel exercises it differently.
- Telemetry (Phase 0), audit logging (Phase 1), and the float reconciliation job (Phase 0) are the three things most commonly deferred under deadline pressure and most painful to retrofit. Resist skipping them for "just get something working" reasons — the reconciliation job in particular is what keeps the derived-balance cache trustworthy once real traffic starts hitting it.
