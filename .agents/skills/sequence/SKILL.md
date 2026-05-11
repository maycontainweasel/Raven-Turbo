---
name: sequence
description: Use when the goal is to turn clarified Orbit structure for this repo into bounded next slices with explicit readiness, ordering, and dependencies.
---

# Sequence

## Goal
Turn clarified Orbit structure into bounded execution slices that are responsible, inspectable, and ready for real work.

## Use when
- The project already has enough meaning to discuss order and next slices.
- The job is to decide what should happen next, what can run in parallel, and what still needs clarification.

## Read order
1. Local repo `AGENTS.md`
2. `.orbit/ORBIT.md` and `.orbit/tenant.json`
3. `.orbit/project.md`, `.orbit/workspace.json`, `.orbit/clarify/latest.md`, `.orbit/sequence/latest.md`
4. Orbit Context Cards first, Notebook second, then related metadata

## Readiness model
Score these from `0` to `2`:
- Intent
- Outcome
- Scope
- Acceptance
- First Steps / Next Step

Interpretation:
- `0-3` = fuzzy
- `4-5` = needs clarification
- `6-7` = sequence-ready
- `8-10` = pan-ready

## Preferred Orbit verbs
- `orbit.workspace.project_tree`
- `orbit.context.read_scope`
- `orbit.notebook.get`
- `orbit.sequence.input`
- `orbit.sequence.read_history`
- `orbit.sequence.apply_proposal`
- `orbit.task.update`
- `orbit.task.relate`
- `orbit.pipeline.commit_item`
- `orbit.run.project_history`

## Do not
- guess missing acceptance criteria
- pretend vague work is execution-ready
- skip back to broad exploration when the correct move is bounded sequencing

## Output shape
1. Candidate slices
2. Charter for each slice
3. Dependency and parallel guidance
4. Readiness judgment
5. Proposed Orbit actions

