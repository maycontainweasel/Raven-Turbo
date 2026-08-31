---
status: review
owner: Raven
last_reviewed: 2026-08-11
contract: raven-statement-truth-contract-v0.1
workline: HP-04
privacy: aggregate-only
supersedes: []
superseded_by: []
---

# Raven Historian HP-04 Selected-Period Resolution Implementation

## Status

HP-04 Phases A-H are implemented with fictional fixtures and a disposable in-memory
SurrealDB only. The implementation remains in review. It does not authorize or
execute the separately gated private re-preview or private apply phases.

No owner-only crosswalk, private statement source, configured private Raven database,
private vault entry, or private financial record was accessed by this implementation
pass. No private canonical source was committed and no active private ledger authority
changed.

## Canonical Models

`StatementLegacyResolution` records one immutable semantic apply or reversal. Its
identity and authority fields include:

- exact Financial Space, Account, legacy source, and canonical source references;
- apply or reversal type and Strategy A, B, or C;
- previous legacy-source, source-claim, and period-claim states;
- target and predecessor resolution lineage;
- credential-free database, source, preview, legacy evidence, Account context,
  crosswalk, revision-claim, request, and result-authority hashes;
- aggregate compatibility counts, idempotency, actor/channel, operation, and time.

`StatementLegacyResolutionItem` records the immutable exact-set disposition of each
canonical component and relevant legacy Transaction. It stores one of the seven
accepted compatibility classes, the active-ledger outcome, canonical component and
legacy Transaction references, optional reviewed transfer authority, evidence and
claim hashes, and operation lineage.

These models intentionally have no generated CRUD or generic router surface. Their
write path is the semantic Raven Domain and persistence contract only.

## Semantic Operations

The Statement Truth catalog now contains 31 operations. The three HP-04 operations
have equivalent Studio tRPC and semantic MCP contracts:

1. `preview_legacy_statement_resolution` derives the exact private projection and an
   aggregate projection without a write.
2. `apply_legacy_statement_resolution` rederives and revalidates every authority hash,
   requires the exact server-derived reviewed item set, and applies one atomic
   semantic transaction.
3. `reverse_legacy_statement_resolution` targets one exact resolution, rejects stale
   or dependent authority, and appends a guarded reversal without deleting history.

There is no generic Surreal write route for this bridge and no force, tolerance,
skip, or override option.

## Exact Resolution Rules

- Adoption requires exact Account, currency, signed movement, financial date, and
  source-row provenance.
- Grouped adoption is limited to same-row, same-date components with an exact signed
  sum.
- A plausible cross-Account movement remains blocked until an exact reviewed
  `AccountTransfer` exists. HP-04 never creates transfer authority automatically.
- Category, Merchant, notes, management meaning, and tax meaning do not rewrite or
  influence statement-source identity.
- Source, extraction, legacy-row, Transaction, claim, reconciliation, or dependent
  authority drift invalidates the reviewed operation.
- Every movement receives exactly one active disposition: adopted existing,
  explicitly materialized, confirmed transfer, or blocked before apply.

## Atomic Apply And Reversal

Apply creates the canonical source graph, immutable compatibility aggregate/items,
exact confirmed matches and active claims, reconciliation authority, and one
`FinancialOperation` inside one SurrealDB transaction. Any validation or concurrent
authority failure rolls the transaction back. Exact retries replay the persisted
operation; changed reuse of an idempotency key conflicts.

Reversal is append-only and dependency-aware. It releases only the exact claims
created by the target resolution, supersedes canonical source authority without
deleting evidence, restores the recorded predecessor states, reopens reconciliation,
and preserves existing legacy Transactions. A Transaction explicitly materialized by
the target becomes historical/ignored rather than being deleted.

## Studio Boundary

The existing statement-import review surface now supports legacy-overlap preview,
exact aggregate/item review, explicit per-item confirmation, separate apply
confirmation, stable command intent, result inspection, and a separately confirmed
reversal. Transfer-review and conflicting classes block apply. The Penpot-derived
visual language was preserved; this was operational wiring rather than a redesign.

## Verification

- Raven Domain: 113/113 tests passed.
- Raven Surreal: 44/44 tests passed.
- Raven semantic MCP: 14/14 tests passed, including 31-operation parity.
- Raven Studio statement UI: 4/4 tests passed.
- Root focused package typechecks: 3/3 passed.
- Strict canonical schema graph validation passed.
- Generated Data Atlas: 30 models; 9/9 tests and two stale checks passed.
- Raven Studio production build passed.
- Disposable live SurrealDB smoke passed for exact adoption, explicit
  materialization, atomic conflict rollback, replay, guarded reversal, claim release,
  one-active-movement authority, and history preservation.
- The broad root build remains blocked by pre-existing Schema application TypeScript
  errors outside the HP-04 generated-schema and Raven package surfaces.

## Review Gate

HP-04 remains in Orbit review pending external implementation acceptance. Phase I
private re-preview and Phase J private apply remain unstarted and require their own
explicit approvals. Strategy D and the first private canonical-source commit block
remain authoritative.
