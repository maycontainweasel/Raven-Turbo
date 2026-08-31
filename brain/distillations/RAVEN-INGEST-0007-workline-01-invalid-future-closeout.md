# Distillation - RAVEN-INGEST-0007 - Workline 01 Conditional Final Acceptance And Invalid-Future Closeout

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0007-workline-01-invalid-future-closeout/`
- Ingest record: `brain/sprints/0007-workline-01-invalid-future-closeout/INGEST_RECORD-RAVEN-INGEST-0007.md`
- Source and ingest date: 2026-07-11
- Mode: external-validation
- Source kind: external-review / orchestrator-output

## Executive Distillation

The external reviewer accepts the three previously requested Workline 01 hardening corrections: composite Account identity, retry-stable UI command idempotency, and balance-note preservation. It also accepts the previously approved freshness-first balance-selection behavior. The overall workline is not yet finally accepted because one narrow contract mismatch remains: when the only credible account balance evidence is future-dated, selection correctly returns no balance, but account freshness collapses to `unknown`, making the promised `invalid_future` account state unreachable.

The reviewer explicitly distinguishes this from a monetary-calculation defect. Future evidence is already excluded from totals. The remaining issue is diagnostic truth: Raven must distinguish absent balance evidence from present evidence whose timestamp is invalid. The source recommends one bounded correction, fixed-clock verification, immediate Workline 01 closeout after passing verification, and no Workline 02 implementation during this closeout.

## Externally Accepted Hardening

These are source-attributed review conclusions, not tests independently rerun by this Brain-only sidecar:

- Account record identity consistently uses `stringID(space, accountKey)`, while `accountKey` remains unique within a Financial Space.
- Same-space duplicate handling returns the stable `ALREADY_EXISTS` domain error.
- Dialog command intents retain one idempotency key across failed submissions or lost responses and clear it only when the intent genuinely ends or changes.
- Balance notes survive the complete Studio, domain, persistence, normalization, view, and idempotent-replay path.
- Balance selection searches preferred kinds for fresh evidence first, then selects the newest eligible stale evidence with kind preference only as a tie-breaker.
- Informational balances remain excluded from current position.

## Remaining Contract Mismatch

Observed by the external reviewer:

1. `selectBalanceSnapshot()` correctly excludes future-dated snapshots from selection.
2. When future-dated evidence is the only credible evidence, selection returns `null`.
3. `toAccountSummary()` derives freshness only from the selected snapshot.
4. `snapshotFreshness(null, ...)` returns `unknown`.

Consequently, account-level `invalid_future` is unreachable even though the domain contract, Studio labels, and MCP descriptions claim to support it. The required distinction is between no balance evidence and known evidence whose timestamp is invalid. The future amount must continue to be neither selected nor counted.

## Acceptance Status

- Composite identity hardening: externally accepted.
- Retry-idempotency hardening: externally accepted.
- Balance-note hardening: externally accepted.
- Freshness-first selection clarification: externally accepted.
- Overall Workline 01: conditional final acceptance.
- Remaining correction: reachable account-level `invalid_future` diagnostics without monetary inclusion.
- Workline 02: not started and not authorized by this source.

## Decisions

No new product or architecture decision is established. The source validates accepted Workline 01 design and identifies one implementation-level contract-completeness defect.

## Open Loops

- Keep `OL-0019` in review until the bounded `invalid_future` correction and required verification pass.
- After verification, the main agent should close `OL-0019`, update active handoff state, and mark Workline 01 done in Brain and Orbit.
- Do not begin observed transactions and transfers during this closeout.

## Risks

- Collapsing invalid future-dated evidence into `unknown` hides an evidence-quality failure and weakens Raven's diagnostic truth.
- Marking Workline 01 done before fixed-clock regression coverage would leave a claimed contract state unreachable.

## Opportunities

- Once Workline 01 is finally closed, the externally recommended next product workline is Observed Transactions and Transfers.
- This recommendation is sequencing guidance only; it is not authorization to start Workline 02 in the current closeout.

## Repeated Themes

- Invalid evidence must remain distinct from missing evidence.
- Evidence diagnostics and monetary eligibility are separate concerns.
- Conditional external acceptance does not become final acceptance until bounded verification passes.
- Workline boundaries must remain explicit during closeout.

## Orbit Sync Candidates

- Keep Workline 01 conditionally accepted while the `invalid_future` correction is underway.
- Mark Workline 01 done only after the bounded fix and verification pass.
- Leave Workline 02 unstarted.
- No Orbit or `.orbit` state was changed in this Brain-only sidecar.
