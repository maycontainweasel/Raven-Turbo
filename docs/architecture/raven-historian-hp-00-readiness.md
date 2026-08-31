---
status: complete
owner: Raven
last_reviewed: 2026-08-09
supersedes: []
superseded_by:
  - raven-historian-hp-01-schema-deployment
---

# Raven Historian HP-00 Readiness

## Verdict

ST-02 is done. The semantic Raven MCP and private statement vault are operationally
ready, but the controlled private pilot is not yet authorized because the configured
Raven database does not contain the complete accepted Statement Truth schema. HP-00
remains in review and no private statement was opened, read, staged, or ingested.

## Readiness Results

| Surface                  | Result                                                                                                      |
| ------------------------ | ----------------------------------------------------------------------------------------------------------- |
| Semantic Raven MCP       | Ready: configured, reachable, and exact 28-operation catalog match                                          |
| Semantic raw SurrealQL   | Not exposed                                                                                                 |
| Generic Surreal MCP      | Diagnostic and read-only by default; raw writes disabled                                                    |
| Private vault/inbox      | Ready: two owner-only roots, current-user owned, non-symlink, contained, path-redacted, 15 MiB source limit |
| Git tracking             | Private root ignored and untracked                                                                          |
| AI-safe archive          | Private root excluded by fail-closed policy                                                                 |
| Raven Studio             | Degraded: user-managed endpoint returns HTTP 502                                                            |
| Configured database      | Blocked: accepted Statement Truth schema is incomplete                                                      |
| Controlled private pilot | Not yet authorized                                                                                          |

The bounded Studio recovery action is for Michael to restart the user-managed process
with `pnpm -C apps/raven-studio run dev`. HP-00 did not start a development server.

## Aggregate-Only Compatibility Audit

The configured Raven database was queried read-only. The audit selected only record
identity, source-state, period, and evidence-link fields needed to compute classes. It
returned no descriptions, amounts, filenames, account names/numbers, source text,
notes, record identifiers, or local paths and performed zero writes.

| Compatibility class                              | Count |
| ------------------------------------------------ | ----: |
| Canonical imports                                |     0 |
| Active canonical imports                         |     0 |
| Superseded canonical imports                     |     0 |
| Active legacy imports                            |    38 |
| Legacy identities across scoped import models    |   438 |
| Mappable legacy periods                          |     0 |
| Unmappable legacy imports                        |    38 |
| Periods already occupied by mappable imports     |     0 |
| Canonical-only periods                           |     0 |
| Legacy-only periods                              |     0 |
| Mixed canonical/legacy periods                   |     0 |
| Canonical imports without reconciliation         |     0 |
| Source-backed Transactions without ST-02 matches | 1,419 |

The zero occupied-period count does not mean the database is clean. All 38 legacy
imports lack the canonical period identity needed to classify occupancy, so a real
period must not be replayed until compatibility is resolved deliberately.

## Missing Accepted Tables

- `StatementSourceClaim`
- `StatementPeriodClaim`
- `StatementRowComponent`
- `StatementIssue`
- `StatementTransactionMatch`
- `StatementComponentResolutionClaim`
- `StatementTransactionResolutionClaim`
- `StatementReconciliation`
- `StatementReconciliationEvent`

HP-00 did not apply schema, migrate records, replay imports, replace sources, create a
reconciliation, or write private financial data. The next bounded gate is to deploy
the already-accepted canonical schema to the configured database under an explicitly
authorized schema-deployment pass, then rerun `pnpm historian:readiness`.

## Operator Assets

- `docs/operations/raven-statement-truth-operations-v0.1.json`
- `docs/runbooks/raven-historian-private-pilot-v0.1.md`
- `docs/prompts/raven-historian-private-pilot-agent.md`

After the database gate passes, the first instruction remains:

> Start the controlled Raven Historian pilot in inventory-and-selection mode only.
> Help me select one recent, complete, closed ZAR period and every interacting tracked
> account using the HP-00 checklist. Do not open or stage a statement until I explicitly
> approve the account/period set.

ST-03, Tax & Transaction Meaning, buckets/Elgiz, Workline 04, Earn, and bulk backfill
remain unstarted.

## Successor Result

HP-01 subsequently deployed the accepted schema additively and proved that all nine
canonical tables and generated admin views are empty while every pre-existing aggregate
count remains unchanged. See `raven-historian-hp-01-schema-deployment.md`.

The private pilot remains unauthorized because selected-period compatibility has not
been established. HP-02 is the next gate.
