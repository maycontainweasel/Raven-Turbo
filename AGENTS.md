<!-- orbit-bootstrap:start -->
# Orbit Bootstrap

## Orbit working contract

- This repo is locally bound to Orbit project `Financial Mastery` (`financial-mastery`).
- Brain Pack version: `0.1.5`.
- Orbit-first, local-mirror-second.
- Use Orbit MCP first for planning, context, sequencing, and project updates.
- Treat Orbit as the planning/control plane and this repo as the implementation surface.
- Prefer Orbit tasks, groups, contexts, notebooks, clarify, and sequence flows over ad hoc markdown planning in this repo.
- Local repo skills are installed under `.agents/skills/`: `orbit-sync`, `discovery-init`, `discovery`, `sequence-init`, `sequence`, `operator-init`, and `operator`.

## Orbit working hats

- `orbit-sync`: use when Orbit is behind the current codebase and needs to catch up with repo reality.
- `discovery-init`: use at the start of a fresh tenant-repo Discovery session to reread the tenant contract and mirror state.
- `discovery`: use for clarification, structure, and improving Orbit understanding before execution.
- `sequence-init`: use at the start of a fresh tenant-repo Sequence session to reread the tenant contract and mirror state.
- `sequence`: use for execution shaping once the work is clear enough.
- `operator-init`: use at the start of a fresh tenant-repo Operator session to reread the tenant contract and mirror state.
- `operator`: use for active run execution once a selected run is clear enough to work step by step.

## Read first

- `.orbit/ORBIT.md`
- `.orbit/tenant.json`
- `.orbit/README.md`
- `.orbit/project.md`
- `.orbit/workspace.json`
- `.orbit/pipeline.md`
- `.orbit/clarify/latest.md`
- `.orbit/sequence/latest.md`

## Startup routine

1. Read `.orbit/ORBIT.md` and `.orbit/tenant.json` for the current tenant contract.
2. Read `.orbit/project.md`, `.orbit/workspace.json`, `.orbit/clarify/latest.md`, and `.orbit/sequence/latest.md` for current Orbit state.
3. Use `orbit-sync` first when Orbit needs to catch up with what already exists in this repo.
4. Use `discovery-init`, `sequence-init`, or `operator-init` when starting a fresh tenant session before deeper work.
5. Read Context Cards first and Notebook second when understanding a work item.
6. Use Orbit MCP to fetch current project/process context before creating new planning artifacts.

## Prompt shortcuts

- `Tenant Commands`
  - list the reusable Brain Pack commands available in this repo
- `Brain Verify`
  - reread the local tenant contract files and confirm Brain Pack version, Orbit binding, and installed working modes
- `Brain Kickoff`
  - start the non-coding planning copilot for the current repo/project
- `Session Checkpoint`
  - save a light dated checkpoint into Orbit during a long thread
- `Thread Sync`
  - compress the current long chat into durable Orbit memory
- `Project Reinstatement`
  - rebuild a fresh agent session from Orbit state instead of old chat memory
- `Discovery Slice`
  - clarify one lane without jumping into coding
- `Execution Handoff`
  - package one lane for another agent to implement

<!-- orbit-bootstrap:end -->

# Raven Application Context

- Application name: `Raven`.
- Orbit project: `Financial Mastery`.
- Raven is a private financial operating system for personal financial truth, present control, and future planning.
- Keep the distinction clear: Raven is the product/codebase; Financial Mastery is the Orbit planning project around it.
- Treat financial source material as sensitive. Do not expose, summarize, or commit private statements unless the user explicitly asks for that specific handling.
