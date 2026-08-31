# Brain Patch - RAVEN-INGEST-0027

## Sources Ingested

- HP-01 external acceptance review and evidence boundary.
- Exact governing HP-02 Authorization and Execution prompt.

## Files Created

- `brain/source-material/external-review/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization/SOURCE_MANIFEST.md`
- Two byte-identical raw source files in the same packet directory.
- `brain/distillations/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization.md`
- `brain/sprints/0027-historian-hp01-schema-deployment/INGEST_RECORD-RAVEN-INGEST-0027.md`
- `brain/sprints/0027-historian-hp01-schema-deployment/BRAIN_PATCH.md`

## Identity Changes

- No Raven product-identity change.
- Reinforces the Historian as a local, semantic-command-only, explicitly approval-gated operator.

## Tenets Changed

- No new `TENET-*` was required.
- Reinforces separation of acceptance evidence, workline authorization, source-staging approval, no-write preview, and financial mutation authority.

## Vision Deltas

- HP-01 configured schema parity is externally accepted and complete.
- HP-02 is authorized as the next private selected-period gate but remains unexecuted.
- Raven is now one controlled local selection/compatibility session away from a possible separately approved first no-write preview.

## Decisions

- Added `DEC-0020`: accept HP-01 and authorize HP-02 Private Selection and Compatibility as the next bounded gate.
- HP-02 authorization does not authorize source staging, preview, commit, or later operations.

## Open Loops

- Closed `OL-0030` for HP-01.
- Advanced `OL-0031` from gated to authorized but unexecuted.
- Preserved the first private source and controlled pilot as later explicit gates.

## Risks

- Updated the private-pilot gate to distinguish HP-02 authorization from selection, compatibility, source-staging, preview, and write authority.
- Preserved minimum-private-read, complete interacting-Account coverage, prescribed classification, and aggregate-only handoff boundaries.

## Opportunities

- Resolve one selected period privately and safely before considering legacy migration or the first financial write.

## Orbit Sync Candidates

- Mark HP-01 done and HP-02 authorized/waiting without syncing private facts.
- No Orbit mutation occurred in this ingest.

## Routine Items Intentionally Ignored

- HP-02 execution, private data, database/MCP/service inspection, source operations, product/schema work, verification runs, archive generation, Git integration, and all non-Brain files.
