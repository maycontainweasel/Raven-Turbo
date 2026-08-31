---
status: complete
owner: Raven
last_reviewed: 2026-07-12
supersedes: []
superseded_by: []
---

# Account Control Workline 02 Implementation

## Review State

Observed Transactions and Transfers, including the final import-identity and immutable-source closeout, are implemented and accepted. Workline 02 is complete. Workline 03 has not started.

## Canonical Schema

`Transaction` now has optional migration-safe canonical fields:

- `amountMinor: int`
- `transactionKind: income | expense | transfer | adjustment | unresolved`
- `flowDirection: inflow | outflow`
- `entrySource: imported | manual | generated`
- `recordedAt`
- `operation -> FinancialOperation`
- `transfer -> AccountTransfer`

`AccountTransfer` is a source-authority aggregate with stable key, source/target Financial Spaces and Accounts, exact amount/currency, financial date, description, source/target transaction legs, operation receipt, and Raven recording time.

The graph was validated before regeneration. Generated specs, models, controllers, routers, migrations, and documentation were inspected after generation. The configured local schema import path completed successfully.

## Shared Product Contract

The shared `AccountControlApi` now exposes these Workline 02 queries:

- `listAccountTransactions`
- `getTransaction`
- `getMonthProgress`
- `listCategories`

It also completes `getAccount.availableMonths` from observed financial dates, newest first.

The new commands are:

- `recordExpense`
- `recordIncome`
- `recordTransfer`

All commands accept exact positive minor-unit money, an exact `YYYY-MM-DD` financial date, and a retry-stable idempotency key. Expense and income append one canonical movement plus one `FinancialOperation`. Transfer appends one aggregate, an outflow source leg, an inflow target leg, and one operation inside one Surreal transaction. Transaction commands do not create or update `AccountBalanceSnapshot` records.

Canonical transaction fields are authoritative only as a complete, valid, semantically coherent tuple: positive exact `amountMinor`, compatible kind/flow semantics, valid financial date, valid entry source, and valid Raven recording instant. Complete canonical truth wins over conflicting legacy fields. Partial fields and old generated sentinels cannot independently override coherent legacy evidence.

The graph no longer generates economically meaningful defaults for optional canonical semantics. `direction` uses explicit `unknown`; optional kind, flow, source, and recording time use empty migration sentinels. The fictional statement renderer emits known credits as exact `income/inflow`, known debits as exact `expense/outflow`, and imported provenance with a reliable recording instant. A transfer whose source does not prove flow remains `transfer` with unknown flow and `LEGACY_TRANSFER_AMBIGUOUS`. Missing or malformed direction remains `unresolved`, emits precise invalid/unresolved warnings, and is excluded from totals rather than defaulting to expense.

## Migration Boundary

`packages/raven-surreal/src/transaction-migration.ts` provides explicit `audit` and opt-in `apply` modes.

- `audit` is the default, performs no writes, and returns aggregate counts only.
- Reports contain no descriptions, account names, amounts, or source text.
- `apply` promotes only exact, safe, valid-date, non-transfer legacy debit/credit rows.
- Canonical fields are audited individually. Meaningful conflicts are counted and receive no write.
- Apply fills only genuinely missing fields or the narrowly recognized old generated sentinel tuple.
- Apply never replaces authoritative exact money, kind, flow, source, financial date, or recording time.
- Ambiguous legacy transfers are never auto-promoted.
- Unsupported precision, unsafe range, invalid date, and canonical conflicts remain exceptions.
- Source import time is used for `recordedAt` when reliable; otherwise the explicit migration recording instant is used and counted.

No private-data migration audit or apply was run in this workline. Only fictional disposable live fixtures were written, and they were removed in `finally` cleanup.

Complete canonical manual and generated transactions now count as `alreadyCanonical`; they are not reported as import-source conflicts merely because the legacy proposal assumes `entrySource=imported`. Complete imported rows continue to receive compatibility checks against meaningful legacy amount, date, kind, and flow evidence.

The separate import-identity compatibility audit is aggregate-only. It reports canonical, legacy, missing-input, and expected-collision counts for the seven scoped models and exposes no apply mode or record-level financial content. Existing private records may require a later explicit ID migration, but no private audit or migration was run here. See `raven-import-identity-and-migration.md`.

## Import Identity And Immutability Closeout

The schema canon now scopes persisted identity as follows:

- StatementImport: account + import key.
- StatementRow: StatementImport + row key.
- Transaction: account + key; imported keys include import key + row key.
- Category, Merchant, and ClassificationRule: Financial Space + local key.
- ClarificationTask: transaction + task key.

The renderer calculates deterministic SHA-256 fingerprints from immutable statement/import and row evidence. Classification suggestions and reviewed meaning are excluded. Dedicated Surreal ensure functions create on first execution, reuse exact records on replay, and return `RAVEN_IMPORT_IMMUTABLE_CONFLICT` when the same identity carries changed immutable evidence. The entire rendered import runs in one transaction, so conflicts produce no partial writes.

The explicit review function may change classification/clarification meaning only after matching the original source checksum. It cannot change amount, currency, financial date, source row, source import, account, or import observation time. Import relationship writes are deterministic and idempotent; category and merchant review edges replace prior current-meaning links rather than accumulating stale alternatives.

## tRPC And MCP

Raven Studio adds thin `accountControl` procedures for all four queries and three commands. Raven MCP adds equivalent tools:

- `list_account_transactions`
- `get_transaction`
- `get_month_progress`
- `list_categories`
- `record_expense`
- `record_income`
- `record_transfer`

The parity test covers all 13 Account Control operations, including the six Workline 01 operations.

## Raven Studio

The implemented route is `/accounts/[spaceKey]/[accountKey]`. `/accounts` now lives at `pages/accounts/index.vue`, preventing Nuxt from treating the list page as the detail route parent.

The account detail page includes:

- breadcrumb and account identity;
- selected balance evidence, kind, as-of time, and freshness;
- Update balance, Expense, Income, and Transfer actions;
- semantic available-month selection, defaulted to the current local month;
- exact income, outflow, and net with visible transfer exclusion;
- kind, flow, category, and search filters;
- deterministic cursor pagination;
- loading, empty, error, warning, and partial-quality states;
- keyboard-activatable transaction rows;
- a read-only semantic transaction drawer with money, date, recorded time, provenance, operation, transfer counterpart, and clarification context.

The month query waits for the account to resolve and uses its actual currency; it never makes a guessed-currency request. Successful account creation advances the existing shared data version so the layout account directory, command palette, and global movement dialogs refresh without a full browser reload.

Account detail now displays the deduplicated union of whole-month progress warnings and current ledger-page warnings. The totals visibly carry the progress query's `complete | partial | unavailable` quality even when the responsible unresolved row is on a later page. Ignored rows remain inspectable but their inactive warnings do not independently degrade ordinary month totals.

## Scope, Time, Status, And Race Rules

- Repository `accountIds === undefined` means intentionally unscoped; `accountIds: []` returns no transactions without an unscoped database query.
- Explicit account references must exist and match the requested currency. Empty or unmatched explicit scopes remain empty; they never broaden access.
- Month progress derives its financial cutoff from `asOf` in configured `Africa/Johannesburg` time. Current-month rows after that local date and every future-month row are excluded; completed past months retain eligible rows.
- `status=ignored` remains inspectable but is excluded from ordinary movement counts, uncategorized counts, and totals. `unresolved` or invalid semantics remain inspectable, add warnings/partial quality, and are excluded from totals.
- On a duplicate-looking first-write failure, the service rereads `FinancialOperation`. A matching request hash returns the original entities as `replayed`; a changed hash returns `IDEMPOTENCY_CONFLICT`; absence of an operation preserves the real storage failure.

Ark UI dialogs provide expense/income and transfer entry. Account detail preselects the account; global entry keeps it selectable. Transfer targets are limited to different active same-currency accounts. Decimal strings are parsed to exact money at the UI boundary. Each dialog owns one command-intent key across failed retries and resets it only on success or cancellation.

The top-bar Add action is a compact Ark menu. The central action registry includes account detail destinations for the Command/Control+P and Command/Control+K palette without expanding the permanent navigation.

Browser verification against the user-managed Raven Studio process proved the independent list/detail routes, client-loaded account detail, account preselection, command palette destinations, and bounded desktop/mobile layouts. No development server was started by Codex.

## Verification

The final focused matrix passed:

```text
pnpm --dir apps/schema run graph:validate:strict
pnpm --dir apps/schema run graph:spec
pnpm --dir apps/schema run schema:generate
pnpm --dir apps/schema exec tsx src/cli.ts import --dry-run
pnpm --dir apps/schema exec tsx src/cli.ts import
pnpm --dir packages/raven-domain test
pnpm --dir packages/raven-domain check-types
pnpm --dir packages/raven-surreal test
pnpm --dir packages/raven-surreal check-types
pnpm --dir apps/raven-mcp test
pnpm --dir apps/raven-mcp check-types
pnpm --dir apps/raven-studio build-local
node --test scripts/tests/render-statement-import.test.mjs
pnpm --dir apps/raven-mcp exec tsx src/live-smoke.ts
pnpm --dir apps/raven-mcp exec tsx src/import-live-smoke.ts
pnpm test:archive-safety
node scripts/share-repo-zip.mjs --profile ai-safe --list
rg <credential-literal signatures> <bounded changed source and Brain paths>
brain-health-check
```

Final closeout results:

- domain: 29/29 tests;
- Surreal repository/migration: 20/20 tests;
- tRPC/MCP parity: 1/1 test covering 13 operations;
- focused typechecks: pass;
- Raven Studio production build: pass;
- fictional statement-rendering process regression: 2/2 pass;
- archive safety: 5/5 tests plus AI-safe preflight pass;
- bounded credential-literal scan: pass;
- Brain health: pass for required structure, indexes, `RAVEN-INGEST-0010` traceability, concise active context, and secret signatures;
- fictional import live smoke: pass twice consecutively with scoped identities, exact replay, stable `importedAt`, three immutable-fact conflicts with rollback, reviewed classification, exact edge counts, cross-space local-key reuse, and cleanup;
- prior fictional expense/income/transfer live smoke: pass.

## Acceptance Evidence

The live smoke recorded fictional income of 8,000 minor units and expense of 2,345 minor units plus a 1,500-minor-unit transfer. Across both accounts, the month result was income 8,000, outflow 2,345, net 5,655, and transfer count 2. This proves neither transfer leg entered income, outflow, or net.

The source account's confirmed balance remained 12,345 minor units with the same snapshot recording time after all three movement commands. This proves observed movement did not synthesize or advance balance truth.

## Known Limits

- Existing ambiguous transfers require later explicit review/reconciliation.
- Migration exceptions remain aggregate-auditable but were not applied to private data.
- Only the currently representable `ignored` transaction status is excluded. A formal supersession/correction relation is deferred with the accepted append-only correction contract.
- Monetary facts have no edit/delete UI; correction/reversal is deferred.
- Category CRUD, transaction-to-occurrence links, Upcoming, Today coverage, and Workline 03 operations are outside this workline.
- Whole-app Nuxt typecheck still has inherited generated Schema Kit/Helios issues outside Account Control; focused typechecks and production build pass.

Workline 02 is complete. Workline 03 remains unstarted and requires its separately approved occurrence-operation execution contract.
