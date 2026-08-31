---
status: review
owner: Raven
last_reviewed: 2026-08-13
supersedes: []
superseded_by: []
---

# Raven Financial Read Analytics 00

## Purpose

Financial Read Analytics 00 is Raven's first exact, semantic read vertical for observed income, spending, fees, merchant cost, Category cost, trends, uncategorized movements, and data quality.

It is a projection over accepted Transaction authority. It does not create budgets, classify Transactions, assign tax meaning, import statements, reconcile periods, mutate source evidence, or create `FinancialOperation` records.

## Query Catalog

The shared Raven Domain exposes seven operations. Raven Studio uses camel-case tRPC peers and Raven MCP exposes the exact snake-case names below:

1. `get_period_financial_summary`
2. `get_category_spend_summary`
3. `get_merchant_spend_summary`
4. `get_fee_summary`
5. `get_monthly_financial_trend`
6. `list_uncategorized_transactions`
7. `get_financial_data_quality_summary`

Every operation accepts one calendar month or an inclusive `from` / `through` range, one currency, optional Financial Space or Account scope, explicit authority scope, and an optional timezone-qualified `asOf` instant. When `asOf` is omitted, Domain uses its injected clock. Category and merchant operations add exact filters. Fee analysis requires at least one reviewed evidence rule.

## Calculation Authority

- Formula version: `raven.financial-read-analytics.v2`.
- Money uses checked integer minor units through Raven Domain. Unsafe addition fails; no floating-point aggregation is permitted.
- Every response is single-currency. Raven performs no FX conversion.
- Ordinary income is an active, valid `income` Transaction with `inflow` direction.
- Ordinary outflow is an active, valid `expense` Transaction with `outflow` direction.
- Net is exact income minus exact outflow.
- Transfers are disclosed as exclusions and never enter income, outflow, net, Category spend, merchant spend, or fee totals.
- Adjustments, ignored Transactions, unresolved semantics, invalid evidence, future evidence, and historical source authority do not enter ordinary totals.
- Statement-backed and provisional manual evidence remain separately counted.
- Renderer-era source Transactions without current or historical canonical match authority are derived as genuine `legacy_unreconciled` authority. They are returned only as a separate quality bucket under the explicit `active_ledger_with_legacy_unreconciled` scope and never enter ordinary totals.
- A previously canonical imported source-row Transaction whose Statement match or source was superseded is `canonical_historical_superseded`, even after ST-02 clears its current `statementMatch` and `effectiveAt` pointers. It remains excluded under every authority scope and can never reappear as legacy evidence.
- A manual or generated Transaction whose former match was superseded returns to active provisional authority and uses its observation date again.
- `spaceKeys` omitted means all active Financial Spaces. An explicit `spaceKeys: []` means no selected space, returns an empty result, and performs no broad Account or Transaction read.
- `asOf` is normalized to an instant and converted to the financial date in `Africa/Johannesburg`. Later financial dates are disclosed as future exclusions.
- Category hierarchy and Category fee-rule matching use the composite `spaceKey + categoryKey` identity throughout.
- Category is management meaning only. No query infers tax treatment, deductibility, VAT treatment, or filing position.

## Exclusion Precedence

One scoped Transaction receives one calculation disposition:

1. future financial date relative to the Johannesburg-local `asOf`;
2. ignored;
3. invalid exact-money or canonical semantics;
4. transfer;
5. adjustment;
6. unresolved movement semantics;
7. canonical historical authority, always excluded;
8. genuine legacy-unreconciled authority, either disclosed as excluded or returned in its separate opt-in bucket;
9. active ordinary income or expense.

The response metadata contains the exact date range, `asOf`, currency, Financial Spaces, Accounts, authority scope, filters, exclusions, unresolved gross known movement volume and count, authority buckets, formula version, and deterministic drill-down references. Drill-down references are capped at 250 and disclose the total count, limit, and truncation state.

## Fee Evidence

Raven does not infer fees from vague text. `get_fee_summary` requires ordered, reviewed rules using one of:

- an explicit Category key set, optionally including its reviewed descendants;
- exact normalized merchant names;
- explicit description phrases supplied by the caller.

Rules have deterministic first-match precedence. Category rules are resolved through Financial-Space-qualified Category identities. Every subtotal identifies the rule id, rule type, label, precedence, amount, count, and bounded Transaction references. Overlapping rules cannot double-count one Transaction.

## Implementation

- Contracts and formulas: `packages/raven-domain/src/financial-analytics-*`.
- Read repository: `packages/raven-surreal/src/repository.ts`.
- Studio tRPC: `apps/raven-studio/server/trpc/routers/financial-analytics.ts`.
- Studio surface: `apps/raven-studio/app/pages/analysis.vue`.
- Semantic MCP: `apps/raven-mcp/src/financial-analytics-tools.ts`.

The Surreal repository performs one Account-scoped, period-bounded `SELECT` using conservative `postedAt`, `effectiveAt`, and `recordedAt` predicates. Within that SELECT, a bounded correlated reverse lookup projects whether the Transaction has immutable confirmed or superseded `StatementTransactionMatch.transaction` history. The projection never infers authority from description, amount, Category, Merchant, or free text. The query contains no aggregation formulas and no write statement. Domain remains final authority for period, `asOf`, authority, exclusion, grouping, checked-money, fee-rule, ordering, and pagination behavior. Studio and MCP are thin adapters over the same transport handlers.

All seven operations are callable through Studio's tRPC/composable layer. The minimal `/analysis` page visibly renders period, Category, trend, quality, and uncategorized sections; merchant and fee operations remain service-callable but are not dedicated visible sections in RA-00.

Data-quality amount fields are explicitly named `grossKnownMovementVolume`. They sum known positive movement magnitudes across directions and must never be presented as spend, income, net, balance, or net position.

## Verification

Run:

```bash
pnpm test:financial-analytics
```

The focused suite uses fictional fixtures only and covers exact Category and merchant totals, Financial-Space-qualified descendants and fee rules, multi-Account and explicitly empty scope, transfer exclusion, current/prior/cross-month bounds, Johannesburg `asOf` cutoff, cleared-pointer source-created and adopted-legacy canonical history, genuine renderer-era legacy, manual return to provisional authority, bounded repository reads and drill-downs, provisional and statement-backed counts, uncategorized and unresolved disclosure, pagination reconciliation, overflow rejection, SELECT-only persistence, and Domain/tRPC/MCP/Studio parity.

The standard Data Atlas, archive-safety, Brain-health, and AI-safe archive checks remain mandatory before external review.
