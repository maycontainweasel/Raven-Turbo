---
status: review
owner: Raven
date: 2026-08-13
workline: RA-00B final canonical-history authority closeout
privacy: aggregate-only
source: RAVEN-INGEST-0033
---

# RA-00B Implementation Checkpoint

## Outcome

RA-00B is implemented and verified in the current main worktree. The correction is internal to financial analytics authority projection; it changes no public operation name or output contract, adds no schema model, and leaves `/analysis` unchanged.

## Reverse History Derivation

The existing Account-scoped and period-bounded analytics `SELECT` now includes one correlated subquery over `StatementTransactionMatch` where `transaction = $parent.id`. It projects only whether at least one immutable match exists with state `confirmed` or `superseded` and source state `committed` or `superseded`. The lookup is capped at one record and returns the typed boolean `hasCanonicalStatementMatchHistory`.

No description, amount, Category, Merchant, or free text participates in authority classification. The repository remains one SELECT-only read and creates no `FinancialOperation`.

## Final Authority Table

| Stored evidence                                                                      | Analytics authority               | Financial date                                             |
| ------------------------------------------------------------------------------------ | --------------------------------- | ---------------------------------------------------------- |
| Valid current confirmed match on committed source                                    | `active`                          | statement effective date, falling back to observation date |
| Imported source-row Transaction, no active authority, canonical match history exists | `canonical_historical_superseded` | observation date; excluded under every scope               |
| Imported source-row Transaction, no active authority, no canonical match history     | `legacy_unreconciled`             | observation date; separate optional legacy bucket only     |
| Manual/generated Transaction whose former match was cleared                          | `active` provisional              | restored observation date                                  |

## Fictional Regressions

- Source-created canonical Transaction with `statementMatch = NONE`, `effectiveAt = NONE`, and reverse superseded history.
- Legacy Transaction adopted canonically and later superseded with the same cleared-pointer shape.
- Genuine renderer-era legacy Transaction with no canonical match history.
- Proposed or rejected match pointers do not invent canonical history.
- Manual Transaction whose superseded match is cleared and returns to provisional observation authority.
- Ordinary totals remain equal under default and legacy-inclusive authority scopes.
- Legacy-inclusive totals and exact references contain only the renderer-era legacy row.
- The repository remains one SELECT-only, Account-bounded, period-bounded query and performs zero queries for empty Account scope.
- Domain/tRPC/MCP/Studio parity and the seven-operation catalog remain unchanged.

## Verification

- Focused RA-00 matrix: 21/21.
- Raven Domain full suite: 132/132; TypeScript passed.
- Raven Surreal full suite: 47/47; TypeScript passed.
- Raven MCP full suite: 16/16; TypeScript and seven-operation parity passed.
- Studio analytics UI: 1/1; production build passed.
- Data Atlas: 9/9; stale check passed twice at 30 models.
- Formatting and root/nested diff checks: passed.
- Schema graph SHA-256 remained `2122f3b20963cd74a2d1888261d422f8a97417fe7a396ed4763e1bb9d668a264`.

## Boundaries

Shared-file safety was clear before editing current main: no HP-04A worktree or active HP-04A shared-file activity existed. HP-04A private gates were untouched. No private source or configured private database was accessed; no financial record, financial schema, or `FinancialOperation` was created or changed.
