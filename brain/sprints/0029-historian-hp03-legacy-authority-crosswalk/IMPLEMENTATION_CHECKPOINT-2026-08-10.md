---
status: review
owner: Raven
date: 2026-08-10
workline: HP-03
privacy: aggregate-only
---

# Historian HP-03 Legacy Authority Crosswalk Checkpoint

## Outcome

- Readiness passed: yes.
- Exact HP-02 selection revalidated: yes.
- Source comparison authorized: yes.
- Separate original and extraction-assistance evidence staged: yes.
- No-write canonical preview completed: yes.
- Preview revalidation completed: yes.
- Source coverage complete and balance difference zero: yes.
- Source-integrity blockers unrelated to known legacy overlap: zero.
- Private exact crosswalk complete: yes.
- Financial database writes: zero.
- Canonical source commit: no.

## Aggregate Crosswalk

| Compatibility class                            | Count |
| ---------------------------------------------- | ----: |
| `exact_existing_transaction_adoption`          |    40 |
| `exact_grouped_component_adoption`             |     0 |
| `canonical_component_requires_materialization` |     0 |
| `legacy_transaction_historical_only`           |     0 |
| `transfer_review_required`                     |     3 |
| `informational_non_movement`                   |    23 |
| `ambiguous_or_conflicting`                     |     1 |

One exact component/legacy-Transaction pair is one aggregate disposition. The private
proof covers every canonical movement component, informational component, and relevant
legacy source-backed Transaction exactly once.

## Strategy

Recommended current strategy: **D - selected period unresolved; canonical source
commit blocked**.

Most movements are exact adoption candidates and no canonical movement currently
requires materialization. Transfer-review and conflicting evidence still prevent a
complete active-authority proof.

## Decisions Requiring Review

1. Append-only compatibility aggregate and item records.
2. Dedicated no-write legacy-resolution preview operation.
3. Dedicated guarded selected-source apply operation with no force flag.
4. Adoption only through canonical confirmed matches and active claims.
5. Apply blocked by every unresolved transfer or conflict.
6. Fictional implementation acceptance separated from private apply approval.

## Verification

- Post-work schema verification passed against the accepted database target.
- Every table/view aggregate count exactly matched its pre-work value.
- `FinancialOperation` remained empty and all canonical source, claim, match, and
  reconciliation tables remained unchanged.
- Raven Domain tests: 98/98 passed.
- Raven Surreal tests: 42/42 passed.
- Raven semantic MCP tests: 14/14 passed.
- Raven Studio Statement UI tests: 4/4 passed.
- Data Atlas tests: 9/9 passed; deterministic stale checks passed twice.
- Domain, Surreal, and MCP typechecks passed.
- Strict canonical schema graph validation passed with no issues.
- Archive-safety tests: 5/5 passed.
- Root and nested schema diff checks and scoped formatting checks passed.
- Brain health passed: required structure, active-state traceability, and obvious-secret
  checks were clean.
- The generated AI-safe review archive passed ZIP integrity, includes every HP-03
  public handoff artifact, and contains zero prohibited private-path entries.

## Deliverables

- Aggregate contract:
  `docs/architecture/raven-historian-hp-03-legacy-overlap-contract.md`.
- Exact HP-04 prompt:
  `docs/prompts/raven-historian-hp-04-selected-period-resolution-implementation.md`.
- Owner-only exact proof: retained outside Git and all external archives.

## Next Gate

Externally/owner review the aggregate HP-03 contract and its owner-only proof. HP-03
remains in Orbit review. HP-04 and the first canonical source commit remain
unauthorized until the six decisions are accepted. No private detail is present in
this checkpoint.
