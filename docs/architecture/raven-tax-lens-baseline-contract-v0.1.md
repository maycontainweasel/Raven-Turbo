# Raven Tax Lens Baseline Contract v0.1

## Outcome

Raven can present the same statement-backed transaction through two meaning
lenses:

- **Normal** is the ordinary personal or management interpretation.
- **Tax** inherits every normal value unless an explicit tax declaration
  overrides that field.

The governing rule is:

> Tax view = declared tax value, otherwise normal value.

Changing the lens changes neither the observed movement nor any monetary total.

## Authority boundary

`Transaction` remains the immutable statement-backed fact: date, amount,
currency, direction, original description, source row, and statement lineage.
Neither a normal assignment nor a tax declaration may rewrite those fields.

Normal meaning continues to use the management records described in the
Transaction Management Meaning Contract. Tax-facing meaning uses two separate
source-authority records:

| Record                      | Responsibility                                                                     |
| --------------------------- | ---------------------------------------------------------------------------------- |
| `TaxCategory`               | Financial-Space-scoped hierarchical vocabulary for tax-facing reporting labels     |
| `TransactionTaxDeclaration` | Append-only, transaction-specific sparse override with revision and review lineage |

A tax declaration does not change the transaction amount, account, date,
currency, source description, statement provenance, normal purpose, normal
category, merchant, or client.

## Sparse inheritance

Each current confirmed declaration may supply:

- an optional `TaxCategory`;
- an optional tax-facing description;
- an evidence-readiness status;
- notes and structured context;
- declaration source, timestamps, operation provenance, and supersession
  lineage.

The effective Tax view is evaluated field by field:

1. Use the declared tax description when present; otherwise use the effective
   normal description.
2. Use the declared tax category when present; otherwise use the effective
   normal category.
3. Show whether each result is declared or inherited.

An explicit “Use normal classification” action supersedes the current tax
declaration and leaves no current override. It does not copy normal values into
tax storage. This keeps inheritance live: a later correction to normal meaning
continues to flow into Tax view until another tax declaration is made.

## Revision and review rules

Tax declarations are append-only in the product workflow. A correction creates
a new revision, marks an earlier current proposal or confirmation as
superseded, and links through `supersedes`.

At most one `user_confirmed` declaration may be current for a Transaction. A
declaration may be `proposed`, `user_confirmed`, `superseded`, or `rejected`.
The initial UI writes only an explicit user-confirmed declaration; future agent
or rule proposals must remain proposals until an authorized review operation
confirms them.

## Evidence readiness

The baseline records only whether supporting evidence has been assessed:
`not_assessed`, `missing`, `partial`, `available`, or `not_required`.
This status is a review aid, not proof that the wording or category is correct.
Evidence files, receipts, contracts, reviewer identity, and workpaper lineage
need a later evidence contract.

## User-interface behavior

The Activity ledger has one Normal/Tax switch.

- Monetary rows, balances, inflow/outflow values, and totals remain identical.
- Normal mode shows normal management meaning.
- Tax mode labels each row as an explicit tax declaration or an inheritance from
  normal.
- The transaction drawer edits the active lens only.
- Tax categories are managed in a separate hierarchy on the Meaning page.
- The original statement description remains available as source truth in both
  modes.

## Explicit exclusions

This baseline does not determine deductibility, private-use or business-use
percentage, VAT treatment, input-tax eligibility, taxpayer or legal entity,
accounting treatment, tax period, exact split allocation, professional review,
workpaper acceptance, return preparation, or a filed position.

A label such as “business meeting” is therefore a working tax-facing
description only. Raven must not infer that it is deductible, and it must not
hide the statement description or the absence of supporting evidence.

## Later contract

A complete Tax Treatment lane still needs an accepted vocabulary and authority
contract for taxpayer/entity, jurisdiction, period, allocation, evidence links,
reviewer identity, deductibility/VAT semantics, workpapers, exports, and stable
MCP operations. The v0.1 tax lens is intentionally the smallest safe baseline
for classifying transactions now without prejudging that later contract.
