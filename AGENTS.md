<!-- orbit-bootstrap:start -->

# Orbit Bootstrap

## Orbit working contract

- This repo is locally bound to Orbit project `Financial Mastery` (`financial-mastery`).
- Brain Pack version: `0.1.9`.
- Orbit-first, local-mirror-second.
- Use Orbit MCP first for planning, context, sequencing, and project updates.
- Treat Orbit as the planning/control plane and this repo as the implementation surface.
- Prefer Orbit tasks, groups, contexts, notebooks, clarify, and sequence flows over ad hoc markdown planning in this repo.
- Local repo skills are installed under `.agents/skills/`: `orbit-sync`, `discovery-init`, `discovery`, `sequence-init`, `sequence`, `operator-init`, `operator`, `workboard-operator`, and `orbit-workline`.

## Orbit working hats

- `orbit-sync`: use when Orbit is behind the current codebase and needs to catch up with repo reality.
- `discovery-init`: use at the start of a fresh tenant-repo Discovery session to reread the tenant contract and mirror state.
- `discovery`: use for clarification, structure, and improving Orbit understanding before execution.
- `sequence-init`: use at the start of a fresh tenant-repo Sequence session to reread the tenant contract and mirror state.
- `sequence`: use for execution shaping once the work is clear enough.
- `operator-init`: use at the start of a fresh tenant-repo Operator session to reread the tenant contract and mirror state.
- `operator`: use for active run execution once a selected run is clear enough to work step by step.
- `workboard-operator`: use at session start to create or resume one Orbit Studio Workline while a Warp/Codex agent works.
- `orbit-workline`: use when the user says `orbit-workline`, `start workline`, or similar to establish a Workline shortcut.

## Workline startup

If this repo is Orbit-connected, the shortest startup command is `orbit-workline`.

Use `orbit-workline` at the start of each fresh Warp/Codex session unless the user explicitly disables Workboard tracking. Then use `workboard-operator` to keep the Workline updated.

- Create or resume a Workline before meaningful implementation.
- Use `.orbit/tenant.json` `workboardLabel` or `shortLabel` as the Workboard project label when present.
- Use a placeholder waiting Workline if the workstream or slice is not clear yet.
- Keep the Workline status to one concise sentence.
- Update the Workline at meaningful phase transitions.
- Move the Workline to `waiting`, `blocked`, `review`, or `done` honestly.
- Do not treat Worklines as Pans or formal Orbit Runs.

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
- `orbit-workline`
  - create or resume a lightweight Orbit Studio Workline for this agent session

<!-- orbit-bootstrap:end -->

# Raven Application Context

- Application name: `Raven`.
- Orbit project: `Financial Mastery`.
- Raven is a private financial operating system for personal financial truth, present control, and future planning.
- Keep the distinction clear: Raven is the product/codebase; Financial Mastery is the Orbit planning project around it.
- Treat financial source material as sensitive. Do not expose, summarize, or commit private statements unless the user explicitly asks for that specific handling.
- Maintenance, hosting, retainers, billing, provider costs, and client timelines are part of Raven's financial operating surface. Follow `docs/raven-maintenance-hosting-control.md` for this workflow.
- Use `.raven-private/maintenance/` for client dossiers, evidence notes, quotes, and hosting inventory workpads. This folder is ignored and may contain private operational material.
- Move facts from private markdown into Raven only after they are stable enough to become structured records. Keep observed facts, assumptions, estimates, and open questions clearly separated.
- Raven MCP/tool functions should be added only for stable, repeated, schema-backed operations that improve agent reliability without bypassing Raven's generated schema/runtime contracts.
- Use `pnpm zip` or `pnpm zip:ai-safe` for any AI or external review archive. `pnpm zip:developer-unsafe` preserves broad developer packaging only and must not be shared externally.
- Keep AI-safe archive policy fail-closed. Changes to exclusions or secret detection require `pnpm test:archive-safety` and a dry-run archive check.

## Mail MCP

Use the `mail` MCP when Gmail source material is needed for Raven financial or operational context.

Rules:

- Prefer read/export/render tools before any mailbox operation plan.
- Use `mail.thread.export_app` when Michael asks to download a thread for local reading; it creates a full folder with `readable/index.html`, raw `.eml`, metadata, and attachments.
- Use `mail.brain.import_thread` with `targetId: "raven-turbo"` when the thread should be staged into Raven's local intake flow.
- Do not send email through this MCP; no direct send tool exists.
- Do not permanently delete email; no permanent delete tool exists.
- Treat exported `.eml` files and attachments as sensitive source material.
- Treat AI summaries, readable HTML/PDF, and intake files as convenience layers only.
- Stage imports first, then summarize into Raven deliberately after reviewing source material.
- Use `mail.plan.apply` only after Michael has reviewed the operation plan and supplied the exact confirmation phrase.

## Local Services And SurrealDB

- `sr.toml` declares Raven local service ports: `surrealdb` on `2993`, `raven` on `9274`, and `typesense` on `8109`.
- `surreal.md` is the canonical `sdb` artifact migrated from `database.md`; `sdb start .` preserves the existing Raven manual database command credentials.
- `dev.toml` is the local runtime manifest for `sm`; use `pnpm services:plan`, `pnpm services:doctor`, and `pnpm services:up` from the repo root.
- `surreal-mcp.toml` exposes the local Raven database as Codex MCP `raven-surreal-local`; use `pnpm mcp:db:static` without a live DB or `pnpm mcp:db` after starting it.

<!-- project-brain-v0.2:start -->

## Project Brain v0.2

This repo uses Project Brain v0.2 for portable project memory. In addition to the existing Orbit bootstrap files, agents should know these modes:

- `brainkeeper-ingest`: use for selected ChatGPT 5.5 Pro prompt/response pairs, external reviews, live captures, backfills, and pre-work primers.
- `Brain Assist Mode`: keep normal work moving while durable identity, vision, tenet, decision, open-loop, opportunity, and Orbit sync signals are captured.
- `Brain Checkpoint`: update the Brain at a natural stop if durable signals were queued during work.
- Full orchestrator outputs always trigger a Brainkeeper sidecar when one is available. The sidecar preserves the raw output and distills durable signals while the main workline proceeds separately. If no sidecar is available, queue the source in `brain/CAPTURE_QUEUE.md` and complete a Brain Checkpoint before handoff.

For memory-sensitive work, read after the Orbit bootstrap and Raven privacy instructions:

1. `brain/START_HERE.md`
2. `brain/EXECUTIVE_SUMMARY.md`
3. `brain/NOW.md`
4. `brain/HANDOFF.md`
5. `brain/VISION.md`
6. `brain/IDENTITY.md`
7. `brain/TENETS.md`
8. `brain/DECISIONS.md`
9. `brain/OPEN_LOOPS.md`
10. `brain/INGEST.md`
11. `brain/AGENT_PROTOCOL.md`
12. `brain/ORBIT_SYNC.md`

## Project Brain Shortcut Codes

- `Brain Backfill Primer: <project name> - <short context>`
  - Return the backfill setup prompt from `docs/11-agent-primer-snippets.md`.
  - Use when this Brain or another target project needs to catch up from historical ChatGPT 5.5 Pro prompt/response pairs.
- `Brain Forward Assist Primer: <project name> - <short context>`
  - Return the forward-work setup prompt from `docs/11-agent-primer-snippets.md`.
  - Use when normal work should continue while Brain Assist Mode captures durable memory in the background.

When expanding either shortcut, return the prompt for the target agent. Do not perform target-project work unless the user explicitly asks for that.

Routine implementation noise should not be logged into active Brain context unless it changes project understanding. Orbit remains planning/control; `brain/` remains portable narrative memory.

Raven-specific boundary: do not ingest, expose, summarize, or commit private financial statements, mailbox exports, dossiers, account records, credentials, or private operational material unless the user explicitly asks for that specific handling.

<!-- project-brain-v0.2:end -->
