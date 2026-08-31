---
status: review
owner: Raven
last_reviewed: 2026-08-10
supersedes: []
superseded_by: []
privacy: aggregate-only
---

# Raven Historian HP-03 Legacy Overlap Contract

## Verdict

HP-03 completed the authorized private, write-free comparison for one source in the
already approved Account/period set. Readiness passed, Michael approved source
staging, the original source and separate extraction assistance were staged, and the
canonical preview and revalidation completed deterministically.

The extraction had complete coverage, exact source order, and a zero balance
difference. Its only blocking preview issue was the expected
`STATEMENT_LEGACY_PERIOD_CONFLICT`. No source-integrity issue unrelated to the known
overlap was found.

The private crosswalk covers every canonical movement component, informational
component, and relevant legacy source-backed Transaction. The current selected-period
strategy is **D: unresolved**. A canonical source commit remains blocked because
transfer review and one conflicting legacy movement do not yet have sufficient active
authority proof.

HP-03 performed zero financial database writes. It did not commit a source, create or
change a Transaction, create a match or claim, materialize a component, reconcile,
attest, supersede, migrate, classify, or process another source.

## Aggregate Outcome

One aggregate disposition can cover an exact canonical-component/legacy-Transaction
pair. Informational components and unpaired legacy Transactions have their own
dispositions. This convention covers every relevant item exactly once without
publishing private crosswalk detail.

| Compatibility class                            | Count |
| ---------------------------------------------- | ----: |
| `exact_existing_transaction_adoption`          |    40 |
| `exact_grouped_component_adoption`             |     0 |
| `canonical_component_requires_materialization` |     0 |
| `legacy_transaction_historical_only`           |     0 |
| `transfer_review_required`                     |     3 |
| `informational_non_movement`                   |    23 |
| `ambiguous_or_conflicting`                     |     1 |

The private proof is owner-only, ignored by Git, permissioned to the owner, and
excluded from AI-safe archives. Its source identities, Account/period facts, values,
record references, row evidence, and exact unresolved items are intentionally absent
from this document.

## Strategy Comparison

| Strategy | Description                                                                                   | HP-03 result                                                                                            |
| -------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| A        | Canonical replacement plus audited adoption of exact legacy Transactions                      | Closest eventual fit, but not currently safe while transfer and conflict dispositions remain unresolved |
| B        | Canonical replacement plus materialization while unmatched legacy movements remain historical | Not selected; no canonical movement currently requires materialization                                  |
| C        | Controlled mix of exact adoption and materialization                                          | Not selected; materialization is unnecessary and would not resolve the remaining authority questions    |
| D        | Keep the selected period unresolved and block canonical commit                                | **Recommended current strategy**                                                                        |
| E        | Abandon the period and select another clean period                                            | Not yet required; use only if the bounded compatibility bridge cannot resolve Strategy D safely         |

Strategy D is a successful fail-closed result. It preserves the selected period for a
deliberate resolution rather than creating duplicate or incomplete active authority.

## Invariants

1. One exact canonical movement component may project to at most one active economic
   movement, and one Transaction may be actively claimed by at most one statement
   resolution.
2. Original source bytes, extraction assistance, canonical extraction, legacy source
   evidence, rows, Transactions, and accepted management meaning remain distinct and
   immutable.
3. Category, Merchant, notes, management state, and tax state may be preserved but
   never prove bank-source identity or make an inexact crosswalk exact.
4. Informational breakdown components never create ledger movement or participate in
   movement totals.
5. Transfer candidates remain review-only until exact counterpart evidence and an
   explicit operator decision exist. Equal magnitude and nearby dates are insufficient
   authority.
6. Legacy-only or conflicting source-backed Transactions remain inspectable historical
   evidence and stay outside the active ledger projection unless a canonical confirmed
   match and active claim later establish authority.
7. Source and period authority, canonical rows/components, compatibility records,
   adopted matches, claims, and reconciliation revision must change atomically or not
   at all.
8. Every preview and apply attempt binds the Account-context fingerprint, source and
   extraction identities, legacy evidence fingerprint, exact crosswalk hash, expected
   revisions, and target database identity.
9. Replay returns the original result for the same request hash. Drift, stale evidence,
   a conflicting replay, or concurrent authority acquisition fails closed with a stable
   Raven error.
10. The bridge is selected-source-only. It cannot become a generic override, bulk
    migration, tolerance matcher, or source-force flag.

## Smallest Safe Bridge

The existing Statement Truth records are necessary but not sufficient on their own.
`StatementImport.replacementOf` can preserve source lineage;
`StatementTransactionMatch`, component and Transaction claims, reconciliation, and
`FinancialOperation` can establish active canonical authority. They do not record the
complete legacy/canonical disposition set, its evidence hash, or the historical-only
outcome for legacy items that must not be adopted.

The smallest reviewable delta is an append-only compatibility aggregate and item set:

### `StatementLegacyResolution`

One immutable record for a locked selected-source plan or a later explicit reversal.
It records canonical and legacy evidence fingerprints, the exact crosswalk hash,
Account-context fingerprint, strategy, expected revisions, operation identity,
predecessor/reversal reference, and timestamps. It stores no source body, path,
description, Category, Merchant, tax meaning, or management meaning.

### `StatementLegacyResolutionItem`

One immutable record per aggregate disposition. It references only the exact canonical
component when one exists, the legacy row/Transaction when one exists, the approved
compatibility class, the active-ledger outcome, and an evidence hash. It does not copy
or rewrite monetary or meaning fields.

Rollback creates a new guarded resolution that reverses the active compatibility
projection. It does not delete or mutate the original resolution, source, rows,
Transactions, matches, claims, or operation receipts.

## Semantic Operations

### `preview_legacy_statement_resolution`

A dedicated no-write semantic query is required. It must:

- reopen and validate the staged source and canonical preview identity;
- read one explicit legacy import and its exact row/Transaction chain;
- compute the seven compatibility classes deterministically;
- detect opposite tracked-Account candidates without inferring transfers;
- verify existing active source, period, component, and Transaction claims;
- produce an exact private result plus an aggregate-safe projection;
- return a deterministic crosswalk hash and expected-revision set;
- perform no repository commit and create no `FinancialOperation`.

### `apply_legacy_statement_resolution`

A dedicated guarded command is required. It must accept only the exact preview hash,
crosswalk hash, expected revision/claim set, approved strategy, and explicit operator
dispositions. It must reject any unresolved transfer or conflict item.

Inside one database transaction it may:

1. revalidate the source, Account context, legacy import, row/Transaction evidence,
   crosswalk, claims, and expected revisions;
2. commit the canonical replacement source and immutable canonical rows/components;
3. create the compatibility aggregate and item records;
4. create audited canonical matches and active component/Transaction claims for exact
   approved legacy Transaction adoptions;
5. preserve unmatched legacy evidence as historical-only through the derived active
   authority projection;
6. calculate the first exact reconciliation revision;
7. create one idempotent `FinancialOperation` receipt with result references.

It may not rewrite legacy amount, date, source, Account, currency, Category, Merchant,
notes, management meaning, or tax meaning. It may not materialize a Transaction unless
the reviewed plan contains an exact unmatched canonical movement and the normal ST-02
materialization invariants pass. The current HP-03 plan contains no such item.

## Active Authority

An adopted legacy Transaction becomes canonically statement-backed through a confirmed
`StatementTransactionMatch` to the new canonical component set and active component
and Transaction resolution claims. Its original observation date, amount, source-row
provenance, Category, Merchant, and notes are not rewritten. A canonical effective
date may be projected from the confirmed statement evidence under the accepted ST-02
contract.

A legacy Transaction without an active canonical claim remains historical source
evidence. Current Raven ledger reads already derive imported source-backed Transactions
without active Statement Truth authority as historical rather than active. The new
resolution item makes that selected-source disposition explicit and auditable without
deleting the Transaction.

## Concurrency, Replay, And Recovery

- Preview is pure and binds all evidence through deterministic hashes.
- Apply uses one idempotency key and request hash. Exact replay returns the prior
  operation; changed intent conflicts.
- Source/period claims and component/Transaction claims remain the uniqueness locks.
- Expected Account context, import revision, claim absence/presence, reconciliation
  revision, and crosswalk hash are checked inside the write transaction.
- Any failed assertion rolls back source commit, compatibility records, matches,
  claims, reconciliation, and operation creation together.
- A private recovery point remains retained through first-pilot acceptance.
- Reversal is a separate explicit semantic command or a mode of the guarded command
  that appends inverse authority records; it is never a delete or hidden update.

## Parity Plan

| Surface             | Required treatment                                                                                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Raven Domain        | Pure deterministic crosswalk planner, strategy validator, command draft, stable errors, and aggregate-safe output type                                              |
| Raven Surreal       | Read-only preview repository plus one transactional apply/reversal implementation with claims, idempotency, concurrency checks, and reconciliation                  |
| tRPC                | Strict schemas and handlers for the exact preview and guarded command; no generic force or override input                                                           |
| Semantic Raven MCP  | Exact semantic parity with tRPC, path-redacted private result handling, aggregate-safe summaries, and write classification                                          |
| Raven Studio        | Existing visual language preserved; one review surface for evidence classes, transfer/conflict decisions, dry-run identity, and a separately confirmed apply action |
| Generic Surreal MCP | Diagnostic and read-only; never an apply surface                                                                                                                    |

The current product design must not be restyled as part of this bridge. Studio work is
limited to exposing the compatibility workflow and command state.

## Approval Decisions

External/owner review must approve or revise no more than these six decisions before
HP-04 implementation begins:

1. Add append-only `StatementLegacyResolution` and
   `StatementLegacyResolutionItem` records as the compatibility audit boundary.
2. Add `preview_legacy_statement_resolution` as the only supported deterministic
   no-write crosswalk query.
3. Add `apply_legacy_statement_resolution` as the only selected-source apply surface,
   with no generic force/override option.
4. Activate adopted legacy Transactions only through canonical confirmed matches and
   active claims; keep all unclaimed legacy Transactions historical-only.
5. Block apply while any transfer-review or ambiguous/conflicting disposition remains
   unresolved, even when all other rows are exact.
6. Split HP-04 into fictional implementation verification and a separately approved
   selected-source private apply phase; implementation success alone grants no private
   write authority.

## Current Gate

The exact implementation/apply prompt is
`docs/prompts/raven-historian-hp-04-selected-period-resolution-implementation.md`.
HP-04 is not authorized by this document alone. The first canonical source commit
remains blocked until this contract is accepted, the bridge is implemented and
externally reviewed, the private preview is reproduced without unresolved classes,
and Michael separately approves the exact apply intent.
