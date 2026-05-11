---
name: orbit-sync
description: Use when Orbit is behind the current repo state and needs to be brought up to date with what this codebase is, what it contains, and what work already exists.
---

# Orbit Sync

## Goal
Bring Orbit up to speed with the current repo reality before deeper Discovery or Sequence work begins.

Orbit remains the planning source of truth.
The local `.orbit/` directory is a synchronized working mirror, not a replacement planning system.

## Use when
- a repo has just been bootstrapped
- Orbit no longer reflects the current codebase shape
- a fresh worker needs to align Orbit with what already exists in the repo

Do not use it as a vague dumping pass.
It should improve Orbit signal, not add noise.

## Workflow
1. Read local `AGENTS.md`, `.orbit/ORBIT.md`, and `.orbit/tenant.json`.
2. Read `.orbit/project.md`, `.orbit/workspace.json`, `.orbit/clarify/latest.md`, and `.orbit/sequence/latest.md`.
3. Inspect the relevant local docs and code surfaces.
4. Compare what the repo seems to contain with what Orbit already knows.
5. Update Orbit using Context Cards, Notebook content, groups, tasks, and relations.
6. Hand the project back to `discovery` or `sequence` once Orbit is no longer materially behind.

## Preferred Orbit verbs
- `orbit.workspace.project_tree`
- `orbit.project.update`
- `orbit.context.create`
- `orbit.context.update`
- `orbit.context.ensure_kind`
- `orbit.notebook.get`
- `orbit.notebook.upsert`
- `orbit.notebook.update`
- `orbit.group.create`
- `orbit.group.bulk_create`
- `orbit.group.update`
- `orbit.task.create`
- `orbit.task.bulk_create`
- `orbit.task.update`
- `orbit.task.relate`
- `orbit.clarify.input`
- `orbit.sequence.input`
- `orbit.platform.feedback_intake` when the tenant discovers an Orbit platform issue rather than project work

Use `orbit.query` or `orbit.db.*` only when the product verb surface does not cover the required action.

## Output shape
1. What the repo appears to be about
2. What Orbit was missing
3. What was updated or proposed in Orbit
4. What still needs clarification
5. Whether the project should move into Discovery or Sequence next

## Do not
- launch runs
- use Orbit as a dumping ground for low-value noise
- silently create large planning structures without showing the shape of the change
- silently patch Orbit semantics from the tenant repo; route platform issues back through `orbit.platform.feedback_intake`
