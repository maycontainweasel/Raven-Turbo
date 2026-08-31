---
status: working
owner: Raven
last_reviewed: 2026-07-11
supersedes: []
superseded_by: []
---

# Codex Prompt - Account Balance Truth Vertical

```text
orbit-workline

Implement Raven Account Control Workline 01: Account Balance Truth Vertical.

Precondition:
Michael has explicitly approved all four decisions in `docs/architecture/raven-account-control-contract-v0.1.md`. If those approvals are not present in Brain/Orbit or the current instruction, stop before product changes and request the four decisions together.

Read and obey:
- root AGENTS.md and required Orbit/Brain startup files;
- `docs/architecture/raven-account-control-contract-v0.1.md`;
- `apps/schema/AGENTS.md`, `apps/schema/config/AGENTS.md`, and the MPDG/runtime authority canon;
- Raven Studio app/server/page AGENTS and generated controller/runtime contracts;
- schema-runtime-protocol.

Keep an independent Brainkeeper sidecar running for any full orchestrator response, but do not let it replace or defer the implementation workline.

Scope:
1. Add the exact-money primitive and shared result/error/warning envelopes in a new workspace package `packages/raven-domain`.
2. In schema canon, add:
   - `FinancialOperation`;
   - `AccountBalanceSnapshot`;
   - Account fields `normalNature`, `liquidityClass`, `freshnessWindowHours`, and `openingBalanceMinor`;
   - only the FinancialSpace control fields required by this vertical.
3. Add a Surreal repository adapter behind the domain repository port. Preserve source-authority, single-database routing and current generated schema contracts.
4. Implement only these operations:
   Queries: `list_accounts`, `get_account`, `get_current_position`, `get_account_freshness`.
   Commands: `create_account`, `confirm_account_balance`.
5. Add thin tRPC procedures under `accountControl` and a semantic stdio MCP package at `apps/raven-mcp` exposing the same six contracts. Do not expose raw CRUD as Raven tools.
6. Build the minimal Raven Studio shell, central route/action registry, command palette, overflow menu, `/accounts`, create-account flow, and balance-confirmation flow.
7. Use Ark UI for accessible headless dialog/menu mechanics and Lucide icons. Do not add another primitive library or a broad design system.
8. Add only fictional test fixtures with no private financial content.

Financial invariants:
- persistence uses integer minor units plus currency;
- TypeScript uses validated branded safe integers;
- wire values are `{ currency, minorUnits }` with safe integer validation;
- no float arithmetic in domain calculations;
- balance confirmations append immutable snapshots;
- unknown is never zero;
- stale balances remain visible but provisional;
- available credit is informational, not liquid cash or an asset;
- every command requires idempotency and returns a `FinancialOperation` receipt.

Migration:
- Start all schema changes in `apps/schema/config/graph.mpdg`.
- Run graph validation before regeneration.
- Add an audit/backfill path for `openingBalance` to `openingBalanceMinor`; do not silently coerce unsupported precision.
- Backfill latest transaction balances only as observed historical snapshots with their real as-of dates. Never label them current confirmations.
- Keep canonical-first/legacy-second reads during transition.
- Do not hand-edit generated files as the source of truth.

Acceptance:
- exact-money parser and arithmetic tests cover excess precision, unsafe range, overflow, and currency mismatch;
- idempotency replay/conflict tests pass;
- balance selection/freshness tests use a fixed clock and cover fresh, stale, unknown, invalid-future, liability, informational available credit, and overdraft nature;
- Studio tRPC and MCP outputs are contract-equivalent on the same fixtures;
- `/accounts` covers loading, empty, error, complete, partial, stale, and unknown states;
- critical reads do not depend on Typesense;
- no real account names, descriptions, numbers, balances, statements, mailbox data, or credentials enter tests/docs/commits.

Boundaries:
- Do not implement transaction commands, AccountTransfer, schedules, occurrences, Upcoming, Today coverage, tax, invoicing, opportunities, retainers, budgets, debt strategy, or buckets.
- Do not refactor Raven V1.
- Do not start the dev server; Michael manages it. Ask him to restart only when runtime verification requires it.
- Preserve unrelated dirty-worktree changes and the nested `apps/schema` repository state.

Verification:
- run schema graph validation and the required regeneration checks;
- run focused package/domain tests, Raven Studio typecheck/build, and Raven MCP typecheck;
- inspect generated authority metadata after regeneration;
- verify archive safety if packaging configuration changes;
- update Orbit at phase transitions and leave the Workline in review;
- Brain Checkpoint only durable decisions/results, not routine implementation noise.

End with:
- changed schema and migration behavior;
- operation parity evidence for UI/tRPC/MCP;
- tests and exact commands run;
- product limitations still in place;
- the next review boundary, without starting Workline 02.
```
