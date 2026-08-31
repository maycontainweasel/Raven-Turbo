# Ingest Record - RAVEN-INGEST-0027

## Metadata

- Project: Raven
- Source date: 2026-08-09
- Ingest date: 2026-08-09
- Mode: external-validation / pre-work-primer
- Status: ingested

## Source Packet

- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization/SOURCE_MANIFEST.md`
- Raw source files: two byte-identical files in the same packet directory
- Distillation: `brain/distillations/RAVEN-INGEST-0027-hp01-acceptance-and-hp02-authorization.md`
- Brain Patch: `brain/sprints/0027-historian-hp01-schema-deployment/BRAIN_PATCH.md`

## Source Roles

1. External acceptance evidence for HP-01, including attributed AI-safe archive identity/integrity, dependency-free check results, bounded operator review, and explicit private-verification limits.
2. Exact governing authorization and execution prompt for a later HP-02 private-selection and compatibility operator session.

## Authoritative Outcome

- HP-01 is externally accepted and done.
- HP-02 is authorized as the next controlled local-private gate but was not executed by this ingest.
- HP-02 workline authorization does not authorize source staging, no-write preview, source commit, or any financial mutation.
- The first private source remains unopened and unstaged.
- Private compatibility, first preview, first commit, pilot acceptance, and bulk backfill remain separate gated states.

## HP-02 Governing Boundaries

- Use only the configured Raven database and semantic Raven MCP after bounded readiness passes; do not create parallel services or environments.
- Select one recent complete closed ZAR period and the complete interacting-Account set privately.
- Obtain explicit approval of the set before compatibility inspection.
- Classify the exact set into one prescribed compatibility class; only `clean_for_first_preview` can proceed.
- Obtain a second explicit approval before staging one source and running write-free preview/validation.
- Stop before commit, matching, materialization, reconciliation, attestation, migration, classification, tax work, later lanes, or backfill.
- Keep all private selection and source facts out of Brain, Orbit, Git, logs, screenshots, fixtures, and external artifacts.

## Handling

- Changed only `brain/**`.
- Did not execute HP-02, inspect private data, query or mutate a database, invoke semantic MCP, inspect or start services, open or stage a statement, inspect the HP-01 recovery artifact, generate an archive, or modify Orbit.
- Did not overwrite unrelated working-tree changes.
