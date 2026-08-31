---
status: canonical
owner: Raven
last_reviewed: 2026-08-10
supersedes: []
superseded_by: []
---

# Raven Documentation Authority

Document status is explicit:

- `canonical` - current authority until deliberately superseded.
- `working` - active operational guidance or an evolving specification.
- `reference` - useful history or design archaeology, not current instruction by default.
- `deprecated` - retained for traceability but no longer recommended.
- `private` - tracked or local material that must not enter routine Brain or external share archives.

## Current Classification

| Document or area                                                                  | Status            | Role                                                                                                                                                             |
| --------------------------------------------------------------------------------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `raven_vision_v1.md`                                                              | canonical         | Product charter and Facts / Meaning / Control / Guidance architecture                                                                                            |
| `raven_build_plan_v1.md`                                                          | reference         | Earlier build sequence, superseded in ordering by the July 2026 reinstatement sequence                                                                           |
| `raven-maintenance-hosting-control.md`                                            | working           | Operational client, hosting, and retainer workflow                                                                                                               |
| `repository-sharing-and-credential-rotation.md`                                   | canonical         | AI-safe archive and credential-handling contract                                                                                                                 |
| `architecture/raven-data-atlas.md`                                                | canonical         | Generated schema-authority model and connectivity projection, with reviewed runtime-edge registry and human-maintained interpretation outside generated markers  |
| `architecture/raven-account-control-contract-v0.1.md`                             | canonical         | Approved exact-money, balance, cashflow, semantic operation, UI, and implementation contract                                                                     |
| `architecture/raven-account-control-workline-01-implementation.md`                | accepted          | Completed Account Balance Truth vertical, migration behavior, and final invalid-future closeout                                                                  |
| `architecture/raven-account-control-workline-02-implementation.md`                | accepted          | Completed Observed Transactions and Transfers vertical, including immutable import replay                                                                        |
| `prompts/raven-account-control-workline-01.md`                                    | reference         | Completed Workline 01 implementation prompt                                                                                                                      |
| `prompts/raven-account-control-workline-02.md`                                    | reference         | Completed Workline 02 implementation and acceptance contract                                                                                                     |
| `architecture/raven-account-control-workline-03-implementation.md`                | complete          | Accepted Upcoming Cashflow vertical, including the final paused-to-terminal lifecycle closeout                                                                   |
| `architecture/raven-account-ledger-and-mcp-readiness-v0.1.md`                     | working           | Account-ledger truth boundaries, current semantic MCP coverage, and explicit reconciliation, meaning, and tax-operation gaps                                     |
| `architecture/raven-statement-truth-contract-v0.1.md`                             | accepted          | Approved immutable statement-source, neutral component, matching, issue, reconciliation, privacy, and Historian operation contract                               |
| `architecture/raven-statement-truth-st-01-implementation.md`                      | complete          | Accepted source-only staging, strict profile/coverage/legacy authority, preview-bound Account context, atomic commit, reads, Studio, and MCP boundary            |
| `architecture/raven-statement-truth-st-02-implementation.md`                      | complete          | Accepted provisional matching, exact one-movement resolution, deterministic concurrency claims, reconciliation, attestation, reopening, Studio, and semantic MCP |
| `architecture/raven-historian-hp-00-readiness.md`                                 | complete          | Accepted readiness gate: MCP/vault ready, aggregate legacy classes recorded, and the prior configured-database schema blocker identified                         |
| `architecture/raven-historian-hp-01-schema-deployment.md`                         | complete          | Externally accepted additive schema deployment, verified private recovery point, count invariance, post-deployment readiness, and HP-02 gate                     |
| `architecture/raven-historian-hp-03-legacy-overlap-contract.md`                   | review            | Aggregate-only private-crosswalk outcome, Strategy D gate, proposed append-only compatibility bridge, parity plan, and six approval decisions                    |
| `architecture/raven-historian-hp-04-selected-period-resolution-implementation.md` | review            | Fictional-only append-only compatibility bridge, exact preview/apply/reversal authority, verification, and separately gated private phases                       |
| `architecture/raven-financial-read-analytics-00.md`                               | review            | Exact read-only period, Category, merchant, fee, trend, uncategorized, and data-quality analytics with explicit authority separation                             |
| `contracts/statement-extraction-input-v0.1.schema.json`                           | canonical         | Machine-readable neutral extraction-assistance wire contract; runtime semantic invariants remain enforced by Raven Domain                                        |
| `contracts/statement-extraction-input-v0.1.md`                                    | canonical         | Historian operator guide for artifacts, coverage, source roles, exact money, and reviewed commit intent                                                          |
| `operations/raven-statement-truth-operations-v0.1.json`                           | canonical         | Machine-readable 31-operation semantic MCP inventory with inputs, outputs, errors, and write classifications                                                     |
| `runbooks/raven-historian-private-pilot-v0.1.md`                                  | working           | HP-00 controlled private-pilot selection, approval, reconciliation, privacy, reporting, and stop protocol                                                        |
| `prompts/raven-historian-private-pilot-agent.md`                                  | working           | Dedicated local Statement Historian starter constrained to semantic MCP and one controlled period                                                                |
| `prompts/raven-historian-hp-02-private-selection.md`                              | reference         | Completed HP-02 private selection and compatibility prompt retained as the historical operator boundary                                                          |
| `prompts/raven-historian-hp-04-selected-period-resolution-implementation.md`      | reference         | Executed fictional implementation prompt; its separate private re-preview/apply phases remain unstarted and separately gated                                     |
| `prompts/raven-statement-truth-workline-st-01.md`                                 | reference         | Completed Statement Source Preview and Atomic Commit prompt retained for historical boundary                                                                     |
| `prompts/raven-statement-truth-workline-st-02.md`                                 | reference         | Original ST-02 Provisional Matching and Exact Statement Reconciliation implementation prompt retained verbatim                                                   |
| `prompts/raven-account-control-workline-03.md`                                    | reference         | Implemented Workline 03 prompt retained as the acceptance contract                                                                                               |
| `raven-worklist.md`                                                               | private           | Statement-derived review and financial investigation backlog                                                                                                     |
| `ux/**`                                                                           | reference         | Historical UX and buckets design material unless promoted explicitly                                                                                             |
| `raven-buckets-lab-prototype-2026-05-31/**`                                       | private/reference | Prototype code mixed with private source material; never bulk-share                                                                                              |
| Project Brain docs `00-*`, `09-*`, `10-*`, `11-*`                                 | canonical         | Brain operation and primer guidance                                                                                                                              |

## Operating the Data Atlas

- Run `pnpm docs:data-atlas` after an accepted canonical schema change to refresh the generated projection.
- Run `pnpm docs:data-atlas:check` to fail when the committed generated block is stale.
- Run `pnpm test:data-atlas` for the focused parser, reference, registry, determinism, and Mermaid-safety contract.
- In an isolated root worktree without the separately managed `apps/schema` checkout, set `RAVEN_SCHEMA_GRAPH_PATH` to the absolute path of the canonical `apps/schema/config/graph.mpdg` before running Atlas commands.

Adding frontmatter does not promote recommendations into accepted decisions. Accepted project decisions live in `brain/DECISIONS.md` and Orbit.
