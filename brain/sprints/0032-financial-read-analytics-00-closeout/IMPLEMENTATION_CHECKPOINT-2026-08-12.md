---
status: review
owner: Raven
date: 2026-08-12
workline: RA-00 read-integrity closeout
privacy: aggregate-only
source: RAVEN-INGEST-0032
---

# Financial Read Analytics 00 Read-Integrity Closeout

## RA-00B Final Authority Closeout - 2026-08-13

- The bounded analytics SELECT now derives immutable canonical match history through a correlated reverse lookup on `StatementTransactionMatch.transaction`, limited to confirmed or superseded canonical match records.
- Current committed statement authority remains active. Imported source-row Transactions with canonical history but no current active pointer are canonical historical/superseded. Imported source-row Transactions without canonical history are genuine legacy-unreconciled. Manual/generated Transactions with a cleared former match remain active provisional and use their observation date.
- The optional legacy-inclusive scope therefore contains only genuine renderer-era legacy evidence; default active-ledger contracts and totals are unchanged.
- The correction was applied directly to current main after confirming that no HP-04A worktree or active shared-file edit existed. No private source, configured private database, financial write, schema change, or `FinancialOperation` was used.

## Outcome

- The six externally identified read-integrity findings are implemented in the isolated RA-00 worktree and surgically integrated into current main.
- Formula authority is now `raven.financial-read-analytics.v2`.
- No private source, configured private database, financial write, schema change, or `FinancialOperation` was used.
- No active HP-04A worktree or shared-file activity was present at integration time. New files were copied selectively and shared files were patched additively; the isolated lockfile and stale shared files were not copied.
- The integrated main artifact remains in external review.

## Corrections

1. Derived authority distinguishes active, genuine legacy-unreconciled, and canonical historical/superseded Transactions. Canonical history never re-enters an opt-in legacy result.
2. Category descendants and Category fee rules use `spaceKey + categoryKey` identities.
3. Explicit empty Financial-Space or Account scope returns empty without a broad read.
4. Every query accepts a timezone-qualified `asOf`; the injected clock default is interpreted in `Africa/Johannesburg`, and later financial dates are future exclusions.
5. Surreal reads use conservative period predicates over `postedAt`, `effectiveAt`, and `recordedAt`; deterministic drill-down refs are capped at 250 with count and truncation metadata.
6. Quality and unresolved magnitudes are named gross known movement volume so they cannot be mistaken for spend, income, net, balance, or net position.

## Verification

- Focused RA-00 suites: 20/20 across Domain, Surreal, MCP, and Studio.
- Raven Domain full suite: 128/128.
- Raven Surreal full suite: 47/47.
- Raven MCP full suite: 16/16.
- Direct Domain, Surreal, and MCP TypeScript checks: passed.
- Studio production build: passed in current main, including `/analysis`.
- Data Atlas tests: 9/9; stale check passed twice.
- Archive-safety tests: 5/5.
- All fixtures remain fictional and the analytics repository remains SELECT-only.

## Studio Boundary

All seven operations are available through Studio tRPC/composables and MCP. The minimal `/analysis` page visibly renders five sections; merchant and fee operations remain callable but are not dedicated visible sections in this workline.
