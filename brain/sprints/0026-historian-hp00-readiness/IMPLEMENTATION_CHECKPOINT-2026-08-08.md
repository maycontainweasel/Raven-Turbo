# Historian HP-00 Readiness Checkpoint

## Status

HP-00 is implemented and remains in review. ST-02 is externally accepted and done.
No private statement was opened, read, staged, or ingested.

## Proven Ready

- The semantic `raven` MCP is configured and exposes the exact 28 Statement Truth
  operations with no raw SurrealQL surface.
- The generic Surreal MCP defaults to diagnostic read-only operation with raw writes
  disabled.
- The configured inbox and vault roots are owner-only, current-user owned,
  non-symlink, Git-ignored, untracked, path-redacted, bounded to the existing 15 MiB
  source limit, and excluded from AI-safe archives.
- The selection checklist, operator runbook, dedicated agent starter, and
  machine-readable operation inventory exist.

## Aggregate-Only Audit

The configured database audit performed zero writes and returned counts/classes only:

- canonical imports: `0`;
- active legacy imports: `38`;
- scoped legacy identities: `438`;
- mappable legacy periods: `0`;
- unmappable legacy imports: `38`;
- source-backed Transactions without ST-02 matches: `1,419`.

No descriptions, amounts, filenames, account identities/numbers, source text, notes,
record IDs, credentials, or local paths were emitted or stored.

## Blocking Gate

The configured database is missing nine accepted Statement Truth tables spanning
source/period claims, components/issues, matching/resolution claims, and
reconciliation/events. HP-00 did not apply schema or migrate records. The controlled
private pilot is not authorized until a separately authorized deployment of the
already-accepted canonical schema completes and `pnpm historian:readiness` returns
`ready`.

The user-managed Raven Studio endpoint returned HTTP `502`. This degrades visual
review but is not the primary integrity blocker. No development server was started.

## Boundaries Preserved

ST-03, Tax & Transaction Meaning, Elgiz/buckets, Workline 04, Earn, and bulk backfill
remain unstarted. Source truth, ledger resolution, management meaning, and tax meaning
remain distinct.
