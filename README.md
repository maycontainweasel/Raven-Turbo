# Raven

Raven is a private, local-first financial operating system for financial truth, present-day control, and future planning. The codebase is managed through the Orbit project **Financial Mastery**.

## Product Surfaces

- `apps/raven-studio` - primary clean UX rebuild.
- `apps/raven` - original behavioral and query reference implementation.
- `apps/schema` - schema authoring and generated runtime authority; this is a nested repository.
- `brain` - portable project identity, decisions, open loops, and handoff memory.
- `docs` - canonical, working, reference, and private project documentation.

Raven Studio and the planned Raven domain MCP will share one semantic application/domain layer. Generic SurrealDB MCP access is for diagnostics and controlled maintenance rather than ordinary product operation.

## Local Services

The root service manifests define:

- SurrealDB on port `2993`.
- Raven Studio on port `9275`.
- Raven Typesense on port `8110`.
- Raven V1 on port `9274` is retained as a legacy reference app but is not started by the primary stack.

Start the complete primary development stack from the repo root:

```bash
pnpm install
pnpm run dev
```

This starts SurrealDB, Raven Typesense, and Raven Studio in one supervised foreground process. Raven is available at `https://raven:4443`; press `Ctrl+C` once to stop the stack cleanly. Nginx remains available as a user-level Homebrew service.

Inspect the service plan or runtime health when needed:

```bash
pnpm services:plan
pnpm services:doctor
```

Raven Studio can be run separately:

```bash
pnpm -C apps/raven-studio dev
```

Its local nginx URL is `https://raven:4443`.

## Database And MCP

Use the existing root commands rather than copying credentials into commands or documentation:

```bash
pnpm db:doctor
pnpm db:start
pnpm mcp:db:static
pnpm mcp:db
```

`surreal.md`, `sr.toml`, `dev.toml`, and `surreal-mcp.toml` define the local service contract. Environment and credential values remain local and must not enter documentation, Brain, logs, or AI-share archives.

## Privacy Boundary

Raven contains private financial source material. Do not expose, summarize, commit, or package statements, mediation exports, mailbox exports, dossiers, account records, environment files, or credentials unless the user explicitly authorizes that exact handling.

Use the fail-closed AI-safe archive command for external review packages:

```bash
pnpm zip:ai-safe -- --list
pnpm zip:ai-safe -- --output /tmp/raven-ai-safe.zip
```

The general developer archive command is explicit and is not safe for external sharing.

## Project Authority

- Orbit / Financial Mastery: planning, sequencing, and execution control.
- Repository code: implementation truth.
- `apps/schema`: generated schema/runtime canon.
- `brain`: portable narrative memory.
- `docs/raven_vision_v1.md`: canonical product charter until deliberately superseded.

See [`docs/README.md`](docs/README.md) for documentation status and authority.
