---
name: brainkeeper-backfill
description: Use when ingesting historical chats, notes, transcripts, screenshots, or previous AI responses into the Project Brain while preserving uncertainty and traceability.
---

# Brainkeeper Backfill

## Workflow

1. Save raw historical source under `brain/source-material/backfill/`.
2. Create a backfill record under `brain/backfill/`.
3. Create a distillation under `brain/distillations/`.
4. Extract repeated themes, unique ideas, accepted decisions, possible decisions needing confirmation, identity signals, tenets, questions, open loops, risks, opportunities, and source references.
5. Mark source date, ingest date, and confidence where possible.
6. Update active Brain files carefully.
7. Produce a Brain Patch.

## Rules

- Do not treat historical brainstorms as accepted decisions unless explicit.
- Preserve uncertainty.
- Deduplicate repeated ideas without losing nuance.
- Do not implement code.
