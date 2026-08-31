# Ingest Record - RAVEN-INGEST-0023

## Metadata

- Project: Raven
- Source date: 2026-08-04
- Ingest date: 2026-08-04
- Mode: external-validation / pre-work-primer
- Status: ingested

## Source Packet

- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0023-st02-authorization/SOURCE_MANIFEST.md`
- Raw source files: two byte-identical files in the same packet directory
- Distillation: `brain/distillations/RAVEN-INGEST-0023-st02-authorization.md`
- Brain Patch: `brain/sprints/0023-st02-authorization/BRAIN_PATCH.md`

## Source Roles

1. Exact bounded implementation authorization for ST-02 Provisional Matching and Exact Statement Reconciliation.
2. Final external review accepting source-only ST-01 as complete and naming ST-02 as the next workline.

## Accepted Status And Authorization

- ST-01 Source Preview and Atomic Commit is externally accepted and done.
- `DEC-0016` and the immutable source-only ST-01 boundary remain unchanged.
- `DEC-0017` records attributable authorization for the separate ST-02 main workline.
- ST-02 is authorized, not completed by this ingest. Its implementation state must follow evidence from the separate main workline and its external review artifact.
- Private statement ingestion, the Historian operator, twelve-month backfill, ST-03 management meaning, Tax, Workline 04, Elgiz, buckets, and Earn remain unauthorized, dormant, or separate.

## Authorized ST-02 Boundary

- Resolve immutable movement components against existing provisional Transactions without creating duplicate economic movements.
- Explicitly materialize unmatched movement components as exactly one imported Transaction plus one confirmed evidence match.
- Keep informational components non-movement and outside movement totals.
- Add audited, append-only match lifecycle, source supersession, reconciliation calculation, attestation, and reopening.
- Preserve exact integer minor-unit arithmetic, ZAR-only single-currency scope, optimistic concurrency, idempotency, immutable source truth, and management/tax independence.
- Extend Raven Studio, tRPC, and semantic MCP through shared contracts without redesigning the Penpot-derived interface or exposing generic database writes.

## Attributed External Verification

SOURCE-02 reports that the accepted ST-01 archive:

- has SHA-256 `7d306996a13659669eda095990ec0dadc2882283c8f321ab32d438cd2ac18ed5`;
- contains 2,607 files;
- passed ZIP compressed-data integrity, renderer `2/2`, archive-safety `5/5`, and prohibited private-path inspection;
- excludes dependencies and private/local material, so dependency-backed package tests, the Nuxt production build, schema import, and disposable live-Surreal smoke were not rerun independently by the external reviewer.

Brainkeeper preserved these as attributed claims and did not independently reopen the archive or rerun product verification.

## Uncertainty And Gate

- The packet provides authorization and a complete implementation contract, not evidence that ST-02 has been implemented.
- The source requires ST-02 to remain in review until external artifact acceptance; Brainkeeper must never mark it done from this packet alone.
- If the separate main workline is already active, its repository and Orbit evidence determines whether the correct status is in progress or review.

## Handling

- Changed only `brain/**`.
- Did not implement ST-02 or modify product, schema, generated artifacts, database, Orbit, or `.orbit`.
- Did not inspect private financial data, vault contents, Account records, statements, transactions, or any live database.
- Did not start a service, generate a review archive, commit, merge, or push.
