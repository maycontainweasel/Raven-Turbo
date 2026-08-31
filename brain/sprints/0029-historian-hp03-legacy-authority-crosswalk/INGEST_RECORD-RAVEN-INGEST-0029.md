# Ingest Record - RAVEN-INGEST-0029

## Metadata

- Project: Raven
- Source date: 2026-08-10
- Ingest date: 2026-08-10
- Mode: pre-work-primer
- Status: ingested

## Source Packet

- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0029-hp03-governing-contract/SOURCE_MANIFEST.md`
- Raw source file: one byte-identical file in the same packet directory
- Distillation: `brain/distillations/RAVEN-INGEST-0029-hp03-governing-contract.md`
- Brain Patch: `brain/sprints/0029-historian-hp03-legacy-authority-crosswalk/BRAIN_PATCH-RAVEN-INGEST-0029.md`

## Relationship To RAVEN-INGEST-0028

- `RAVEN-INGEST-0028` already owns the HP-02 external acceptance source, `DEC-0021`, and aggregate HP-03 next-gate context.
- This ingest does not duplicate that source or reopen HP-02.
- This ingest adds only the exact governing HP-03 execution contract.

## Authoritative Outcome

- `DEC-0021` remains accepted and unchanged.
- The exact HP-03 phase sequence, approval gate, deterministic crosswalk rules, strategy constraints, required deliverables, hard stops, verification, and handoff are now preserved verbatim.
- This Brainkeeper ingest does not execute HP-03 or change any main-agent Phase A state.
- Source staging, no-write preview, compatibility implementation/apply, and canonical source commit remain distinct authorities.

## Handling

- Changed only `brain/**`.
- Preserved the completed `RAVEN-INGEST-0028` record and existing main-agent aggregate checkpoints.
- Did not inspect private data, query or mutate a database, invoke MCP, inspect or start services, open or stage a statement, inspect owner-only artifacts, generate an archive, or access Orbit.
- Did not overwrite unrelated Brain memory or working-tree changes.
