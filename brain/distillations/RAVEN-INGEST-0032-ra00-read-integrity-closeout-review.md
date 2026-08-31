# Distillation - RAVEN-INGEST-0032 - RA-00 Read-Integrity Closeout Review

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0032-ra00-read-integrity-closeout-review/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0032-ra00-read-integrity-closeout-review/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0032-financial-read-analytics-00-closeout/INGEST_RECORD-RAVEN-INGEST-0032.md`
- Source date: not explicitly stated; supplied and ingested 2026-08-12
- Mode: external-validation

## Executive Distillation

The external reviewer confirms that RA-00 is a real and useful read-only financial-query foundation. The seven operations exist across Raven Domain, a SELECT-only Surreal repository, Studio tRPC, and semantic Raven MCP. Exact integer minor-unit arithmetic remains in Domain; transfers and ordinary excluded states remain outside ordinary totals; canonical, provisional, and legacy evidence are intended to remain distinguishable; Category remains management meaning rather than tax treatment; fee queries require reviewed evidence rules; and no private financial data or financial write is involved.

The reviewer accepts the architecture, calculation ownership, operation catalog, no-write boundary, and MCP direction. The reviewer does not accept the isolated implementation as complete and does not accept integration into main. RA-00 must stay in review for one bounded read-integrity and safe-integration closeout.

## Accepted Boundaries

- Read-only analytics architecture: accepted.
- Exact calculation ownership in shared Domain semantics: accepted.
- Seven named semantic operations: accepted.
- No `FinancialOperation` or financial write: accepted.
- Named semantic MCP operations rather than generic Surreal write access: accepted.
- Category remains management meaning with no tax inference.
- Fictional-only and private-source-free implementation boundary remains intact.
- HP-04A remains a separate Historian lane; RA-00 does not inherit private source or apply authority.

## Six Required Findings

### 1. Legacy And Superseded Canonical History Must Be Split

The current authority projection can expose all imported source-row Transactions lacking an active Statement claim as `legacy_unreconciled`. That risks combining genuine renderer-era legacy evidence with formerly canonical evidence whose source has been superseded. Superseded canonical history must remain historical and excluded even when legacy-unreconciled evidence is explicitly requested.

Required conceptual split:

- active provisional;
- active canonical statement-backed;
- genuine legacy-unreconciled;
- canonical historical/superseded;
- unresolved or invalid.

### 2. Category Descendants Must Remain Financial-Space Scoped

Category identity is `Financial Space + local Category key`, but descendant accumulation currently uses local keys globally. Category descendants and Category-based fee matching must carry `spaceKey + categoryKey` throughout so a Business query cannot include a same-key Personal Category.

### 3. Explicit Empty Financial-Space Scope Must Stay Empty

Omitted `spaceKeys` may intentionally mean all active spaces. Explicit `spaceKeys: []` must mean no selected spaces, return an empty result, and avoid a broad database query. An empty UI selection must never broaden scope.

### 4. Current-Month Reads Need An Africa/Johannesburg `asOf` Cutoff

The response reports `asOf`, but calculations do not yet use it. The service must accept an explicit `asOf`, default through the injected clock, derive the financial date in `Africa/Johannesburg`, and exclude later financial dates as future evidence. Studio must not derive the default month through UTC `toISOString()` around South African month-end.

### 5. Repository Reads And Drill-Down Metadata Need Bounds

Domain remains final financial authority, but the repository query should add a conservative period predicate across `postedAt`, `effectiveAt`, and `recordedAt` rather than loading all history for selected Accounts and currency. Drill-down reference metadata also needs a bound or explicit truncation declaration so twelve-month and multi-year use remains operationally honest.

### 6. Data-Quality Amounts Need Economic-Safe Naming

Quality fields that sum positive magnitudes across income and expense represent gross known movement volume. They must not be named or presented as spend, income, net, balance, or net position. Contracts and MCP output must make the gross-volume meaning explicit.

## Smaller Reporting Clarification

All seven operations are callable through Studio services and MCP. The current `/analysis` page visibly renders five: period summary, Category spend, monthly trend, data quality, and uncategorized Transactions. Merchant and fee operations are available through Studio services but are not dedicated visible page sections. Future implementation reporting should distinguish service availability from visible rendering.

## Safe Integration Sequence

The external review requires this order:

1. Harden RA-00 in its isolated worktree.
2. Verify the six findings and added regression cases.
3. Check whether HP-04A is still editing shared main-worktree files.
4. Surgically port analytics additions while preserving every newer mainline change.
5. Do not copy the isolated branch wholesale, its lockfile, stale shared files, unrelated template packages, or a missing nested-schema checkout.
6. Rerun the complete focused verification matrix in main.
7. Generate a main-worktree AI-safe review archive.

The Historian lane may continue independently. Parallel validity ends whenever HP-04A and RA-00 edit the same main-worktree registration, repository, Domain, MCP, tRPC, Studio, generated, or package files.

## Decision And Open-Loop Effects

- No new accepted `DEC-*` is created. The external review validates the existing read-only boundary and establishes a review gate; it is not a user acceptance of the current implementation or main integration.
- `OL-0036` advances from implementation to bounded read-integrity closeout and safe-integration review.
- `RISK-0022` remains active and is sharpened by the six concrete findings.
- `RISK-0023` records the implementation-specific risk of authority leakage, cross-space Category leakage, scope broadening, future-date inclusion, unbounded reads, and ambiguous quality-volume naming.
- `Q-0033` records that the linked downloadable detailed closeout prompt was not locally supplied.

## Identity, Tenets, And Vision

- No Raven product-identity change.
- Reinforces that read-only financial summaries can still be materially misleading and therefore require the same authority, scope, date, and exactness discipline as writes.
- Reinforces Financial Space as part of scoped management-meaning identity.
- Reinforces local-time financial cutoffs for Raven's South African operating context.
- Reinforces surgical integration from isolated worktrees rather than wholesale copying of stale shared files.

## Opportunities

- Once hardened and safely integrated, the seven semantic reads form Raven's first conversational financial-query backbone for Category, fee, Merchant, Account, trend, uncategorized, and authority-quality questions.
- The bounded closeout can establish reusable contracts for explicit empty scope, time cutoffs, authority class separation, bounded drill-downs, and economically safe quality labels.

## Orbit Sync Candidates

- RA-00 architecture accepted; implementation remains in review for one bounded closeout.
- Preserve all six findings and the safe-integration sequence.
- Do not mark main integration accepted until the main-worktree verification archive is reviewed.

No Orbit state was accessed or changed because the governing sidecar request explicitly prohibited Orbit work.

## Attributed Verification And Uncertainty

The reviewer reports archive SHA-256 `ce3c494c8ae2b415c893e340a155e9b606b8a5f69a8810c83e1e3b437f4fc809`, 1,605 entries, valid ZIP integrity, and independently rerun archive-safety tests `5/5`. Brainkeeper did not inspect the archive or rerun product verification. The reviewer could not independently rerun pnpm TypeScript suites or the Nuxt production build because installed dependencies are correctly absent from the AI-safe archive.

The source links to `raven_ra00_read_integrity_and_integration_prompt.md`, but no local attachment for that detailed prompt was supplied. Its claimed contents, exact commands, and execution authority are therefore not preserved or inferred by this ingest. A main implementation agent must obtain or be explicitly given that prompt before treating it as governing source material.

## Routine Items Intentionally Excluded

- No implementation, product inspection, schema, Domain, repository, tRPC, MCP, Studio, test, fixture, package, documentation outside Brain, database, service, archive, Orbit, commit, merge, push, or private-source action.
- No private Account, period, source, amount, balance, path, record, description, counterparty, Category, Merchant, tax, crosswalk, or disposition detail.
