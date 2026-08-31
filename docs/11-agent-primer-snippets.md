# Agent Primer Snippets

This file stores reusable prompt skeletons for agents working in projects that have Project Brain installed. It is intentionally practical: copy a snippet into a target repo agent, or ask a Project Brain-aware agent to expand one of the shortcut codes below.

These snippets should evolve as Project Brain improves. If a target project reveals a better ingestion or assist pattern, update this file and the deployable template copy.

## Shortcut Codes

Use these in the Project Brain repo, or in any repo that has the Brain docs installed:

```text
Brain Backfill Primer: <project name> - <short context>
```

Returns a prompt for getting a target project's Brain up to speed from historical ChatGPT 5.5 Pro prompts/responses.

```text
Brain Forward Assist Primer: <project name> - <short context>
```

Returns a prompt for continuing normal project work while a Brainkeeper assistant captures durable memory in the background.

## Snippet 1 - Brain Backfill Primer

Use this when the codebase already exists, but the Brain needs to catch up with historical planning conversations.

```text
You are working inside <PROJECT_NAME>.

We are in Brain Backfill Catch-Up mode.

Context:
<SHORT_CONTEXT>

Goal:
Bring this project's Brain up to speed from historical ChatGPT 5.5 Pro planning material. I will paste one prompt/response pair at a time, or at most two or three tightly related pairs. Your job is to preserve the raw source and distill durable project memory without turning old brainstorms into fake decisions.

Read first:
1. AGENTS.md
2. brain/START_HERE.md
3. brain/EXECUTIVE_SUMMARY.md
4. brain/NOW.md
5. brain/HANDOFF.md
6. brain/INGEST.md
7. brain/BACKFILL.md
8. brain/AGENT_PROTOCOL.md
9. brain/ORBIT_SYNC.md if present
10. .orbit/tenant.json if present

Use:
- brainkeeper-backfill for old material that predates the Brain
- brainkeeper-ingest if the repo uses the unified ingest workflow

Rules:
- Do not implement code during this backfill pass.
- Save the human prompt and assistant response verbatim.
- Preserve uncertainty.
- Treat repetition as signal.
- Do not treat brainstorms as accepted decisions unless the source clearly states the decision was accepted.
- Extract identity signals, vision language, tenets, decisions, decisions needing confirmation, open loops, questions, risks, opportunities, repeated themes, and Orbit sync candidates.
- Update active Brain files only where the source changes durable project understanding.
- Keep routine implementation details out of active Brain context unless they change project identity, architecture, planning, or direction.
- Do not store secrets, credentials, private keys, tokens, private financial records, or sensitive personal material in the Brain.

For each prompt/response pair:
1. Create a raw source file under the appropriate brain/source-material folder.
2. Create a backfill or ingest record.
3. Create a distillation.
4. Update indexes.
5. Update identity, tenets, vision, decisions, open loops, questions, risks, opportunities, NOW, and HANDOFF only where warranted.
6. Produce a Brain Patch that lists files created, files updated, durable signals captured, uncertain items, and recommended next backfill source.

When you are ready, ask me for the first prompt/response pair in this format:

Mode: backfill
Source title:
Source date:

Human prompt:
...

Assistant response:
...
```

## Snippet 2 - Brain Forward Assist Primer

Use this when the project is no longer only backfilling. The agent should keep working normally, while Brain memory is updated alongside the work.

```text
You are working inside <PROJECT_NAME>.

We are in Brain Forward Assist mode.

Context:
<SHORT_CONTEXT>

Goal:
Continue normal project work while keeping Project Brain current. I may paste ChatGPT 5.5 Pro prompts/responses, external validation, plans, or implementation guidance. You should understand that material, act on it where appropriate, and keep a Brainkeeper assistant running in the background so durable project memory is captured without blocking the work.

Read first:
1. AGENTS.md
2. brain/START_HERE.md
3. brain/EXECUTIVE_SUMMARY.md
4. brain/NOW.md
5. brain/HANDOFF.md
6. brain/VISION.md
7. brain/IDENTITY.md
8. brain/TENETS.md
9. brain/INGEST.md
10. brain/CAPTURE_QUEUE.md
11. brain/AGENT_PROTOCOL.md
12. brain/ORBIT_SYNC.md if present
13. .orbit/tenant.json if present

Main-agent behavior:
- Keep the project work moving.
- If I paste a ChatGPT 5.5 Pro response and it contains an explicit prompt for this agent, run or adapt that prompt after checking it against the repo and Brain.
- If the response does not contain an explicit prompt, infer the appropriate next action from the response, the Brain, and the current repo state.
- Ask for clarification only when the next action is genuinely ambiguous or risky.
- Do not let Brain maintenance block useful implementation or planning work.

Brainkeeper assistant behavior:
- If this environment supports sub-agents, delegate Brain capture to a Brainkeeper sub-agent.
- If sub-agents are not available, use brain/CAPTURE_QUEUE.md during the work and run Brain Checkpoint at a natural stopping point.
- Use brainkeeper-ingest for pasted ChatGPT 5.5 Pro prompt/response pairs, external reviews, live captures, and pre-work primers.
- Use brainkeeper-live for current-session capture when no separate external source is being ingested.
- Use brainkeeper-backfill only when the source predates the Brain.

Capture:
- identity shifts
- "this is not X, it is Y" project-definition language
- durable vision language
- tenets and strategic tradeoffs
- major accepted decisions
- decisions needing confirmation
- open loops and unresolved questions
- repeated concerns
- future opportunities
- Orbit sync candidates when Orbit is connected

Ignore:
- routine small fixes
- temporary debugging noise
- transient implementation details
- speculative ideas that do not affect future context

End each substantial turn with:
- what project work was done or planned
- what Brain updates were made
- what durable signals were queued instead of written
- what prompt or source should be ingested next, if any
```

## Expansion Rule For Agents

When the user types one of the shortcut codes, do not perform the target-project work inside the Project Brain repo. Instead, return the appropriate prompt with `<PROJECT_NAME>` and `<SHORT_CONTEXT>` filled in from the user's shortcut text.

If the target project does not have Project Brain installed, recommend `Brain Deploy` first.
