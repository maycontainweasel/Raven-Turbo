# Distillation - RAVEN-INGEST-0012 - Workline 03 Acceptance Review And Integrity Hardening

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0012-workline-03-integrity-hardening/`
- Ingest record: `brain/sprints/0012-workline-03-integrity-hardening/INGEST_RECORD-RAVEN-INGEST-0012.md`
- Source date: 2026-07-12
- Ingest date: 2026-07-13
- Mode: external-validation / pre-work-primer
- Source kind: linked external AI source review, formal acceptance review, and authoritative integrity-hardening prompt

## Executive Distillation

The external reviewers conclude that Workline 03 is a real, substantial implementation rather than documentation-only work. They accept its canonical schedule/occurrence identities, immutable nominal date and amount anchors, pure recurrence engine, semantic operation catalog, Studio/tRPC/MCP parity, and initial `/upcoming` surface as a base. They do not grant final acceptance. Source inspection identified bounded but financially material gaps at retry, concurrency, lifecycle, effective-date materialization, occurrence-history, reconciliation, certainty-summary, timezone-grouping, and Studio truth boundaries.

The linked hardening prompt defines one closeout run that preserves the accepted architecture and operation names. Its objective is to make Workline 03 safe and truthful under retries, concurrent lifecycle changes, future-effective changes, occurrence races, and transaction reconciliation while completing the minimum promised Studio truth surface. Workline 03 must return for final acceptance afterward. Workline 04 Today Coverage must remain unstarted.

## External Validation Context And Limits

### Observed By The Reviewers

- `CashflowSchedule` and `CashflowOccurrence` exist with the intended composite identities.
- `scheduledDueOn` and `scheduledAmountMinor` remain immutable nominal anchors while effective date and amount can be overridden.
- Once, weekly, monthly, quarterly, and yearly recurrence exists, including month-end and February 29 clamp-and-return behavior.
- The complete 4-query, 6-schedule-command, and 7-occurrence-command catalog exists across Studio/tRPC and MCP.
- Unlinked settlement remains distinct from observed transaction truth.
- The initial true-black `/upcoming` product surface exists and is accepted as an implementation base.

### Uncertainty Preserved

- The reviewers inspected the fresh AI-safe source archive but could not independently rerun pnpm tests, the Nuxt build, or the live Surreal smoke because installed dependencies were excluded.
- Reported prior verification remains repository evidence from the implementation workline; this ingestion pass did not rerun it.
- "Accepted as a base" is not final Workline 03 acceptance and does not authorize Workline 04.
- The hardening prompt permits the smallest schema addition if future-effective state cannot otherwise be represented truthfully. It does not predetermine that a schema change is required.
- This Brainkeeper sidecar preserves Source 3 as implementation intent but does not execute it.

## Accepted Foundation

- Schedule rules and concrete occurrences remain separate source-authority records.
- Occurrence identity remains `S($schedule, $scheduledDueOn)` and schedule identity remains `S($space, $key)`.
- Nominal date and amount remain immutable anchors; effective overrides remain explicit.
- Accepted future cashflow remains separate from observed transaction truth.
- Terminal occurrence history remains immutable in principle.
- Direction and certainty remain explicit, with outgoing accepted cashflow committed and incoming cashflow confirmed, expected, or possible.
- Shared semantic operations remain the authority for Studio, tRPC, and MCP.

## Required Integrity Closeout

### Retry-Stable Command Intent

- Schedule and occurrence drawer actions must use the shared command-intent primitive rather than generating a new key per click.
- Each distinct open action retains one idempotency key across failed requests or lost responses.
- Keys reset only after success, closure/cancellation, entity change, or a genuinely new intent; separate actions never share a key accidentally.

### Concurrent Semantic Replay

- Every schedule and occurrence mutation must apply the Workline 02 first-write rule after duplicate-looking persistence or revision failures.
- Matching operation and request hash replays the original semantic result.
- The same key with a changed hash returns `IDEMPOTENCY_CONFLICT`.
- When no operation exists, Raven preserves the genuine storage or revision error.

### Explicit Schedule Lifecycle

- `active` may update, pause, end, or cancel.
- `paused` may update while remaining paused, resume, end, or cancel.
- `ended` and `cancelled` are terminal and cannot be resurrected.
- Invalid transitions require one stable domain error and coherent effective/lifecycle dates.

### Deterministic Effective-Date Materialization

- One pure planner should derive old-rule materialization, new schedule state, occurrence creates, updates, cancellations, and expected revisions.
- `materializedThrough` is monotonic; same or shorter horizons are no-ops; extension begins strictly after the current boundary.
- Future-effective updates preserve old terms before `effectiveFrom` and reconcile only mutable due rows at or after it.
- Pause preserves accepted dates through its boundary; resume skips the paused gap; end preserves dates on or before its boundary; cancellation preserves past truth and cancels future unsettled rows from its boundary.
- Obsolete due rows are cancelled rather than deleted, newly required nominal dates use deterministic identity, and query/mutation races cannot leave partial or contradictory state.

### Occurrence-History Protection

- Every schedule-produced occurrence patch carries expected occurrence revision and expected mutable status.
- Persistence validates the schedule and all affected occurrences atomically before creating the operation or writing any entity.
- Concurrent settlement, skip, waiver, cancellation, or override causes one stable conflict rather than terminal-history overwrite.

### Canonical And Unique Settlement Evidence

- Final settlement/reconciliation authority belongs inside the same Surreal transaction that links the occurrence.
- Evidence must be a complete coherent canonical transaction, non-ignored, resolved, non-transfer, direction-compatible, exact in amount and currency, in the same Financial Space, and on the exact assigned account when one exists.
- One observed transaction may actively settle only one occurrence in v0.1, enforced atomically under concurrent attempts.
- Linking evidence never mutates observed transaction truth or balance evidence.

### Semantic Summaries And Timing

- Domain output, not `upcoming.vue`, owns checked per-currency summary arithmetic.
- `committedOutflow`, `confirmedInflow`, `expectedInflow`, and `possibleInflow` remain separate with due and unreconciled counts.
- No all-certainty incoming total or net may allow expected/possible income to visually offset committed outflow.
- Domain timing groups derive from explicit query `asOf`, schedule timezone, and effective `dueOn`: overdue, today, next seven days, later this month, later, and history.
- Terminal past rows belong in history, not later, and timezone/local-today explanation remains inspectable.

### Minimal Studio Truth Surface

- Preserve the compact true-black, data-first interface; this is not a redesign.
- Keep direction, certainty, recurrence, status, account, category, and reconciliation visible without opening a drawer.
- Render `Linked`, `Unreconciled`, query quality, and warnings deliberately.
- Provide All, To pay, Incoming, and Schedules navigation or an equivalent compact control.
- Allow schedules without an occurrence in the current horizon to remain manageable.
- Add Upcoming payment and Expected income quick actions while retaining generic creation where useful.
- Replace raw transaction-ID-only reconciliation with a scoped semantic candidate picker, retaining any manual-ID route only as a secondary expert path.
- Back drawers with complete detail queries and expose revisions, recurrence, effective dates, lifecycle, overrides, settlement evidence, and FinancialOperation provenance/history.

### Bounded Contract And Verification Cleanup

- Reject invalid one-off date contracts, unsupported currency changes, and overlong title/note/reason/search inputs.
- Persist lifecycle notes/reasons and document the maximum query/materialization horizon.
- Extend deterministic and disposable fictional live-Surreal evidence for retries, races, effective boundaries, settlement uniqueness, semantic summaries, timezone groups, parity, and Workline 01-02 regression safety.
- Use fictional data only; do not inspect or migrate private records; do not start a development server; do not commit or push.

## Identity Signals

- No Raven product-identity change is introduced.
- The packet reinforces Raven as a system where correctness under retries, races, certainty, and reconciliation is part of financial truth rather than implementation polish.

## Tenets And Repeated Themes

- Command identity belongs to durable user intent, not a click or transport attempt.
- Concurrent replay and atomic conflict handling are financial integrity requirements.
- Effective-date changes extend accepted truth without rewriting nominal identity or terminal history.
- Observed, accepted, confirmed, expected, and possible money remain visibly distinct.
- Financial arithmetic and date semantics belong in the shared domain, not page-local code.
- Reconciliation quality, warnings, provenance, and history must remain inspectable.
- Implementation, source review, runtime verification, final acceptance, and downstream authorization remain separate gates.

## Decisions

- No new Brain decision is created by this packet.
- The accepted `DEC-0013` schedule/occurrence model and `DEC-0014` conservative calculation boundary remain in force.
- The prompt's transition matrix and hardening requirements are bounded acceptance criteria for Workline 03, not a new product architecture decision.

## Open Loops

- Close the retry-stable UI command-intent gap.
- Add concurrent replay to every schedule and occurrence mutation.
- Enforce the explicit schedule transition matrix and coherent effective dates.
- Make materialization monotonic, boundary-safe, and race-safe.
- Atomically protect occurrence revisions/status during schedule changes.
- Enforce canonical same-space/account and one-transaction-to-one-occurrence settlement evidence.
- Move certainty-separated summaries and timezone groups into shared domain output.
- Complete the minimal Studio warnings, reconciliation, schedules, candidate-picker, detail, and history surfaces.
- Run the bounded fictional verification matrix and return Workline 03 for final acceptance.
- Keep Workline 04 unstarted until the acceptance gate closes.

## Risks

- Lost-response retries can duplicate intent when a drawer generates a new key per click.
- Concurrent first writes can return the wrong conflict instead of replaying an applied command.
- Invalid schedule transitions or future-effective changes can resurrect terminal schedules, create gaps, or apply terms too early.
- A schedule mutation can overwrite a concurrent terminal occurrence action unless all revisions and statuses are checked atomically.
- Pre-transaction settlement checks can let one transaction settle multiple occurrences or cross a Financial Space/account boundary.
- Page-owned totals can collapse certainty and imply unsupported coverage.
- Browser-local grouping can disagree with schedule-local financial dates.
- Hidden warnings, provenance, and unreconciled state can make partial truth appear complete.

## Opportunities

- Establish one reusable mutation/materialization planner for deterministic accepted-future truth.
- Reuse Workline 02's concurrent replay and command-intent patterns across all Account Control commands.
- Make Upcoming a trustworthy human and agent surface before Today Coverage consumes it.

## Orbit Sync Candidates

- Keep Orbit Workline `financial-mastery:account-control-foundation:0007:upcoming-cashflow` in review.
- Set its bounded next objective to Workline 03 integrity and UX-truth hardening across the nine closeout areas above.
- Preserve accepted architecture and operation names; do not open a new architecture cycle.
- Do not start Workline 04 Today Coverage.
- No Orbit or `.orbit` state was inspected or changed by this Brainkeeper sidecar.
