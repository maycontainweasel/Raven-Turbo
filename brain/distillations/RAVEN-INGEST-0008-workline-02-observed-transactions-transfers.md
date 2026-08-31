# Distillation - RAVEN-INGEST-0008 - Account Control Workline 02: Observed Transactions And Transfers

## Source

- Raw source directory: `brain/source-material/pre-work/RAVEN-INGEST-0008-workline-02-observed-transactions-transfers/`
- Ingest record: `brain/sprints/0008-workline-02-observed-transactions-transfers/INGEST_RECORD-RAVEN-INGEST-0008.md`
- Source date: 2026-07-11
- Ingest date: 2026-07-12
- Mode: pre-work-primer
- Source kind: implementation-prompt

## Executive Distillation

The prompt authorizes the main agent to implement Account Control Workline 02 as working product code through the existing shared Account Control domain. The bounded outcome is one complete observed-money loop: open a tracked account, inspect its exact month ledger, record expense and income, record an atomic linked transfer between eligible tracked accounts, see exact month income/outflow/net with transfers excluded, inspect semantic transaction provenance and linkage, and perform equivalent operations through Raven MCP.

Workline 01 is explicitly accepted and complete and must not be reopened, re-ingested, or reimplemented. Workline 02 must preserve its exact-money, composite account identity, command idempotency, immutable balance evidence, note persistence, freshness-first selection, and invalid-future diagnostics. Workline 02 is implementation work rather than another architecture-only review, but its terminal state is `review`, not `done`. Workline 03 and all Upcoming/Today behavior remain outside this source's authorization.

## Authorized Product Loop

- Navigate from `/accounts` to `/accounts/[spaceKey]/[accountKey]`.
- Read a deterministic account-scoped month ledger with semantic filters and pagination.
- Record exact positive expense/outflow and income/inflow observations without changing balance snapshots.
- Record one transfer aggregate with source and target legs plus one FinancialOperation receipt atomically.
- Calculate income, outflow, and net with both canonical and ambiguous legacy transfers excluded.
- Inspect one semantic transaction, including category, provenance, clarification summary, operation receipt, and transfer counterpart when available.
- Expose every new semantic read and command through the same AccountControlApi used by Studio, tRPC, and Raven MCP.

## Binding Predecessor Invariants

The prompt states these are already accepted and are not new approval gates:

- Canonical money is validated integer minor units plus currency.
- Transaction amounts are stored as positive magnitudes; semantic kind and movement flow are distinct.
- A tracked-account transfer is one aggregate with two linked legs, and neither leg enters income, outflow, or aggregate net.
- Observed monetary facts are append-only through semantic product paths.
- Every command is idempotent and provenance-backed by FinancialOperation.
- Studio, tRPC, and MCP share one AccountControlApi and domain service.
- Recording movement never mutates, synthesizes, or advances an AccountBalanceSnapshot.
- Workline 01's unknown, stale, and invalid-future balance truth remains unchanged.

## Bounded Contract Corrections

These corrections are required within Workline 02 without reopening broad architecture:

1. `postedAt` is a financial calendar date. Manual commands accept normalized `YYYY-MM-DD`; `recordedAt` remains an exact instant. Date-only facts must never round-trip through timezone conversion.
2. Legacy transfers without canonical flow remain visibly unresolved and excluded from totals. Add `LEGACY_TRANSFER_AMBIGUOUS`; never infer flow from descriptions.
3. Add shared semantic reads `list_categories` and `get_transaction` with UI/tRPC/MCP parity.
4. Extend `get_month_progress` with optional composite account references, never account key alone.
5. Keep occurrence reconciliation deferred; do not accept and discard `occurrenceId` before Workline 03.

## Schema And Migration Scope

- Begin schema authority changes in `apps/schema/config/graph.mpdg`, validate, regenerate, and import through the established schema workflow.
- Extend Transaction with optional migration-safe canonical fields for exact amount, transaction kind, flow direction, entry source, recorded instant, operation reference, and transfer reference while retaining required legacy compatibility fields.
- Add AccountTransfer as the source-authority aggregate linking both composite account references, exact money, posted date, optional description, both transaction legs, operation receipt, and recorded instant.
- New semantic writes dual-write only the minimum legacy compatibility fields required by Raven V1.
- Add an audit-first transaction migration/report with default non-writing `audit` and explicit opt-in `apply` modes.
- Migration reports contain aggregate counts only and must not expose private descriptions, account names, amounts, or source text.
- Canonical fields win on reads. Exact valid legacy fallback emits `LEGACY_MONEY_FALLBACK`; ambiguous transfer, precision, range, date, and canonical-conflict cases remain explicit exceptions rather than coercions.
- Do not run private-data apply/backfill automatically and do not redesign StatementRow or the import pipeline broadly.

## Shared Semantic Contract

Required queries:

- `list_account_transactions`
- `get_transaction`
- `get_month_progress`
- `list_categories`
- Complete `get_account.availableMonths` from observed financial dates, newest first.

Required commands:

- `record_expense`
- `record_income`
- `record_transfer`

All commands require deterministic identity, checked exact money, normalized financial dates, provenance, retry-safe idempotency, stable domain errors, and no balance-snapshot mutation. Transfer validation requires distinct active tracked accounts with the same currency, and transfer persistence must be atomic.

## Adapter, Transport, And MCP Scope

- Extend the existing repository port and Surreal adapter; Vue, tRPC, and MCP must not bypass it.
- Canonical transaction fields are read first and exact legacy adaptation second.
- Financial totals remain domain-service calculations using checked minor-unit arithmetic, not legacy Surreal float sums.
- Ledger reads require deterministic cursor pagination and may not depend on Typesense.
- Add thin `accountControl` tRPC procedures and semantic MCP tools for all four queries and three commands.
- MCP descriptions must distinguish observed movement from plans, explain transfer exclusion, surface legacy uncertainty, and preserve `{ currency, minorUnits }` as canonical input.
- Contract-parity tests must prove equivalent tRPC and MCP behavior for each operation.

## Raven Studio Scope

- Preserve the quiet black, system-aware, dense Notion/GitHub-like direction.
- Add account detail routing, command-registry and palette access, keyboard behavior, and a minimal quick-create choice.
- Account detail includes identity, current selected balance evidence, month selection, exact month totals, transfer-exclusion status, filters, deterministic ledger pagination, full loading/empty/error/partial/warning states, keyboard row navigation, and a semantic transaction drawer.
- Expense/income and transfer dialogs use accessible Ark UI flows and parse decimal strings only at the UI boundary.
- Each open dialog owns one retry-stable command-intent idempotency key under the accepted Workline 01 reset rules.
- The transaction drawer is read-only for monetary facts and exposes semantic amount, kind/flow or uncertainty, dates, category, summary provenance, receipt, transfer counterpart, and clarification state.
- Operational page queries retain the proven client-load pattern and must not depend on SSR access to local SurrealDB.

## Verification Contract

- Use fictional fixtures only and never place real financial or operational material in tests, docs, logs, snapshots, or prompts.
- Cover exact expense/income creation, invalid money/date/currency/category cases, replay and conflict semantics, immutable balance truth, atomic transfer creation, transfer validation and replay, transfer exclusion, canonical-over-legacy precedence, exact legacy fallback, ambiguous legacy transfer handling, available-month ordering, deterministic pagination/filtering, category safety, transport parity, and all Workline 01 regressions.
- Run schema validation before generation, generated-authority inspection, focused domain/Surreal/MCP tests and typechecks, Raven Studio production build, secret-safety checks, and a disposable fictional live-Surreal smoke with cleanup.
- Do not start a development server and do not run a private-data migration apply.
- Report inherited whole-app Nuxt typecheck failures outside Account Control honestly without absorbing them into Workline 02.

## Stop Gates And Explicit Exclusions

- Preserve the full prompt at `docs/prompts/raven-account-control-workline-02.md` during main implementation.
- Leave the Orbit Workline in `review`; do not mark Workline 02 done.
- Do not start Workline 03.
- Do not implement cashflow schedules/occurrences, Upcoming, Today calculations, recurring promotion, transaction correction/reversal, raw transaction mutation, category CRUD, ingestion redesign, transfer-candidate reconciliation, broader financial modules, Elgiz buckets, Raven V1 refactoring, or broad Schema Kit/Helios cleanup.
- Preserve unrelated dirty-worktree and nested-repository changes.

## Decisions

No new Brain decision is created by this sidecar. The prompt supplies implementation clarifications and accepted predecessor invariants for the main workline; durable decision records should be changed only if implementation or acceptance materially changes project understanding.

## Open Loops For Main Agent

- Implement and verify the complete bounded Workline 02 product loop.
- Reconcile `RISK-0008`, `brain/ROADMAP.md`, stale closed-loop wording for `OL-0016` and `OL-0017`, and Workline 01 prompt classification as part of bounded Brain consistency.
- After implementation, update active `NOW`, `HANDOFF`, and `OPEN_LOOPS` honestly while leaving Workline 02 in review.
- Preserve migration exceptions and legacy uncertainty explicitly for external acceptance.
- Do not open or begin Workline 03.

## Risks Preserved From The Prompt

- Date-only financial facts can shift days if passed through local-midnight or UTC conversion.
- Legacy transfer descriptions are not reliable evidence of flow direction.
- Partial transfer persistence would corrupt observed-money truth unless aggregate, legs, and receipt are atomic.
- Float-based legacy totals or adapter leakage could violate exact-money guarantees.
- Account keys can repeat across Financial Spaces, so account scoping must remain composite.
- UI retry behavior can duplicate observations if command-intent keys are transport-scoped.
- A migration apply can touch private data and therefore must remain explicit, opt-in, aggregate-only in reporting, and unexecuted by default.
- Product semantics can diverge if Studio, tRPC, and MCP bypass the shared domain service.

## Repeated Themes

- Observed movement and balance evidence are separate truths.
- Exact money, uncertainty, provenance, and idempotency remain end-to-end concerns.
- Transfers are movement between tracked accounts, not income or spending.
- Legacy uncertainty must stay visible rather than being guessed away.
- One semantic domain must serve UI and agents equally.
- A workline's implementation authorization and its acceptance/completion gate are distinct.

## Orbit Sync Candidates

- Create or resume the bounded Observed Transactions and Transfers Workline for main-agent execution.
- Preserve Workline 01 as accepted and complete.
- Track implementation phase transitions, then leave Workline 02 in `review` for Michael/external acceptance.
- Do not create or start Workline 03.
- No Orbit or `.orbit` state was changed by this Brainkeeper sidecar.
