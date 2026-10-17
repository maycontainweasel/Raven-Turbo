# Raven relocation and Astra operation — 17 October2026

Raven's complete project container moved from
`/Users/michaelpeters/Dev/mpd/projects/raven` to `~/projects/raven`.
The main checkout is `~/projects/raven/raven-turbo`; existing worktrees remain in
`~/projects/raven/raven-worktrees/{financial-read-analytics-00,generated-data-atlas}`.
A compatibility symlink at the old container path points to the new location;
there is only one physical copy. Retire that alias only after dependent tools
and existing editor sessions have moved to the canonical path.

## Verified preservation

The same-volume rename matched all74,538 inventoried entries before any path
repair; no private file contents were read for that metadata inventory. Main and
both linked Raven worktrees passed git worktree repair with the original HEAD,
status and staged/unstaged diff hashes unchanged before operational edits. Other
financial feature/source changes remain separate and are not claimed as this work.
The database remains at its original external persistent path, and Typesense keeps
named volume raven-dev_typesense_data. No reset, import, schema migration or financial
record inspection was performed. Sensitive raw inventories/config backups/logs stay
outside Git in Astra's private relocation area.

## Standard Astra

Open **Environments → Raven → Raven → Development** and use Start/Stop.
The **Raven · Local stack** service runs the existing supervised scripts/dev-stack.mjs,
which owns current apps/raven-studio plus its SurrealDB and Typesense dependencies.
Use the Launch to control them together; do not start a second pnpm dev stack while
Astra owns this one. The legacy apps/raven reference UI is retained and not launched.
Startup at login was not enabled by this intake.

| Resource | Existing endpoint |
| --- | --- |
| Current Raven | https://raven:4443 |
| Studio upstream | http://127.0.0.1:9275 |
| Database health | http://127.0.0.1:2993/health |
| Search health | http://127.0.0.1:8110/health |
| Legacy UI (off) | port9274 |

The existing trusted Nginx route already selected Studio9275 and was preserved.
Astra Start reported healthy/active/no issues. Healthy-stack Stop removed all3
owned listeners while preserving storage, then Start restored HTTP200 for Studio,
trusted Raven HTTPS (title Today · Raven), database and search. This uses supported
native operations and reader checks; no agent-driven native GUI click is claimed.

The first relocated start failed because a pnpm executable shim retained its old
absolute NODE_PATH. `pnpm install --offline --frozen-lockfile --ignore-scripts`
regenerated local links/shims without lockfile or dependency-version changes.
Existing dev-stack redaction/process-group tests pass (2). Actual lifecycle checks
supply the integration proof. Existing operation setup is checkpointed alongside
this relocation; unrelated financial changes remain uncommitted and preserved.

## Planning and allocation boundaries

Product/codebase Raven remains bound to the existing One project **Financial
Mastery**, not a newly duplicated One project. Orbit kit was officially planned/
installed at the new root, preserving project/environment/content identities.
Previous generated deployment files were preserved privately before reinstall;
no generated binding was edited by hand. MCP context reads from the new root pass.
The old installation record may remain as historical inventory; new binding is
canonical. Main checkout identity is path-derived by the kit.

Astra environment is native-59b99419a7df97475ef0. Intake uses the existing-workspace
registration/service/application operations; it does not scaffold over this repo.
SR owner raven-turbo now points to the canonical checkout; its declared Studio9275,
legacy9274, database2993 and search8110 assignments were synchronized. These are
explicit legacy external assignments outside the historic8120–8129 block, **not**
a new validated ten-port .astra environment contract. Future portable-contract
adoption/individual provider controls need their own bounded slice. Retirement,
permanent purge, database deletion and credential changes are not part of this move.

Astra canonical Task: node:a485ae6aa8e24b6d8afe19ae075944ec.
Next human action: use the Raven Launch in standard Astra and open the base URL.
