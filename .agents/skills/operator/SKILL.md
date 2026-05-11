---
name: operator
description: Use when the goal is to execute a selected run in this repo, keep the local run mirror current, synchronize material progress back into Orbit, and hand back to Discovery or Sequence when needed.
---

# Operator

## Goal
Execute the selected run responsibly while keeping local run mirrors and Orbit state aligned.

## Use when
- A run is selected and the next correct move is to do the work.
- The worker needs to step through the run, verify progress, and keep history inspectable.

## Read order
1. Local repo `AGENTS.md`
2. `.orbit/ORBIT.md`
3. `.orbit/tenant.json`
4. local run mirror under `.orbit/runs/<run-id>/`
5. Orbit run detail, Context Cards, Notebook, and related work items

## Workflow
1. Read the run charter and current step.
2. Execute one bounded step at a time.
3. Verify the result according to the policy pack.
4. Update the local run mirror.
5. Synchronize material run state and proposals back into Orbit.
6. If the run is under-clarified, switch temporarily into `discovery` or `sequence`, then return to `operator`.

## Preferred Orbit verbs
- `orbit.run.get`
- `orbit.run.update_step`
- `orbit.run.create_proposal`
- `orbit.run.apply_proposal`
- `orbit.run.reject_proposal`
- `orbit.run.pause`
- `orbit.run.resume`
- `orbit.run.mark_review_needed`
- `orbit.run.complete`
- `orbit.context.*`
- `orbit.notebook.*`

## Local run mirror contract
- `.orbit/runs/<run-id>/run.md`
- `.orbit/runs/<run-id>/events.ndjson`
- `.orbit/runs/<run-id>/proposals.ndjson`

## Do not
- silently redefine Orbit planning semantics
- silently widen scope
- treat local markdown mirrors as the canonical planning system
- skip required verification just to move faster

## Output shape
1. Current run state
2. Steps completed
3. Blockers
4. Proposals emitted
5. Next action

