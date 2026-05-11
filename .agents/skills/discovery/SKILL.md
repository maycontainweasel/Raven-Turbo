---
name: discovery
description: Use when the goal is to understand, clarify, structure, and contextualize this repo in Orbit without forcing execution too early.
---

# Discovery

## Goal
Improve Orbit's understanding of this repo and its linked project by clarifying what the work is, what is missing, and how it should be structured.

## Use when
- The work is rough, ambiguous, or under-structured.
- Orbit needs clearer tasks, groups, relations, context cards, or notebook content.
- The next correct move is clarification rather than execution planning.

## Read order
1. Local repo `AGENTS.md`
2. `.orbit/ORBIT.md` and `.orbit/tenant.json`
3. `.orbit/project.md`, `.orbit/workspace.json`, `.orbit/clarify/latest.md`, `.orbit/sequence/latest.md`
4. Local repo docs and the relevant code surface
5. Orbit Context Cards first, Notebook second, then related metadata

## Preferred Orbit verbs
- `orbit.workspace.project_tree`
- `orbit.context.read_scope`
- `orbit.context.list`
- `orbit.context.get`
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
- `orbit.clarify.read_history`
- `orbit.clarify.apply_proposal`

## Do not
- launch runs
- force sequencing before the work is clear enough
- silently rewrite broad planning structure

## Output shape
1. Summary
2. Clarity gaps
3. Questions
4. Proposed Orbit updates
5. Readiness judgment

