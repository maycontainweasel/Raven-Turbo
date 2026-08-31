# Brain Patch - RAVEN-INGEST-0025

## Sources Ingested

- Master-orchestrator ST-02 final acceptance and pilot-readiness review.
- Exact governing Historian HP-00 Controlled Private Statement Pilot Readiness prompt.

## Files Created

- `brain/source-material/external-review/RAVEN-INGEST-0025-st02-acceptance-and-hp00-authorization/SOURCE_MANIFEST.md`
- Two byte-identical raw source files in the same packet directory.
- `brain/sprints/0025-st02-acceptance-and-hp00-authorization/INGEST_RECORD-RAVEN-INGEST-0025.md`
- `brain/distillations/RAVEN-INGEST-0025-st02-acceptance-and-hp00-authorization.md`
- `brain/sprints/0025-st02-acceptance-and-hp00-authorization/BRAIN_PATCH.md`

## Identity Changes

- No Raven product-identity change.
- Clarifies that the first private-history operator is a Statement Historian, not a tax adviser or autonomous classifier.
- Reinforces the primary-developer / non-implementing Brainkeeper separation.

## Tenets Changed

- No new `TENET-*` was required.
- Reinforces bank evidence as movement authority, semantic-MCP-only writes, explicit approval gates, aggregate-only compatibility reporting, multi-account period completeness, and separation of reconciliation from management/tax meaning.

## Vision Deltas

- ST-02 is now externally accepted and done.
- Raven is one bounded operational-readiness pass away from a controlled private statement pilot.
- Historical usefulness should accrue after one, three, and twelve reconciled months rather than waiting for all backfill to complete.

## Decisions

- Added `DEC-0018` to record ST-02 final external acceptance and authorize only HP-00 readiness.
- The controlled private pilot remains pending HP-00 readiness evidence and explicit authorization at that workline's end.

## Open Loops

- Closed `OL-0028` for the ST-01/ST-02 implementation and acceptance sequence.
- Added `OL-0029` for HP-00 readiness and the first-pilot authorization gate.

## Risks

- Updated `RISK-0017` for accepted semantic matching/reconciliation with remaining operational-bypass risk.
- Marked the bounded ST-02 double-counting risk in `RISK-0020` externally accepted while preserving the private-operation gate.
- Added `RISK-0021` for premature or privacy-unsafe private pilot operation.

## Opportunities

- Updated the Privacy-Safe Raven Historian and operational Account Ledger opportunities from closeout foundations to accepted foundations ready for HP-00.

## Orbit Sync Candidates

- Mark ST-02 done and open/resume one HP-00 Workline in the main workline only.
- Keep private details out of Orbit and leave later lanes unstarted.
- No Orbit or `.orbit` write occurred in this sidecar.

## Raw Preservation

- Two standalone raw files preserve the supplied attachment bytes exactly and in supplied order.
- Every file has recorded byte length, newline count, and SHA-256.

## Validation

- Required top-level Brain files, folders, packet, distillation, sprint record, and indexes: passed.
- Raw attachment-to-preserved-file byte comparison: `2/2` passed.
- Preserved byte lengths, newline counts, and SHA-256 values match the source manifest: passed.
- Ingest, source, theme, decision, open-loop, risk, and active-context traceability: passed.
- Decision, open-loop, and risk identifiers are unique and indexed: passed.
- Active ST-01/ST-02 complete, HP-00 authorized/not executed, first-source-unopened consistency: passed.
- Scoped Prettier check and `git diff --check -- brain`: passed.
- Scoped obvious-secret scan: passed with no findings.
- Archive-safety policy: `5/5` passed.
- Brain health structure/current-context/manual traceability review: passed with no blocker.

## Routine Items Intentionally Ignored

- HP-00 implementation, Orbit status changes, product/schema/database work, private-source handling, MCP/vault/Studio checks, compatibility audit execution, archives, commits, merges, and pushes.
