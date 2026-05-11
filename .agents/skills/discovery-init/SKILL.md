---
name: discovery-init
description: "Use when you want to initialize a fresh tenant-repo discovery session: reread the tenant contract, load the current Orbit mirror, and prepare for discovery work."
---

# Discovery Init

## Goal
Initialize a fresh tenant-repo Discovery session against the current Brain Pack and tenant contract.

## Read order
1. Local repo `AGENTS.md`
2. `.orbit/ORBIT.md`
3. `.orbit/tenant.json`
4. `.orbit/project.md`
5. `.orbit/workspace.json`
6. `.orbit/clarify/latest.md`
7. `.orbit/sequence/latest.md`

## Required initialization output
Before doing discovery work, state:
- `brainPackVersion`
- `orbitContractVersion`
- `mcpContractVersion`

If you cannot state those values, stop and reread the files above before proceeding.

## What this init skill should do
1. Confirm the current tenant contract and Brain Pack version.
2. Confirm the local Orbit mirror is readable.
3. Summarize what Discovery is responsible for in this repo.
4. If the user explicitly asks for discovery work in the same prompt, continue directly into `discovery`.

## Default behavior
If the user only says `Use the discovery-init skill`, do not mutate Orbit state yet.
Return an initialization summary and the recommended next Discovery action.

## Handoff rule
After initialization, use `discovery` for actual clarify, structure, and context work.

