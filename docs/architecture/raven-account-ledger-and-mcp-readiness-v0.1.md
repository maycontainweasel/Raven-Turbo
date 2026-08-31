---
status: working
owner: Raven
last_reviewed: 2026-08-26
supersedes: []
superseded_by: []
---

# Raven Account Ledger and MCP Readiness v0.1

## Purpose

This document records the bounded readiness pass for operating Raven account ledgers
one month at a time while management meaning and tax assessment remain separate from
source evidence.

It is not a tax vocabulary, a tax opinion, a schema authorization, or a statement
import contract.

## Locked Invariant

A bank statement is authoritative evidence that money moved through an account. It
does not, by itself, prove why the movement occurred or how it should be treated for
management or tax.

Raven therefore keeps three questions separate:

1. **Evidence:** what source supports the observed movement?
2. **Management meaning:** how should Raven group and understand the movement for
   personal or business control?
3. **Tax meaning:** what evidence-backed tax treatment has been proposed, reviewed,
   and accepted by an authorized person?

Manual current-month observations are provisional. A later statement import must be
able to match them without counting the economic event twice.

## Implemented Read Model

The transaction read model now exposes:

- `evidenceState`: `provisional`, `statement_backed`, or `unresolved`;
- `managementMeaningState`: `unclassified`, `classified`, or
  `needs_clarification`;
- `taxMeaningState`: currently only `not_assessed` in the shared account-ledger
  read model and MCP contract.

These fields are deterministic projections of existing records. They do not add
persisted tax meaning or claim that a period is reconciled.

New manual expenses no longer accept legacy `Category.kind = tax`. Category remains
a management classification mechanism. Existing legacy tax categories are surfaced
as management meaning that needs clarification.

Raven Studio now also has a bounded app/schema tax-lens baseline: a separate
`TaxCategory` hierarchy and sparse, revisioned `TransactionTaxDeclaration` that
inherits normal meaning by default. This does not yet promote tax meaning into the
shared account-ledger read model or MCP contract, and it does not determine
deductibility, VAT, professional review, workpaper acceptance, or filing treatment.
See `raven-tax-lens-baseline-contract-v0.1.md`.

The Raven Studio account ledger preserves its existing design while:

- showing only data returned by Raven's runtime;
- never replacing failed requests with fictional financial values;
- showing unknown month totals as unavailable rather than zero;
- showing evidence, management, and tax states separately;
- keeping the shared account-ledger Tax state explicitly not assessed while the
  Raven Studio tax-lens declaration remains a separate, bounded surface.

## Current Semantic MCP Coverage

| Need                         | Current operation                                    | Current boundary                                                        |
| ---------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------- |
| Discover accounts            | `list_accounts`, `get_account`                       | Available                                                               |
| Inspect balance truth        | `get_current_position`, `get_account_freshness`      | Available                                                               |
| Read an account-month ledger | `list_account_transactions`                          | Available with separate evidence, management, and tax-readiness states  |
| Inspect a movement           | `get_transaction`                                    | Available with provenance and linked transfer context                   |
| Read observed month totals   | `get_month_progress`                                 | Available; transfers and ambiguous legacy transfers are excluded        |
| Read management categories   | `list_categories`                                    | Available; legacy tax categories are not accepted tax treatment         |
| Record current activity      | `record_expense`, `record_income`, `record_transfer` | Available as provisional observations with idempotent semantic commands |
| Confirm balance evidence     | `confirm_account_balance`                            | Available as an immutable as-of confirmation                            |

## MCP Gaps

The following capabilities are not exposed as stable semantic MCP operations.
Agents must not imply that they are available.

| Lane               | Missing semantic operation or contract                           | Why it matters                                                                       |
| ------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| Statement intake   | Preview a statement import without writing                       | Validate account, period, rows, totals, and duplicates before commit                 |
| Statement intake   | Commit and replay an approved import deterministically           | Preserve immutable source identity and safe retry behavior                           |
| Statement review   | List imports, source rows, and exceptions                        | Support a bounded month-review workflow                                              |
| Reconciliation     | Propose and confirm manual-to-statement matches                  | Prevent provisional and statement-backed records from double counting                |
| Reconciliation     | Attest an account period as reconciled                           | Separate row processing from period-level completeness                               |
| Clarification      | List, explain, resolve, and reopen clarification tasks           | Give agents a review queue without silently assigning meaning                        |
| Management meaning | Propose, confirm, reject, and supersede classification           | Preserve human authority and proposal history                                        |
| Allocation         | Create and review exact split allocations                        | Ensure child allocations equal observed transaction minor units                      |
| Evidence           | Link invoices, receipts, contracts, notes, and reviewer evidence | Make later tax and reporting claims inspectable                                      |
| Tax meaning        | Propose, review, accept, reject, and supersede tax treatment     | Requires the Tax and Transaction Meaning vocabulary and authority contract           |
| Reporting          | Produce reconciled period and classification reports             | Reports need explicit coverage, currency, evidence, and review status                |
| Tax workpapers     | Export evidence-backed workpapers                                | Requires accepted tax vocabulary, allocation, entity, period, and reviewer semantics |

Existing statement-import scripts and generated database functions are implementation
building blocks. They are not a shared domain/tRPC/MCP product contract.

## Recommended Sequence

1. Define the account-period reconciliation and statement-intake semantic contract:
   preview, commit/replay, row review, provisional matching, exceptions, and period
   attestation.
2. Expose those accepted operations through the shared domain, tRPC, Raven Studio,
   and MCP surfaces.
3. Define management-meaning proposals, exact splits, confirmation, rejection, and
   supersession.
4. Extend the bounded tax-lens baseline into an accepted Tax Treatment contract by
   resolving evidence, entity, period, allocation, deductibility/VAT, and
   reviewer-authority questions.
5. Add shared domain/read-model and MCP tax operations only after that full contract
   is accepted.
6. Add reports and workpaper exports with explicit coverage and multi-currency
   boundaries.

## Boundaries

- No financial schema changed in this readiness pass.
- No persisted tax field or tax allocation was added.
- No private statement, account record, or financial value was used.
- No bucket implementation or design was changed.
- No existing Penpot-derived account-page layout was redesigned.
- Multi-currency values must remain separate until Raven has an accepted FX contract.
