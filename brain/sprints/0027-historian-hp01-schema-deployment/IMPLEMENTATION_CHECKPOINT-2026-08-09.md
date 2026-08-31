# HP-01 Implementation Checkpoint

Date: 2026-08-09
Status: review
Owner: Raven

## Outcome

The accepted Statement Truth schema was deployed to the configured Raven database as
one additive schema transaction after a verified private recovery point was created.
The deployment added the nine canonical Statement Truth base tables, their nine
generated admin views, and 27 generated CRUD function definitions. All newly present
tables are empty and all 52 pre-existing table/view record counts are unchanged.

`pnpm historian:readiness` now reports
`schema_ready_legacy_compatibility_unresolved`. Schema readiness is complete, but the
controlled private pilot remains unauthorized. The aggregate legacy blocker remains
38 active imports with no canonical period mapping and 1,419 source-backed
Transactions without ST-02 match authority. HP-02 must select one closed ZAR
multi-account period and resolve overlap privately before any source is staged.

## Recovery And Plan Evidence

- Redacted target fingerprint:
  `sha256:6c1ad03824d243d519ef628660c23542a6ec0d0c76e5408d9f5c791555d004a1`.
- Verified recovery reference:
  `HP01-2026-08-09T12-13-15-856Z-95e598780f7e`.
- Recovery SHA-256:
  `95e598780f7ee5d487cb9f167e4a900083e51fa5824c62afa3b3e6fe871b15da`.
- Recovery method: database stopped, owner-only offline RocksDB archive, archive
  integrity check, isolated extraction, and source/extracted tree-digest equality.
- Canonical source: `apps/schema/config/graph.mpdg` and its generated model artifacts.
- Plan: 9 additive base tables, 27 additive functions, 9 additive admin views, 0
  compatible alignments, and 0 destructive or row-changing operations.
- The operator rejected non-schema top-level statements and required both the target
  fingerprint and verified recovery reference before apply.

The private recovery artifact remains outside Git, Brain sources, and AI-safe archives.
No endpoint, namespace, database name, credential, or private path is recorded here.

## Verification

- HP-01 plan, apply, post-apply definition-shape verification, and aggregate count
  invariance passed.
- Strict graph validation, spec generation, and 28-model artifact regeneration passed.
- Raven Domain: 98 tests and typecheck passed.
- Raven Surreal: 42 tests and typecheck passed.
- Raven MCP: 14 tests and typecheck passed.
- Raven Studio statement UI: 4 tests passed; production build passed with existing
  non-blocking warnings.
- Fictional disposable ST-01 and ST-02 live smokes passed and cleaned up.
- Data Atlas: 9 tests and two consecutive 28-model stale checks passed.
- Legacy fictional statement renderer: 2 tests passed.

Final archive-safety, AI-safe preflight, Brain health, formatting, secret scan, and
root/nested diff checks are recorded in the completion handoff.

## Boundaries Preserved

No private statement or financial record body was opened or emitted. No financial
record was created, updated, deleted, migrated, replayed, matched, reconciled,
classified, or attested. No development server was started. Nothing was committed,
merged, or pushed.
