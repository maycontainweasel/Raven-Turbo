# Distillation - RAVEN-LIVE-0001 Normal/Tax Lens Baseline

## Durable decision

Michael directly authorized a working Normal/Tax transaction-meaning baseline.
Normal management meaning is the default. Tax mode uses a separate tax vocabulary
and only replaces the fields explicitly declared for a transaction; every other
field inherits the effective Normal value.

## Implemented expression

- `TaxCategory` is a separate hierarchical, Financial-Space-scoped vocabulary.
- `TransactionTaxDeclaration` is a sparse, append-only, revisioned source-authority
  record attached to an observed Transaction.
- Effective tax description and category resolve independently as declared value or
  Normal fallback.
- Returning to inheritance supersedes the current declaration instead of copying
  Normal values.
- Activity exposes Normal/Tax modes and the transaction drawer edits only the active
  tax declaration.
- Meaning manages ordinary and tax category hierarchies separately.
- Statement truth and monetary totals never change with the lens.

## Boundary preserved

The working lens is not full Tax Treatment. It does not determine deductibility,
VAT, entity/taxpayer, exact allocation, period, professional review, workpapers, or
filing. The broader Tax Lane 00 contract remains open for those semantics and for
shared domain/read-model/MCP promotion.

## Verification signal

Graph validation, focused schema/UI tests, Data Atlas regeneration/check/tests,
production build, and live browser inspection passed. Verification created no tax
or financial records.

## Traceability

- Raw session: `../sessions/RAVEN-LIVE-0001-normal-tax-lens-baseline.md`
- Decision: `DEC-0027`
- Remaining open loop: `OL-0027`
- Architecture: `../../docs/architecture/raven-tax-lens-baseline-contract-v0.1.md`
- Orbit Workline: `financial-mastery:transaction-classification:0003:normal-and-tax-treatment-modes`
