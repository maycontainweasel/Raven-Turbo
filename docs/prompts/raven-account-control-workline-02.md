---
status: working
owner: Raven
last_reviewed: 2026-07-11
contract: raven-account-control-contract-v0.1
predecessor: raven-account-control-workline-01
---

# Codex Prompt — Account Control Workline 02: Observed Transactions and Transfers

```text
orbit-workline

Implement Raven Account Control Workline 02: Observed Transactions and Transfers.

Workline 01 is accepted and complete. Do not reopen, re-ingest, or reimplement the
Account Balance Truth vertical. Preserve its exact-money, account identity,
idempotency, balance-selection, note-persistence, and invalid-future invariants.

The Brainkeeper sidecar may run under the standing protocol, but it must not
replace, defer, or terminate the main implementation workline. Continue through
working product code in this run and leave the main Workline in review.

Read and obey:

- root `AGENTS.md` and all required Orbit/Brain startup files;
- `docs/architecture/raven-account-control-contract-v0.1.md`;
- `docs/architecture/raven-account-control-workline-01-implementation.md`;
- `docs/prompts/raven-account-control-workline-01.md` as implementation-pattern
  reference only;
- `apps/schema/AGENTS.md`, `apps/schema/config/AGENTS.md`, and the MPDG/runtime
  authority canon;
- Raven Studio app/server/page AGENTS and generated controller/runtime contracts;
- `packages/raven-domain`, `packages/raven-surreal`, and `apps/raven-mcp`;
- the proven Raven V1 account and transaction routers only as behavioral/query
  references. Do not copy their page architecture or incorrect transfer totals.

Preserve this exact workline instruction in:

`docs/prompts/raven-account-control-workline-02.md`

## Objective

Deliver one complete observed-money loop through the same semantic domain layer:

1. Open a tracked account.
2. View its exact month ledger.
3. Record an expense.
4. Record income.
5. Move money between two tracked accounts as one linked transfer.
6. See exact month income, outflow, and net with transfers excluded.
7. Inspect one transaction's category, provenance, operation receipt, and transfer
   counterpart.
8. Perform the equivalent reads and commands through Raven MCP.

This workline must produce working product code. It is not another architecture-only
review.

## Accepted invariants

The following are already approved and are not approval gates:

- canonical money is validated integer minor units plus currency;
- transaction amounts are positive magnitudes;
- semantic kind is separate from movement flow;
- tracked-account transfers are one aggregate with two linked legs;
- transfer legs never count as income, outflow, or aggregate net;
- observed monetary facts are append-only through semantic product paths;
- every command is idempotent and provenance-backed by `FinancialOperation`;
- Studio, tRPC, and MCP use one shared `AccountControlApi` and domain service;
- recording a transaction does not mutate, synthesize, or silently advance an
  `AccountBalanceSnapshot`;
- unknown and stale balance truth from Workline 01 remains unchanged.

## Bounded contract corrections required inside this workline

These are implementation clarifications implied by the accepted Workline 02 UI.
Apply them in the canonical contract/implementation note without starting a new
broad architecture cycle.

1. **Financial date semantics**
   - Treat a transaction's `postedAt` as a financial calendar date in Account
     Control v0.1.
   - New manual commands accept and persist normalized `YYYY-MM-DD` values.
   - `recordedAt` remains an exact instant.
   - Never round-trip a date-only fact through local-midnight/UTC conversion.
   - Existing parseable date-time rows may be normalized to their explicit leading
     calendar date; invalid values are reported, never guessed.

2. **Legacy transfer uncertainty**
   - Canonical persisted `flowDirection` remains `inflow | outflow`.
   - A legacy transfer lacking canonical flow must remain visibly unresolved on the
     read side (`unknown` or an equivalently explicit uncertainty representation).
   - Add a stable `LEGACY_TRANSFER_AMBIGUOUS` warning.
   - Never infer or backfill a legacy transfer flow from description alone.
   - Ambiguous legacy transfers remain visible in the ledger but are excluded from
     income, outflow, and net.

3. **Enabling semantic reads**
   The promised Account detail UI requires two small shared reads in addition to
   the accepted catalog:
   - `list_categories` for the optional category selector/filter;
   - `get_transaction` for the semantic transaction drawer.
   They must have UI/tRPC/MCP parity and must not expose raw CRUD as product tools.

4. **Account-scoped month progress**
   - Extend `get_month_progress` with an unambiguous optional account filter, such
     as `accountRefs: [{ spaceKey, accountKey }]`.
   - Preserve the unfiltered multi-account use case needed later by Today.
   - Do not identify accounts by `accountKey` alone because keys may repeat across
     Financial Spaces.

5. **Occurrence reconciliation remains deferred**
   - Do not expose and silently discard `occurrenceId` before Workline 03 exists.
   - Add transaction/occurrence linking only with the accepted Upcoming settlement
     workline.

## Scope A — schema canon and migration

Start all schema changes in `apps/schema/config/graph.mpdg`, validate before
regeneration, and regenerate/import through the established schema workflow.
Do not hand-edit generated outputs as source authority.

### Extend `Transaction`

Add canonical, migration-safe optional fields so existing records remain readable:

- `amountMinor: int`;
- `transactionKind: income | expense | transfer | adjustment`;
- `flowDirection: inflow | outflow`;
- `entrySource: imported | manual | generated`;
- `recordedAt`;
- `operation: record<financialOperation>`;
- `transfer: record<accountTransfer>`.

Retain the legacy fields (`amount`, `direction`, `isTransfer`, status, source-row
provenance, category, merchant, notes) during transition.

New semantic writes dual-write only what is necessary for legacy Raven V1
compatibility. Domain calculations must read canonical fields first and never use
legacy floating-point arithmetic after conversion at the adapter boundary.

For new manual entries use legacy compatibility values consistently:

- expense -> `direction=debit`, `isTransfer=false`;
- income -> `direction=credit`, `isTransfer=false`;
- transfer leg -> `direction=transfer`, `isTransfer=true`;
- manual entries may use the existing reviewed/clarified legacy status, but
  `entrySource=manual` is the semantic authority.

### Add `AccountTransfer`

Add one source-authority aggregate containing at least:

- deterministic key/id;
- source Financial Space and Account;
- target Financial Space and Account;
- exact positive amount and currency;
- financial posted date;
- optional trimmed description;
- source transaction leg;
- target transaction leg;
- `FinancialOperation` reference;
- recorded-at instant.

One transfer command creates the aggregate, both legs, and the operation receipt in
one Surreal transaction. The source and target account must differ and both must be
tracked, active, and same-currency in v0.1.

### Transaction exact-money migration

Add an audit-first migration/report in `packages/raven-surreal` with explicit
`audit` and opt-in `apply` modes. The default performs no writes and returns only
aggregate counts; never include private descriptions, account names, amounts, or
source text in the report.

Report at least:

- rows audited;
- already canonical;
- eligible income rows;
- eligible expense rows;
- ambiguous legacy transfers left for review;
- precision/range/date exceptions;
- canonical/legacy conflicts;
- rows applied.

Rules:

- convert legacy amounts with the exact decimal parser;
- canonical amount is a positive magnitude;
- debit -> expense/outflow and credit -> income/inflow only when the legacy row is
  not a transfer;
- do not auto-promote ambiguous legacy transfers;
- use source import time for `recordedAt` when reliable, otherwise use the explicit
  migration recording instant and report the fallback count;
- preserve imported amount/date/source immutability;
- canonical fields win on reads; a valid legacy fallback emits
  `LEGACY_MONEY_FALLBACK`;
- unsupported precision, unsafe range, invalid date, and conflicting canonical
  values become exceptions, never coercions;
- do not run a private-data apply/backfill automatically.

Do not change `StatementRow` or the import pipeline broadly unless a narrowly
required generated dependency makes it unavoidable. Document any such exception.

## Scope B — shared domain contract and service

Extend `packages/raven-domain` rather than creating page-owned financial logic.
Keep browser-safe types separate from server-only implementation where the current
package boundary requires it.

### Required semantic queries

1. `list_account_transactions`
   - input: `spaceKey`, `accountKey`, `month` (`YYYY-MM`), optional kind, flow,
     category, search, cursor, and bounded limit;
   - output: deterministic cursor page of semantic transaction rows plus `QueryMeta`;
   - stable order: financial date descending, then recorded/id tie-breakers;
   - category and transfer identity are visible;
   - legacy ambiguity and fallback warnings are explicit.

2. `get_transaction`
   - resolve one transaction by record id;
   - return exact semantic amount, kind/flow/uncertainty, financial and recorded
     dates, category, merchant/counterparty summary where present, notes, source
     provenance, clarification summary, operation receipt summary, and linked
     transfer/counterpart leg where present;
   - do not return a raw mutable persistence object.

3. `get_month_progress`
   - input: month, currency, optional `spaceKeys`, optional unambiguous account refs,
     and optional `asOf`;
   - exact result: income, outflow, and `net = income - outflow`;
   - transfers and ambiguous legacy transfers are excluded;
   - include useful counts (income, expense, transfer, uncategorized) when they can
     be produced without inventing a second calculation path;
   - all sums use checked minor-unit arithmetic in the domain layer.

4. `list_categories`
   - list active categories for one Financial Space, optionally filtered by
     compatible category kinds;
   - return stable keys, names, kinds, and parent summary where available;
   - this is a selection/read surface only; category creation/editing is not part of
     Workline 02.

5. Complete Workline 01's existing `get_account.availableMonths` result from
   observed transaction dates, newest first. Do not leave it as an empty placeholder.

### Required semantic commands

1. `record_expense`
   - one manual `expense/outflow` transaction;
   - exact strictly positive amount;
   - tracked account and matching currency required;
   - normalized financial date and non-empty description required;
   - optional same-space compatible category;
   - append-only; no balance snapshot mutation.

2. `record_income`
   - one manual `income/inflow` transaction;
   - same exactness, date, account, category, provenance, and idempotency rules.

3. `record_transfer`
   - validate distinct source/target account refs before persistence;
   - same currency and strictly positive amount;
   - one `AccountTransfer`, one source `transfer/outflow` leg, one target
     `transfer/inflow` leg, and one `FinancialOperation` receipt;
   - all four records are applied atomically;
   - replay returns the same aggregate and legs;
   - a reused key with a changed request returns `IDEMPOTENCY_CONFLICT`;
   - transfer legs never receive expense/income categories and never enter those
     totals.

### Validation and truth rules

- Trim descriptions and category keys before hashing/persistence.
- Validate financial dates without timezone shifting.
- Require `minorUnits > 0` for all three commands.
- Validate a supplied category exists, belongs to the command's Financial Space,
  is active, and is direction-compatible. Expense-compatible kinds may include
  expense/tax/savings/other; income-compatible kinds may include income/other.
- Canonical transaction identity is deterministic from the operation/leg so replay
  can resolve the original entity.
- Expand `FinancialOperationRecord.command`, request hashing, replay resolution, and
  receipt entity references for the three commands.
- Add stable errors such as `INVALID_TRANSACTION_DATE`, `INVALID_CATEGORY`,
  `DUPLICATE_TRANSFER`, and `TRANSACTION_IMMUTABLE` only where the domain can return
  them consistently through tRPC and MCP.
- No semantic transaction update/delete operation exists in this workline.
- Do not adjust a confirmed balance after recording movement. Balance truth remains
  separately observed and timestamped.

## Scope C — Surreal repository

Extend the existing repository port/adapter; do not bypass it from Vue, tRPC, or
MCP.

Required behavior:

- read canonical transaction fields first and use an exact legacy adapter second;
- fetch category/source/operation/transfer fields narrowly enough for the semantic
  outputs;
- calculate financial totals in the shared domain service, not with legacy Surreal
  float sums;
- provide stable cursor pagination;
- create expense/income transaction plus operation atomically;
- create transfer aggregate, both legs, and operation atomically;
- map duplicate/idempotency/database races to stable Raven domain errors or replay;
- never use Typesense for critical ledger reads;
- preserve source-authority and single-database routing;
- retain generic generated CRUD only for schema/admin mechanics, not product paths.

## Scope D — tRPC and Raven MCP parity

Add thin tRPC procedures under `accountControl` and matching semantic MCP tools:

Queries:

- `list_account_transactions`
- `get_transaction`
- `get_month_progress`
- `list_categories`

Commands:

- `record_expense`
- `record_income`
- `record_transfer`

The existing Workline 01 operations must remain unchanged and continue to pass.

MCP descriptions must make these distinctions explicit:

- expense/income record observed movement, not a plan;
- transfer moves money between tracked accounts and is excluded from spending and
  income;
- transaction reads may contain legacy uncertainty warnings;
- canonical MCP money input remains `{ currency, minorUnits }`.

Add parity tests proving the same service input produces contract-equivalent tRPC
and MCP output for every new operation.

## Scope E — Raven Studio product UI

Keep the accepted quiet black/system-aware, Notion/GitHub-like direction. Data is
more important than decoration. Do not add a dashboard card system, charts,
gradients, hero copy, or broad design-system work.

### Route and navigation

Implement:

`/accounts/[spaceKey]/[accountKey]`

- make account names/rows on `/accounts` navigate to the detail route while the
  freshness control continues to open balance confirmation;
- add Account detail navigation to the central route/action registry and command
  palette;
- retain both Command/Control+P and Command/Control+K;
- update the top-bar Add action into a minimal quick-create choice rather than
  permanently adding navigation clutter.

### Account detail page

The page must include:

- breadcrumb and account identity;
- selected balance, balance kind, as-of time, and freshness;
- `Update balance`, `Expense`, `Income`, and `Transfer` actions;
- month selector driven by semantic available months, defaulting to the current
  local calendar month;
- exact month income, outflow, and net, with a visible statement that transfers are
  excluded;
- compact transaction table with Date, Description, Kind/flow, Category, and Amount;
- optional kind/flow/category/search filters backed by the semantic query;
- loading, empty, error, legacy-warning, partial, and pagination states;
- accessible keyboard row navigation;
- a semantic transaction drawer on row activation.

Display signs/arrows in presentation only:

- income/inflow -> positive visual sign;
- expense/outflow -> negative visual sign;
- transfer source/target -> directional transfer treatment;
- canonical persisted amounts remain positive magnitudes.

A recorded transaction must refresh the ledger/month progress but must not make the
last confirmed balance appear newer or silently subtract from it. Make that
separation understandable without adding explanatory clutter.

### Entry dialogs

Build the smallest accessible Ark UI flows needed:

- expense/income dialog: account, positive amount, financial date, description,
  optional category;
- transfer dialog: source account, target account, positive amount, financial date,
  optional description;
- account is preselected when invoked from Account detail and selectable when
  invoked globally;
- only same-currency eligible target accounts appear for transfer;
- each open dialog owns one command-intent idempotency key, reuses it across failed
  retries/lost responses, and resets it only under the accepted Workline 01 rules;
- user-entered amount is a decimal string parsed at the UI boundary; never use it
  directly in calculations.

### Transaction drawer

Show, when available:

- exact amount and currency;
- kind and flow or explicit legacy-flow uncertainty;
- financial date and Raven recorded time;
- category and merchant/counterparty summary;
- source/import provenance without a raw editable object;
- operation id/receipt for manual commands;
- transfer counterpart and linked aggregate;
- clarification state as read-only context.

No edit/delete control for monetary facts.

As with `/accounts`, operational queries must not depend on SSR access to the local
Surreal service. Preserve the successful client-load pattern and honest loading
state.

## Scope F — tests and verification

Use fictional fixtures only. Never copy real account names, descriptions, client
names, transaction text, balances, statements, mailbox data, or credentials into
tests, snapshots, docs, logs, or prompts.

Required focused tests include:

1. Expense creates positive exact `expense/outflow`; income creates positive exact
   `income/inflow`.
2. Zero, negative, unsafe, excess-precision, unsupported-currency, invalid-date,
   wrong-account-currency, and invalid-category inputs fail predictably.
3. Idempotent replay returns the original transaction; changed request conflicts.
4. Recording expense/income creates no balance snapshot and does not alter freshness.
5. Transfer creates one aggregate and two opposite linked legs in one transaction.
6. Same-account and cross-currency transfers fail without partial records.
7. Transfer replay is stable; changed request conflicts.
8. Month totals exclude both transfer legs and all ambiguous legacy transfers.
9. Canonical transaction fields win over conflicting legacy fields.
10. Valid legacy debit/credit fallback is exact and emits
    `LEGACY_MONEY_FALLBACK`.
11. Legacy transfer without canonical flow stays visible, unresolved, excluded, and
    emits `LEGACY_TRANSFER_AMBIGUOUS`.
12. Account available months are deterministic and newest first.
13. Pagination/order/filter behavior is deterministic under fixed fixtures.
14. Category validation is space- and direction-safe.
15. Every new Studio/tRPC operation has equivalent MCP behavior.
16. Existing Workline 01 balance/freshness/idempotency tests remain green.

Verification must include:

- schema graph validation before regeneration;
- required schema generation/import checks and authority inspection;
- focused `@raven/domain`, `@raven/surreal`, and Raven MCP tests/typechecks;
- Raven Studio production build;
- a disposable live-Surreal smoke using fictional records for expense, income,
  transfer, replay, totals, and cleanup;
- credential-literal/secret-safety checks;
- no dev server start;
- no private-data migration apply.

Known inherited whole-app Nuxt typecheck failures outside Account Control must not
be folded into this workline. Run the accepted focused checks and production build,
and report any unrelated inherited failures honestly.

## Documentation, Brain, and Orbit

Create/update:

- `docs/prompts/raven-account-control-workline-02.md`;
- `docs/architecture/raven-account-control-workline-02-implementation.md`;
- the bounded Workline 02 corrections in the canonical Account Control contract;
- documentation authority index;
- durable Brain decisions/open loops/risks only where project understanding changes;
- Orbit Workline status at meaningful phase transitions.

Also reconcile the small durable-state drift visible after Workline 01:

- `RISK-0008` must no longer claim exact money is unconfirmed; mark the original
  inexact-money foundation risk closed or rewrite only the residual legacy-migration
  risk precisely;
- update `brain/ROADMAP.md` so the shared-domain contract and Account Balance Truth
  are not still described as future work;
- remove the stale “approval gate remains open” wording from closed `OL-0016` and
  `OL-0017`;
- classify the Workline 01 prompt as completed/reference rather than still gated.

Treat this as bounded Brain consistency, not a separate planning workline.

Do not mark Workline 02 done. Leave it in `review` for Michael/external acceptance.
Do not start Workline 03.

## Explicit boundaries

Do not implement:

- cashflow schedules or occurrences;
- Upcoming;
- Today coverage/gap/rate calculations;
- recurring-pattern promotion;
- transaction correction/reversal UI;
- raw transaction update/delete;
- category management CRUD;
- statement ingestion redesign;
- transfer-candidate acceptance/reconciliation;
- tax, invoicing, opportunities, retainers, budgets, debt strategy, Orbit execution,
  or Elgiz buckets;
- broad Raven V1 refactoring;
- broad Schema Kit/Helios cleanup.

Preserve unrelated dirty-worktree and nested-repository changes.

## End response

State unambiguously:

- whether product code was implemented;
- every schema model/field added or changed;
- exact migration audit/apply behavior and whether private data was touched;
- every shared query and command added;
- exact tRPC procedures and MCP tools added;
- exact routes, dialogs, filters, drawer behavior, command-palette actions, and
  interactions now working;
- proof that transfers are excluded from month totals;
- proof that transaction commands do not mutate balance truth;
- tests and exact commands run, with results;
- live-smoke behavior and cleanup;
- known limitations and unresolved migration exceptions;
- files and UI states Michael should inspect for acceptance;
- confirmation that Workline 03 was not started.

Leave the Orbit Workline in review.
```
