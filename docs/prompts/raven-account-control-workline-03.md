---
status: working
owner: Raven
last_reviewed: 2026-07-12
contract: raven-account-control-contract-v0.1
predecessor: raven-account-control-workline-02
---

# Codex Prompt — Account Control Workline 03: Upcoming Cashflow

```text
orbit-workline

Implement Raven Account Control Workline 03: Upcoming Cashflow.

Workline 01 Account Balance Truth and Workline 02 Observed Transactions and
Transfers are accepted and complete. Preserve their exact-money, account-balance,
transaction, transfer, import-identity, immutable-source, idempotency, warning,
Studio, tRPC, and semantic MCP behavior. Do not reopen either workline as a broad
review.

The Brainkeeper sidecar may run under the standing protocol, but it must not
replace, defer, or terminate this main implementation workline. Continue through
working product code in this run. Leave Workline 03 in Orbit review for
Michael/external acceptance. Do not start Workline 04 Today Coverage.

Read and obey:

- root `AGENTS.md` and all required Orbit/Brain startup files;
- `docs/architecture/raven-account-control-contract-v0.1.md`;
- `docs/architecture/raven-account-control-workline-01-implementation.md`;
- `docs/architecture/raven-account-control-workline-02-implementation.md`;
- `docs/architecture/raven-import-identity-and-migration.md`;
- `docs/prompts/raven-account-control-workline-01.md` and Workline 02 only as
  implementation-pattern references;
- `apps/schema/AGENTS.md`, `apps/schema/config/AGENTS.md`, and schema-generation
  authority rules;
- `packages/raven-domain`, `packages/raven-surreal`, `apps/raven-mcp`, and the
  existing Raven Studio shell/action registry;
- Raven V1 recurring/client/retainer surfaces only as behavioral references. Do
  not copy their page architecture or convert their floating-point records into
  accepted future truth.

Preserve this exact instruction in:

`docs/prompts/raven-account-control-workline-03.md`

## Objective

Deliver one complete accepted-future-money loop through the same shared semantic
layer:

1. Open `/upcoming`.
2. Add a one-off or recurring outgoing payment.
3. Add confirmed, expected, or possible incoming money.
4. See concrete due occurrences grouped as overdue, today, next seven days, later
   this month, and later.
5. Edit, pause, resume, end, or cancel the parent schedule without rewriting
   settled history.
6. Settle an occurrence as paid/received, optionally linking an existing observed
   transaction.
7. Skip, waive, or cancel one occurrence.
8. Override one occurrence's amount or due date without mutating its parent
   schedule.
9. Inspect recurrence, certainty, provenance, reconciliation, and lifecycle state.
10. Perform equivalent reads and commands through Raven MCP.

This workline must produce working product and schema code. It is not another
architecture-only review.

## Bounded preflight corrections

Complete these at the start of the workline without creating a separate cycle:

1. **Canonical status sync**
   - The implementation note and Brain mark Workline 02 complete, while the
     canonical contract still contains stale `implemented and in review` / `awaits
     acceptance` wording.
   - Update only the affected current-status passages and prompt index. Preserve
     historical ingest records unchanged.

2. **Transaction record-ID alignment before occurrence links**
   - Schema canon declares `Transaction` identity as `S($account, $key)`, while the
     current raw Surreal writes for new manual expense/income and transfer legs
     still create `type::record("transaction", $transactionKey)`.
   - Preferred correction: create all new manual/generated transaction records
     with the canonical account-scoped record identity while retaining the public
     local `key`; persist the actual resulting record references in
     `FinancialOperation.resultRefs` and `AccountTransfer`.
   - Preserve replay of already-created legacy/global-ID transactions. Do not
     migrate private records in this workline.
   - Make the aggregate import-identity audit truthful: it must either limit the
     Transaction identity section to imported rows or separately report imported
     and manual/generated identity classes. New canonical manual records must not
     be misleadingly reported as import-migration failures.
   - Add focused unit/live regression evidence. This is schema consistency, not a
     reopening of Workline 02 financial behavior.

## Accepted invariants

These are approved and are not new approval gates:

- accepted future cashflow is separate from observed transaction truth;
- `CashflowSchedule` is the accepted recurring/one-off rule;
- `CashflowOccurrence` is the concrete due instance;
- outgoing certainty is always `committed`;
- incoming certainty is `confirmed | expected | possible`;
- only confirmed future incoming will later affect coverage;
- exact money is positive integer minor units plus currency;
- all calendar facts use explicit `YYYY-MM-DD` local financial dates;
- every semantic command is idempotent and backed by `FinancialOperation`;
- schedule and occurrence changes are audited and optimistic-concurrency safe;
- inferred recurring patterns, retainers, opportunities, and imported history do
  not automatically create schedules;
- an unlinked settlement never invents an observed transaction;
- Studio, tRPC, and MCP use one `AccountControlApi` and one domain service;
- Workline 04 coverage, earning rates, buckets, notifications, invoices, and
  opportunities remain out of scope.

## Binding occurrence semantics

The accepted due-date override requires this precise identity clarification:

- `scheduledDueOn` is the immutable nominal recurrence date and identity anchor.
- Occurrence record identity is `S($schedule, $scheduledDueOn)`.
- `dueOn` is the effective date shown to the user and may be overridden.
- `scheduledAmountMinor` is the amount copied from the schedule revision when the
  occurrence is generated/reconciled.
- `amountMinor` is the effective amount and may be overridden.
- Overriding amount or due date increments occurrence revision, records an
  operation, and does not change the schedule or `scheduledDueOn`.
- Settled, skipped, waived, and cancelled occurrences are terminal in v0.1, except
  that a settled unlinked occurrence may later be reconciled to a valid observed
  transaction.
- No raw delete or generic mutation is an approved product path.

## Recurrence contract

Implement one pure deterministic recurrence engine in `packages/raven-domain`.
Do not put recurrence calculations in Vue, tRPC, MCP, or Surreal query strings.

Supported recurrence:

- `once`: one explicit date;
- `weekly`: start date, interval >= 1, ISO weekday 1..7;
- `monthly`: start date, interval >= 1, day of month 1..31;
- `quarterly`: monthly stepping of `3 * interval`, day of month 1..31;
- `yearly`: interval >= 1, month 1..12, day 1..31.

Deterministic edge rules:

- monthly/quarterly day 29, 30, or 31 clamps to the last valid day of a shorter
  target month, but later months return to the configured day rather than drifting;
- yearly February 29 clamps to February 28 in a non-leap year and returns to
  February 29 in a leap year;
- occurrence dates before `startDate` or after `endDate` are never generated;
- timezone must be a valid IANA timezone; default new Studio input to
  `Africa/Johannesburg` but persist it explicitly;
- date-only recurrence must never round-trip through UTC midnight;
- generation through the same horizon is idempotent;
- use checked safe-integer arithmetic for exact amounts.

## Schedule revision and materialization rules

- `CashflowSchedule.revision` begins at 1 and increments on every accepted schedule
  mutation.
- `CashflowOccurrence.revision` begins at 1 and increments on every accepted
  occurrence mutation.
- Commands require `expectedRevision` where they update an existing schedule or
  occurrence. Mismatch returns a stable revision-conflict error.
- Track a schedule `materializedThrough` local date.
- Creation materializes through an explicit requested horizon or a documented
  bounded Studio default of at least the end of the following three calendar
  months.
- `list_upcoming_cashflows` may transactionally ensure active schedules are
  materialized through its requested `through` horizon. This is derived
  materialization only; it must be deterministic and duplicate-safe.
- Pause stops new materialization after the pause date. Already materialized due
  occurrences remain explicit and require settle/skip/waive/cancel.
- Resume reactivates generation from an explicit `resumeOn` date and skips the
  paused gap; it does not backfill dates that were never materialized while paused.
- End stops recurrence after an explicit `endOn`; due occurrences on or before the
  end remain.
- Cancel schedule stops generation and atomically marks unsettled future
  occurrences from an explicit effective date as cancelled. Overdue/past due
  occurrences remain explicit unless individually acted on.
- Updating schedule terms requires `effectiveFrom`. It must explicitly reconcile
  only non-terminal occurrences from that date forward through the already
  materialized horizon:
  - terminal/history rows remain frozen;
  - matching nominal dates may be updated to the new schedule revision under the
    explicit update operation;
  - obsolete due rows are marked cancelled, never deleted;
  - newly required nominal dates are created;
  - no settled/history row is silently rewritten.

## Settlement and reconciliation rules

- `settle_cashflow_occurrence` moves one `due` occurrence to `settled` and records
  `settledAt` plus optional note.
- An unlinked settlement is allowed and returns `UNRECONCILED_SETTLEMENT`.
- It does not create, edit, or infer a Transaction.
- When a transaction is supplied, validate:
  - transaction is canonical, non-ignored, and not unresolved;
  - outgoing occurrence links only to `expense/outflow`;
  - incoming occurrence links only to `income/inflow`;
  - transfer legs cannot settle an occurrence;
  - currency matches;
  - effective occurrence amount equals transaction amount in v0.1;
  - when the schedule has an account, transaction account matches it;
  - one observed transaction cannot be the active settlement evidence for more
    than one occurrence in v0.1.
- `reconcile_cashflow_occurrence` may attach a valid transaction to a settled,
  currently unlinked occurrence. It may not alter money, dates, or observed
  transaction truth.

## Scope A — schema canon

Begin all model changes in `apps/schema/config/graph.mpdg`, run strict graph
validation, regenerate every generated asset, inspect generated identity/functions,
and use the configured schema import workflow. Do not hand-edit generated outputs
as source authority.

### Add `CashflowSchedule`

Use a source-authority model with at least:

- Financial-Space-scoped identity: `id: S($space, $key)`;
- `space` and optional `account`;
- optional same-space `category`;
- local `key` and non-empty `title`;
- `direction: outflow | inflow`;
- `certainty: committed | confirmed | expected | possible`;
- exact positive `amountMinor` and `currency`;
- explicit IANA `timezone`;
- `cadence: once | weekly | monthly | quarterly | yearly`;
- `interval`;
- `startDate`, optional `endDate`;
- cadence-specific fields (`onceDueOn`, `dayOfWeek`, `dayOfMonth`, `monthOfYear`)
  represented in a generation-safe way;
- `status: active | paused | ended | cancelled`;
- `revision`;
- `materializedThrough`;
- pause/resume/end/cancel effective dates where needed;
- created/last `FinancialOperation` references;
- `recordedAt`, `updatedAt`, and optional notes.

Direction-safe validation:

- outflow requires `certainty=committed`;
- inflow rejects `committed` and requires confirmed/expected/possible;
- optional account must be active, in the selected Financial Space, and use the
  same currency;
- optional category must be active, in the same Financial Space, and compatible
  with direction (`expense/tax/savings/other` for outflow;
  `income/other` for inflow).

### Add `CashflowOccurrence`

Use a source-authority model with at least:

- `id: S($schedule, $scheduledDueOn)`;
- `schedule`, `space`, optional account and category snapshots/references;
- `scheduledDueOn` and effective `dueOn`;
- `scheduleRevision` and occurrence `revision`;
- copied title, direction, certainty, recurrence label or cadence;
- `scheduledAmountMinor`, effective `amountMinor`, and currency;
- `status: due | settled | skipped | waived | cancelled`;
- optional `settledAt` and linked `transaction`;
- optional override/status reason and note;
- last `FinancialOperation`;
- `recordedAt` and `updatedAt`.

Do not store `overdue` as mutable truth. Derive it from effective `dueOn`, status,
query `asOf`, and timezone.

### Extend `FinancialOperation` domain command union

Add the Workline 03 commands to browser-safe/server contracts, operation receipts,
transport parity, and persistence normalization. Do not create a second audit
mechanism.

## Scope B — shared semantic contract

Extend `packages/raven-domain` with browser-safe types, server repository ports,
pure recurrence functions, validation, deterministic projections, service methods,
and fixed-clock tests.

### Required queries

1. `list_cashflow_schedules`
   - filter by optional spaces, status, direction, and certainty;
   - return schedule summary, recurrence label, next due occurrence where known,
     revision, account/category, and query metadata.

2. `get_cashflow_schedule`
   - return one complete semantic schedule plus bounded occurrence summary and
     provenance; never return a raw mutable record.

3. `list_upcoming_cashflows`
   - input: `from`, `through`, optional spaces, direction, certainty, status,
     account refs, and optional search;
   - validate `from <= through` and use bounded horizon limits;
   - ensure deterministic materialization through `through` for active schedules;
   - return occurrences sorted by effective due date, then direction/title/id;
   - include schedule/account/category, recurrence, revisions, reconciliation state,
     and query metadata;
   - default excludes terminal rows unless explicitly requested;
   - expose enough dates/state for Studio to derive Overdue, Today, Next 7 days,
     Later this month, and Later without inventing financial rules in the page.

4. `get_cashflow_occurrence`
   - return exact scheduled/effective amount and date, status, overdue state,
     schedule snapshot, account/category, operation provenance, override history
     summary, settlement link, and `UNRECONCILED_SETTLEMENT` when applicable.

### Required schedule commands

- `create_scheduled_cashflow`
- `update_scheduled_cashflow`
- `pause_scheduled_cashflow`
- `resume_scheduled_cashflow`
- `end_scheduled_cashflow`
- `cancel_scheduled_cashflow`

Every command:

- uses retry-stable idempotency and request hash;
- validates exact money, recurrence, certainty, account/category scope, and timezone;
- returns semantic entity/occurrence results plus `CommandReceipt`;
- writes schedule, reconciled occurrences, and one `FinancialOperation` atomically;
- on duplicate-looking first-write races, rereads and replays or returns stable
  `IDEMPOTENCY_CONFLICT` exactly like Workline 02.

### Required occurrence commands

- `settle_cashflow_occurrence`
- `reconcile_cashflow_occurrence`
- `skip_cashflow_occurrence`
- `waive_cashflow_occurrence`
- `cancel_cashflow_occurrence`
- `override_cashflow_occurrence_amount`
- `override_cashflow_occurrence_due_date`

Each command requires occurrence ID, `expectedRevision`, idempotency metadata, and
optional bounded note/reason. Enforce the state-transition contract and preserve
terminal history.

### Stable errors and warnings

Add at minimum:

Errors:

- `INVALID_RECURRENCE`
- `INVALID_CERTAINTY`
- `INVALID_CASHFLOW_DATE_RANGE`
- `SCHEDULE_REVISION_CONFLICT`
- `OCCURRENCE_REVISION_CONFLICT`
- `OCCURRENCE_CONFLICT`
- `OCCURRENCE_ALREADY_SETTLED`
- `INVALID_OCCURRENCE_TRANSITION`
- `INVALID_SETTLEMENT_TRANSACTION`

Warnings:

- `UNRECONCILED_SETTLEMENT`

Preserve all existing codes and transport mapping.

## Scope C — Surreal repository and atomicity

Extend `packages/raven-surreal`; do not put financial branching in Studio or MCP.

Required persistence behavior:

- repository reads for schedules and occurrences;
- deterministic occurrence identity and generation;
- atomic create/update/lifecycle commands with operation receipt;
- optimistic revision checks inside the database transaction, not only in memory;
- exact replay and concurrent-first-write behavior;
- no raw delete of accepted future truth;
- no transaction or balance snapshot creation during schedule/occurrence commands;
- settlement link validation against canonical observed Transaction truth;
- no Typesense dependency;
- explicit empty-scope behavior (`undefined` means intentionally unscoped; `[]`
  means no matches) consistent with Workline 02.

No private-data migration is required because the cashflow models are new. Do not
auto-create schedules from Retainer, Client, transaction history, statement rows,
or inferred recurring patterns.

## Scope D — tRPC and semantic MCP parity

Add thin camelCase tRPC procedures and snake_case MCP tools for every required query
and command. Use the same domain input/output schemas and stable error codes.

MCP tool descriptions must make certainty and observed-vs-accepted boundaries clear,
for example:

- `create_scheduled_cashflow`: create accepted future money; it does not record an
  observed transaction;
- `settle_cashflow_occurrence`: mark an accepted due item paid/received; without a
  transaction link it remains unreconciled;
- `list_upcoming_cashflows`: list concrete accepted due items and certainty without
  treating expected/possible income as confirmed cash.

Extend the parity test across the complete Account Control operation catalog.

## Scope E — Raven Studio `/upcoming`

Keep the current true-black, minimal, Notion/GitHub-like visual language. Do not add
a sidebar, hero, chart, card mosaic, gradients, glow, or decorative animation.

### Route and navigation

- Add `/upcoming`.
- Add `Upcoming` to the shared route/action registry, command palette, overflow
  navigation, and top-bar quick add.
- Add quick actions for `Upcoming payment` and `Expected income`.
- Preserve `Command/Control + P` and `Command/Control + K` behavior.

### Page structure

Use one compact data-first page:

```text
Upcoming                                              + Cashflow
[All] [To pay] [Incoming] [Schedules]         [Filters] [Search]

Overdue
Due        Item             Account      Certainty    Recurrence    Amount

Today
...

Next 7 days
...

Later this month
...

Later
...
```

Rules:

- sectioning uses the occurrence's effective `dueOn` and the schedule timezone;
- direction, certainty, recurrence, status, account, category, and reconciliation
  are visible without opening a drawer;
- confirmed, expected, and possible incoming use explicit text labels; colour alone
  is insufficient;
- terminal rows are hidden by default but available through filters/history;
- loading, empty, error, partial, and unreconciled states are deliberate and stable;
- empty state says `No accepted cashflows in this period` and offers Add;
- do not calculate Workline 04 coverage or required earnings here.

### Dialogs and drawers

Use Ark UI headless primitives and existing Raven form patterns.

Add:

1. **Cashflow create dialog**
   - Personal/Business Financial Space;
   - outgoing/incoming;
   - title;
   - exact amount/currency;
   - certainty (outgoing fixed to committed);
   - optional account and category;
   - once/weekly/monthly/quarterly/yearly recurrence inputs;
   - timezone defaulted to Africa/Johannesburg;
   - materialization horizon hidden behind a safe product default, not exposed as
     technical jargon.

2. **Schedule drawer/edit flow**
   - recurrence and revision;
   - edit effective-from date;
   - pause/resume/end/cancel actions with explicit consequences;
   - occurrence history summary;
   - provenance/operation information.

3. **Occurrence drawer**
   - scheduled and effective amount/date;
   - certainty, overdue, account/category, recurrence, revisions;
   - settlement/reconciliation state;
   - actions: paid/received, skip, waive, cancel, override amount, override due date;
   - optional transaction linking using existing account ledger reads;
   - unlinked settlement visibly says `Unreconciled`.

Each open mutation intent owns one idempotency key across failed retries, just like
Worklines 01-02.

Support keyboard activation, sensible focus return, escape/close behavior, desktop
and 390px mobile layout, and no page-owned financial calculations.

## Required fictional test matrix

Use no private names, records, statements, amounts, or clients.

### Domain recurrence tests

1. once generates one occurrence;
2. weekly interval/weekday generation;
3. monthly day 31 clamps in short months and returns to 31 later;
4. quarterly interval is deterministic;
5. yearly February 29 clamp/return behavior;
6. start/end boundaries and invalid recurrence rejection;
7. explicit IANA timezone validation and no UTC date drift;
8. duplicate horizon generation returns no duplicates.

### Lifecycle tests

9. outflow rejects non-committed certainty; inflow rejects committed;
10. account/category scope and currency validation;
11. create replay returns the same schedule/occurrences; changed hash conflicts;
12. stale schedule and occurrence revisions return stable conflict codes;
13. update freezes terminal rows and explicitly reconciles only future due rows;
14. pause/resume/end/cancel match the documented materialization rules;
15. amount and due-date override retain occurrence identity and scheduled fields;
16. skip, waive, and cancel are audited terminal transitions;
17. linked settlement validates direction/currency/amount/account and does not
    mutate the Transaction;
18. unlinked settlement emits `UNRECONCILED_SETTLEMENT` and creates no Transaction;
19. later reconciliation links valid observed evidence exactly once;
20. concurrent identical first writes replay; changed request hashes conflict.

### Read/UI/transport tests

21. list ordering and Overdue/Today/Next-7/Later inputs are deterministic under a
    fixed clock;
22. expected/possible income remains visibly distinct from confirmed;
23. omitted scope versus explicit empty scope cannot broaden queries;
24. tRPC/MCP parity covers the complete operation catalog;
25. `/upcoming`, create dialog, schedule drawer, occurrence drawer, filters, command
    palette, and mobile layout work against fictional records;
26. Workline 01 balances and Workline 02 expense/income/transfer/month behavior have
    no regression;
27. new manual/generated transaction IDs follow the canonical account-scoped rule,
    while legacy IDs remain readable without private migration.

## Disposable live-Surreal smoke

Use fictional records only and clean up in `finally`.

Prove at minimum:

- create monthly committed outgoing and confirmed/expected incoming schedules;
- deterministic occurrence generation and exact replay;
- month-end recurrence;
- update/pause/resume behavior;
- skip/waive/cancel/overrides;
- settled linked and settled unlinked behavior;
- invalid settlement rejection;
- no observed Transaction or AccountBalanceSnapshot is created by an unlinked
  settlement;
- tRPC/MCP-equivalent service results;
- cleanup leaves no fictional schedules, occurrences, operations, or edges.

Do not inspect, audit, import, or migrate private financial data. Do not start a
new development server. Browser verification may use Michael's existing
user-managed Raven Studio process after a restart.

## Verification

Run, as applicable:

- strict graph validation, specs, generation, dry-run import, and configured local
  schema import;
- generated artifact/identity inspection;
- domain tests and focused typecheck;
- Surreal repository tests and focused typecheck;
- full Account Control tRPC/MCP parity test and MCP typecheck;
- Raven Studio production build;
- disposable fictional Workline 01-03 live smoke;
- archive-safety tests and AI-safe preflight;
- bounded credential-literal scan;
- Brain health;
- root `git diff --check` and nested `apps/schema` diff check.

Report inherited whole-app Schema Kit/Helios typecheck warnings honestly without
absorbing unrelated repairs into this workline.

## Documentation and state

Update:

- `docs/architecture/raven-account-control-contract-v0.1.md` with the accepted
  occurrence identity/effective override clarification and current statuses;
- `docs/architecture/raven-account-control-workline-03-implementation.md`;
- `docs/prompts/raven-account-control-workline-03.md`;
- current documentation authority/index where needed;
- Brain decisions, risks, open loops, roadmap, NOW, handoff, executive summary,
  changelog, and indexes through the standing Brainkeeper protocol;
- Orbit throughout the workline.

Preserve historical ingest records rather than rewriting them.

## Stop gate and final response

When implementation and fictional verification pass, leave Workline 03 in Orbit
`review`; do not mark it done without Michael/external acceptance. Do not begin
Workline 04.

State unambiguously:

- whether product/schema code changed;
- the final CashflowSchedule and CashflowOccurrence identity/field invariants;
- the implemented recurrence and month-end rules;
- every semantic query and command now available through Studio, tRPC, and MCP;
- schedule and occurrence lifecycle behavior;
- settlement/reconciliation validation and what remains unreconciled;
- exact `/upcoming` routes, dialogs, drawers, filters, and command-palette actions;
- the bounded transaction-ID preflight result;
- every verification command/result;
- confirmation that no private data was inspected or migrated;
- known limitations;
- confirmation that Workline 03 is in review and Workline 04 was not started;
- the exact files/screens Michael should inspect for acceptance.
```