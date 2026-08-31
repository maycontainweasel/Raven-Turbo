# Open Loops

## Historical Foundation

### OL-0001 - Choose First Raven Backfill Source

Status: closed

Completed with `RAVEN-INGEST-0001`.

### OL-0002 - Define Safe Financial Source Handling

Status: active

Define and enforce which private sources remain staged only. AI-safe sharing is the current implementation step.

### OL-0003 - Identify Stable Raven Operations

Status: closed

Thirty semantic Account Control operations are implemented with shared Studio tRPC and MCP transport handlers.

## Elgiz And Planning

### OL-0004 - Review And Integrate Buckets Lab Prototype

Status: deferred

Raven V1 and the prototype remain references until present-control foundations are dependable.

### OL-0005 - Define Bucket Flow Persistence Model

Status: deferred

Define after the domain contract, exact-money invariant, and present-control schema.

### OL-0006 - Keep Observed Ledger Separate From Planning Flows

Status: open

The shared domain contract must preserve observed, planned, and simulated separation.

### OL-0007 - Define Bucket Rule Semantics

Status: deferred

Revisit after obligations and coverage calculations are trusted.

### OL-0008 - Synchronize Canvas And Table Views

Status: deferred

Both views must eventually use one canonical model.

## July 2026 Reinstatement

### OL-0009 - Define Raven Domain Operation Contract

Status: closed

The typed query, command, result, error, warning, idempotency, provenance, tRPC, and MCP conventions are accepted and implemented through Worklines 01 and 02.

### OL-0010 - Define Exact Money Representation

Status: closed

Integer minor units are accepted in `DEC-0011`; Workline 01 implementation and focused verification are complete.

### OL-0011 - Define Balance Truth And Freshness

Status: closed

The `AccountBalanceSnapshot` contract and freshness-first selection clarification are accepted in `DEC-0012`.

### OL-0012 - Define Recurring Pattern Versus Obligation Promotion

Status: review

The proposed boundary keeps `RecurringPattern` as inferred evidence and requires explicit review to create a `CashflowSchedule`.

### OL-0013 - Define Orbit Integration Contract

Status: open

Define stable links among financial actions, earning targets, clients, projects, and work capacity without duplicating ownership.

### OL-0014 - Establish Safe Repository Sharing

Status: closed

Completed on 2026-07-11 with default AI-safe packaging, a separately named developer-unsafe profile, secret preflight, path policy, and tests.

### OL-0015 - Classify Legacy UX Documents

Status: active

Mark current authority and keep historical UX material as reference unless promoted explicitly.

### OL-0016 - Define The First Present Dashboard Contract

Status: closed

The Today wireframe and deterministic calculation contract are accepted in `DEC-0014`. Today implementation remains deferred until accepted upcoming-cashflow truth exists.

### OL-0017 - Define Transaction And Transfer Semantics

Status: closed

The exact transaction and linked-transfer contract is accepted in `DEC-0011` and implemented in Workline 02.

### OL-0018 - Define Audited Occurrence-Level Cashflow Operations

Status: closed

Implemented in Workline 03 with immutable `scheduledDueOn`, effective amount/date overrides, optimistic occurrence revisions, operation receipts, and Studio/tRPC/MCP parity.

### OL-0019 - Review Account Balance Truth Vertical

Status: closed

The external archive review accepted the black-canvas and first-load fixes and identified three integrity gates. All three are now implemented and verified:

- each dialog intent retains one idempotency key across failed retries;
- optional balance notes persist and return with immutable evidence;
- Account storage identity is `stringID(space, key)`, with duplicate detection on the same space-scoped invariant and stable conflict errors.

The final invalid-future closeout keeps future evidence unselected and uncounted while exposing `invalid_future`, the newest offending as-of time, `BALANCE_INVALID_FUTURE`, and separate current-position metadata. Workline 01 is accepted and complete.

### OL-0020 - Restore Clean Whole-App Typecheck

Status: open

Resolve inherited generated Schema Kit, Helios, and optional-dependency type errors without folding that broad cleanup into Account Control Workline 01.

### OL-0021 - Review Observed Transactions And Transfers Vertical

Status: closed

Workline 02 is accepted and complete. Final fictional evidence proves scoped import identities, exact replay, immutable-fact rollback, reviewed classification without source mutation, idempotent source links, cross-space local-key reuse, truthful migration reporting, whole-month warning disclosure, and no regression across the Account Control surface.

### OL-0023 - Review Upcoming Cashflow Vertical

Status: closed

Workline 03 is accepted and complete across schema, recurrence, lifecycle, settlement/reconciliation, Studio `/upcoming`, tRPC, and MCP.

Bounded closeout completed on 2026-07-13:

- command intent survives failed/lost-response retries and concurrent first writes replay by request hash;
- the active/paused/ended/cancelled transition matrix and lifecycle dates are enforced;
- materialization is monotonic and safe across future-effective changes and races;
- occurrence revision/status is protected atomically during schedule mutation;
- settlement evidence is canonical, same-space/account, and one-transaction-to-one-occurrence;
- domain summaries separate certainty per currency and expose schedule-timezone timing groups;
- Studio exposes warnings, Linked/Unreconciled state, schedules, candidate selection, complete detail, and FinancialOperation provenance/history;
- the bounded fictional matrix passes.

Final closeout completed on 2026-07-18 under `RAVEN-INGEST-0016`:

- paused-to-end/cancel creates no due row after `pausedOn` and terminalizes only pre-materialized mutable due rows in the paused gap;
- immutable settled, skipped, waived, and cancelled history is preserved;
- one lifecycle-eligibility rule governs Upcoming lists, counts, summaries, and `nextDueOn`;
- schedule views expose configured status, effective status at explicit schedule-local `asOf`, and the next pending transition;
- Studio separates term and lifecycle dates, applies action-specific lower bounds, and keeps retry-stable intent per action;
- domain, Surreal, MCP parity, Studio intent, production build, schema, Atlas, archive-safety, and disposable fictional live-smoke checks pass.

Workline 04 remains unstarted and requires a separate sequence/authorization.

### OL-0022 - Plan Existing Import Identity Migration

Status: aggregate audit complete; migration deferred

The explicitly authorized HP-00 aggregate-only audit ran with zero writes and no record-level output. It reported `438` scoped legacy identities, `38` active legacy imports with no canonical period mapping, and `1,419` source-backed Transactions without ST-02 matches. Any identity or period migration/replacement remains deferred and requires separate approval.

## July 13 Parallel Lanes

### OL-0024 - Integrate Accepted Generated Data Atlas

Status: closed

Closed on 2026-07-18 after external technical acceptance, surgical integration of the five accepted files, exactly three additive root scripts with none removed, preservation of the Documentation Authority index, regeneration from current `graph.mpdg`, passing required checks, and inspection of the primary-main AI-safe archive. The stale isolated branch was not merged or copied wholesale.

### OL-0025 - Approve Past Truth Reinstatement Audit And Historian Contract

Status: proposed

Decide whether to run the supplied isolated, read-only, aggregate-only audit and semantic Historian contract. No private records were inspected and no audit, migration, replay, or write was run during ingestion.

### OL-0026 - Approve Elgiz Bucket Foundation And Pure Engine

Status: proposed

Decide whether to run the supplied isolated Elgiz contract/pure-engine workline and resolve its four architecture gates: plan version identity, minimal model, shortage/remainder/cap/overflow semantics, and the virtual-versus-real-money boundary.

## July 22 Tax And Transaction Meaning

### OL-0027 - Approve Tax And Transaction Meaning Contract And Vocabulary

Status: working lens baseline accepted; full Tax Treatment contract remains open

`DEC-0027` authorizes and implements the bounded Normal/Tax presentation baseline:
separate hierarchical tax categories plus sparse revisioned per-transaction tax
declarations that inherit Normal meaning field by field.

The broader Tax Lane 00 questions preserved in `RAVEN-INGEST-0017` remain open:
legal/taxpayer entity boundary; exact split allocation; deductibility and VAT
semantics; role and reviewer authority; opaque evidence links; period and workpaper
identity; filed/amended supersession; shared domain/read-model/MCP operations; and a
controlled private pilot. The working lens must not be represented as accepted Tax
Treatment.

## July 28-29 Account Ledger And Statement Truth Direction

### OL-0028 - Approve And Execute The Statement Truth Sequence

Status: closed for ST-01 and ST-02; later worklines remain separate

The eight Statement Truth decisions and four binding implementation clarifications remain accepted under `DEC-0016`. `RAVEN-INGEST-0023` records final ST-01 acceptance and authorizes ST-02 under `DEC-0017`. `RAVEN-INGEST-0024` preserves the bounded closeout gate. `RAVEN-INGEST-0025` records final external acceptance of that closeout. ST-01 and ST-02 are done.

ST-01 remains source-only. ST-02 provides provisional matching, explicit materialization, source supersession, exact reconciliation, attestation, reopening, cross-space transfer review, server-derived evidence, concurrency protection, active authority, authoritative period placement, semantic history, exact attestation sets, and stable errors. ZAR remains the accepted scope; GBP requires future explicit registry and adapter approval before UK ingestion; no FX. Later Statement Truth meaning and private operation remain separately gated.

## August 8 Historian Pilot Readiness

### OL-0029 - Execute HP-00 Controlled Private Statement Pilot Readiness

Status: closed; externally accepted and complete

HP-00 proves the exact 28-operation semantic MCP catalog, owner-only ignored vault, diagnostic read-only generic MCP, aggregate-only compatibility output, multi-account closed-ZAR checklist, runbook, and Historian starter. The external review accepts its fail-closed outcome. Studio remained at HTTP `502`; the configured database lacked nine accepted Statement Truth tables; no private statement was opened.

### OL-0030 - Execute HP-01 Accepted Schema Deployment And Readiness Recheck

Status: closed; externally accepted and complete

The primary workline verified private recovery and redacted target identity, applied 45 additive schema definitions in one transaction, proved the nine canonical tables and nine admin views empty, preserved all 52 pre-existing counts, and reran readiness. SOURCE-01 of `RAVEN-INGEST-0027` externally accepts the bounded deployment. Status remains `schema_ready_legacy_compatibility_unresolved`; schema readiness alone does not authorize a private source or pilot.

### OL-0031 - Execute HP-02 Private Selection And Compatibility Gate

Status: closed; externally accepted and complete

The primary operator passed readiness, completed private selection and interacting-Account coverage, obtained explicit selection approval, and classified the exact set through bounded read-only inspection as `legacy_overlap_confirmed`. HP-02 stopped as required. `RAVEN-INGEST-0028` records external acceptance of this fail-closed result. No source was opened or staged and no financial write occurred.

### OL-0032 - Execute HP-03 Selected-Period Legacy Authority Crosswalk

Status: closed; externally accepted and complete

The bounded operator obtained both explicit approvals, staged separately hashed source and assistance evidence, completed deterministic preview/revalidation, and produced the owner-only exact crosswalk plus aggregate contract. Aggregate dispositions are 40 exact adoption, 0 grouped adoption, 0 materialization, 0 legacy-only, 3 transfer review, 23 informational, and 1 ambiguous/conflicting. `RAVEN-INGEST-0030` records external acceptance of this successful fail-closed workline. Strategy D still keeps canonical commit blocked, and financial database writes remain externally reported as zero.

### OL-0033 - Approve HP-03 Bridge And Authorize HP-04

Status: closed; approved and authorized

`RAVEN-INGEST-0030` accepts all six bridge decisions once under `DEC-0022` and authorizes only the fictional HP-04 implementation and external-review boundary under `DEC-0023`. Canonical source commit, private re-preview, private apply, and active-ledger authority changes remain unauthorized.

### OL-0034 - Execute HP-04 Fictional Compatibility Bridge

Status: closed; fictional foundation externally accepted

Phases A-H are implemented with fictional fixtures and an isolated disposable database. `RAVEN-INGEST-0031` records external acceptance of this architecture and implementation foundation. Selected-source readiness, private re-preview, exact apply approval, canonical source commit, and active private authority remain separate under HP-04A.

### OL-0035 - Execute HP-04A Selected-Source Activation Closeout

Status: authorized; separate workline

Implement the old-renderer period/context binding, eligible statement-closing snapshot parity, and exact server-derived reviewed blocker dispositions under `DEC-0024`. Complete fictional verification before requesting permission for any owner-only source or crosswalk access. Preserve private re-preview, item decisions, apply approval, reconciliation, and attestation as separate controlled gates.

RA-00 does not execute this loop.

### OL-0036 - Implement Financial Read Analytics RA-00

Status: RA-00B implemented; final artifact in external review

The architecture, seven semantic operations, current-main integration, default active-ledger calculations, no-write boundary, and six prior integrity corrections are externally accepted. RA-00B now protects optional `active_ledger_with_legacy_unreconciled` after ST-02 clears a Transaction's active match pointer while immutable reverse canonical match history survives.

Implementation derives canonical match history independently of the current pointer, keeps formerly canonical source-created or adopted Transactions historical, includes only genuine renderer-era rows as legacy-unreconciled, returns cleared manual/generated matches to active provisional observation-date authority, and preserves default output compatibility. Shared-file safety was clear and verification passed with fictional fixtures only. The remaining gate is external acceptance of the final current-main artifact.

### OL-0037 - Execute Emergency Source-Only Statement Reconstruction

Status: implemented and privately run; review and later activation gates remain

Use the exact `RAVEN-INGEST-0034` orchestrator packet with the higher-precedence `RAVEN-INGEST-0035` user addendum to establish one urgent, controlled private Workline. Inventory and deduplicate recovered source evidence, use no-write semantic stage/preview/validation, build the Phase C index as owner-only deterministic filesystem-native JSON/NDJSON with bounded local query/report commands, and report only aggregate-safe status outside the private boundary. Do not introduce DuckDB, another embedded database, or a new Raven schema model.

The controlled run produced the deterministic private source index under opaque reference `EI-2026-08-17-00`, passed exact report reconciliation and canonical count invariance, and performed no financial write. The source-only index remains visibly provisional and must never feed canonical ledger authority, Account position, budgets, reconciled analytics, management meaning, tax meaning, accounting conclusions, or legal conclusions automatically. The remaining loop is owner review of blocked Account/profile metadata and extraction issues, exact recipient aliases if those schedules are wanted, and a separate explicit activation gate for any canonical ST-01/ST-02 or HP-04A action.

One selected closed month is now practically visible in Studio from existing legacy statement Transactions through an explicit Account-review scope. This does not close the canonical activation loop: committed source authority, audited adoption/materialization, reconciliation, and attestation remain separate.
