# Raven Transaction Management Meaning Contract v0.1

## Outcome

Raven keeps the statement-backed `Transaction` as observed financial truth and
adds management meaning through separate, reviewable records. This contract is
deliberately narrower than accounting or tax treatment.

## The four distinct answers

| Question                                       | Raven record         | Example                                                                        |
| ---------------------------------------------- | -------------------- | ------------------------------------------------------------------------------ |
| What did the statement prove?                  | `Transaction`        | Date, amount, direction, original description, source lineage                  |
| Who was the counterparty?                      | `Merchant`           | OpenAI, Elite Host, a school, or a person                                      |
| What recognizable purpose did it serve?        | `TransactionPurpose` | ChatGPT Pro subscription, household contribution, school fees, trading deposit |
| Where does it belong for management reporting? | `Category`           | Business > Software > AI, Family > Education > School fees                     |

These dimensions must not be collapsed. A merchant can supply several purposes;
the same purpose can move between accounts; and two payments to the same person
can have different purposes.

## Purpose definition

`TransactionPurpose` is a reusable Financial-Space-scoped definition. It has a
stable key and display name, optional default merchant and category, aliases for
matching, a broad management-only kind, and an occurrence pattern.

The occurrence pattern describes historical recognition only. It is not a
future obligation, recurrence schedule, invoice, or proof that a payment is due.

## Per-transaction assignment

`TransactionPurposeAssignment` connects one Transaction to one purpose without
editing imported money, dates, descriptions, checksums, statement rows, or
authority claims.

The assignment carries the transaction-specific information:

- proposed, confirmed, rejected, or superseded review state;
- assignment source and confidence;
- an optional occurrence label;
- structured context, such as a hosting account or beneficiary;
- an optional Client link when the transaction is income from, or a cost for,
  a known client;
- lightweight occurrence tags for cross-cutting review and report groupings;
- notes, operation provenance, review time, and supersession lineage.

In the v0.1 operational surface, the optional Client link is stored as
`context.client` and tags are stored as `context.tags`. Both belong to the
reviewed assignment rather than the statement Transaction. Tags are deliberately
freeform occurrence labels, not a replacement for the managed Category
hierarchy. A later contract may promote them into a governed taxonomy when the
repeated vocabulary is stable enough.

Assignments are append-only in semantic product flows. A correction creates a
new revision and supersedes the old revision. At most one assignment may be
current and confirmed for a Transaction in v0.1. This prevents double counting.
Future exact split allocations belong to a separate allocation contract rather
than multiple unweighted purpose assignments.

## Rules and clarification

`ClassificationRule.targetPurpose` may suggest or apply a known purpose through
the reviewed classification path. `ClarificationTask.suggestedPurpose` may hold
a proposed purpose when the match is uncertain. An agent or rule does not turn a
proposal into confirmed meaning without an authorized review operation.

## Reporting semantics

Management reports may group confirmed current assignments by purpose, merchant,
category hierarchy, Client, tag, account, Financial Space, and month. Merchant
and Client profile ledgers must be derived from explicit links and retain a
drill-down to the statement-backed Transaction. Reports must keep these
boundaries visible:

- a transfer to an exchange is trading funding, not automatically a trading
  loss or ordinary expense;
- a payment to a spouse or former spouse identifies the counterparty, while the
  purpose may be household support, rent, school fees, reimbursement, or unknown;
- bank fees should use specific purposes where known, such as finance charge or
  account service fee, beneath a banking-fee category hierarchy;
- unknown or proposed assignments remain visibly unresolved and are not counted
  as confirmed purpose totals.

## First operational workflow

1. Find candidates using statement description, merchant, reference, amount,
   date pattern, and account.
2. Create or reuse one `TransactionPurpose`.
3. Propose matches in bulk, preserving the candidate evidence and confidence.
4. Review exceptions and confirm only justified assignments.
5. Generate totals from confirmed current assignments and retain drill-down
   transaction references for every figure.

This supports immediate management and lawyer-facing analysis without making an
accounting, tax, legal, or professional-review claim.

## Tax lens bridge

Tax-facing wording and categories are deliberately not stored in this
management assignment. The bounded
[`raven-tax-lens-baseline-contract-v0.1.md`](./raven-tax-lens-baseline-contract-v0.1.md)
defines a separate hierarchical tax vocabulary and sparse, revisioned
per-transaction declaration. Tax mode inherits normal meaning field by field
until an explicit declaration exists; it never changes statement truth or
monetary totals.
