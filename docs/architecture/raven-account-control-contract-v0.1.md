---
status: canonical
owner: Raven
last_reviewed: 2026-07-18
supersedes: []
superseded_by: []
---

# Raven Account Control Contract v0.1

## Decision Status

Michael explicitly approved the four financial invariants on 2026-07-11. This contract is the implementation authority for the bounded Account Control sequence, subject to the binding clarifications recorded below.

Already accepted:

- Raven Studio is the primary UX rebuild; Raven V1 is a behavioral reference.
- Raven is headless-first: Studio and the semantic Raven MCP share one application/domain layer.
- The first product slice is present control across Today, Accounts, Account detail, and Upcoming.
- The initial UI is quiet, dense, minimal, keyboard-friendly, and data-first.
- Observed, accepted, inferred, and possible financial truth must remain distinct.

Approved here:

1. exact integer minor-unit money and append-only transaction semantics;
2. explicit account balance snapshots and freshness;
3. neutral cashflow schedules plus materialized occurrences;
4. deterministic coverage and earning-rate calculations with partial-data states.

## Repository Evidence

The proposal is grounded in the current repository rather than a greenfield model:

| Surface                         | Observed fact                                                                                                                                                     | Contract consequence                                                                                                       |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `apps/schema/config/graph.mpdg` | `FinancialSpace`, `Account`, `Transaction`, `Category`, statement models, clarification models, `Client`, and `Retainer` exist. All are source-authority records. | Extend schema canon; do not create parallel page-owned persistence.                                                        |
| Generated model metadata        | Raven Studio is single-database and all relevant models resolve to source authority.                                                                              | Semantic writes use the generated default/source instance; there is no instance fan-out in this slice.                     |
| Existing money fields           | Monetary fields currently generate as JavaScript `number`.                                                                                                        | Existing fields are legacy compatibility fields, not the new exact domain contract.                                        |
| `Account`                       | Has `openingBalance`, but no explicit current balance, kind, as-of time, source, or freshness.                                                                    | Add `AccountBalanceSnapshot`; do not overwrite `Account` to confirm a balance.                                             |
| `Transaction`                   | Has `amount`, optional historical `balance`, `direction`, `isTransfer`, and source-row provenance.                                                                | Add canonical exact amount, kind, flow, source, and transfer linkage while dual-reading legacy rows.                       |
| Custom account router           | Provides explorer, month, and transfer-match queries. Its month net currently subtracts transfers.                                                                | Reuse query shape and ordering, but not its financial summary formula. Transfers must be excluded from income/outflow/net. |
| Custom financial-space router   | Provides active spaces, grouped accounts, counts, and latest activity.                                                                                            | Extract grouping/query patterns into the repository adapter.                                                               |
| Custom transaction router       | Provides a useful transaction-detail read.                                                                                                                        | Preserve the detail shape, then adapt its money and provenance into the semantic contract.                                 |
| Generated CRUD                  | Create/update/delete/resource endpoints exist per model.                                                                                                          | Retain for schema/admin mechanics; do not expose them as normal UI or MCP financial commands.                              |
| Raven MCP                       | Only generic `raven-surreal-local` database access exists.                                                                                                        | Add a separate semantic MCP app; keep generic Surreal MCP diagnostic.                                                      |
| Raven Studio                    | The only product route is a blank `/`. Ark UI and Lucide/Uno support are installed.                                                                               | Build only the small shell and route primitives needed by the vertical slices.                                             |

No existing custom router satisfies the final semantic contract unchanged. The `_surreal` helpers, router-merge convention, record lookup patterns, transaction ordering, detail query, and grouping logic are reusable. Financial totals and user-facing command behavior move into the shared domain layer.

## 1. Financial Invariants

### 1.1 Exact Money

| Concern          | Recommendation                                                                                                                       | Rule                                                                                                                       |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| Persistence      | Store canonical money as SurrealDB `int` minor units beside an ISO 4217 currency code.                                               | `12345` means ZAR 123.45. No canonical float/decimal amount.                                                               |
| TypeScript       | Use branded safe integers: `type MinorUnits = number & { readonly __minorUnits: unique symbol }`.                                    | Constructors require `Number.isSafeInteger`; every add, subtract, multiply, and sum checks overflow.                       |
| tRPC/MCP wire    | Use `{ currency: string, minorUnits: integer }`.                                                                                     | The wire schema requires a safe integer. Do not send formatted decimal strings as canonical values.                        |
| Input            | Accept a positive human decimal string at the UI boundary, then parse with the currency exponent. MCP accepts canonical `MoneyWire`. | For ZAR, reject non-zero precision beyond two decimal places. Do not silently round entered facts.                         |
| Derived division | Use integer quotient/remainder.                                                                                                      | Required earning rates round upward to the next minor unit so the requirement is never understated.                        |
| Formatting       | Use `Intl.NumberFormat` after converting minor units for display only.                                                               | Formatting never feeds calculations or persistence.                                                                        |
| Currency support | Start with an explicit currency exponent registry containing ZAR (`2`).                                                              | Unsupported currencies return `UNSUPPORTED_CURRENCY`; cross-currency totals remain separate until an FX contract exists.   |
| Existing fields  | Add `*Minor` fields and dual-read canonical-first, legacy-second.                                                                    | A legacy fallback emits `LEGACY_MONEY_FALLBACK`; semantic commands dual-write during migration.                            |
| Migration        | Audit scale, backfill with decimal-safe conversion, compare, then promote canonical reads.                                           | Values with more than the supported exponent or an unsafe range go to a migration exception report, never silent coercion. |

The generated schema currently maps `int` to `z.number().int()`. The semantic layer must add `safe()` validation and own all exact-money reads/writes. Raw generated CRUD is not an approved money command surface.

### 1.2 Transaction Truth

Canonical transaction fields are separate from legacy `direction`:

- `amountMinor` is always a positive magnitude.
- `transactionKind` is `income | expense | transfer | adjustment | unresolved`.
- `flowDirection` is `inflow | outflow`.
- `entrySource` is `imported | manual | generated`.
- `recordedAt` is when Raven recorded the fact; `postedAt`/`effectiveAt` remain financial dates.
- `operation` links manual/generated writes to a `FinancialOperation` receipt.
- `transfer` links both transfer legs to one `AccountTransfer` aggregate.

Command behavior:

| Command           | Canonical effect                                                                                                  | Counting rule                                                   |
| ----------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| `record_expense`  | One manual `expense/outflow` transaction with positive magnitude.                                                 | Included in outflow and net.                                    |
| `record_income`   | One manual `income/inflow` transaction with positive magnitude.                                                   | Included in income and net.                                     |
| `record_transfer` | Atomically create one `AccountTransfer`, one `transfer/outflow` source leg, and one `transfer/inflow` target leg. | Both legs are excluded from income, outflow, and aggregate net. |

Additional rules:

- Canonical transaction semantics are authoritative only when exact positive money, financial date, kind/flow, entry source, and Raven recording instant form a complete, valid, coherent tuple. Complete canonical truth wins conflicts; partial fields and generated sentinels do not independently override coherent legacy evidence.
- Optional migration-era semantic fields have no economically meaningful generated default. Unknown direction and unresolved semantics remain explicit and never imply expense or outflow.
- Imported debit becomes exact `expense/outflow`; imported credit becomes exact `income/inflow`. A transfer without source-proven flow remains transfer with unknown flow. Malformed or missing direction becomes `unresolved` with unknown flow. Ambiguous and unresolved rows remain inspectable but are excluded from financial totals.
- A transfer requires different tracked accounts, the same currency in v0.1, one amount, and one idempotency key.
- Existing transfer matching remains inferred evidence. A candidate does not become a linked transfer without review.
- Imported monetary facts are immutable. Classification/meaning may be reviewed with audit, but amount/date/source corrections use append-only correcting entries.
- Manual monetary corrections are also append-only: reversal plus replacement under one operation. The first slice does not expose raw transaction update/delete.
- Every command requires `idempotencyKey`. Repeating the same key and request hash returns the prior receipt; the same key with a different hash returns `IDEMPOTENCY_CONFLICT`.
- If concurrent first writes race, a duplicate-looking write failure triggers an operation reread: matching command/hash replays the original entities, a changed hash returns `IDEMPOTENCY_CONFLICT`, and no operation preserves the genuine storage failure.
- Provenance records actor, channel (`ui | mcp | import | system`), operation, source reference where applicable, and timestamps.

#### Imported Identity And Replay

Local semantic keys remain public API values, while persisted identities include their owner:

| Model                | Persisted identity                                                    |
| -------------------- | --------------------------------------------------------------------- |
| `StatementImport`    | account + import key                                                  |
| `StatementRow`       | StatementImport + stable row key                                      |
| `Transaction`        | account + transaction key; imported keys include import key + row key |
| `Category`           | Financial Space + local key                                           |
| `Merchant`           | Financial Space + local key                                           |
| `ClassificationRule` | Financial Space + local key                                           |
| `ClarificationTask`  | transaction + local key                                               |

The statement import executes atomically through dedicated ensure functions. Immutable source checksums cover account/import scope, financial date, amount, currency, raw source evidence, and source-row identity, while excluding reviewed classification meaning. Exact replay reuses records, edges, and the original `importedAt`. Reusing an identity with changed immutable facts returns `RAVEN_IMPORT_IMMUTABLE_CONFLICT` and rolls back the whole import. Reviewed category, merchant, kind, flow, and clarification status move only through the explicit review path; that path cannot alter money, date, checksum, source row, source import, or account.

Source corrections require a new import/replacement identity and later explicit lineage. They do not mutate an accepted imported fact in place.

### 1.3 Account And Balance Semantics

`Account` gains stable classification, not a mutable current balance:

- `normalNature: asset | liability`
- `liquidityClass: liquid | non_liquid`
- `freshnessWindowHours: int`
- `openingBalanceMinor` for migration compatibility only

Each balance observation is an immutable `AccountBalanceSnapshot`:

| Field                     | Meaning                                                  |
| ------------------------- | -------------------------------------------------------- | ----------------- | --------------------------------------------------------------------------- | ------------- | -------------- |
| `account`, `space`        | Owning records.                                          |
| `balanceKind`             | `available                                               | ledger            | statement                                                                   | market_value  | outstanding`.  |
| `amountMinor`, `currency` | Non-negative magnitude in canonical exact money.         |
| `economicNature`          | `asset                                                   | liability         | informational`; controls position inclusion and supports overdrafts safely. |
| `asOf`                    | When the balance was true.                               |
| `recordedAt`              | When Raven learned it.                                   |
| `evidenceLevel`           | `confirmed                                               | observed`.        |
| `sourceKind`              | `manual_confirmation                                     | statement_closing | transaction_observation                                                     | provider_sync | market_quote`. |
| `sourceRef`               | Optional record reference; no copied raw statement text. |
| `operation`               | Command receipt for manual/generated observations.       |

Balance-kind rules:

| Kind           | Primary use                                         | Position treatment                                                                                |
| -------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `available`    | Spendable cash reported for a liquid asset account. | Counts as liquid and asset only when `economicNature=asset`; available credit is `informational`. |
| `ledger`       | Posted account balance.                             | Position fallback for current/savings/cash accounts.                                              |
| `statement`    | Closing balance from an imported statement.         | Observed fallback; never described as current without a newer confirmation.                       |
| `market_value` | Current value of an investment or other asset.      | Counts as non-liquid asset unless the account explicitly says liquid.                             |
| `outstanding`  | Amount owed on credit, loan, or debt.               | Counts as a liability.                                                                            |

Selection and freshness:

1. Establish the account-specific preferred kinds: liquid assets prefer `available`, then `ledger`, then `statement`; investments prefer `market_value`; liabilities prefer `outstanding`, then `statement`.
2. Search that preference chain for a fresh eligible snapshot and select the first preferred kind with fresh evidence.
3. Only when no preferred kind is fresh, select the newest eligible stale observation and use kind preference as a tie-breaker.
4. Never select an `invalid_future` snapshot, and never substitute an `informational` snapshot into net position or liquid cash.
5. `ageHours = floor((queryAsOf - snapshot.asOf) / 1 hour)`.
6. State is `fresh` when age is within `freshnessWindowHours`, `stale` when older, `unknown` when no eligible snapshot exists, and `invalid_future` when `asOf` is unreasonably ahead of query time.
7. A latest imported transaction balance may be backfilled as `transaction_observation/observed`. It remains an observation with its historical `asOf`; it is not a manual current-balance confirmation.

Aggregation:

- `liquidCash`: selected fresh or stale asset positions from accounts marked liquid; stale values remain visible but make the result provisional.
- `knownAssets`: all selected `economicNature=asset` position amounts.
- `knownLiabilities`: all selected `economicNature=liability` position amounts.
- `knownNetPosition = knownAssets - knownLiabilities`.
- Unknown accounts are not treated as zero. Results include completeness, missing account IDs, stale account IDs, and warnings.
- If any active liquid account is unknown, coverage is `unavailable`. If liquid balances are only stale, coverage is numeric but `provisional` and never presented as decision-grade.

### 1.4 Upcoming Cashflow Model

| Option                                            | Strengths                                                                                                                                 | Weaknesses                                                                                                                      | Verdict          |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| Separate `Obligation` and `Receivable` models     | Direction-specific names and validation.                                                                                                  | Duplicates recurrence, occurrence, settlement, pause/end, provenance, UI, and MCP behavior; cross-direction views become joins. | Reject for v0.1. |
| `CashflowSchedule` only                           | Smallest table count.                                                                                                                     | Repeating rules cannot preserve concrete due-state, amount snapshots, settlement, skips, or transaction reconciliation.         | Reject.          |
| Neutral `CashflowSchedule` + `CashflowOccurrence` | One lifecycle for incoming/outgoing while preserving direction and certainty; deterministic concrete due items; shared UI/MCP operations. | Requires strict direction-specific validation.                                                                                  | Recommend.       |

Recommended names:

- `CashflowSchedule`
- `CashflowOccurrence`

Schedule contract:

- `direction: outflow | inflow`
- outgoing certainty: `committed`
- incoming certainty: `confirmed | expected | possible`
- `cadence: once | weekly | monthly | quarterly | yearly`
- positive `amountMinor`, currency, local `startDate`, optional `endDate`, IANA timezone, interval, and cadence-specific day fields
- `status: active | paused | ended | cancelled`
- schedule reads expose persisted `configuredStatus`, timezone/as-of-derived `effectiveStatus`, and the next accepted `pendingTransition` without adding duplicate persistence fields
- optimistic `revision`

Occurrence contract:

- `scheduledDueOn` is the immutable nominal recurrence date and identity anchor;
- occurrence identity is unique on `(schedule, scheduledDueOn)`;
- `dueOn` is the effective date shown to the user and may be overridden without changing identity;
- `scheduledAmountMinor` preserves the amount copied from the schedule revision, while `amountMinor` is the effective amount and may be overridden;
- copies direction, certainty, currency, title, and schedule revision so history does not change when a schedule changes;
- `status: due | settled | skipped | waived | cancelled`;
- `overdue` is derived when status is `due` and `dueOn` is before the schedule's local today;
- settled outflow is displayed as `paid`; settled inflow as `received`;
- settlement may link an observed transaction; an unlinked settlement is allowed but emits `UNRECONCILED_SETTLEMENT` and is not invented as an observed transaction.

Deterministic generation:

- Occurrence identity is unique on `(schedule, scheduledDueOn)` for v0.1; due-date overrides never change identity.
- Generation uses the schedule timezone and materializes through a requested horizon transactionally.
- Every list or materialization horizon is bounded to 1,831 calendar days. Re-running the same or a shorter horizon is a no-op; `materializedThrough` advances monotonically inside the database transaction.
- `termsEffectiveFrom` is the schedule terms-authority boundary. An update preserves old terms before the boundary, applies new terms only at or after it, and reconciles only the already materialized interval. Obsolete due rows are cancelled, never deleted.
- Ordinary extension begins strictly after the current materialized boundary. A future-effective update first closes any old-rule gap through the day before its boundary; later extension uses the accepted new rule.
- Updating a schedule increments `revision`; settled, skipped, waived, and cancelled rows remain frozen. Every proposed due-row patch carries its expected occurrence revision and status.
- Schedule revision, schedule status, every targeted occurrence revision/status, deterministic creates, FinancialOperation, and all entity writes are validated/applied atomically.
- Pause preserves accepted due dates through `pausedOn` and creates no new dates after it. Resume begins at `resumedOn`, cancels a pre-materialized paused gap, and never backfills that gap.
- Ending or cancelling from paused state never materializes the paused gap. Any already materialized row after `pausedOn` that is still `due` is atomically terminalized with the schedule operation; settled, skipped, waived, and already-cancelled rows remain unchanged.
- End preserves dates on or before `endedOn` and cancels due rows after it. Cancel preserves prior truth and cancels unsettled occurrences on or after `cancelledOn`.

Schedule transition matrix:

| Current status | Allowed commands                                   |
| -------------- | -------------------------------------------------- |
| `active`       | update, pause, end, cancel                         |
| `paused`       | update while remaining paused, resume, end, cancel |
| `ended`        | none; terminal                                     |
| `cancelled`    | none; terminal                                     |

Invalid transitions return `INVALID_SCHEDULE_TRANSITION`. Lifecycle dates must not precede `startDate`, the current terms-authority boundary, or applicable prior lifecycle dates. Terminal markers are cleared or retained only by the canonical transition planner, so active schedules cannot carry stale end/cancel markers.

Settlement evidence:

- Settlement linking is authoritative only inside the same Surreal transaction that changes the occurrence.
- The transaction must contain complete canonical integer money, a financial date, Raven recording time, entry source, coherent expense/outflow or income/inflow semantics, and no warning/fallback state. Ignored, unresolved, transfer, partial, and legacy-fallback rows are rejected.
- Currency and effective amount must match exactly. Financial Space must match. If the schedule assigns an account, that account must match exactly.
- One observed Transaction can be active settlement evidence for only one occurrence. A generated unique optional index is the structural guard; concurrent attempts produce one applied link and one `OCCURRENCE_CONFLICT`.
- Linking never mutates Transaction money, date, account, category, status, provenance, or balance evidence.

Upcoming query semantics:

- Per-currency summaries expose `committedOutflow`, `confirmedInflow`, `expectedInflow`, `possibleInflow`, `dueCount`, and `unreconciledCount`. They do not expose an all-certainty net.
- Schedule lists, detail occurrence lists/counts, next-due selection, upcoming lists, and summaries use the same lifecycle-eligibility rule. A due row in a paused gap or outside an accepted terminal boundary is never visible or counted as an obligation.
- Every occurrence exposes `timing.group`, `timing.timezone`, and `timing.localToday` under the query's explicit `asOf`. Groups are `overdue`, `today`, `next_seven_days`, `later_this_month`, `later`, and `history`; terminal rows always belong to history.
- Query quality becomes partial when an included settled occurrence is unreconciled. Omitted scope means all; an explicit empty scope means none.
- FinancialOperation remains the audit authority. Cashflow operations retain bounded note/reason/effective-date and before/after override facts in `auditMeta`, and schedule operations reference the schedule plus affected occurrences.

Certainty boundary:

- Coverage includes committed outgoing occurrences.
- Coverage includes only confirmed incoming occurrences due from the query date through the horizon.
- Overdue incoming, expected incoming, and possible incoming are shown separately and excluded from coverage.
- `RecurringPattern` is inferred evidence only and is not part of the first write model. Promotion requires an explicit review that creates a schedule. No inferred row auto-creates a schedule.
- An Opportunity model belongs to the later Earn lane. A possible cashflow is not counted as an opportunity conversion or confirmed cash.

### 1.5 Calculation Semantics

All calculations are per currency. v0.1 does not convert currencies.

| Result                  | Exact rule                                                                                                                                                 |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Month-to-date income    | Sum canonical `income/inflow` transaction magnitudes from local month start through `asOf`; exclude transfers, ignored/superseded facts, and future dates. |
| Month-to-date outflow   | Sum canonical `expense/outflow` transaction magnitudes over the same interval; exclude transfers.                                                          |
| Month-to-date net       | Income minus outflow.                                                                                                                                      |
| Liquid cash             | Sum selected liquid account asset positions. Unknown liquid accounts make coverage unavailable; stale ones make it provisional.                            |
| Known position          | Known assets minus known liabilities, with missing/stale account lists.                                                                                    |
| Confirmed incoming      | Unsettled `inflow/confirmed` occurrences from local today through horizon. Overdue incoming is excluded.                                                   |
| Committed outgoing      | Unsettled `outflow/committed` occurrences due on or before horizon, including overdue items.                                                               |
| Coverage surplus        | `liquidCash + confirmedIncoming - committedOutgoing`.                                                                                                      |
| Coverage gap            | `max(0, -coverageSurplus)`.                                                                                                                                |
| Remaining calendar days | Local dates from query date through horizon, inclusive.                                                                                                    |
| Remaining workdays      | Inclusive local dates whose weekday is configured for the selected Financial Space; zero is explicit.                                                      |
| Planned billable time   | Explicit override, or remaining workdays multiplied by configured billable minutes per workday.                                                            |
| Required per workday    | `ceil(coverageGapMinor / remainingWorkdays)`.                                                                                                              |
| Required per hour       | `ceil(coverageGapMinor * 60 / plannedBillableMinutesRemaining)`.                                                                                           |

Zero denominators return `RATE_UNAVAILABLE`, not infinity or zero. Every calculation result exposes inputs, formula version, `asOf`, horizon, currency, completeness, freshness warnings, and excluded values by certainty.

## 2. Shared Semantic Contract

### 2.1 Contract Sketch

These sketches define the boundary; they are not an implementation scaffold.

```ts
type Brand<T, Name extends string> = T & { readonly __brand: Name };
type MinorUnits = Brand<number, "MinorUnits">;
type ISODate = Brand<string, "ISODate">;
type Instant = Brand<string, "Instant">;
type IdempotencyKey = Brand<string, "IdempotencyKey">;

type MoneyWire = Readonly<{
  currency: string;
  minorUnits: number; // validated safe integer
}>;

type WarningCode =
  | "BALANCE_STALE"
  | "BALANCE_UNKNOWN"
  | "PARTIAL_POSITION"
  | "LEGACY_MONEY_FALLBACK"
  | "LEGACY_TRANSFER_AMBIGUOUS"
  | "LEGACY_TRANSACTION_INVALID"
  | "TRANSACTION_SEMANTICS_UNRESOLVED"
  | "PARTIAL_CANONICAL_TRANSACTION"
  | "CANONICAL_LEGACY_CONFLICT"
  | "TRANSACTION_DATE_INVALID"
  | "IMPORTED_BALANCE_OBSERVATION"
  | "UNRECONCILED_SETTLEMENT"
  | "EXPECTED_INCOME_EXCLUDED"
  | "POSSIBLE_INCOME_EXCLUDED"
  | "OVERDUE_INCOME_EXCLUDED"
  | "CROSS_CURRENCY_EXCLUDED"
  | "RATE_UNAVAILABLE";

type ErrorCode =
  | "NOT_FOUND"
  | "INVALID_MONEY"
  | "UNSUPPORTED_CURRENCY"
  | "CURRENCY_MISMATCH"
  | "INVALID_ACCOUNT_CLASSIFICATION"
  | "INVALID_BALANCE_KIND"
  | "INVALID_TRANSACTION"
  | "INVALID_TRANSACTION_DATE"
  | "INVALID_CATEGORY"
  | "INVALID_RECURRENCE"
  | "INVALID_CERTAINTY"
  | "IDEMPOTENCY_CONFLICT"
  | "DUPLICATE_TRANSFER"
  | "TRANSACTION_IMMUTABLE"
  | "OCCURRENCE_CONFLICT"
  | "OCCURRENCE_ALREADY_SETTLED"
  | "SCHEDULE_REVISION_CONFLICT"
  | "INTERNAL";

type Provenance = Readonly<{
  channel: "ui" | "mcp" | "import" | "system";
  actorId?: string;
  sourceKind?: string;
  sourceRef?: string;
  operationId?: string;
  recordedAt: Instant;
}>;

type QueryMeta = Readonly<{
  asOf: Instant;
  currency?: string;
  quality: "complete" | "partial" | "provisional" | "unavailable";
  warnings: readonly WarningCode[];
  provenance: readonly Provenance[];
}>;

type CommandMeta = Readonly<{
  idempotencyKey: IdempotencyKey;
  channel: "ui" | "mcp" | "system";
  actorId?: string;
}>;

type CommandReceipt = Readonly<{
  operationId: string;
  idempotencyKey: IdempotencyKey;
  status: "applied" | "replayed";
  entityRefs: readonly string[];
  recordedAt: Instant;
  warnings: readonly WarningCode[];
}>;
```

```ts
type AccountSummary = Readonly<{
  spaceKey: string;
  accountKey: string;
  name: string;
  accountType: string;
  normalNature: "asset" | "liability";
  liquidityClass: "liquid" | "non_liquid";
  selectedBalance: BalanceView | null;
  freshness: FreshnessView;
}>;

type BalanceView = Readonly<{
  snapshotId: string;
  kind: "available" | "ledger" | "statement" | "market_value" | "outstanding";
  money: MoneyWire;
  economicNature: "asset" | "liability" | "informational";
  asOf: Instant;
  recordedAt: Instant;
  evidenceLevel: "confirmed" | "observed";
  sourceKind: string;
}>;

type FreshnessView = Readonly<{
  state: "fresh" | "stale" | "unknown" | "invalid_future";
  ageHours: number | null;
  windowHours: number;
  asOf: Instant | null;
}>;

type TransactionView = Readonly<{
  id: string;
  account: { spaceKey: string; accountKey: string };
  financialDate: ISODate | null;
  recordedAt: Instant | null;
  description: string;
  amount: MoneyWire | null;
  kind: "income" | "expense" | "transfer" | "adjustment" | "unresolved";
  flowDirection: "inflow" | "outflow" | null;
  status:
    | "imported"
    | "normalized"
    | "matched"
    | "classified"
    | "clarified"
    | "ignored";
  category?: { key: string; name: string };
  merchantName?: string;
  transferId?: string | null;
  provenance: Provenance;
  warnings: WarningCode[];
}>;

type CashflowView = Readonly<{
  occurrenceId: string;
  scheduleId: string;
  title: string;
  dueOn: ISODate;
  money: MoneyWire;
  direction: "outflow" | "inflow";
  certainty: "committed" | "confirmed" | "expected" | "possible";
  status: "due" | "settled" | "skipped" | "waived" | "cancelled";
  overdue: boolean;
  recurrenceLabel: string;
  transactionId?: string;
}>;
```

```ts
type ListAccountsInput = { spaceKeys?: string[]; asOf?: Instant };
type ListAccountsOutput = {
  spaces: Array<{ key: string; name: string; accounts: AccountSummary[] }>;
  meta: QueryMeta;
};

type GetAccountInput = { spaceKey: string; accountKey: string; asOf?: Instant };
type GetAccountOutput = {
  account: AccountSummary;
  availableMonths: string[];
  meta: QueryMeta;
};

type ListAccountTransactionsInput = {
  spaceKey: string;
  accountKey: string;
  month: string;
  kind?: TransactionView["kind"];
  flow?: "inflow" | "outflow" | "unknown";
  categoryKey?: string;
  search?: string;
  cursor?: string;
  limit?: number;
};
type ListAccountTransactionsOutput = {
  account: { spaceKey: string; accountKey: string };
  month: string;
  transactions: TransactionView[];
  nextCursor: string | null;
  meta: QueryMeta;
};

type GetCurrentPositionInput = {
  spaceKeys?: string[];
  currency: string;
  asOf?: Instant;
};
type GetCurrentPositionOutput = {
  liquidCash: MoneyWire | null;
  knownAssets: MoneyWire;
  knownLiabilities: MoneyWire;
  knownNetPosition: MoneyWire;
  missingAccountIds: string[];
  staleAccountIds: string[];
  meta: QueryMeta;
};

type GetMonthProgressInput = {
  spaceKeys?: string[];
  accountRefs?: Array<{ spaceKey: string; accountKey: string }>;
  month: string;
  currency: string;
  asOf?: Instant;
};
type GetMonthProgressOutput = {
  income: MoneyWire;
  outflow: MoneyWire;
  net: MoneyWire;
  meta: QueryMeta;
};

type ListUpcomingCashflowsInput = {
  spaceKeys?: string[];
  from: ISODate;
  through: ISODate;
  direction?: "outflow" | "inflow";
  certainty?: CashflowView["certainty"][];
  status?: CashflowView["status"][];
};
type ListUpcomingCashflowsOutput = { items: CashflowView[]; meta: QueryMeta };

type GetCoverageGapInput = {
  spaceKeys?: string[];
  currency: string;
  through: ISODate;
  asOf?: Instant;
  plannedWorkdaysRemaining?: number;
  plannedBillableMinutesRemaining?: number;
};
type GetCoverageGapOutput = {
  liquidCash: MoneyWire | null;
  confirmedIncoming: MoneyWire;
  committedOutgoing: MoneyWire;
  surplus: MoneyWire | null;
  gap: MoneyWire | null;
  requiredPerWorkday: MoneyWire | null;
  requiredPerHour: MoneyWire | null;
  formulaVersion: "account-control-v0.1";
  inputs: Record<string, unknown>;
  meta: QueryMeta;
};

type GetAccountFreshnessInput = {
  spaceKeys?: string[];
  accountKeys?: string[];
  asOf?: Instant;
};
type GetAccountFreshnessOutput = {
  accounts: Array<{ accountId: string; freshness: FreshnessView }>;
  meta: QueryMeta;
};
```

```ts
type CreateAccountInput = CommandMeta & {
  spaceKey: string;
  accountKey: string;
  name: string;
  bankName?: string;
  accountType: string;
  currency: string;
  normalNature: "asset" | "liability";
  liquidityClass: "liquid" | "non_liquid";
  freshnessWindowHours: number;
};

type ConfirmAccountBalanceInput = CommandMeta & {
  spaceKey: string;
  accountKey: string;
  balanceKind: BalanceView["kind"];
  money: MoneyWire;
  economicNature: BalanceView["economicNature"];
  asOf: Instant;
  note?: string;
};

type RecordExpenseInput = CommandMeta & {
  spaceKey: string;
  accountKey: string;
  money: MoneyWire;
  postedAt: ISODate;
  description: string;
  categoryKey?: string;
};

type RecordIncomeInput = CommandMeta & {
  spaceKey: string;
  accountKey: string;
  money: MoneyWire;
  postedAt: ISODate;
  description: string;
  categoryKey?: string;
};

type RecordTransferInput = CommandMeta & {
  source: { spaceKey: string; accountKey: string };
  target: { spaceKey: string; accountKey: string };
  money: MoneyWire;
  postedAt: ISODate;
  description?: string;
};

type RecurrenceRule =
  | { cadence: "once"; dueOn: ISODate }
  | {
      cadence: "weekly";
      startDate: ISODate;
      interval: number;
      dayOfWeek: number;
      endDate?: ISODate;
    }
  | {
      cadence: "monthly" | "quarterly";
      startDate: ISODate;
      interval: number;
      dayOfMonth: number;
      endDate?: ISODate;
    }
  | {
      cadence: "yearly";
      startDate: ISODate;
      interval: number;
      month: number;
      dayOfMonth: number;
      endDate?: ISODate;
    };

type CreateScheduledCashflowInput = CommandMeta & {
  spaceKey: string;
  accountKey?: string;
  title: string;
  direction: "outflow" | "inflow";
  certainty: "committed" | "confirmed" | "expected" | "possible";
  money: MoneyWire;
  timezone: string;
  recurrence: RecurrenceRule;
};

type UpdateScheduledCashflowInput = CommandMeta & {
  scheduleId: string;
  expectedRevision: number;
  patch: Partial<
    Pick<
      CreateScheduledCashflowInput,
      "accountKey" | "title" | "certainty" | "money" | "timezone" | "recurrence"
    >
  >;
};

type PauseScheduledCashflowInput = CommandMeta & {
  scheduleId: string;
  expectedRevision: number;
  pausedAt: Instant;
};

type SettleCashflowOccurrenceInput = CommandMeta & {
  occurrenceId: string;
  settledAt: Instant;
  transactionId?: string;
  note?: string;
};

type EntityCommandOutput<T> = { entity: T; receipt: CommandReceipt };
type TransferCommandOutput = {
  transferId: string;
  source: TransactionView;
  target: TransactionView;
  receipt: CommandReceipt;
};
```

### 2.2 Operation Conventions

- `AccountControlService` owns every operation below.
- Queries are deterministic for explicit `asOf`/date inputs and are never cached through Typesense.
- Commands require `CommandMeta`, validate through the semantic contract, execute transactionally, and return a receipt.
- tRPC adapters are thin procedures under `accountControl`; MCP adapters are thin tools using the same input/output schemas.
- Stable domain errors become tRPC error metadata and MCP structured error results without changing their codes.
- Repository account scope is explicit: omitted `accountIds` is intentionally unscoped, while `accountIds: []` is an empty resolved scope and returns no rows without an unscoped transaction query.
- Month-to-date uses `asOf` converted in the configured Raven financial timezone, defaulting to `Africa/Johannesburg`. Current-month facts after that financial date and all future-month facts are excluded; eligible completed-past-month facts remain included.
- `status=ignored`, unresolved semantics, invalid dates, and unknown flow are inspectable evidence but are excluded from ordinary movement and uncategorized counts and from income, outflow, and net. Transfers remain excluded from monetary totals.

### 2.3 Query Catalog

| Operation                   | Purpose and typed result                                                                        | Money/freshness/provenance                                                              | Errors and warnings                                                                        | tRPC / MCP / UI                                                                                                                                                 |
| --------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `list_accounts`             | Group `AccountSummary` rows by Financial Space. `ListAccountsInput -> ListAccountsOutput`.      | Selected `BalanceView`; freshness and query provenance per result.                      | `UNSUPPORTED_CURRENCY`; balance/legacy/partial warnings.                                   | `accountControl.listAccounts` / `list_accounts` "List tracked accounts with balance freshness." / Accounts and palette.                                         |
| `get_account`               | Resolve one account and available months. `GetAccountInput -> GetAccountOutput`.                | Selected balance, freshness, source.                                                    | `NOT_FOUND`; balance/legacy warnings.                                                      | `accountControl.getAccount` / `get_account` "Get one account and its current balance evidence." / Account detail.                                               |
| `list_account_transactions` | Cursor-page one account/month with semantic kinds. `ListAccountTransactionsInput -> ...Output`. | Exact money and provenance per transaction.                                             | `NOT_FOUND`, `INVALID_MONEY`; legacy fallback warning.                                     | `accountControl.listAccountTransactions` / `list_account_transactions` "List observed transactions for an account month." / Account table and filters.          |
| `get_transaction`           | Resolve one semantic transaction with operation, transfer, and clarification context.           | Exact canonical-first money and source provenance; legacy uncertainty remains explicit. | `NOT_FOUND`; legacy money/date/transfer warnings.                                          | `accountControl.getTransaction` / `get_transaction` "Get one observed transaction with provenance and linked transfer context." / Transaction drawer.           |
| `get_current_position`      | Calculate liquid cash, known assets, liabilities, and known net position.                       | Exact totals, selected balance sources, completeness.                                   | `UNSUPPORTED_CURRENCY`; stale/unknown/partial/cross-currency warnings.                     | `accountControl.getCurrentPosition` / `get_current_position` "Calculate the known financial position and show missing evidence." / Today and Accounts summary.  |
| `get_month_progress`        | Calculate exact month income, outflow, and net excluding transfers.                             | Exact totals; transaction provenance summary.                                           | `UNSUPPORTED_CURRENCY`; legacy/partial warnings.                                           | `accountControl.getMonthProgress` / `get_month_progress` "Calculate month-to-date income and outflow, excluding transfers." / Today and account month.          |
| `list_categories`           | List active, space-scoped category choices with optional direction-safe kind filtering.         | Selection metadata only; no category mutation.                                          | `NOT_FOUND`; invalid space.                                                                | `accountControl.listCategories` / `list_categories` "List active transaction categories available in a financial space." / Entry dialogs and ledger filter.     |
| `list_upcoming_cashflows`   | Materialize/query concrete occurrences and certainty.                                           | Exact occurrence money; schedule/occurrence provenance.                                 | `INVALID_RECURRENCE`; excluded-certainty warnings only when aggregating.                   | `accountControl.listUpcomingCashflows` / `list_upcoming_cashflows` "List due, overdue, and future accepted cashflows." / Today and Upcoming.                    |
| `get_coverage_gap`          | Calculate resources, commitments, gap, and earning rates with drillable inputs.                 | Exact formula inputs, freshness, certainty exclusions, formula version.                 | `UNSUPPORTED_CURRENCY`; unknown makes unavailable; stale makes provisional; rate warnings. | `accountControl.getCoverageGap` / `get_coverage_gap` "Calculate the coverage gap and required earning rate, with assumptions." / Today formula drawer.          |
| `get_account_freshness`     | Return freshness state for selected/all accounts. `GetAccountFreshnessInput -> ...Output`.      | Snapshot as-of/source and age.                                                          | No not-found for filters; unknown accounts are explicit results.                           | `accountControl.getAccountFreshness` / `get_account_freshness` "Check which account balances are fresh, stale, or unknown." / Today notice and Accounts column. |

### 2.4 Command Catalog

| Operation                    | Purpose and typed result                                                                                                                               | Idempotency/provenance                                                                      | Errors and warnings                                                                                           | tRPC / MCP / UI                                                                                                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `create_account`             | Create classified account. `CreateAccountInput -> EntityCommandOutput<AccountSummary>`.                                                                | Required key; `FinancialOperation`; source-authority write.                                 | `INVALID_ACCOUNT_CLASSIFICATION`, `IDEMPOTENCY_CONFLICT`.                                                     | `accountControl.createAccount` / `create_account` "Create a tracked financial account with its nature and freshness policy." / Accounts quick add.                            |
| `confirm_account_balance`    | Append a confirmed balance snapshot. `ConfirmAccountBalanceInput -> EntityCommandOutput<BalanceView>`.                                                 | Required key; manual provenance; never mutates prior snapshot.                              | `INVALID_MONEY`, `INVALID_BALANCE_KIND`, `IDEMPOTENCY_CONFLICT`.                                              | `accountControl.confirmAccountBalance` / `confirm_account_balance` "Record an as-of balance confirmation without overwriting history." / Account action and freshness notice. |
| `record_expense`             | Append manual expense/outflow. `RecordExpenseInput -> EntityCommandOutput<TransactionView>`.                                                           | Required key and operation/source provenance; no occurrence link exists before Workline 03. | `INVALID_MONEY`, `INVALID_TRANSACTION_DATE`, `INVALID_CATEGORY`, `CURRENCY_MISMATCH`, `IDEMPOTENCY_CONFLICT`. | `accountControl.recordExpense` / `record_expense` "Record an observed expense as a positive exact amount." / Quick add and Account action.                                    |
| `record_income`              | Append manual income/inflow. `RecordIncomeInput -> EntityCommandOutput<TransactionView>`.                                                              | Same as expense.                                                                            | Same as expense.                                                                                              | `accountControl.recordIncome` / `record_income` "Record observed income as a positive exact amount." / Quick add and Account action.                                          |
| `record_transfer`            | Atomically create linked outflow/inflow legs. `RecordTransferInput -> TransferCommandOutput`.                                                          | One key covers transfer and both legs; one operation receipt.                               | `INVALID_MONEY`, `CURRENCY_MISMATCH`, `DUPLICATE_TRANSFER`, `IDEMPOTENCY_CONFLICT`.                           | `accountControl.recordTransfer` / `record_transfer` "Move money between tracked accounts without counting it as income or spending." / Quick add and Account action.          |
| `create_scheduled_cashflow`  | Create accepted one-off/recurring schedule and materialize bounded occurrences. `CreateScheduledCashflowInput -> EntityCommandOutput<CashflowView[]>`. | Required key; schedule provenance; deterministic occurrence uniqueness.                     | `INVALID_MONEY`, `INVALID_CERTAINTY`, `INVALID_RECURRENCE`, `IDEMPOTENCY_CONFLICT`.                           | `accountControl.createScheduledCashflow` / `create_scheduled_cashflow` "Create an accepted outgoing or incoming cashflow schedule." / Upcoming quick add.                     |
| `update_scheduled_cashflow`  | Revise a schedule and reconcile unsettled future occurrences.                                                                                          | Required key plus expected revision.                                                        | `SCHEDULE_REVISION_CONFLICT`, validation errors, `IDEMPOTENCY_CONFLICT`.                                      | `accountControl.updateScheduledCashflow` / `update_scheduled_cashflow` "Update a cashflow schedule without rewriting settled history." / Upcoming edit drawer.                |
| `pause_scheduled_cashflow`   | Pause future generation while retaining existing due items.                                                                                            | Required key plus expected revision.                                                        | `SCHEDULE_REVISION_CONFLICT`, `IDEMPOTENCY_CONFLICT`.                                                         | `accountControl.pauseScheduledCashflow` / `pause_scheduled_cashflow` "Pause future occurrences of a cashflow schedule." / Upcoming row action.                                |
| `settle_cashflow_occurrence` | Mark due occurrence paid/received and optionally link a transaction.                                                                                   | Required key; occurrence lock; settlement provenance.                                       | `OCCURRENCE_ALREADY_SETTLED`, `OCCURRENCE_CONFLICT`, `IDEMPOTENCY_CONFLICT`; unlinked warning.                | `accountControl.settleCashflowOccurrence` / `settle_cashflow_occurrence` "Settle a due cashflow and link observed evidence when available." / Upcoming row action.            |

Binding deferred correction before Workline 03:

- Add audited occurrence-level semantic operations for skip, waive, and cancel.
- Add audited one-occurrence overrides for amount and due date without mutating the parent schedule or settled history.
- Define typed UI, tRPC, and MCP parity for those operations before implementing Upcoming.
- This correction does not widen or block Workline 01.

## 3. Raven Studio UI Contract

### 3.1 Global Shell

```text
+----------------------------------------------------------------------------+
| Raven  /  {breadcrumb or page title}              [+ Add]   [...]         |
+----------------------------------------------------------------------------+
|                                                                            |
|                         route content                                      |
|                                                                            |
+----------------------------------------------------------------------------+

Cmd/Ctrl+P or Cmd/Ctrl+K
+--------------------------------------------------------------+
| Search routes and actions...                                 |
| > Today                                      Go to            |
|   Accounts                                   Go to            |
|   Upcoming                                   Go to            |
|   Record expense                             Action           |
|   Record income                              Action           |
|   Record transfer                            Action           |
+--------------------------------------------------------------+
```

Interaction rules:

- One typed `routeActionRegistry` drives command palette, quick add, and overflow entries.
- `Cmd/Ctrl+P` is primary; `Cmd/Ctrl+K` opens the same palette.
- The overflow menu holds route links, settings/theme, and secondary actions; no duplicate registry.
- System font and system-aware light/dark theme. No sidebar, hero, gradients, glow, card mosaic, or decorative chart.
- Ark UI supplies accessible dialog/menu/select primitives; Lucide supplies icons. Domain UI remains app-specific.
- All mutation dialogs show exact amount, account, effective date, provenance channel, and resulting warning state before success closes.

### 3.2 Today `/`

```text
Today                                                        11 Jul 2026
Position              Month to date             Coverage through 31 Jul
R -- liquid           R -- in / R -- out        R -- gap  |  R -- / workday
[2 stale, 1 unknown]  [View transactions]       [Show formula]
-----------------------------------------------------------------------------
Upcoming                                   To pay | Expected in
When        Item                 Account         Certainty      Amount   State
Overdue     ...                  ...             committed     R --     Due
Next 7 days ...                 ...             confirmed     R --     Due
[View all upcoming]
-----------------------------------------------------------------------------
Month progress
Income R --                         Outflow R --                  Net R --
-----------------------------------------------------------------------------
```

States:

- Loading uses stable row skeletons, not layout-changing cards.
- Empty upcoming says `No accepted cashflows in this period` and offers Add.
- Unknown liquid balance replaces coverage values with `Unavailable` and links to Update balance.
- Stale liquid balance shows provisional values with the oldest as-of date.
- Partial position always lists excluded/missing accounts; no unknown value displays as zero.
- Formula drawer shows every account balance, included occurrence, excluded incoming certainty, denominator, and formula version.

### 3.3 Accounts `/accounts`

```text
Accounts                                                     [+ Account]
Liquid cash R --     Known assets R --     Liabilities R --     Net R --
Completeness: partial - 1 unknown, 2 stale
-----------------------------------------------------------------------------
Personal
Account                 Type        Balance         As of          Freshness
Everyday                Current     R --            10 Jul 14:00   Fresh
Credit                  Credit      R -- owed       01 Jul 09:00   Stale
-----------------------------------------------------------------------------
Business
...
```

Rules:

- Rows are grouped by Financial Space and keyboard navigable.
- Balance includes kind and economic meaning (`available`, `owed`, `market value`).
- Clicking a stale/unknown freshness cell opens confirmation, not a generic edit form.
- Create Account requires nature, liquidity, currency, and freshness policy.
- Currency totals are separate; no hidden FX conversion.

### 3.4 Account Detail `/accounts/[spaceKey]/[accountKey]`

```text
Accounts / Personal / Everyday                               [...]
R -- available     as of 10 Jul 14:00     Fresh     [Update balance]
[Expense] [Income] [Transfer]
-----------------------------------------------------------------------------
Month: [July 2026 v]   Filters: [All kinds v] [All flows v]       [Search]
Date        Description                    Kind       Category        Amount
11 Jul      ...                            expense    ...             R --
10 Jul      ...                            transfer   Transfer        R --
-----------------------------------------------------------------------------
Transaction drawer -> exact amount, kind/flow, source, recorded/effective
times, transfer counterpart, category, clarification state, operation receipt
```

Rules:

- Month selection uses calendar months from semantic query output.
- Transfers are visibly linked and never included in month income/outflow.
- Detail drawer reuses the proven V1 query fields but renders semantic money/provenance.
- No raw update/delete for observed monetary facts.

### 3.5 Upcoming `/upcoming`

```text
Upcoming                                         [+ Cashflow]      [Filters]
[All] [To pay] [Expected in]
-----------------------------------------------------------------------------
Overdue
Due         Item                 Direction  Certainty     Recurrence   Amount
...
-----------------------------------------------------------------------------
Next 7 days
...
-----------------------------------------------------------------------------
Later this month
...
-----------------------------------------------------------------------------
Later
...

Row actions: Edit schedule | Pause | Mark paid/received | Skip/Waive
```

Rules:

- Sections are derived from local dates and occurrence status.
- Direction, certainty, recurrence, and reconciliation state are always visible.
- Confirmed, expected, and possible incoming rows have distinct labels; only confirmed affects coverage.
- Edit/pause acts on the schedule; settle/skip/waive acts on the occurrence.
- Settle offers linking an existing transaction. Without a link, success remains `Unreconciled`.

## 4. Implementation Map

### 4.1 Shared Package Boundary

```text
packages/raven-domain/
  src/money/                         exact parsing, formatting inputs, arithmetic
  src/account-control/contracts.ts   schemas and stable errors/warnings
  src/account-control/service.ts     semantic queries and commands
  src/account-control/repository.ts  persistence port
  src/account-control/calculations.ts

packages/raven-surreal/
  src/account-control-repository.ts  Surreal implementation using explicit queries
  src/operation-transaction.ts       idempotency + atomic command transaction

apps/raven-studio/server/trpc/routers/account-control.ts
  thin tRPC adapter using Studio's generated default/source DB context

apps/raven-mcp/
  stdio semantic MCP server; only the approved operation catalog
```

`packages/raven-domain` has no Nuxt, tRPC, MCP, or Surreal dependency. `packages/raven-surreal` is the only package that knows table/query details. The Studio tRPC and MCP adapters do not contain formulas or financial branching.

### 4.2 Existing Logic Disposition

| Existing location                                   | Disposition                                                                                                 |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `apps/raven-studio/server/trpc/routers/_surreal.ts` | Reuse query result helpers in the Studio adapter where compatible.                                          |
| `financialspace.ts` list/explorer                   | Extract active-space/account grouping, count, and latest-activity query patterns.                           |
| `account.ts` explorer                               | Extract account/space resolution, statement import metadata, and month discovery.                           |
| `account.ts` month                                  | Extract transaction ordering and category grouping; replace number money and summary formulas.              |
| `account.ts` transferMatches                        | Keep as inferred `RecurringPattern`/transfer-candidate evidence only; never auto-link.                      |
| `transaction.ts` detail                             | Reuse descriptive/source fields; adapt money, kind, flow, and provenance.                                   |
| `clarificationtask.ts` queue                        | Preserve for later Review lane; no Account Control rewrite.                                                 |
| `retainer.ts` dashboard                             | Keep as operational reference; never auto-create confirmed incoming schedules.                              |
| Raven V1 environment/account page                   | Extract month selector, transaction drawer, and filter behavior; discard decorative/card-heavy composition. |

### 4.3 Schema Gap And Migration Matrix

| Schema surface           | Current                                   | Proposed change                                                                                                                | Migration / compatibility                                                                                 |
| ------------------------ | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| `FinancialSpace`         | key, type, currency                       | Add `timezone`, `workweekDays`, `billableMinutesPerWorkday`.                                                                   | Default timezone explicitly for existing spaces; validate weekdays/minutes.                               |
| `Account`                | type, currency, float `openingBalance`    | Add `normalNature`, `liquidityClass`, `freshnessWindowHours`, `openingBalanceMinor`.                                           | Derive suggested classifications from type but require review before accepted; dual-read opening balance. |
| `AccountBalanceSnapshot` | Missing                                   | New immutable source-authority model with kind, exact money, economic nature, as-of, recorded-at, evidence, source, operation. | Backfill latest eligible imported transaction balances only as observed historical snapshots.             |
| `StatementRow`           | float `amount`, `balance`                 | Add `amountMinor`, `balanceMinor`.                                                                                             | Audit scale, decimal-safe backfill, preserve raw row immutability and legacy fields.                      |
| `Transaction`            | float money, ambiguous transfer direction | Add `amountMinor`, `transactionKind`, `flowDirection`, `entrySource`, `recordedAt`, operation/transfer/correction refs.        | Canonical-first dual-read. Legacy transfer rows need reviewed flow/linkage; do not infer acceptance.      |
| `AccountTransfer`        | Missing                                   | New aggregate linking source/target accounts and transaction legs with exact money and operation provenance.                   | New manual transfers use it immediately; imported candidates remain unlinked until review.                |
| `CashflowSchedule`       | Missing                                   | New neutral accepted plan with direction, certainty, exact money, recurrence, timezone, status, revision.                      | No automatic conversion from retainers or recurrence inference.                                           |
| `CashflowOccurrence`     | Missing                                   | New concrete due record with copied schedule terms, lifecycle, settlement, and reconciliation link.                            | Unique `(schedule,dueOn)`; deterministic horizon generation.                                              |
| `FinancialOperation`     | Missing                                   | New idempotency/audit receipt with channel, actor, command, key, request hash, result refs, status, timestamps.                | All semantic commands require it; raw generated CRUD remains outside product paths.                       |
| `MonthlySnapshot`        | float aggregate snapshot                  | Do not use for authoritative Account Control calculations initially.                                                           | Recompute exact month progress from canonical transactions; migrate snapshot money later.                 |
| `RecurringPattern`       | Missing                                   | Deferred inferred-evidence model.                                                                                              | No first-slice write; preserve the review-before-promotion boundary.                                      |
| Retainer/hosting money   | float fields                              | Outside this slice.                                                                                                            | Do not treat as confirmed cashflow; migrate under a later billing/maintenance exact-money workline.       |

All graph edits must begin in `apps/schema/config/graph.mpdg`, pass `pnpm run graph:validate`, regenerate downstream assets, and preserve source-authority/single-database behavior. Do not hand-edit generated contracts as the source change.

### 4.4 Minimal UI Primitives

Build only:

- `RavenTopbar`
- `RavenCommandPalette` and central route/action registry
- `RavenOverflowMenu`
- `RavenDataTable`
- `RavenDrawer`
- `RavenMoney`
- `RavenFreshness`
- `RavenStatus`
- shared form rows for account, money, date, certainty, and recurrence

Use Ark UI for accessible headless mechanics and Lucide icons. Do not create a broad design system, generic dashboard cards, or page-specific financial calculations.

### 4.5 Non-Private Fixtures

Use fictional data only:

- Spaces: `Personal`, `Studio Business`.
- Accounts: liquid current asset, savings asset, credit liability, investment asset.
- Balances: fresh, stale, unknown, observed statement fallback, overdraft represented as liability nature.
- Transactions: expense, income, linked two-leg transfer, legacy fallback, correction pair.
- Schedules: monthly committed rent, weekly committed transport, confirmed invoice, expected invoice, possible project.
- Occurrences: overdue, next seven days, settled-linked, settled-unlinked, skipped, waived.

No statement descriptions, account numbers, client names, mailbox text, or real amounts enter fixtures or snapshots.

## 5. Ordered Implementation Worklines

### Workline 01 - Account Balance Truth Vertical

Status: accepted and complete.

Scope:

- exact-money primitive and shared envelopes;
- `FinancialOperation`, Account classification fields, and `AccountBalanceSnapshot`;
- `list_accounts`, `get_account`, `get_current_position`, `get_account_freshness`, `create_account`, `confirm_account_balance`;
- thin Studio tRPC and semantic MCP adapters;
- global shell plus `/accounts` and balance confirmation flow.

Acceptance tests:

1. Minor-unit parsing rejects excess precision, unsafe integers, overflow, and currency mismatch.
2. Repeated command key/request returns the same receipt; changed request returns `IDEMPOTENCY_CONFLICT`.
3. Balance selection honors kind precedence, as-of time, evidence, and economic nature.
4. Fresh, stale, unknown, and invalid-future states are deterministic under a fixed clock.
5. Unknown liquid accounts make coverage inputs unavailable; stale balances remain provisional.
6. Studio and MCP return contract-equivalent outputs for the same fixture.
7. Generated source-authority routing is used; Typesense is not required.
8. `/accounts` supports keyboard navigation, loading, empty, error, partial, stale, and unknown states.

Review boundary: approve schema migration evidence, domain tests, `/accounts`, and MCP parity before transactions.

### Workline 02 - Observed Transaction And Transfer Vertical

Status: accepted and complete.

Scope:

- canonical transaction fields and `AccountTransfer`;
- transaction dual-read/backfill report;
- list transactions, month progress, record expense/income/transfer;
- Account detail route and transaction drawer.

Acceptance tests:

- Positive command amounts produce correct kind/flow.
- Transfer command is atomic, linked, idempotent, and excluded from all income/outflow/net totals.
- Imported facts cannot be mutated through semantic commands.
- Legacy transfer ambiguity remains a review warning.
- Studio and MCP parity holds for all operations.

Review boundary: approve exact monthly totals and transfer behavior before upcoming cashflow.

### Workline 03 - Upcoming Cashflow Vertical

Scope:

- complete the binding occurrence-level command correction for skip, waive, cancel, one-occurrence amount override, and one-occurrence due-date override;
- `CashflowSchedule` and `CashflowOccurrence`;
- deterministic recurrence generation and lifecycle commands;
- Upcoming route and matching semantic MCP tools.

Acceptance tests:

- Re-running generation creates no duplicates.
- Month-end recurrence behavior is deterministic and documented.
- Schedule revisions do not rewrite settled history.
- Pause/end/cancel semantics match the contract.
- Incoming certainty validation and labels are direction-safe.
- Unlinked settlement remains visible as unreconciled.

Acceptance status: complete on 2026-07-18 after the paused-to-terminal lifecycle closeout and full fictional verification. Today calculations remain a separate Workline 04.

### Workline 04 - Today Coverage Loop

Scope:

- exact current position, month progress, coverage, and rate formulas;
- Today route, freshness notice, upcoming table, and formula drawer;
- equivalent read-only MCP tools.

Acceptance tests:

- Transfers never affect income/outflow/net.
- Only confirmed, non-overdue incoming affects coverage.
- Committed overdue/outstanding outflow is included.
- Unknown/stale/cross-currency inputs produce the specified quality and warnings.
- Daily/hourly rates use integer ceiling and handle zero denominators.
- Every displayed number drills into its inputs and formula version.

Review boundary: complete end-to-end Account Control acceptance across all four routes and MCP.

The completed Workline 01, Workline 02, and Workline 03 prompts are preserved as references in `docs/prompts/`.

## 6. Approval Record

Michael approved these four decisions on 2026-07-11:

1. **Exact money and transactions:** integer minor units; positive magnitudes; separate kind/flow; linked two-leg transfers; append-only monetary corrections.
2. **Balance truth:** immutable `AccountBalanceSnapshot`; explicit economic nature, kind, as-of/source/freshness; unknown is never zero and stale coverage is provisional.
3. **Upcoming cashflow:** neutral `CashflowSchedule` + `CashflowOccurrence`; committed outgoing and confirmed/expected/possible incoming; only confirmed future incoming counts toward coverage.
4. **Calculation contract:** per-currency exact formulas; transfers excluded; unknown liquid cash blocks coverage; required rates round upward and expose all inputs.

Binding clarifications:

- Fresh eligible balance evidence takes precedence over stale higher-priority balance kinds; stale selection happens only when no preferred kind is fresh.
- Workline 03 must add audited occurrence-level skip, waive, cancel, amount-override, and due-date-override operations before Upcoming implementation.
- Workline 03 implements occurrence identity as `S($schedule, $scheduledDueOn)` and preserves effective due-date and amount overrides separately.

## 7. Known Limitations

- The contract does not define FX conversion; aggregates are per currency.
- Tax, invoicing, opportunities, retainers, debt strategy, budgets, and Elgiz buckets are outside this slice.
- Existing statement/transaction values must pass a scale audit before exact-money promotion.
- Existing `direction=transfer` rows cannot always be migrated to inflow/outflow safely without review.
- Unlinked settled occurrences are accepted planning state but not reconciled observed truth.
- Recurrence v0.1 intentionally avoids arbitrary RRULE complexity and holiday calendars.
- The generic Surreal MCP remains available for diagnostics and is not the semantic product interface.

## Final Recommendation

Use `AccountBalanceSnapshot`, `AccountTransfer`, `FinancialOperation`, `CashflowSchedule`, and `CashflowOccurrence`. Defer `RecurringPattern` persistence until the review lane. Worklines 01, 02, and 03 are accepted and complete. Workline 04 remains unstarted and may be sequenced separately.
