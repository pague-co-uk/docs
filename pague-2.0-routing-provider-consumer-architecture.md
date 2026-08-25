# Pague 2.0 — Asynchronous Routing and Provider Consumer Architecture

**Status:** Locked
**Purpose:** Canonical architecture decision for message routing, provider isolation, failover, and asynchronous service communication.

## 1. Architectural Decision

Pague 2.0 will use a fully asynchronous, message-driven architecture for SMS delivery.

The system separates:

1. **Control Plane API** — accepts and manages messages and configuration.
2. **Outbox Publisher** — publishes transactional outbox events to RabbitMQ.
3. **Routing Service** — determines which provider route should handle a message.
4. **Provider-specific Consumer Applications** — one standalone application per provider/integration.
5. **RabbitMQ** — asynchronous communication layer between applications.
6. **MySQL** — authoritative source of message routing and delivery state.

The architecture is intentionally designed so that failure of one provider application does not affect other providers.

## 2. High-Level Architecture

```text
                         CONTROL PLANE API
                               │
                               │ DB transaction
                               ▼
                         MySQL / Outbox
                               │
                         PENDING event
                               │
                               ▼
                     ┌──────────────────┐
                     │ Outbox Publisher │
                     │   Standalone     │
                     └────────┬─────────┘
                              │
                              ▼
                           RabbitMQ
                              │
                         sms.queued
                              │
                              ▼
                    ┌────────────────────┐
                    │  Routing Service   │
                    └─────────┬──────────┘
                              │
                     routing decision
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
 sms.route.airtel       sms.route.tnm       sms.route.onfon
          │                   │                   │
          ▼                   ▼                   ▼
 Airtel Consumer         TNM Consumer        Onfon Consumer
          │                   │                   │
         SMPP                SMPP                HTTP
          │                   │                   │
       Airtel                TNM               Onfon
```

Additional providers, such as Africa's Talking, receive their own queue and their own standalone consumer application.

## 3. Provider Isolation

Every provider/integration gets its own application.

Examples:

```text
airtel-malawi-consumer
tnm-malawi-consumer
onfon-consumer
africas-talking-consumer
```

The transport mechanism does **not** determine application boundaries.

```text
Airtel Malawi      → SMPP → airtel-malawi-consumer
TNM Malawi         → SMPP → tnm-malawi-consumer
Onfon              → HTTP → onfon-consumer
Africa's Talking   → HTTP → africas-talking-consumer
```

Even when two providers use the same protocol, they remain separate applications.

### Reason

Provider-specific applications provide:

- Failure isolation
- Independent deployment
- Independent restart/recovery
- Provider-specific configuration
- Provider-specific protocol behavior
- Provider-specific error handling
- Independent connection pools
- Independent telemetry
- No provider-specific conditionals inside a generic consumer

A failure in Airtel must not bring down TNM, Onfon, or Africa's Talking.

## 4. Responsibilities

### 4.1 Control Plane API

The Control Plane is responsible for:

- Authentication and authorization
- Client management
- Message creation
- Float management
- Message persistence
- Transactional outbox creation
- Connector configuration
- Route configuration
- MNO configuration
- Route priorities

The Control Plane does **not** publish outbox events to RabbitMQ.

It only writes the outbox event as part of the database transaction.

```text
Create Message
     │
     ▼
MySQL transaction
 ├── Message
 ├── Float debit
 ├── Message status event
 └── Outbox event (PENDING)
```

### 4.2 Outbox Publisher

The Outbox Publisher is a standalone application.

Responsibilities:

- Poll `outbox_events`
- Claim pending events
- Publish them to RabbitMQ
- Mark successful events as `PUBLISHED`
- Retry failed publishing
- Recover stale processing events
- Mark permanently failed events

The Control Plane does not need to maintain a RabbitMQ connection for this purpose.

Current initial flow:

```text
outbox_events
      │
      ▼
Outbox Publisher
      │
      ▼
RabbitMQ
      │
      ▼
sms.queued
```

### 4.3 Routing Service

The Routing Service owns routing decisions.

Responsibilities:

- Consume `sms.queued`
- Resolve the destination MNO
- Resolve the client's configured routes
- Order routes by priority
- Create and track route attempts
- Dispatch a message to exactly one route at a time
- Process provider result events
- Select the next route after a confirmed failure
- Detect route exhaustion
- Mark the message failed when no eligible routes remain

The Routing Service is the **only application allowed to advance a message to another route**.

Provider consumers must never select the next provider themselves.

### 4.4 Provider Consumer Applications

Each provider consumer is a standalone application.

Responsibilities:

- Consume its provider-specific queue
- Execute the provider integration
- Submit the SMS
- Interpret provider responses
- Report the result asynchronously
- Acknowledge RabbitMQ messages only according to the consumer's processing guarantees

A provider consumer receives a specific route attempt.

It does not need to know the client's complete routing configuration.

It does not decide which provider comes next.

## 5. Routing Model

Routing is based on:

```text
Client + MNO
```

For each client/MNO combination there is an ordered list of routes.

Example:

```text
Client A + Airtel Malawi

Priority 1 → Airtel Malawi
Priority 2 → Onfon
Priority 3 → Africa's Talking
```

Another client can have a completely different route order:

```text
Client B + Airtel Malawi

Priority 1 → Onfon
Priority 2 → Airtel Malawi
```

This allows routing policy to be configured independently for each client.

## 6. Route vs Connector

These concepts are deliberately separate.

### Connector

A Connector represents a provider/integration and its technical communication details.

Conceptually:

```text
Connector
──────────────
id
name
provider
type
configuration
enabled
```

Examples:

```text
Airtel Malawi
type = SMPP

Onfon
type = HTTP
```

### Route

A Route represents the use of a connector for a particular client/MNO combination.

Conceptually:

```text
Route
──────────────
id
clientId
mnoId
connectorId
priority
enabled
```

Therefore:

```text
Client
   │
   └── Route
         │
         ├── MNO
         │
         └── Connector
                 │
                 ├── Provider
                 ├── Transport
                 └── Configuration
```

The Routing Service asks:

> Which connector should handle this message?

The Connector Consumer answers:

> How do I communicate with this particular provider?

## 7. Mobile Network Operator Resolution

Routing requires determining the destination MNO.

The routing decision begins with:

```text
clientId + destination
```

and resolves:

```text
MNO
```

The architecture must support an MNO resolution mechanism.

Prefix-based resolution may be used initially where appropriate, but the routing architecture must not assume that a number prefix is universally authoritative because number portability can affect MNO ownership.

## 8. RabbitMQ Communication

Applications communicate asynchronously through RabbitMQ.

They do not call one another synchronously over HTTP for the delivery workflow.

RabbitMQ is the **communication layer**.

MySQL is the **authoritative state store**.

```text
RabbitMQ = communication
MySQL    = state
```

## 9. Command Flow

The Routing Service sends a route execution command to the selected provider consumer.

Example:

```text
Routing Service
      │
      ▼
RabbitMQ
      │
      ▼
sms.route.airtel
      │
      ▼
Airtel Consumer
```

The command should carry enough identity to correlate the execution with the routing state.

Conceptually:

```json
{
  "messageId": "message-uuid",
  "attemptId": "attempt-uuid",
  "routeId": "route-uuid",
  "connectorId": "connector-uuid"
}
```

The provider consumer therefore knows exactly which message and route attempt it is executing.

## 10. Provider Result Flow

Provider consumers report results asynchronously.

Example:

```text
Airtel Consumer
      │
      ▼
RabbitMQ
      │
      ▼
sms.route.result
      │
      ▼
Routing Service
```

A result should identify the attempt that produced it.

Conceptually:

```json
{
  "messageId": "message-uuid",
  "attemptId": "attempt-uuid",
  "routeId": "route-uuid",
  "connectorId": "connector-uuid",
  "status": "FAILED",
  "errorCode": "SMPP_TIMEOUT",
  "errorMessage": "Connection timed out"
}
```

The Routing Service uses the result to update the authoritative routing state.

## 11. Route Failover

Suppose the configured routes are:

```text
Priority 1 → Airtel
Priority 2 → Onfon
Priority 3 → Africa's Talking
```

The Routing Service creates:

```text
Attempt 1
Route = Airtel
Priority = 1
```

and dispatches it.

If Airtel succeeds:

```text
Attempt 1 → SUBMITTED
Message    → SUBMITTED
```

No other route is attempted.

If Airtel fails:

```text
Attempt 1 → FAILED
```

The Routing Service transactionally finds the next eligible route:

```text
Priority > 1
ORDER BY priority ASC
LIMIT 1
```

It then creates:

```text
Attempt 2
Route = Onfon
Priority = 2
```

and dispatches it.

If Onfon fails, the same process selects Africa's Talking.

If there is no eligible route remaining, the message becomes:

```text
FAILED
```

with an appropriate failure reason such as:

```text
NO_ROUTE_AVAILABLE
```

## 12. Route Attempt Tracking

Route attempts are recorded separately from the Message.

Conceptually:

```text
Message
   │
   └── MessageRouteAttempt[]
```

Example:

```text
Message ABC

Attempt 1
──────────────
Route: Airtel
Priority: 1
Status: FAILED
Error: SMPP timeout

Attempt 2
──────────────
Route: Onfon
Priority: 2
Status: SUBMITTED
```

The attempt record should contain at least:

```text
id
messageId
routeId
priority
attemptNumber
status
dispatchedAt
startedAt
submittedAt
failedAt
errorCode
errorMessage
createdAt
updatedAt
```

## 13. Exactly-One-Route-at-a-Time Rule

The system must ensure that one message is not intentionally dispatched through multiple routes simultaneously.

The central invariant is:

> **Only the Routing Service may create a new MessageRouteAttempt.**

Provider consumers can only report the result of the attempt they were given.

They cannot say:

```text
Try Onfon
```

or:

```text
Try Africa's Talking
```

The Routing Service makes that decision.

## 14. Transactional Route Advancement

Route advancement must be protected by database concurrency control.

For example, if two Routing Service workers process the same failure event concurrently, only one may advance the message.

Conceptually:

```text
Current attempt = A1
Status = FAILED
```

The transition to A2 must use a concurrency condition such as:

```text
WHERE messageId = M1
AND currentAttemptId = A1
AND routingStatus = ROUTING
```

Only one transaction may successfully advance the state.

This prevents two workers from simultaneously creating competing route attempts.

Database constraints should also be used where appropriate to prevent duplicate attempts.

## 15. RabbitMQ Retry vs Route Failover

These are different concepts.

### Consumer execution retry

If the Airtel consumer crashes while processing attempt A1:

```text
A1
 │
 └── consumer failure
       │
       ▼
RabbitMQ redelivery
       │
       ▼
A1 again
```

This is **not** a new route attempt.

### Route failover

If Airtel actually reports a confirmed provider failure:

```text
A1 → FAILED
     │
     ▼
Routing Service
     │
     ▼
A2 → Onfon
```

This is a new route attempt.

The distinction must remain explicit.

## 16. Unknown Provider Outcomes

A provider failure is not always definitive.

For example:

```text
Consumer
   │
   ▼
Airtel
   │
   ├── accepts message
   │
   └── response is lost
```

The consumer may see a timeout even though the provider accepted the message.

Therefore:

```text
FAILED
```

and:

```text
UNKNOWN
```

must be treated differently.

A confirmed provider rejection may permit failover.

An ambiguous timeout may require provider-specific reconciliation or a conservative policy before another route is attempted.

Otherwise the same SMS could be accepted by multiple providers.

This is a distributed-systems limitation that cannot be solved solely with database transactions.

## 17. Delivery State vs Submission State

The routing system primarily decides whether a provider has **accepted the message for submission**.

That is distinct from final handset delivery.

For example:

```text
QUEUED
   ↓
SUBMITTED
   ↓
DELIVERED
```

A provider submission acknowledgement is not necessarily the same as a delivery receipt.

Provider-specific consumers are responsible for translating provider responses and delivery receipts into the platform's message lifecycle.

## 18. Failure Isolation

Each provider application has its own:

- Process
- RabbitMQ consumer
- Configuration
- Provider connection
- Retry behavior
- Telemetry
- Logs
- Deployment lifecycle

Therefore:

```text
Airtel failure
     ↓
airtel-malawi-consumer affected
```

does not imply:

```text
TNM consumer affected
Onfon consumer affected
Africa's Talking consumer affected
```

The Routing Service can continue dispatching to other providers when their routes are eligible.

## 19. Current Application Landscape

The platform is evolving toward the following standalone applications:

```text
control-plane-api
outbox-publisher
routing-service

airtel-malawi-consumer
tnm-malawi-consumer
onfon-consumer
africas-talking-consumer
...
```

Additional provider consumers are added independently.

The provider application name and deployment boundary are provider-specific, not protocol-specific.

## 20. Current End-to-End Flow

```text
Client
  │
  ▼
Control Plane API
  │
  │ DB transaction
  ▼
Message + Outbox Event
  │
  ▼
outbox_events
  │
  │ PENDING
  ▼
Outbox Publisher
  │
  ▼
RabbitMQ
  │
  │ sms.queued
  ▼
Routing Service
  │
  ├── resolve MNO
  ├── load Client + MNO routes
  ├── order by priority
  ├── create route attempt
  └── dispatch selected route
          │
          ▼
    Provider Queue
          │
          ▼
   Provider Consumer
          │
          ▼
      Provider API/SMPP
          │
       result
          │
          ▼
    RabbitMQ result
          │
          ▼
    Routing Service
          │
      ┌───┴────┐
      │        │
   success   failure
      │        │
      ▼        ▼
 SUBMITTED  next route
               │
               ├── route 2
               ├── route 3
               └── ...
                    │
                    ▼
              no routes left
                    │
                    ▼
                  FAILED
```

## 21. Architectural Invariants

The following rules are locked:

1. **The Control Plane does not publish outbox events to RabbitMQ.**
2. **The Outbox Publisher is a standalone application.**
3. **RabbitMQ is the asynchronous communication layer.**
4. **MySQL is the authoritative source of routing and message state.**
5. **The Routing Service owns route selection and failover.**
6. **Only the Routing Service may advance a message to another route.**
7. **Every route execution has a unique MessageRouteAttempt.**
8. **Provider consumers never select the next route.**
9. **Every provider/integration has its own standalone consumer application.**
10. **Protocol similarity does not justify sharing a consumer application.**
11. **RabbitMQ consumer retry is distinct from route failover.**
12. **A message must not be intentionally dispatched to multiple routes simultaneously.**
13. **Unknown provider outcomes must not automatically be treated as confirmed failures.**
14. **Route exhaustion results in message failure.**
15. **Provider submission state is distinct from final delivery state.**

## 22. Next Implementation Order

The architecture is now locked. Implementation should proceed in this order:

### 1. Database schema

Finalize:

- `MobileNetwork`
- `Connector`
- `Route`
- `MessageRouteAttempt`
- Message routing state
- Required indexes and uniqueness constraints

### 2. Control Plane configuration

Add management APIs for:

- MNOs
- Connectors
- Routes
- Client/MNO route priorities
- Enable/disable operations

### 3. Routing Service

Build:

- RabbitMQ consumer for `sms.queued`
- MNO resolution
- Route resolution
- Priority selection
- Route attempt creation
- Provider dispatch
- Result consumption
- Failover
- Route exhaustion
- Concurrency protection

### 4. First provider consumer

Build one provider consumer end-to-end to establish the pattern.

### 5. Additional provider consumers

Each provider is implemented and deployed independently.

---

**This document is the architectural reference for the asynchronous routing and provider-consumer portion of Pague 2.0.**
