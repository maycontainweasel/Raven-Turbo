# Distillation - RAVEN-INGEST-0011 - Workline 03 Upcoming Cashflow Validation And Pre-Work Primer

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0011-workline-03-upcoming-cashflow/`
- Ingest record: `brain/sprints/0011-workline-03-upcoming-cashflow/INGEST_RECORD-RAVEN-INGEST-0011.md`
- Source date: 2026-07-12
- Ingest date: 2026-07-12
- Mode: external-validation / pre-work-primer
- Source kind: linked external AI completion review and authoritative Workline 03 implementation prompt

## Executive Distillation

The external review accepts Workline 02 as complete after source-level inspection of the final import-identity closeout. It reports scoped identities, immutable import replay, atomic conflict behavior, classification/source separation, cross-space semantic isolation, truthful migration reporting, and whole-month warning disclosure. It independently reran only the pure Node statement-renderer suite (`2/2`); package tests, live Surreal smokes, and the Nuxt build were not independently rerun. These are external-review findings, not verification performed by this Brainkeeper.

The linked pre-work prompt authorizes Workline 03: Upcoming Cashflow as the next complete product vertical. Raven should represent accepted future-money rules as `CashflowSchedule` records and concrete due instances as `CashflowOccurrence` records. It binds deterministic recurrence, exact minor-unit money, explicit local financial dates and timezone, immutable settled history, optimistic revisions, idempotent audited commands, explicit certainty, settlement/reconciliation boundaries, Studio/tRPC/MCP parity, and a minimal `/upcoming` interface. Workline 03 is not implemented or accepted merely because this packet has been ingested.

## External Validation Context

- Workline 01 and Workline 02 are described by Source 1 as done.
- Source 1 reports that Workline 02's final import closeout aligns persistence identity with account, Financial Space, StatementImport, and transaction ownership scopes.
- Source 1 preserves an operational warning: existing private imported records may still use older identities, so bulk replay requires a separate aggregate-only compatibility audit and an explicitly approved migration or coexistence plan.
- Source 1 identifies stale Workline 02 status language and manual/generated transaction record-ID alignment as bounded Workline 03 preflight corrections rather than reasons to reopen Workline 02 broadly.
- The Brainkeeper did not independently inspect implementation code or rerun product verification.

## Workline 03 Product Loop

- Open `/upcoming` and add one-off or recurring outgoing or incoming accepted cashflow.
- Materialize deterministic concrete occurrences and group them as overdue, today, next seven days, later this month, and later.
- Keep outgoing certainty fixed as `committed`; distinguish incoming `confirmed`, `expected`, and `possible` explicitly.
- Edit, pause, resume, end, or cancel schedules without silently rewriting terminal history.
- Settle occurrences with or without an observed transaction link; an unlinked settlement remains visibly `UNRECONCILED_SETTLEMENT` and does not invent a transaction.
- Reconcile a settled unlinked occurrence later against valid observed evidence.
- Skip, waive, cancel, or override one occurrence through audited commands rather than raw mutation.
- Expose equivalent semantic reads and commands through Raven Studio, tRPC, and Raven MCP.

## Binding Domain Invariants

### Observed Versus Accepted Truth

- Accepted future cashflow is separate from observed transaction truth.
- Inferred recurring patterns, retainers, opportunities, imported history, and transaction history do not automatically become accepted schedules.
- Settlement without a valid transaction link records accepted lifecycle state but remains unreconciled; it must not create or mutate observed transaction or balance evidence.

### Schedule And Occurrence Identity

- `CashflowSchedule` is scoped to Financial Space with identity `S($space, $key)`.
- `CashflowOccurrence` is scoped to its schedule and immutable nominal date with identity `S($schedule, $scheduledDueOn)`.
- `scheduledDueOn` anchors occurrence identity; effective `dueOn` may be overridden without changing identity.
- `scheduledAmountMinor` preserves the schedule-revision amount; effective `amountMinor` may be overridden without changing the schedule.
- Schedule and occurrence mutations increment independent revisions and require expected-revision checks.

### Recurrence

- One pure domain recurrence engine supports once, weekly, monthly, quarterly, and yearly schedules.
- Monthly and quarterly dates 29-31 clamp in shorter months but return to the configured day later rather than drifting.
- Yearly February 29 clamps to February 28 in non-leap years and returns to February 29 in leap years.
- Date-only recurrence remains local and must not round-trip through UTC midnight.
- Materialization through the same horizon is deterministic, idempotent, and bounded.

### Lifecycle And History

- Pause prevents new materialization after its effective date while existing occurrences remain explicit.
- Resume begins from an explicit date and does not backfill a paused gap that was never materialized.
- End stops recurrence after an explicit date while preserving due occurrences through that date.
- Schedule cancellation stops generation and cancels applicable unsettled future occurrences atomically; overdue or past due occurrences remain explicit.
- Schedule revisions reconcile only non-terminal occurrences from `effectiveFrom`; obsolete rows are cancelled, new nominal rows are created, and terminal history remains frozen.
- Settled, skipped, waived, and cancelled occurrences are terminal in v0.1, except that a settled unlinked occurrence may later gain a valid reconciliation link.

### Settlement Validation

- A linked transaction must be canonical, resolved, non-ignored, non-transfer, direction-compatible, currency-compatible, amount-equal, and account-compatible where the schedule has an account.
- One observed transaction cannot serve as active settlement evidence for multiple occurrences in v0.1.
- Reconciliation may attach evidence but may not alter occurrence money/date truth or the observed transaction.

## Bounded Preflight

- Synchronize stale current-status wording in the canonical Account Control contract and prompt index while preserving historical ingest records.
- Align new manual/generated transaction record IDs with the schema's account-scoped canonical identity while preserving public local keys and replay of existing global-ID records.
- Store actual resulting transaction record references in operation receipts and transfers.
- Make aggregate identity reporting distinguish imported records from manual/generated identity classes truthfully.
- Do not migrate private records in this workline.

## Required Delivery Surface

- Schema authority for `CashflowSchedule`, `CashflowOccurrence`, and the extended `FinancialOperation` command union.
- Shared domain recurrence, validation, projections, queries, commands, errors, warnings, and fixed-clock tests.
- Atomic Surreal persistence with deterministic identities, optimistic revision checks, replay/conflict behavior, settlement validation, and no raw deletion of accepted future truth.
- Four semantic queries, six schedule commands, and seven occurrence commands across the shared API, tRPC, and MCP.
- A minimal true-black `/upcoming` page with filters, search, grouped occurrences, schedules view, create dialog, schedule drawer, occurrence drawer, quick actions, command-palette actions, keyboard behavior, and 390px mobile support.
- Fictional-only unit, transport, build, and disposable live-Surreal evidence, including cleanup.

## Decisions

- No new Brain decision is created by this sidecar.
- The prompt treats the schedule/occurrence separation and occurrence identity/effective override semantics as accepted implementation invariants, but active decision reconciliation remains with the main agent.
- Workline 03 must remain in review after implementation; final acceptance is a separate gate.
- Workline 04 Today Coverage remains out of scope and unstarted.

## Open Loops For Main Agent

- Perform the bounded Workline 02 status and transaction-ID consistency preflight.
- Implement the complete Workline 03 schema, domain, repository, Studio, tRPC, and MCP vertical.
- Prove deterministic recurrence, materialization, lifecycle, optimistic concurrency, idempotency, terminal-history protection, and settlement validation with fictional evidence.
- Preserve Workline 01 and Workline 02 behavior and legacy transaction readability without private migration.
- Reconcile active Brain, architecture documentation, prompt authority, and Orbit only after implementation and verification.
- Leave Workline 03 in review for acceptance and do not begin Workline 04.

## Risks Preserved From The Packet

- Conflating accepted future money with observed transactions would corrupt financial truth.
- Due-date overrides can duplicate occurrences unless immutable `scheduledDueOn` anchors identity.
- UTC conversion of date-only recurrence can shift financial dates.
- Month-end recurrence can drift unless each occurrence derives from configured recurrence fields rather than the prior clamped date.
- Schedule edits can rewrite settled history unless terminal rows are frozen and future reconciliation is explicit.
- Unlinked settlement can imply false observed evidence unless unreconciled state remains visible.
- Stale revisions and duplicate first writes can silently lose intent unless conflict and replay behavior are enforced atomically.
- Old private import identities remain a separate migration/coexistence concern and should not be bulk replayed implicitly.

## Opportunities

- Deliver Raven's first accepted-future-money view answering what must be paid, what may come in, and by when.
- Establish a durable recurrence and lifecycle foundation for later Today Coverage without prematurely calculating coverage or earning requirements.
- Preserve one semantic Account Control layer across human UI and agent operations.

## Repeated Themes

- Observed, accepted, inferred, and possible money remain distinct.
- Schedule rules and occurrence facts require separate identities and histories.
- Financial dates are local calendar facts, not UTC timestamps.
- Deterministic idempotency and optimistic concurrency are financial-truth requirements.
- Terminal history is preserved; corrections and overrides are explicit and audited.
- Certainty and reconciliation must be visible in text, not inferred from color or hidden state.
- Implementation, verification, review, and acceptance remain separate gates.

## Orbit Sync Candidates For Main Agent

- Start or connect the Workline 03 Upcoming Cashflow workline for implementation.
- Keep Workline 03 in `review` after implementation and fictional verification until Michael or external review accepts it.
- Do not start Workline 04 Today Coverage.
- No Orbit or `.orbit` state was inspected or changed by this Brainkeeper sidecar.
