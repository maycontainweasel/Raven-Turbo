# Distillation - RAVEN-INGEST-0021 - ST-01 External Review And Integrity Closeout

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0021-st01-external-review-integrity-closeout/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0021-st01-external-review-integrity-closeout/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0021-st01-external-review-integrity-closeout/INGEST_RECORD-RAVEN-INGEST-0021.md`
- Source date: not stated; supplied 2026-07-30
- Ingest date: 2026-07-30
- Mode: external-validation / pre-work-primer

## Executive Distillation

The external reviewer confirms that ST-01 is a genuine source-only vertical with sound foundations across canonical schema, the shared domain, a private source vault, Surreal persistence, Raven Studio, tRPC, MCP, and the generated Data Atlas. The reviewer accepts the architecture-level boundary: original evidence, extraction assistance, and canonical extraction remain distinct; preview is write-free; exact source components preserve source dates; and source commit creates no Transaction, management meaning, tax meaning, match, or reconciliation.

Overall ST-01 acceptance is nevertheless withheld. The packet identifies integrity defects that must be corrected in one bounded closeout before real statement use. `DEC-0016` remains accepted and is not reopened. ST-02 and private ingestion remain blocked.

## Review Gate

```text
ST-01 broad source-only vertical      implemented and foundation accepted
ST-01 overall external acceptance     not yet
Required next action                  one bounded integrity closeout
ST-02 matching/reconciliation         blocked and unstarted
Private statement ingestion           not authorized
```

The packet's orchestrator prompt is authoritative workline input, but this Brainkeeper ingest does not execute it or modify Orbit.

## Durable Closeout Requirements

### Atomic Source Authority

The final database transaction must enforce at most one active committed source authority for an Account and exact period, and prevent the same original source from occupying another period for that Account. A deterministic period/source claim or equivalent transaction-safe authority must handle concurrent first writes and remain compatible with later append-only supersession. The transaction must also revalidate the Financial Space and active Account.

Stable outcomes are required:

- exact source already present: `STATEMENT_DUPLICATE_SOURCE`;
- occupied period with different source: `STATEMENT_IMMUTABLE_CONFLICT`;
- changed request under the same idempotency key: `IDEMPOTENCY_CONFLICT`.

### Strict Extraction Assistance

`statement-extraction-input-v0.1` needs a checked-in machine-readable schema, fictional example, and concise operator guide. Structural ambiguity must fail closed: arrays must be arrays, identifiers must be unique, dates must pass exact calendar validation, unknown meaning-bearing fields must be rejected, and all integers and accumulations must stay in the safe exact range.

The row/component matrix must require coherent movement roles, positive exact amounts, equal effect magnitudes, known flow coherent with balance convention, and at least one printed source date for movement. Informational breakdowns retain zero balance effect and no future Transaction eligibility.

Printed running balances must be validated without discarding their source value. Explicit coverage must prove whether every page, section, and printed row was processed. Incomplete or indeterminate monetary coverage is blocking `STATEMENT_PARTIAL_PERIOD`; a zero-row statement is valid only with explicit complete coverage and exact zero-activity balance evidence. Every meaning-bearing source fact and coverage field participates in canonical extraction identity.

### Honest Legacy State

The semantic read model must preserve `legacy`, actual persisted source state, profile and extractor versions, currency, and validation ruleset. Studio must distinguish:

- `ST-01 committed source`;
- `Legacy import - source authority not yet verified`;
- `Superseded source`.

Legacy records must not be relabeled as verified ST-01 authority. A legacy record occupying a period creates a precise compatibility blocker. Any aggregate-only compatibility audit remains a separate later gate; this closeout does not inspect or migrate private records.

### Replay, Snapshot, And Graph Integrity

Commit request identity must derive from submitted preview identity and command metadata. Existing operation replay/conflict resolution occurs before vault reopening so an applied operation can replay from committed records even if staged evidence is temporarily unavailable. New commits still reopen, rehash, re-extract, and revalidate.

Closing snapshots require deterministic Financial Space/Account-scoped identity, statement period-end interpreted in the owning Financial Space timezone, and profile/Account authority over balance convention. Assistance alone cannot authorize economic nature. The atomic commit must also create `AccountStatementImports` while preserving row, component, and issue edges.

### Stable Operator Intent And Advisory Detection

Studio must retain one idempotency key for one reviewed preview intent across failed or lost-response retries. It resets only after success, abandonment, a different source, changed Account/profile, or a newly generated preview. Source/profile changes invalidate stale previews.

An extraction-assistance `profileHint` is assistance evidence, not independent bank recognition. The UI should expose provenance and evidence codes while showing source hash prefix, Account/currency, adapter/extractor versions, coverage, and blockers without redesigning the Account Ledger.

### Real Fictional Boundary Proof

tRPC and MCP must share or derive equivalent validation contracts and parity tests must cover schemas and representative payloads. A fictional multi-page-sized PDF plus JSON sidecar must survive the Studio serialization/server/vault path without leaking a local path.

A disposable isolated Surreal namespace/database must prove atomic commit, stable replay, changed-request conflict, concurrent period exclusion, rollback, exact records and runtime edges, absence of later-lane records, and cleanup in `finally`. It must never use configured private Raven records.

## Preserved Boundaries

- Do not inspect, stage, preview, query, audit, migrate, or modify private statements or live financial records.
- Do not start ST-02, private Historian operation, Transaction materialization, matching, reconciliation, management meaning, tax treatment, buckets, Workline 04, Elgiz, or Earn.
- Do not redesign the Penpot-derived Account Ledger.
- Keep generic Surreal MCP outside the Historian path.
- Use fictional isolated sources and databases only.
- Do not commit, merge, or push.

## Observed Facts And Attributed Claims

Observed from the supplied packet:

- the formal review explicitly withholds overall ST-01 acceptance;
- the same review explicitly accepts the broad implementation foundations;
- the packet supplies one bounded closeout prompt covering the identified defects;
- ST-02 and private statement use remain blocked.

Attributed external-review claims not independently reverified by Brainkeeper:

- reviewed archive SHA-256 is `114a9265ac5cdadfec231b737dce1ca261199d18fff2e9a92f193503da83187b`;
- ZIP integrity passed;
- legacy renderer tests passed `2/2`;
- archive-safety tests passed `5/5`;
- source-level schema/domain/repository/UI inspection was completed.

Open implementation truth:

- no closeout defect is treated as corrected by this ingest;
- no live persistence or upload-boundary proof is treated as complete;
- external acceptance remains pending a fresh implementation archive and review.

## Risks

- Concurrent commits can establish competing source authority for one Account/period.
- Permissive extraction can convert malformed or incomplete source evidence into apparently immutable truth.
- Unchecked aggregation can corrupt exact money.
- Legacy evidence can be overstated as ST-01-verified.
- Lost-response retries can create avoidable conflicts if command intent changes.
- UTC end-of-day and unscoped snapshot identity can misstate closing evidence.
- Assistance-controlled balance convention can overstate asset/liability authority.
- Replay can fail unnecessarily when already-committed source bytes are temporarily unavailable.
- String-level repository tests alone do not prove real transaction or upload behavior.

## Opportunities

- Publish a stable, agent-readable extraction contract for the future private Historian.
- Make source authority concurrency-safe and append-only from its first accepted release.
- Preserve honest distinctions among legacy, verified, and superseded evidence.
- Establish fictional end-to-end evidence for Studio transport and Surreal atomicity before private use.

## Orbit Sync Candidates

- Keep the existing ST-01 Workline in review with review attention.
- Set the next bounded objective to source integrity, atomic uniqueness, legacy fidelity, and operator readiness.
- Keep ST-02, private ingestion, and all later lanes unstarted.
- Sync no private source path, filename, statement content, account record, amount, or credential.

No Orbit or `.orbit` state was changed by this ingest.

## Routine Items Intentionally Excluded

- No product code, schema, generated artifact, architecture document outside Brain, Studio, tRPC, MCP, database, private source, service, archive, Orbit write, commit, merge, or push.
- No implementation result inferred from the embedded prompt.
