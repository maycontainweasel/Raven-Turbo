# Distillation - RAVEN-INGEST-0033 - RA-00B Canonical-History Authority Closeout

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0033-ra00b-canonical-history-authority-closeout/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0033-ra00b-canonical-history-authority-closeout/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0033-financial-read-analytics-00b-authority-closeout/INGEST_RECORD-RAVEN-INGEST-0033.md`
- Source date: supplied 2026-08-13
- Mode: external-validation / pre-work-primer

## Executive Distillation

The external reviewer accepts the RA-00 current-main surgical integration, all seven read-only semantic operations, default `active_ledger` analytics, and the six earlier integrity corrections. Exact integer money, per-currency scope, transfer exclusion, Financial-Space-qualified Categories, explicit-empty scope, Johannesburg-local `asOf`, bounded reads and references, gross-known-movement-volume naming, and the no-tax-inference boundary are accepted. Merchant and fee operations remain available through Studio services and MCP without dedicated visible `/analysis` sections.

One narrow defect remains only in optional `active_ledger_with_legacy_unreconciled` reads. ST-02 source supersession clears the active `Transaction.statementMatch` pointer and `effectiveAt` while preserving immutable reverse `StatementTransactionMatch.transaction` history. An imported source-row Transaction that was formerly canonical can therefore look like renderer-era legacy evidence if analytics considers only the current pointer.

The exact RA-00B prompt authorizes one final micro-closeout, not another analytics architecture cycle. The bounded read query must derive canonical match history independently of the active pointer, return the smallest typed provenance field, and normalize authority without using amounts, descriptions, Category, Merchant, or free text. The default active-ledger output must remain byte/contract compatible.

## Accepted State

- RA-00 current-main surgical integration: externally accepted.
- Seven read-only Domain/tRPC/MCP operations and outputs: externally accepted.
- Default `active_ledger` calculations: externally accepted and usable.
- Six prior integrity corrections: externally accepted.
- Financial schema remains unchanged.
- Financial writes and `FinancialOperation` remain absent.
- Private-data and configured-private-database access remain absent and prohibited.
- RA-00 overall remains briefly in review only for the optional legacy-inclusive authority projection.

## Remaining Authority Defect

Actual supersession storage may have:

- imported source-row Transaction;
- current `statementMatch = NONE`;
- cleared `effectiveAt`;
- immutable reverse canonical match history still present.

Without the reverse-history fact, formerly canonical history can be misclassified as `legacy_unreconciled` and re-enter the optional review bucket. Default active-ledger totals are not affected.

Required final classification:

- valid current committed statement authority -> `active`;
- imported source-row Transaction with canonical match history and no active authority -> `canonical_historical_superseded`;
- imported source-row Transaction without canonical match history -> `legacy_unreconciled`;
- manual/generated Transaction whose former match is superseded and cleared -> active provisional using its observation date.

Only genuine renderer-era `legacy_unreconciled` records may enter the optional legacy-inclusive scope.

## Bounded RA-00B Workline

The main implementation agent is authorized to:

1. Extend the existing bounded, Account- and period-scoped SELECT with a deterministic reverse canonical-match-history lookup.
2. Return the smallest typed history projection needed by the repository normalizer.
3. Preserve SELECT-only behavior, one bounded read, zero-query empty Account scope, and zero financial writes.
4. Add the exact fictional source-supersession, source-created, adopted-legacy, renderer-era, and manual-provisional regressions.
5. Preserve Domain/tRPC/MCP/Studio parity and the accepted default output contract.
6. Coordinate shared-file activity with HP-04A before touching current main.
7. Verify, update the implementation record, package current-main safely, and leave RA-00 in external review.

The workline may not redesign `/analysis`, add schema models, access private data, query the configured private database, create financial writes, start another RA workline, or touch HP-04A private gates.

## Decision And Open-Loop Effects

- No new `DEC-*` is needed. `DEC-0025` remains the governing read-only RA-00 authorization.
- `OL-0036` narrows to RA-00B's final canonical-history authority micro-closeout.
- `RISK-0023` narrows from six broad integrity findings to one reverse-history provenance defect in optional legacy-inclusive analytics.
- `OPP-0013` advances: default analytics and current-main integration are accepted; only optional legacy review remains gated.
- `Q-0033` is resolved because the complete locally supplied RA-00B prompt is preserved in this ingest.

## Identity, Tenets, And Vision

- No Raven product-identity change.
- No new tenet is required.
- Reinforces that immutable history, not only current pointers, participates in read authority.
- Reinforces that provisional manual evidence can regain active provisional status after a superseded match without inheriting canonical historical exclusion.
- Reinforces that a read-only defect can be narrow, explicitly bounded, and corrected without reopening accepted product architecture.

## Opportunities

- Completion of RA-00B can make the optional legacy-inclusive view safe for review while preserving byte-compatible default analytics.
- The reverse-history projection becomes a reusable pattern for authority-aware reads where active pointers are intentionally cleared but immutable provenance remains.

## Orbit Sync Candidates

- Record current-main RA-00 integration and default active-ledger analytics as accepted.
- Keep RA-00 overall in external review only for RA-00B's optional legacy-inclusive authority correction.
- Keep HP-04A moving independently and preserve its private gates.

No Orbit state was accessed or changed because the sidecar request explicitly prohibited Orbit work.

## Attributed Verification And Uncertainty

The reviewer reports archive SHA-256 `6d24050d1dfdb57fb39f5602f894fc5c010d262bbc793e2bcbb982078329552e`, 2,898 entries, ZIP integrity passing, and independently rerun archive-safety tests `5/5`. Brainkeeper did not inspect the archive, product code, dependencies, or configured database and did not rerun product verification. The findings and acceptance states remain externally attributed until the main workline completes RA-00B and a later artifact review accepts it.

## Routine Items Intentionally Excluded

- No implementation, product inspection, schema, Domain, repository, tRPC, MCP, Studio, test, fixture, package, documentation outside Brain, database, service, archive, Orbit, commit, merge, push, or private-source action.
- No private Account, period, source, amount, balance, path, record, description, counterparty, Category, Merchant, tax, crosswalk, or disposition detail.
