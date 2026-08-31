# Distillation - RAVEN-INGEST-0003 - Account Control Foundation

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0003-account-control-foundation/`
- Ingest record: `brain/sprints/0003-account-control-foundation/INGEST_RECORD-RAVEN-INGEST-0003.md`
- Source and ingest date: 2026-07-11
- Mode: external-validation / pre-work-primer

## Executive Distillation

The package narrows Raven's accepted present-control direction into a proposed first complete product slice named the Account Control Foundation. Its daily loop is: capture what is real, see the present position, anticipate what is due, and know the immediate earning requirement.

The slice combines observed accounts and transactions with accepted future cashflows in one operating view while keeping their records and certainty distinct. It proposes four initial Raven Studio routes (`/`, `/accounts`, account detail, and `/upcoming`) and one semantic operation layer shared by UI and Raven MCP.

## Identity And Vision Signals

- Raven should become useful through a complete daily control loop, not an isolated accounts directory or a premature buckets engine.
- The first useful answer is operational: what exists, what is due, what is uncertain, and what must be earned.
- Present control is the dependable foundation for later Earn, debt, budgets, tax, invoicing, opportunities, Elgiz buckets, and projections.
- The UI is one Raven client; semantic agent operation is equally important.

## Existing Accepted Direction Reinforced

- Raven Studio is the primary clean rebuild, with Raven V1 as a behavioral/query reference.
- Raven is headless-first and requires UI/MCP command parity through shared application services.
- Present control precedes expanded buckets.
- Raven Studio begins quiet, dense, document-like, and data-first.
- Observed facts, accepted plans, inferred suggestions, and possibilities must not be silently mixed.

## Accepted Process Decision

- Full orchestrator outputs trigger a Brainkeeper sidecar when available. The sidecar preserves raw source and distills durable signals while the main workline proceeds separately. Without a sidecar, the source enters `CAPTURE_QUEUE.md` and must be checkpointed before handoff.

## Proposed Product Contract

- Name the first complete slice Account Control Foundation.
- Use four initial routes: Today, Accounts, Account detail, and Upcoming.
- Support balance confirmation, expense, income, transfer, scheduled cashflow, settlement, current-position, month-progress, freshness, and coverage operations through shared services.
- Model explicit balance observations with amount, kind, currency, effective time, recorded time, provenance, and freshness.
- Prefer a neutral cashflow schedule plus concrete occurrence model, subject to architecture review.
- Keep recurring-pattern evidence review-only until explicitly promoted.
- Keep opportunities outside confirmed cash and coverage.
- Make every calculation input, freshness state, and uncertainty inspectable.

## Decisions Requiring Explicit Approval

1. Exact money representation across persistence, TypeScript, and wire contracts.
2. Transaction direction, transfer linkage, correction, provenance, and idempotency semantics.
3. Balance kinds, asset/liability nature, freshness thresholds, and stale/unknown behavior.
4. Neutral schedule-plus-occurrence versus separate obligation/receivable models, including incoming certainty rules.

## Open Loops

- Complete the bounded Account Control contract review before implementation.
- Resolve exact-money, balance-freshness, transaction/transfer, and upcoming-cashflow semantics.
- Confirm the smallest semantic UI/MCP operation catalog.
- Identify reusable Raven Studio queries and Raven V1 behavior without copying page orchestration.
- Define non-private fixtures and acceptance tests for one complete vertical slice.

## Risks

- Mixing observed, accepted, inferred, and possible money would make coverage and earning figures misleading.
- Treating historical transaction balances as current would create false confidence.
- Incorrect transfer semantics could double-count income and outflow.
- Duplicating rules across UI, tRPC, and MCP would cause financial answers to diverge.
- Building broad UI or schema before approving the narrow contract would recreate the fragmentation Raven Studio was intended to escape.

## Opportunities

- Deliver immediate daily value through one compact Today-to-ledger-to-upcoming loop.
- Reuse the established read side while adding only missing balance and upcoming-cashflow foundations.
- Make explainable coverage and required earning rates the bridge from financial truth to action.
- Follow Account Control with a bounded Earn lane for clients, retainers, confirmed income, and opportunities.

## Repeated Themes

- Complete loop over disconnected CRUD pages.
- Certainty boundaries over convenient aggregation.
- Shared semantic services over client-specific logic.
- Inspectable calculations over confident-looking totals.
- Present truth and control before future simulation.

## Orbit Sync Candidates

- Shape the next workline as the final bounded Account Control contract review.
- Carry the four explicit approval decisions into Orbit clarification/review.
- Sequence implementation as one vertical slice with UI/MCP parity after approval.
- Preserve Earn and Elgiz as later lanes rather than expanding the current workline.

## Routine Items Intentionally Ignored

- No product, schema, UI, package, or runtime changes were made.
- Download links and archive-copy observations are source context, not durable product state.
- Example financial amounts and example labels were not treated as user account records.
