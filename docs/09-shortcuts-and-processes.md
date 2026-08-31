# Shortcuts And Processes

## Brain Ingest Pair

Use when pasting one external prompt/response pair.

```text
Mode: backfill | external-validation | live-capture | pre-work-primer
Source title:
Source date:

Human prompt:
...

Assistant response:
...
```

## Brain Backfill Primer

Use when you want an agent to return the reusable setup prompt for backfilling a target project from historical ChatGPT 5.5 Pro prompt/response pairs.

```text
Brain Backfill Primer: <project name> - <short context>
```

Canonical snippet:

- `docs/11-agent-primer-snippets.md`

## Brain Forward Assist Primer

Use when you want an agent to return the reusable setup prompt for continuing normal work while a Brainkeeper assistant captures durable project memory in the background.

```text
Brain Forward Assist Primer: <project name> - <short context>
```

Canonical snippet:

- `docs/11-agent-primer-snippets.md`

## Brain Assist Mode

Use during normal project work. Capture durable project signals without interrupting execution.

Capture identity shifts, tenets, major decisions, repeated concerns, opportunities, and unresolved questions. Ignore routine implementation noise.

## Brain Checkpoint

Use at the end of a session.

```text
Brain Checkpoint

Review this session for durable project signals. Update the Brain only where the conversation changed identity, vision, decisions, open loops, tenets, opportunities, current state, or Orbit sync candidates.
```

## Brain Deploy

Use from the Project Brain source repo to install or update a Brain in another project.

## Brain Health

Use to validate required files, traceability, active context, and secret-safety.
