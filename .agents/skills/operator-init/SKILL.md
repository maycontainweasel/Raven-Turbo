---
name: operator-init
description: "Use when you want to initialize a fresh tenant-repo operator session: reread the tenant contract, load the execution-side Orbit mirror, and prepare for operator work."
---

# Operator Init

## Goal
Initialize a fresh tenant-repo Operator session against the current Brain Pack and tenant contract.

## Read order
1. Local repo `AGENTS.md`
2. `.orbit/ORBIT.md`
3. `.orbit/tenant.json`
4. `.orbit/project.md`
5. `.orbit/workspace.json`
6. `.orbit/pipeline.md`
7. `.orbit/clarify/latest.md`
8. `.orbit/sequence/latest.md`

## Required initialization output
Before doing operator work, state:
- `brainPackVersion`
- `orbitContractVersion`
- `mcpContractVersion`

If you cannot state those values, stop and reread the files above before proceeding.

## What this init skill should do
1. Confirm the current tenant contract and Brain Pack version.
2. Confirm the execution-side local Orbit mirror is readable.
3. Summarize what Operator is responsible for in this repo.
4. If the user explicitly asks for operator work in the same prompt, continue directly into `operator`.

## Default behavior
If the user only says `Use the operator-init skill`, do not mutate Orbit state yet.
Return an initialization summary and the recommended next Operator action.

## Handoff rule
After initialization, use `operator` for actual run execution and run-state work.

