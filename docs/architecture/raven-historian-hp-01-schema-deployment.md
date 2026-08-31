---
status: review
owner: Raven
last_reviewed: 2026-08-09
supersedes: []
superseded_by: []
---

# Raven Historian HP-01 Schema Deployment

## Verdict

The accepted Statement Truth schema was deployed to the configured Raven database as
one bounded schema transaction. The plan was purely additive, every pre-existing
aggregate record count remained unchanged, and all nine new canonical tables and
nine generated admin views are empty.

HP-01 remains in review pending external acceptance. Schema readiness does not
authorize a private statement. The next gate is HP-02 private account/period selection
and legacy-compatibility resolution.

## Recovery And Target

| Evidence              | Result                                                                                   |
| --------------------- | ---------------------------------------------------------------------------------------- |
| Target fingerprint    | `sha256:6c1ad03824d243d519ef628660c23542a6ec0d0c76e5408d9f5c791555d004a1`                |
| Recovery reference    | `HP01-2026-08-09T12-13-15-856Z-95e598780f7e`                                             |
| Recovery timestamp    | `2026-08-09T12:13:15.856Z`                                                               |
| Recovery method       | Offline RocksDB archive while the database was stopped                                   |
| Tool                  | bsdtar 3.5.3 / libarchive 3.5.3                                                          |
| Recovery SHA-256      | `95e598780f7ee5d487cb9f167e4a900083e51fa5824c62afa3b3e6fe871b15da`                       |
| Recovery verification | Archive integrity, isolated extraction, and source/extracted tree digest equality passed |
| Permissions           | Owner-only directory and artifact                                                        |

The normal Raven configuration path supplied the endpoint, namespace, and database.
Only their combined hash appears here. Credentials and private paths were not printed,
stored in Brain, or placed in the review archive.

The standard logical-export helper could not authenticate against the existing server
identity. Its output was not accepted as a recovery point. The verified cold snapshot
was created before schema application and remains outside the repository and AI-safe
archive.

## Canonical Plan

Canonical source: `apps/schema/config/graph.mpdg`.

| Classification                            | Count |
| ----------------------------------------- | ----: |
| Additive base-table definitions           |     9 |
| Additive generated function definitions   |    27 |
| Additive generated admin-view definitions |     9 |
| Compatible definition alignments          |     0 |
| Destructive or row-changing operations    |     0 |
| Total top-level schema definitions        |    45 |

- Canonical graph SHA-256: `7842f897b1e075dd81f8ce471a2f211e84f952b868e3709450a9dbfdead32277`
- Nine generated specs contained 165 canonical fields and nine explicit identity structures.
- All nine models are intentionally schemaless with full permissions.
- The accepted generated artifacts contain no physical `DEFINE FIELD`, index, or
  relation definition for these nine models.
- CRUD verbs inside generated function bodies were not executed. The deployment
  executed only top-level `DEFINE` statements.
- No `DROP`, `REMOVE`, `DELETE`, `TRUNCATE`, record `CREATE`, record `UPDATE`, data
  copy, migration, replay, cleanup, or asset-tracking write was present in the plan.

The general schema importer was not used unchanged because its cleanup and remote
asset-tracking behavior would violate HP-01. The bounded operator consumes the
canonical generated specs and SURQL artifacts directly, rejects non-schema top-level
statements, requires the confirmed target fingerprint and verified recovery reference,
and applies the accepted definitions in one transaction.

## Newly Present Tables

Canonical Statement Truth tables:

- `statementSourceClaim`
- `statementPeriodClaim`
- `statementRowComponent`
- `statementIssue`
- `statementTransactionMatch`
- `statementComponentResolutionClaim`
- `statementTransactionResolutionClaim`
- `statementReconciliation`
- `statementReconciliationEvent`

Generated read-only projection tables:

- `StatementSourceClaimAdmin`
- `StatementPeriodClaimAdmin`
- `StatementRowComponentAdmin`
- `StatementIssueAdmin`
- `StatementTransactionMatchAdmin`
- `StatementComponentResolutionClaimAdmin`
- `StatementTransactionResolutionClaimAdmin`
- `StatementReconciliationAdmin`
- `StatementReconciliationEventAdmin`

All 18 newly present tables have zero records. The 27 expected create/update/delete
function definitions are present with canonical argument shapes and full permissions.
Remote table kind, schemaless mode, permissions, view projections, and function
signatures match the generated definitions.

## Aggregate Invariance

The preflight contained 52 existing tables and views. Count-only queries captured the
baseline and the operator compared every pre-existing count after deployment. All 52
were unchanged.

Key invariants include:

| Aggregate class                                         | Before | After |
| ------------------------------------------------------- | -----: | ----: |
| Active legacy statement imports                         |     38 |    38 |
| Statement rows                                          |  1,419 | 1,419 |
| Source-backed Transactions                              |  1,419 | 1,419 |
| Financial operations                                    |      0 |     0 |
| New Statement Truth source/match/reconciliation records |      0 |     0 |

No FinancialOperation, StatementImport, StatementRow, StatementRowComponent,
Transaction, source claim, period claim, match, resolution claim, issue,
reconciliation, reconciliation event, snapshot, or other financial record was created,
updated, deleted, migrated, or replayed.

## Readiness Result

`pnpm historian:readiness` now reports:

```text
status                                    schema_ready_legacy_compatibility_unresolved
semantic Statement Truth operations      28 / exact match
semantic raw SurrealQL                    not exposed
generic Surreal writes                    disabled
private vault/inbox                       ready
accepted Statement Truth schema           complete
missing canonical tables                  0
active legacy imports                     38
unmappable legacy imports                 38
selected-period occupancy                 not selected
controlled pilot authorized               no
controlled pilot started                  no
Raven Studio                              degraded / HTTP 502
next gate                                 HP-02
```

The readiness policy now keeps schema completeness, legacy compatibility,
selected-period occupancy, and pilot authorization as separate states. It cannot
authorize a pilot merely because tables exist.

## Verification

- Strict MPDG validation, specification generation, and full generated-artifact
  regeneration passed for 28 models.
- HP-01 plan, apply, post-apply definition-shape verification, and count invariance
  passed.
- Raven Domain: 98 tests and typecheck passed.
- Raven Surreal: 42 tests and typecheck passed.
- Raven MCP: 14 tests, exact 28-operation parity, and typecheck passed.
- Raven Studio statement UI: 4 tests passed; production build passed with existing
  non-blocking warnings.
- Disposable fictional ST-01 and ST-02 live smokes passed and cleaned up.
- Data Atlas: 9 tests passed and the 28-model stale check passed twice.
- Legacy fictional renderer: 2 tests passed.
- Archive safety, AI-safe preflight, Brain health, formatting, secret scan, and root
  plus nested diff checks are part of final packaging verification.

## Boundary

No private statement was opened, staged, read, parsed, previewed, committed, matched,
reconciled, classified, or attested. No private record body, description, amount,
filename, account identity/number, note, tax material, or record identifier was
inspected or emitted.

No migration, compatibility repair, source replacement, replay, ST-03, Tax &
Transaction Meaning, Elgiz/buckets, Workline 04/Today, Earn, or bulk backfill ran. No
development server was started. Nothing was committed, merged, or pushed.

## Review Archive

The final AI-safe archive identity, integrity result, and exclusion proof are reported
in the completion handoff after packaging and inspection.
