# Distillation - RAVEN-INGEST-0005 - Account Control Approval Gate Review

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0005-account-control-approval-gate/`
- Ingest record: `brain/sprints/0005-account-control-approval-gate/INGEST_RECORD-RAVEN-INGEST-0005.md`
- Source and ingest date: 2026-07-11
- Mode: external-validation
- Source kind: external-review / orchestrator-output

## Executive Distillation

The external review confirms, from the reviewed AI-safe archive, that the Account Control architecture contract and Workline 01 prompt exist while Account Control product implementation had not started at the time of review. It recommends approving all four gated financial decisions and proceeding to Workline 01 with two clarifications: freshness must outrank stale balance-kind preference, and occurrence-level cashflow commands must be added before Workline 03.

The source also supplies a draft instruction written in Michael's voice that says all four decisions are explicitly approved. Because that text is an orchestrator-authored handoff template rather than an attributable user statement, this ingest does not convert the four proposed decisions into accepted decisions. A direct user approval or evidence that the draft was issued remains the gate.

## Source-Time Status Observations

The following are external-review observations from the source, not independently re-inspected facts in this sidecar:

- Product direction was already accepted.
- The 945-line Account Control contract and exact Workline 01 prompt existed.
- Raven Studio still had a blank root page.
- The proposed shared domain, Surreal adapter, and semantic MCP packages did not exist.
- The proposed Account Control schema models had not been added.
- No Account Control product functionality had been implemented.

These observations describe the archive at review time and must not be used to overwrite concurrent implementation status.

## Recommended Approvals - Not Yet Accepted By This Source

1. `DEC-0011` - exact money and transaction truth:
   - canonical integer minor units;
   - positive magnitudes with separate transaction kind and flow;
   - linked two-leg transfers excluded from income and spending;
   - append-only corrections preserving history.
2. `DEC-0012` - immutable balance snapshots:
   - observed values with as-of time, source, evidence, economic nature, and freshness;
   - unknown is never zero;
   - historical reconstruction and asset/liability semantics remain explicit.
3. `DEC-0013` - schedule plus occurrence:
   - `CashflowSchedule` represents the recurring expectation;
   - `CashflowOccurrence` represents the dated instance and its lifecycle;
   - only confirmed future income affects coverage, while expected and possible income remains visible.
4. `DEC-0014` - conservative explainable calculations:
   - calculate per currency until an explicit FX contract exists;
   - exclude transfers;
   - block coverage when material liquid balances are unknown;
   - label stale calculations provisional;
   - round earning requirements upward and expose inputs and assumptions.

## Proposed Clarifications

### Balance selection

The review proposes that freshness take precedence over blindly applying balance-kind priority:

1. Search the account's preferred eligible balance kinds in order for fresh evidence.
2. Select the first preferred kind with a fresh snapshot.
3. If none are fresh, select the newest eligible stale observation.
4. Use kind priority only as a stale-observation tie-breaker.
5. Exclude invalid-future and informational values wherever the contract excludes them.

The orchestrator characterizes this as binding and non-blocking for Workline 01, but acceptance still requires attributable approval.

### Occurrence-level cashflow commands

Before Workline 03, reconcile the Upcoming UI promises with the semantic command catalog by adding audited operations to skip, waive, cancel, override one occurrence's amount, and override one occurrence's due date. The review recommends treating this as a deferred contract correction that does not block Workline 01.

## Execution Constraints And Handoff Context

The embedded draft instruction proposes the following boundaries for the separate implementation lane:

- Do not repeat `RAVEN-INGEST-0003` or `RAVEN-INGEST-0004`.
- Do not run another broad architecture review.
- Continue from explicit approval into Workline 01 implementation.
- Workline 01 should deliver exact money, Account Balance Truth, shared domain operations, Surreal persistence, tRPC/MCP parity, a minimal Raven Studio shell, command palette, `/accounts`, create-account and confirm-balance flows, tests, builds/typechecks, and migration evidence.
- Do not implement Workline 02 transaction entry.
- Do not start the development server.
- Preserve unrelated and nested-repository worktree changes.
- Use fictional fixtures only.
- End at the Workline 01 review boundary and leave its Orbit Workline in review.

These are recommended execution instructions carried by the source. This Brainkeeper sidecar neither authorizes nor executes them and does not inspect whether a separate lane has begun.

## Risks

- A stale higher-priority balance kind could hide fresher credible evidence if kind priority is applied before freshness.
- The Upcoming UI could promise occurrence mutations that the semantic command layer cannot audit or perform.
- Treating an orchestrator-authored approval template as user approval would collapse recommendation into decision and could incorrectly release an implementation gate.
- Source-time repository observations could overwrite concurrent implementation truth if promoted without revalidation.

## Decisions

- No decision status changed.
- `DEC-0011` through `DEC-0014` now have strong external-validation recommendations and proposed amendments, but remain proposed pending attributable approval.

## Open Loops

- Obtain or identify attributable explicit approval for `DEC-0011` through `DEC-0014` and both clarifications.
- Reconcile occurrence-level operations before Workline 03.
- Preserve the freshness-first balance-selection clarification in the contract when approval is confirmed.

## Opportunities

- None new. The review strengthens the already-recorded Account Control and shared semantic operation opportunities.

## Orbit Sync Candidates

- After attributable approval, record `DEC-0011` through `DEC-0014` and the balance-selection clarification in Orbit.
- Carry the occurrence-level command correction as a dependency before Workline 03.
- No Orbit write was performed by this isolated sidecar.

## Routine Items Intentionally Ignored

- The three supporting files were not needed and were not opened or ingested.
- No Account Control code, schema, UI, docs deliverable, prompt, Orbit state, or `.orbit` mirror was inspected or modified.
- No concurrent implementation status was inferred from the source-time review.
