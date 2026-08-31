---
status: complete
owner: Raven
last_reviewed: 2026-07-18
contract: raven-account-control-contract-v0.1
prompt: raven-account-control-workline-03
---

# Raven Account Control Workline 03 Implementation

Workline 03 implements accepted future cashflow through the same domain, Surreal, tRPC, Studio, and semantic MCP boundary used by accepted Worklines 01 and 02. The July 18 final paused-lifecycle closeout is implemented and fictionally verified. Workline 03 is complete. Workline 04 has not started.

## Delivered

- Source-authority `CashflowSchedule` identity `S($space, $key)` and `CashflowOccurrence` identity `S($schedule, $scheduledDueOn)`.
- Pure deterministic once, weekly, monthly, quarterly, and yearly recurrence with month-end/leap-year clamping and a 1,831-day maximum horizon.
- A pure schedule-mutation planner covering old-rule extension, terms authority, lifecycle state, deterministic creates, expected occurrence revisions/statuses, cancellation patches, and immutable terminal history.
- Canonical transition matrix: active -> update/pause/end/cancel; paused -> paused update/resume/end/cancel; ended and cancelled are terminal.
- Monotonic materialization that extends strictly after the current boundary, no-ops on same/shorter horizons, skips paused gaps, and preserves effective end/cancel boundaries.
- Paused-to-terminal planning that creates no occurrence in the paused gap, terminalizes any pre-materialized due gap row with operation provenance, preserves non-due history, and advances `materializedThrough` monotonically.
- One shared lifecycle-eligibility rule for schedule lists, detail history, occurrence counts, next-due selection, upcoming lists, and per-currency summaries, including defensive handling of stale pre-closeout due rows.
- Schedule read models expose configured status, effective status at explicit `asOf` in the schedule timezone, and the next pending lifecycle transition/date without changing persisted schema.
- Retry-stable per-action Studio command intents and duplicate-looking first-write rereads for every schedule and occurrence mutation. Matching hashes replay; changed hashes conflict.
- Atomic Surreal schedule mutations that validate schedule and every targeted occurrence before any entity or FinancialOperation write.
- Atomic canonical settlement validation for exact money, semantics, date/provenance completeness, Financial Space, assigned account, occurrence state, and one-transaction-to-one-occurrence uniqueness.
- `FinancialOperation.auditMeta`, complete entity histories, and schedule operation refs to affected schedules/occurrences.
- Certainty-separated per-currency summaries with no all-certainty net, plus schedule-timezone timing metadata under explicit `asOf`.
- Thirty-operation tRPC/MCP parity with bounded title, note, reason, search, timezone, and evidence-ID inputs.

## Studio Surface

- `/upcoming` uses compact All / To pay / Incoming / Schedules tabs.
- Occurrence rows show timing, direction, certainty, recurrence, status, Financial Space, account, category, amount override, and Linked/Unreconciled state without opening a drawer.
- Schedules remain manageable when no occurrence exists in the selected horizon.
- Query quality and warning codes are rendered explicitly.
- Quick actions include Upcoming payment, Expected income, and generic scheduled cashflow.
- Creation requires Financial Space, direction, title, exact money, certainty, recurrence, currency, and timezone; account and category are optional.
- Schedule detail exposes all recurrence/lifecycle terms, revision, effective editing, consequence text, occurrence counts, and FinancialOperation history.
- Future terms and lifecycle actions use separate effective-date state. Lifecycle defaults use the schedule-local query date, enforce accepted authority lower bounds, and retain a distinct retry-stable intent per action.
- Occurrence detail exposes scheduled/effective amount/date, timing, scope, revisions, settlement state, overrides, operation history, all accepted actions, and canonical candidate selection. Manual Transaction ID entry is an expert fallback.

## Persistence Notes

- `CashflowSchedule.termsEffectiveFrom` represents current terms authority.
- `FinancialOperation.auditMeta` stores bounded lifecycle/override context without a second audit model.
- `CashflowOccurrence.transaction` has a generated unique optional index.
- Schedule/occurrence operation result refs are derived from actual database record IDs inside the same transaction.
- The repository response adapter distinguishes raw records with a domain `status` field from Surreal statement envelopes and preserves stable cashflow conflict codes.

## Verification

- Strict MPDG validation, spec generation, schema generation, dry-run import, live import, and unique-index rebuild pass.
- Domain suite: 58 passing tests, including paused March 31 -> end/cancel May 31, pre-materialized gap rows, immutable terminal history, defensive lifecycle eligibility, configured/effective/pending projection, retry intent, concurrent replay, transition matrix, future terms, monotonic materialization, terminal race protection, canonical settlement rejection, uniqueness, summaries, timing, and Workline 01-02 regressions.
- Surreal suite: 24 passing tests, including validation-before-write query contracts and monotonic SQL.
- tRPC/MCP parity suite passes for all 30 Account Control operations plus explicit lifecycle-field equivalence; domain, Surreal, and MCP package typechecks pass.
- Three focused Studio tests pass for action-scoped retry intents, success rotation, timezone-local dates, and lifecycle lower bounds.
- Raven Studio production build passes.
- The focused Nuxt typecheck reports no errors in Workline 03 files. The repository-wide Studio typecheck remains red on 120 inherited Helios, Schema Kit, generated, and unrelated legacy errors; those are outside this bounded workline.
- Live browser verification passes at desktop and mobile widths with no page overflow, controls outside the viewport, Nuxt error page, or hydration error. The existing Ark UI fragment scope-attribute warnings remain separate shared-shell cleanup.
- Disposable live-Surreal smoke passes replay, paused-to-terminal atomicity, configured/effective/pending lifecycle reads, no paused-gap due visibility, changed-hash conflict, lifecycle boundaries, future terms, monotonic materialization, schedule/occurrence races, four certainty classes, canonical settlement scope/account rules, unique linking, linked/unlinked states, zero cashflow-created Transactions or balance snapshots, and cleanup.
- Archive-safety policy tests and an AI-safe manifest dry run pass. Private financial sources, credentials, raw Brain sources, and local service configuration remain excluded.
- Brain health, traceability, secret-literal, and scoped whitespace checks pass for the Workline 03 capture and implementation.

No private financial source material was used or persisted by these tests.
