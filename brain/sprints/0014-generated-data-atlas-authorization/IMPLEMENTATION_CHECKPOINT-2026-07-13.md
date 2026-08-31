# Generated Data Atlas Implementation Checkpoint

## Metadata

- Parent ingest: `RAVEN-INGEST-0014`
- Date: 2026-07-13
- Status: implemented; ready for review; not accepted or done
- Branch: `codex/generated-data-atlas`
- Worktree: `/Users/michaelpeters/Dev/mpd/projects/raven/raven-worktrees/generated-data-atlas`
- Evidence basis: implementation outcome reported by the main workline

## Implemented Outcome

- The atlas derives from `apps/schema/config/graph.mpdg` through exported canonical `parseFile` and `buildSpec` functions.
- Generated output covers 19 models, 49 direct record references, one self-reference, and eight explicitly registered runtime relation-table edges.
- Whole, Past, Present, Future, and Business/Earn Mermaid diagrams are generated.
- Root commands are `pnpm docs:data-atlas`, `pnpm docs:data-atlas:check`, and `pnpm test:data-atlas`.
- `RAVEN_SCHEMA_GRAPH_PATH` supports isolated root worktrees where the separately managed `apps/schema` repository is not attached.

## Reported Verification

- Nine focused tests pass.
- The deterministic atlas stale check passes twice.
- Strict graph validation and formatting pass.
- Root and nested-repository diff checks pass.
- Brain health, secret scans, archive-safety tests, and AI-safe archive preflights pass.

## Boundaries Preserved

- No financial schema or product-code change.
- No private data or database access.
- No development server.
- No commit or push.
- Proposed bridges remain interpretation rather than schema canon.

## Status Handoff

- Move the Generated Data Atlas Workline to Orbit review, not done.
- Final artifact acceptance and any merge remain pending review.
- Workline 03 remains in review.
- Workline 04, Past Truth/Historian, Elgiz, and Earn remain unstarted or proposed.
- The broad July parallel-lane plan remains unaccepted.

This checkpoint records implementation outcome only. It does not create another raw ingest or alter the preserved `RAVEN-INGEST-0014` sources.

