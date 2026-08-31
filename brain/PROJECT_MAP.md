# Project Map

## Product Applications

- `apps/raven` - original/reference UI with proven financial interactions and the buckets prototype.
- `apps/raven-studio` - primary clean rebuild UI.
- `apps/schema` - schema authoring and generated runtime authority.
- `apps/schema-docs` - schema documentation surface.

## Product Memory And Planning

- Orbit / Financial Mastery - planning, sequencing, execution, and work context.
- `brain/` - portable narrative memory.
- `docs/raven_vision_v1.md` - canonical product charter until deliberately superseded.
- `docs/raven_build_plan_v1.md` - reference plan superseded in sequence by the July reinstatement.
- `docs/architecture/raven-data-atlas.md` - canonical generated projection of MPDG model identity and connectivity, with reviewed runtime-edge and interpretation registries.
- `docs/ux/` - historical/reference UX material unless promoted explicitly.

## Runtime And Agent Surfaces

- SurrealDB - source financial database.
- schema-kit generated runtime - model contracts and CRUD orchestration.
- custom tRPC routers - current app-specific query surfaces.
- generic Surreal MCP - development and diagnostic database access.
- Raven domain MCP - implemented and externally accepted semantic Account Control and Statement Truth interface; HP-03 is accepted after its write-free crosswalk, and HP-04 may add the fictional 31-operation compatibility surface while all private re-preview/apply and source-commit authority remains separately gated.
- Orbit MCP - planning and work-execution integration.

## Sensitive And Private Surfaces

- `docs/statements/**` and statement-derived intermediates.
- `mediation-financial-export*/**`.
- mailbox exports and attachments.
- `.raven-private/**` dossiers and workpads.
- `history.txt` and history dumps.
- environment, credential, certificate, backup, and local-data files.
- generated source or configuration containing embedded credentials.

These are excluded from Brain and AI-safe share archives.
