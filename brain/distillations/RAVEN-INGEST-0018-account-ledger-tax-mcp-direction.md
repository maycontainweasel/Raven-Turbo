# Distillation - RAVEN-INGEST-0018 - Account Ledger, Tax, And MCP Direction

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0018-account-ledger-tax-mcp-direction/`
- Ingest record: `brain/sprints/0018-account-ledger-tax-mcp-direction/INGEST_RECORD-RAVEN-INGEST-0018.md`
- Source date: 2026-07-28
- Ingest date: 2026-07-28
- Mode: external-validation / live-capture / pre-work-primer

## Executive Distillation

Michael has directed Raven's next practical focus toward making existing account pages and transaction workflows operational. The intended workflow starts with one recent month across the relevant accounts, treats bank-statement movements as the immutable backbone, supports provisional day-to-day entries, and later reconciles those entries to imported statement evidence without counting one economic event twice. Historical coverage then expands backward month by month.

The current Penpot-derived visual design is to be preserved. The task is to connect and harden existing account and transaction views, not redesign them. Buckets are explicitly owned by another lane.

The orchestrator strengthens the architecture by making the Account Ledger the Past lane's operational centre and separating permanent observed facts from Management and Tax interpretation lenses. It identifies statement reconciliation as the most important missing semantic loop before high-volume agent-assisted statement processing.

Tax work remains layered meaning, not source truth. Agents may help debate, propose, explain, and quantify classifications, but accepted tax vocabulary, exact allocation persistence, evidence boundaries, professional authority, workpaper states, and filing semantics remain gated by the unapproved Tax & Transaction Meaning contract in `OL-0027`.

## Authority Layers

### Existing Accepted Architecture

- Exact minor-unit money and immutable imported facts.
- Scoped statement/import identities and ensure-or-conflict replay.
- Explicit provenance and unresolved evidence.
- Transfers excluded from income and expenditure.
- Shared semantic domain operations across Studio, tRPC, and MCP.
- Worklines 01-03 and the Generated Data Atlas complete.

### Current Attributable User Direction

- Prioritize account pages, transaction pages, statement loading, fee understanding, categorization, and tax-supporting interpretation.
- Begin with the latest available month across accounts and work backward.
- Record current spending provisionally, then reconcile it when statements arrive.
- Use statements as the baseline proof that money moved.
- Preserve the updated Penpot-derived designs and homepage.
- Identify and close MCP gaps needed for agents to assist reliably.
- Keep buckets outside this pass.

### Orchestrator Recommendations

- One account, currency, and calendar period per Account Ledger workspace.
- A statement proves movement, not purpose or tax treatment.
- Manual and statement evidence remain distinct until explicitly matched.
- Reconciliation proves every statement row, opening balance, closing balance, and economic movement exactly once.
- Management and Tax are lenses over one ledger, not alternate financial facts.
- Management category, context, recurrence, accounting treatment, tax treatment, evidence, and review authority stay separate.
- Exact split allocations reconcile in minor units.
- Evidence, management-meaning, and tax-review states remain independent.
- AI suggestions carry confidence and reasons and remain distinguishable from confirmed, rejected, and superseded meaning.

## Requested Operating Loop

```text
Create and verify accounts
→ confirm available balance evidence
→ record current-month movements provisionally
→ import statement evidence when available
→ preview and match manual entries to statement rows
→ create transactions for unmatched statement rows
→ resolve unmatched manual entries and statement exceptions
→ prove opening balance, closing balance, and complete row coverage
→ classify management meaning
→ propose tax/accounting meaning where authorized
→ report by account, period, category, fee, evidence, and review state
→ repeat backward one month at a time
```

## MCP Gap Analysis

This is a source-based gap map, not a fresh code audit.

### Needed For Statement Truth

- Semantic statement preview before writes.
- Deterministic statement commit/replay.
- Manual-to-statement matching candidates with explainable scores.
- Explicit confirm/reject match commands.
- Duplicate-economic-event protection.
- Account-period reconciliation reads and commands.
- Opening/closing balance proof and unresolved-difference reporting.
- Statement-row and provisional-entry exception queues.

### Needed For Management Meaning

- Transaction review queues by account and period.
- Fee, merchant, category, and recurrence-candidate summaries.
- Explainable classification suggestions based on accepted history.
- Confirm, reject, supersede, and bulk-review commands with provenance.
- Exact split-allocation preview and validation.
- Classification-coverage and unresolved-amount reports.

### Needed For Tax Meaning

- Proposed treatment reads and commands scoped to explicit taxpayer/entity and period.
- Evidence-sufficiency and professional-review queues.
- Treatment summaries and bounded workpaper exports.
- Clear proposal, user-confirmed, professionally reviewed, and accepted-for-workpaper states.

These Tax operations remain blocked until `OL-0027` resolves the Tax & Transaction Meaning contract and vocabulary. They must not be implemented as ad hoc fields on `Transaction`.

## Existing Capability Versus Missing Loop

The orchestrator reports that Raven already has semantic operations for accounts, balance confirmations, manual expenses, income, transfers, account-month ledgers, categories, and provenance. The principal missing end-to-end loop is statement preview, manual/statement matching, reconciliation, exception handling, and period attestation. A future implementation workline must inspect the current operation catalog before declaring exact MCP additions.

## Product And UX Boundaries

- Preserve the current Penpot-derived visual structure.
- Keep date, description, amount, flow, account, and source/reconciliation state visible in every lens.
- Lens changes must never change top-line balance, income, outflow, or net movement.
- Prefer wiring existing controls and drawers to semantic operations.
- Discuss any necessary design change before making it.
- Do not fold buckets or Today Coverage Workline 04 into this lane.

## Unresolved Decisions

1. Whether to approve the Tax & Transaction Meaning contract and its eight grouped decisions in `OL-0027`.
2. The canonical account-period reconciliation identity, lifecycle, attestation, and reopening rules.
3. Manual-to-statement matching thresholds, authority, ambiguity handling, and double-count prevention.
4. Whether `Management` is the accepted user-facing name for the non-tax interpretation lens.
5. Which MCP additions belong to the first bounded account-ledger workline after inspecting the current operation catalog.
6. How statement-backed period closure interacts with later interpretation changes.
7. Exact scope of the first private one-month operational pass and all accounts that must be included for transfer completeness.
8. Whether any tax operation can move beyond proposal without the future authority contract; current safe default is no.

## Risks

- Manual and imported rows could double count one economic event without explicit matching and reconciliation.
- A generic status could incorrectly collapse reconciliation, management classification, and tax authority.
- Tax or accounting desire could mutate observed statement truth.
- Category could become overloaded with context, recurrence, accounting, and tax meaning.
- An incomplete single-account month could misclassify transfers, reimbursements, and card settlements.
- UI rewrites could erase the Penpot-derived operating design before its workflows are connected.
- Low-level database tools could bypass semantic safeguards if MCP gaps are filled ad hoc.
- Private statement material could leak into Brain, fixtures, logs, or archives during future operation.

## Opportunities

- Turn the Account Ledger into a dependable human-and-agent review workspace.
- Establish one exact, non-duplicating reconciliation loop for provisional and statement-backed observations.
- Build explainable management suggestions from accepted historical patterns.
- Produce transparent fee, category, recurrence, reconciliation, and later tax-readiness reports.
- Grow semantic MCP around stable review operations rather than raw database access.
- Validate Raven with one bounded private month before expanding history.

## Orbit Sync Candidates

- Treat Account Ledger operationalization and statement reconciliation as a clarified candidate Past-lane workline after current operation and UI inspection.
- Keep the Tax contract as a separate proposed decision gate.
- Keep buckets under its separate lane and Workline 04 unstarted.
- Sync only safe work status and approved decisions; no statement contents, account records, or private tax findings.
- No Orbit or `.orbit` update occurred in this ingest.

## Routine Items Intentionally Excluded

- No product/schema implementation.
- No UI edits or Penpot redesign.
- No MCP operation creation.
- No private statement inspection or data loading.
- No database or service startup.
- No Workline creation or status change.
- No commit, merge, or push.
