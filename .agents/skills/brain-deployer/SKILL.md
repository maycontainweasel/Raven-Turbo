---
name: brain-deployer
description: Use to install or update Project Brain in another repo from the reusable templates, choosing core-only or Orbit-connected mode while avoiding overwriting existing project memory.
---

# Brain Deployer

## Before Writing

Inspect the target repo:

- existing `AGENTS.md`
- existing `brain/`
- existing `.orbit/`
- project type and docs
- git status

## Install Modes

- Core: copy `templates/core/` into the target.
- Orbit-connected: copy `templates/core/`, then apply `templates/orbit/` overlay.
- Existing Brain update: add missing protocol files and instructions without overwriting memory.

## Rules

- Do not overwrite existing Brain memory without a migration plan.
- Preserve target repo instructions.
- If a target has `.orbit/`, keep `.orbit/` distinct from `brain/`.
- Copy core Brainkeeper skills into the target when installing Project Brain.
- Configure `brain/brain.config.yaml` for core-only or Orbit-connected mode.
- Add `brain/INGEST.md`, `brain/CAPTURE_QUEUE.md`, and `brain/indexes/INGEST_INDEX.md` when missing.
- Record what was installed, skipped, or needs manual merge.
- Recommend the first Brainkeeper prompt for the target.

## Output

End with:

- mode used
- files created
- files skipped
- conflicts or merge notes
- existing memory preserved
- Orbit alignment
- next Brainkeeper action
