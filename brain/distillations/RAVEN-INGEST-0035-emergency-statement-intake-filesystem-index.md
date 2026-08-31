# Distillation - RAVEN-INGEST-0035 - Emergency Statement Intake Filesystem Index

## Source

- Packet: `brain/source-material/pre-work/RAVEN-INGEST-0035-emergency-statement-intake-filesystem-index/`
- Manifest: `brain/source-material/pre-work/RAVEN-INGEST-0035-emergency-statement-intake-filesystem-index/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0035-emergency-statement-intake-filesystem-index/INGEST_RECORD-RAVEN-INGEST-0035.md`
- Source date: supplied 2026-08-17
- Mode: pre-work-primer

## Executive Distillation

The replacement orchestrator attachment is byte-identical to the packet preserved by `RAVEN-INGEST-0034`. Michael supplied a separate explicit addendum because that packet overcomplicates Phase C by requiring DuckDB or an equivalent embedded database.

The addendum has higher precedence. Phase C must use an owner-only, rebuildable, filesystem-native deterministic JSON/NDJSON index with bounded local query/report commands. It must use no second database, add no canonical Raven schema model, and perform no canonical Raven financial write. The broader emergency intake lane remains private, provisional-source-only, aggregate-safe outside its owner-only boundary, and unstarted by Brainkeeper.

## Precedence And Supersession

- SOURCE-02 governs every conflict with SOURCE-01.
- The phrase `DuckDB or equivalent embedded database` in SOURCE-01 is superseded and must not guide implementation.
- SOURCE-01's proposed logical records may be represented as deterministic JSON/NDJSON filesystem artifacts rather than tables in another database.
- Bounded local query/report commands may read the rebuildable filesystem index but may not create canonical Raven authority or financial writes.
- Every non-conflicting privacy, provenance, exact-money, uncertainty, source-only, reporting, verification, and later-activation boundary in SOURCE-01 remains proposed and unchanged.
- `RAVEN-INGEST-0034` is not edited or erased; `RAVEN-INGEST-0035` is the current governing correction for Phase C.

## Durable Decision

- `DEC-0026`: Emergency intake Phase C uses a filesystem-native deterministic JSON/NDJSON index, not DuckDB or another embedded database.
- This decision settles only the proposed storage/query mechanism. It does not establish execution, private permission, verified inventory, adapter coverage, or financial results.

## Authority And Privacy Boundaries

- The filesystem index is operational evidence infrastructure, not active Raven ledger authority.
- It cannot feed Account position, budgets, reconciled analytics, accepted management meaning, tax meaning, accounting conclusions, or legal conclusions automatically.
- No private statement body, source identity, Account detail, period, amount, balance, locator, fingerprint, description, counterparty, recipient, legal analysis, or tax fact may enter Brain or Orbit.
- Brainkeeper inspected neither `docs/statements` nor any owner-only intake output, database, or service.

## Existing Signals Updated

- `OL-0037` remains the single open execution loop, now governed by the filesystem-native Phase C correction.
- `RISK-0024` remains the relevant leakage and authority-contamination risk; avoiding a second database narrows operational complexity but does not relax containment or provenance controls.
- `OPP-0014` remains the opportunity for urgent source-level visibility through a rebuildable private index.
- No duplicate open loop, risk, or opportunity is created.

## Orbit Sync Candidates

- If a primary operator establishes the Workline, describe Phase C as an owner-only deterministic JSON/NDJSON index with bounded local query/report commands.
- Do not describe DuckDB or another embedded database as part of the current governing lane.
- Keep execution status, private permissions, and operational results unestablished until separately acted on.
- Sync only aggregate-safe phase state, issue/coverage classes, blockers, and gates.

No Orbit or `.orbit` state was accessed or changed by this sidecar.

## Routine Items Intentionally Excluded

- No product implementation, statement-folder inspection, private-output inspection, database operation, service action, archive generation, Orbit mutation, or Git-history action.
- No execution claim, verified source inventory, Account mapping, period coverage, extraction result, private query result, or financial calculation.
