---
name: orbit-workline
description: Use when the user says "orbit-workline", "start workline", "connect workline", "resume workline", or "workline" and wants this Orbit-connected agent session to create or resume an Orbit Studio Workline before continuing.
---

# Orbit Workline Shortcut

## Goal

Turn a short user phrase into the Workline startup ritual.

Canonical phrase:

```txt
orbit-workline
```

Accepted aliases:

- `start workline`
- `connect workline`
- `resume workline`
- `workline`

This is an agent skill invocation phrase, not a shell command.

## Behavior

When the user invokes this shortcut:

1. Confirm the repo is Orbit-connected by reading local `AGENTS.md`, `.orbit/ORBIT.md`, `.orbit/tenant.json`, and `.orbit/workspace.json` when present.
2. Determine the Workboard project label.
3. Determine workstream, sprint number, and slice from the user text if supplied.
4. If workstream, sprint number, or slice are unclear, create a safe waiting placeholder.
5. Call `orbit.studio.workboard.upsert`.
6. Report the Workline id/ref back to the user.
7. Wait for the next implementation prompt unless the user already gave clear current work.
8. Continue using `workboard-operator` for status updates and state changes.

## Project Label Resolution

For the Workline `project` field, prefer:

1. user-supplied `Project`
2. `.orbit/tenant.json` `workboardLabel`
3. `.orbit/tenant.json` `shortLabel`
4. `.orbit/tenant.json` `displayName`
5. `.orbit/tenant.json` `projectLabel`
6. `.orbit/tenant.json` `tenantName`
7. `.orbit/workspace.json` `workboardLabel`
8. `.orbit/workspace.json` `title`
9. repo directory name
10. `Unassigned`

For the Orbit root repo, default to `ORBIT`.

## Defaults

If the user only says `orbit-workline`, use:

```txt
Workstream: Unscoped
Sprint No: 0000
Slice: Awaiting direction
State: waiting
Status Line: Waiting for the next implementation prompt.
```

If the user supplies clear current work or says the line is cooking, use `state: cooking` and a concise present-tense status line.

If the user supplies project/workstream/sprint/slice but no status line, use:

```txt
Waiting for the next implementation prompt.
```

## Examples

### Placeholder

User:

```txt
orbit-workline
```

Creates or resumes:

```txt
Project: <from local metadata>
Workstream: Unscoped
Sprint No: 0000
Slice: Awaiting direction
State: waiting
Status Line: Waiting for the next implementation prompt.
```

### Explicit Workline

User:

```txt
orbit-workline Project: LUCKY Workstream: Coupon Framework Sprint No: 0002 Slice: Dynamic Coupons
```

Creates or resumes:

```txt
Project: LUCKY
Workstream: Coupon Framework
Sprint No: 0002
Slice: Dynamic Coupons
State: waiting
Status Line: Waiting for the next implementation prompt.
```

### Cooking Line

User:

```txt
start workline cooking on Media Management Framework / 0000 To be determined
```

Creates or resumes a `cooking` Workline with a concise status line such as:

```txt
Working on Media Management Framework / 0000 To be determined.
```

## Output Shape

After upsert, report:

```txt
Workline created/resumed.
id/ref: <id>
Project: <project>
Workstream: <workstream>
Sprint No: <sprintNo>
Slice: <slice>
State: <state>
Status: <statusLine>
```

Then wait for the next prompt unless the user already supplied the implementation prompt.

## Rules

- Keep the status line to one concise sentence.
- Do not use the Workboard as a transcript.
- Do not create duplicate Worklines for the same project/workstream/sprint/slice.
- Use `waiting` for ordinary handoff or next-prompt pauses.
- Use `blocked` only for real blockers.
- Do not redefine Worklines as formal Runs, Pans, or Sprints.
