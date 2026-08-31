---
name: workboard-operator
description: Use when an Orbit-connected Warp/Codex agent should establish and maintain one Orbit Studio Workline while it works.
---

# Workboard Operator

## Goal

Every Orbit-connected agent session should establish and maintain one Orbit Studio Workline unless the user explicitly disables it.

The Workboard is a simple live status table. A Workline is one row on that table. Worklines are not formal Orbit Runs, Pans, Sprints, or Kitchen execution objects.

## Terms

- Workboard: the Orbit Studio live work page.
- Workline: one visible row on the Workboard.
- Project: the project/client/system tag, such as `Lucky`.
- Workstream: the umbrella area, such as `Coupon Framework`.
- Sprint No: a lightweight sequence label, such as `0002`.
- Slice: the bounded current piece, such as `Dynamic Coupons`.
- Status Line: one concise sentence describing what is happening now.
- State: `cooking`, `waiting`, `blocked`, `review`, or `done`.

## Startup Ritual

At session start:

1. Determine whether this repo is Orbit-connected by reading `AGENTS.md`, `.orbit/ORBIT.md`, and `.orbit/tenant.json` when present.
2. Identify the project label from the user prompt or local tenant metadata.
3. Identify the current workstream, sprint number, and slice if the user supplied them.
4. If the workline identity is unknown, create a placeholder waiting Workline:
   - Project: the known Workboard project label, or `Unassigned`
   - Workstream: `Unscoped`
   - Sprint No: `0000`
   - Slice: `Awaiting direction`
   - State: `waiting`
   - Status Line: `Waiting for user to define the current workstream and slice.`
5. Call `orbit.studio.workboard.upsert`.
6. Keep the returned row `id`.
7. Do not begin meaningful implementation until the Workline has been created or resumed, unless the user explicitly disables Workboard tracking.

## Shortcut

If the user says `orbit-workline`, `start workline`, `connect workline`, `resume workline`, or `workline`, use the `orbit-workline` shortcut skill first. After the Workline is created or resumed, continue using this `workboard-operator` skill for status updates and state changes.

## Project Label Resolution

For the Workboard `project` field, prefer:

1. user-supplied project label in the prompt
2. `.orbit/tenant.json` `workboardLabel`
3. `.orbit/tenant.json` `shortLabel`
4. `.orbit/tenant.json` `displayName`
5. `.orbit/tenant.json` `projectLabel`
6. `.orbit/tenant.json` `tenantName`
7. `.orbit/workspace.json` `workboardLabel`
8. `.orbit/workspace.json` `title`
9. local repo directory name
10. `Unassigned`

The Workboard label may be shorter than the full Orbit project title. For example, a project titled `Passmed Completion` can use `PASSMED` as the Workboard project label.

## Deterministic Identity

Use this identity key:

```txt
project + workstream + sprintNo + slice
```

Rules:

- Reuse an existing active Workline when the same key is still current.
- Do not create duplicates for the same active work.
- If the user supplies a sprint number, use it.
- If the sprint number is unknown, use `0000`.
- If the slice is unknown, use `Awaiting direction`.
- Create a new Workline only when the workstream, sprint number, or slice materially changes.
- If uncertain, ask the user or use the placeholder waiting Workline.

## Preferred MCP Tools

- `orbit.studio.workboard.list`
- `orbit.studio.workboard.upsert`
- `orbit.studio.workboard.update_status`
- `orbit.studio.workboard.move`
- `orbit.studio.workboard.complete`

## Start Or Resume

Use `orbit.studio.workboard.upsert`:

```json
{
  "project": "Lucky",
  "workstream": "Coupon Framework",
  "sprintNo": "0002",
  "slice": "Dynamic Coupons",
  "state": "cooking",
  "statusLine": "Preparing dynamic coupon validation and admin create flow.",
  "agent": "Codex",
  "target": "Warp"
}
```

## Status Update Cadence

Update the status line:

- when starting
- after understanding the prompt
- when beginning implementation
- when switching to testing or review
- when waiting for input
- when blocked
- when ready for review
- when complete
- during long work, every 10-20 minutes if the current activity materially changed

Do not spam updates. The Workboard is not a transcript.

## Progress Update

Use `orbit.studio.workboard.update_status`:

```json
{
  "id": "lucky:coupon-framework:0002:dynamic-coupons",
  "statusLine": "Testing expiry and stacking behavior in the admin create flow."
}
```

## Waiting

Waiting means the agent can continue if input arrives.

Use `orbit.studio.workboard.move`:

```json
{
  "id": "lucky:coupon-framework:0002:dynamic-coupons",
  "state": "waiting",
  "statusLine": "Waiting for orchestrator response before applying the next coupon slice."
}
```

## Blocked

Blocked means the agent cannot responsibly continue without resolving a concrete blocker.

Use `blocked` only for a real blocker:

```json
{
  "id": "lucky:coupon-framework:0002:dynamic-coupons",
  "state": "blocked",
  "statusLine": "Blocked by missing staging credentials for coupon checkout testing."
}
```

Do not use `blocked` for ordinary handoff waiting.

## Review

Review means the agent believes the slice is inspectable.

Use `review` when the current slice is ready to inspect:

```json
{
  "id": "lucky:coupon-framework:0002:dynamic-coupons",
  "state": "review",
  "statusLine": "Dynamic coupons are ready for browser review."
}
```

## Done

Done means the slice is complete enough to stop tracking as active.

Use `orbit.studio.workboard.complete` only when the slice is complete:

```json
{
  "id": "lucky:coupon-framework:0002:dynamic-coupons",
  "statusLine": "Dynamic coupon slice completed and ready to roll into the next sprint number."
}
```

## Rules

- Keep the status line to one concise sentence.
- Use present-tense current activity where possible.
- Do not use the Workboard as a transcript.
- Do not paste logs, diffs, or long test output into the status line.
- Do not call ordinary handoff waiting `blocked`.
- Do not silently redefine a Workline as a full Orbit Run.
- When in doubt, move to `waiting` and state the next needed input.

## Output Shape

When reporting back to the user, include:

1. Workline id
2. Current state
3. Current status line
4. Next needed action
