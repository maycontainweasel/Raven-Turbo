# Distillation - RAVEN-INGEST-0016

## Summary

The authoritative Workline 03 closeout prompt has been revised for the post-Atlas repository state. The product defect and required correction remain the same: terminalising a paused schedule must not generate or revive obligations in the paused interval, and Studio must not derive lifecycle intent from a historical terms date. The revised prompt now treats the Generated Data Atlas as accepted, integrated, verified, and complete; adds Atlas stale/test checks to the verification matrix; and requires a fresh AI-safe review archive from current primary main.

This Brainkeeper pass preserves and distills the prompt only. Workline 03 remains in review, `OL-0023` stays open, and completion belongs to the separate main implementation workline.

## Observed Facts

- The existing planner's shared `end` / `cancel` path can materialize dates beyond `pausedOn` when the terminal date is later than `materializedThrough`.
- Due rows materialized before a pause can be hidden while persisted status is `paused` and become visible again after status changes to `ended` or `cancelled`.
- Studio currently shares one `effectiveOn` value between future terms and lifecycle actions and initializes it from historical `termsEffectiveFrom`.
- The post-Atlas prompt differs materially from the `RAVEN-INGEST-0014` source by recognizing Atlas completion, adding Atlas checks, prohibiting Atlas reopening, and requiring an inspected primary-main review archive.
- The companion Atlas acceptance review was not re-ingested because its durable status is already represented by `RAVEN-INGEST-0015`, its main-integration checkpoint, and active Brain files.

## Canonical Paused-Lifecycle Invariant

Pause preserves accepted dates through `pausedOn` and creates no dates after it. Resume begins at `resumedOn` and never backfills the paused gap. Ending or cancelling a paused schedule must not revive obligations in that gap.

## Required Planner And Read-Model Correction

- For `paused -> end` and `paused -> cancel`, never generate due dates after the current pause boundary merely because the terminal date is later.
- Preserve eligible dates on or before `pausedOn` and all immutable or terminal occurrence history.
- Atomically terminalize already-materialized, still-due paused-gap rows without deleting history.
- Preserve truthful terminal-command provenance and distinguish paused-gap cancellation from direct terminal-boundary cancellation where useful.
- Keep `materializedThrough` monotonic while documenting processed horizons that created no gap obligations.
- Preserve current correct behavior for active terminal commands, pause/resume, terminal occurrence immutability, and future-effective terms.
- Apply one lifecycle-eligibility rule to list results, certainty summaries, due counts, and `nextDueOn`; persisted status changes must not alter eligibility inconsistently.

## Effective Lifecycle Truth

The shared domain boundary must deterministically distinguish:

- persisted or configured lifecycle status;
- effective lifecycle status at explicit `asOf` in the schedule's IANA timezone;
- the next pending lifecycle transition and its effective local date, when present.

Studio, tRPC, and MCP must consume the same representation. Financial tests must not use ambient current time or browser timezone.

## Safe Studio Intent

- Future-term `effectiveFrom` and lifecycle `effectiveOn` require separate state.
- Lifecycle actions default from the schedule-timezone local date at query `asOf`, not historical terms authority.
- Pause, resume, end, and cancel require action-specific lower bounds that respect start, terms authority, pause, and resume boundaries.
- One retry-stable idempotency key belongs to one open action/date/note intent. Failed or lost responses reuse it; a changed intent receives a new key.
- The UI must present consequences before submission and refresh shared Upcoming state after success without a full reload.
- The closeout does not authorize a Studio redesign.

## Verification Contract

The main workline must cover fixed-clock paused-to-end and paused-to-cancel scenarios, including schedules pre-materialized beyond the pause boundary; immutable terminal history; active terminal behavior; future-effective lifecycle truth; shared eligibility across reads and summaries; mutation/terminal-action concurrency; retry-stable Studio intent; tRPC/MCP parity; and at least one disposable fictional live-Surreal regression with `finally` cleanup.

The existing Workline 03 matrix remains required. The revised prompt also requires `docs:data-atlas:check`, `test:data-atlas`, nested-schema checks, browser behavior where available through the user-managed process, archive-safety checks, and an inspected AI-safe primary-main review archive.

## Identity Signals

No identity change. The prompt reinforces Raven's requirement that accepted future obligations remain auditable, timezone-explicit, and lifecycle-truthful across domain, storage, UI, and agent surfaces.

## Tenets Reinforced

- Persisted command state and effective financial state are related but not interchangeable.
- One financial eligibility rule must serve every projection of the same obligation set.
- Historical occurrence evidence is terminalized explicitly, never hidden by deletion or revived by a later status transition.
- User intent and idempotency identity must align.
- Completed architecture/documentation lanes remain closed while independent product gates proceed.

## Decisions And Status

- No new product architecture decision is accepted by ingestion.
- Workline 03 remains in review pending implementation, full verification, and external/Michael acceptance.
- The Atlas remains complete and must not be reopened by this workline.
- Workline 04 remains unstarted; Past/Historian and Elgiz remain proposed; Earn remains later.

## Open Loops

- Implement and verify the exact paused-to-terminal invariant and shared lifecycle eligibility.
- Expose configured, effective, and pending lifecycle truth through shared domain, Studio, tRPC, and MCP contracts.
- Correct Studio lifecycle date and retry-intent behavior.
- Close `OL-0023` only after the main workline passes the full matrix and acceptance gate.

## Risks

- A persisted terminal status can expose due rows that were only conditionally hidden under `paused` unless eligibility is shared and status-independent.
- A historical terms date reused as lifecycle intent can cause unintended retroactive commands.
- UI-only filtering would leave domain, adapter, summary, and agent surfaces inconsistent.
- Prematurely marking Workline 03 done would allow Today Coverage to calculate against revived or ineligible obligations.

## Opportunities

- Establish one explainable lifecycle view for human and agent consumers.
- Make future-effective lifecycle commands truthful without sacrificing command provenance.
- Convert the final Workline 03 gate into stable evidence for Workline 04 coverage calculations.

## Repeated Themes

- Effective truth is explicit in time and timezone.
- Financial history is preserved, not rewritten or deleted.
- Shared domain semantics precede presentation fixes.
- Independent worklines keep independent acceptance gates.

## Orbit Sync Candidates

- None from this sidecar. Orbit state must not be changed here.
- The main workline may mark Workline 03 done only after implementation and verification actually pass.

## Routine Details Intentionally Excluded

- No product implementation or test result is attributed to this ingest.
- No private financial source or database state is summarized.
- The repeated Atlas acceptance review was assessed but not duplicated as raw Brain material.

