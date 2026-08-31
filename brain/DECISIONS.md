# Decisions

## DEC-0001 - Install Project Brain In Orbit-Connected Mode

Date: 2026-05-31
Status: accepted

Decision:
Install Project Brain v0.2 for Raven while preserving the existing Orbit bootstrap, Raven-specific instructions, private source folders, and dirty worktree.

Reason:
Raven is already connected to Orbit and needs portable narrative memory for historical discussions, external AI review, decisions, open loops, opportunities, and handoff continuity.

Consequences:

- Orbit / Financial Mastery remains the planning/control source of truth.
- The Markdown Brain becomes the portable narrative-memory source of truth.
- The repo remains the implementation source of truth.
- Brainkeeper ingest/backfill can now process selected ChatGPT 5.5 Pro prompt/response pairs.
- Private financial source material remains outside Brain ingestion unless explicitly selected.

## DEC-0002 - Raven Studio Is The Primary UX Rebuild

Date: 2026-07-11
Status: accepted

Decision:
Use `apps/raven-studio` as the primary clean rebuild surface. Preserve `apps/raven` as a behavioral and query reference.

Consequences:

- Migrate proven behavior selectively, not page-for-page.
- New product UI decisions target Raven Studio first.
- Decorative patterns from Raven V1 are not defaults.

## DEC-0003 - Raven Is Headless-First

Date: 2026-07-11
Status: accepted

Decision:
Treat the semantic Raven MCP as a primary product surface. Raven Studio, MCP, and future clients share application/domain commands and queries.

Consequences:

- Core financial logic does not live only in Vue pages or MCP handlers.
- Generic Surreal MCP remains diagnostic tooling.
- Commands require validation, provenance, idempotency, and explainability.

## DEC-0004 - Initial Raven Studio UI Is Data-First And Minimal

Date: 2026-07-11
Status: accepted

Decision:
Prioritize a fast, dense, robust, GitHub/ChatGPT-like interface before visual richness.

Consequences:

- Prefer compact navigation, tables, lists, drawers, split views, and inline editing.
- Avoid gradients, glow, large heroes, card-heavy dashboards, and nonessential animation.
- Start with system fonts and system-aware theme behavior.

## DEC-0005 - Present Control Is The Next Product Slice

Date: 2026-07-11
Status: accepted

Decision:
Build balance freshness, upcoming obligations, recurring commitments, base monthly cost, coverage gap, and required daily/hourly earning rates before expanding buckets.

Consequences:

- Obligations and balance semantics precede the next Elgiz implementation.
- The first complete slice must work through both UI and MCP.

## DEC-0006 - Orbit Executes Work; Raven Owns Financial Meaning

Date: 2026-07-11
Status: accepted

Decision:
Raven owns financial facts, calculations, obligations, targets, and recommendations. Orbit owns projects, tasks, time, sequencing, and execution.

Consequences:

- Raven may create or link financial actions in Orbit.
- Raven may consume work-capacity and expected-income context.
- Raven does not grow a second general-purpose project manager.

## DEC-0007 - Product Terminology

Date: 2026-07-11
Status: proposed

Proposal:
Use Area for Today/Ledger/Plan/Earn/Review, Financial Space for Personal/Business/Trading/Family, and Account for real-world financial accounts. Retire Environment from user-facing financial navigation over time.

## DEC-0008 - AI-Safe Is The Default Share Archive

Date: 2026-07-11
Status: accepted

Decision:
`pnpm zip` and `pnpm zip:ai-safe` use a fail-closed privacy profile. The prior broad behavior remains only as `pnpm zip:developer-unsafe` and is not for external sharing.

Consequences:

- Private financial paths and local configuration are excluded by policy.
- Private Markdown frontmatter is honored.
- Remaining selected text is scanned for high-confidence secret signatures.
- Archive creation aborts when a secret remains.
- Archive-policy changes require focused tests and a dry run.

## DEC-0009 - Full Orchestrator Outputs Trigger A Brainkeeper Sidecar

Date: 2026-07-11
Status: accepted

Decision:
When a full orchestrator output is supplied, run a Brainkeeper sidecar for raw preservation and durable distillation while the main workline proceeds separately. If no sidecar is available, queue the source in `CAPTURE_QUEUE.md` and complete a Brain Checkpoint before handoff.

Reason:
The orchestrator carries high-value project context that should remain traceable without interrupting or contaminating the implementation workline.

Operating clarification:
Michael clarified on 2026-07-29 that the local Codex agent is Raven's primary solution developer. Full master-orchestrator responses must be read completely and their implementation prompts processed as priority on the primary workline while a Brainkeeper sidecar ingests them in parallel without duplicating implementation.

## DEC-0010 - Account Control Foundation Scope

Date: 2026-07-11
Status: accepted

Decision:
Define Raven's first complete product slice as a daily Account Control Foundation spanning observed accounts and transactions, explicit balance freshness, accepted upcoming cashflows, present position, coverage, and immediate earning requirements across Today, Accounts, Account detail, and Upcoming.

Acceptance:
Michael approved the bounded Account Control contract through the attached approval-and-execution instruction on 2026-07-11.

## DEC-0011 - Exact Money And Transaction Truth

Date: 2026-07-11
Status: accepted

Decision:
Use validated integer minor units for canonical money, positive transaction magnitudes, separate transaction kind and flow direction, one linked two-leg aggregate for tracked-account transfers, append-only monetary corrections, and idempotent provenance-backed semantic commands.

Acceptance:
Explicitly approved through the user's attached approval-and-execution instruction on 2026-07-11.

## DEC-0012 - Account Balance Snapshot Truth

Date: 2026-07-11
Status: accepted

Decision:
Represent account balance evidence as immutable `AccountBalanceSnapshot` records with balance kind, economic nature, exact amount, as-of time, recorded-at time, evidence level, source, and deterministic freshness. Unknown is never zero; stale liquid cash makes coverage provisional.

Binding clarification:
Select the first fresh eligible snapshot through the account's kind-preference chain. Only if none are fresh may Raven select the newest eligible stale observation, using kind preference as a stale tie-breaker. Invalid-future and excluded informational snapshots remain ineligible.

Acceptance:
Explicitly approved with the binding clarification through the user's attached approval-and-execution instruction on 2026-07-11.

## DEC-0013 - Neutral Upcoming Cashflow Model

Date: 2026-07-11
Status: accepted

Decision:
Use `CashflowSchedule` plus `CashflowOccurrence` for both outgoing and incoming accepted plans. Preserve direction-specific certainty, deterministic occurrence generation, frozen settled history, and explicit transaction reconciliation. Only confirmed future incoming counts toward coverage.

Binding clarification implemented in Workline 03:
Occurrence identity is `S($schedule, $scheduledDueOn)`. Effective `dueOn` and `amountMinor` may be overridden without changing immutable nominal date or scheduled amount. Audited commands cover skip, waive, cancel, one-occurrence amount override, and one-occurrence due-date override.

Acceptance:
Explicitly approved with the deferred correction through the user's attached approval-and-execution instruction on 2026-07-11.

## DEC-0014 - Account Control Calculation Contract

Date: 2026-07-11
Status: accepted

Decision:
Calculate per currency with exact minor-unit arithmetic; exclude transfers from income, outflow, and net; include committed outgoing and only confirmed non-overdue incoming in coverage; make unknown liquid cash block coverage; make stale inputs provisional; and round required earning rates upward while exposing every input and formula version.

Acceptance:
Explicitly approved through the user's attached approval-and-execution instruction on 2026-07-11.

## DEC-0015 - Scoped Import Identity And Immutable Replay

Date: 2026-07-12
Status: accepted

Decision:
Persist scoped identities for StatementImport (account + key), StatementRow (import + row key), Transaction (account + key), Category/Merchant/ClassificationRule (Financial Space + key), and ClarificationTask (transaction + key). Statement imports use checksum-backed ensure-or-conflict writes inside one transaction. Exact replay preserves source records and `importedAt`; changed immutable source evidence returns a stable conflict and rolls back; reviewed meaning moves only through an explicit checksum-gated path.

Consequences:

- Local keys remain the UI/MCP contract and may repeat across Financial Spaces.
- Source corrections require a new replacement/correction identity and later lineage rather than mutation.
- Existing private records may require a separately approved composite-ID migration.
- No private record audit or migration was run in Workline 02.

## DEC-0016 - Statement Truth Source Authority And Ordered Worklines

Date: 2026-07-29
Status: accepted
Source: RAVEN-INGEST-0020

Decision:
Accept the Raven Statement Truth, Import and Reconciliation Contract v0.1 with these eight authorities:

1. Original evidence SHA-256 and canonical extraction SHA-256 are distinct.
2. Adapter detection is advisory; target Account and exact profile/version confirmation are explicit.
3. `StatementRowComponent` preserves zero, one, or many neutral exact source components per printed row.
4. Preview is write-free; atomic source commit reopens and revalidates evidence and creates no `Transaction` or component disposition.
5. Later matching is audited and never silently confirmed.
6. `StatementIssue` and `StatementReconciliation` remain separate authorities.
7. Private sources use opaque vault references; `ST-01` is ZAR-only, GBP requires later approval, and there is no FX.
8. `ST-01` source preview/commit, `ST-02` matching/reconciliation, `ST-03` management meaning, and `ST-04` private Historian operation are separate gated worklines.

Binding clarifications:

- Original bank evidence, optional normalized-JSON/OCR assistance, and canonical Raven extraction use separate identities.
- MCP path intake is confined to configured roots or exact connector mounts with canonical containment, file/type/size validation, owner-only atomic staging, and path redaction.
- Components explicitly distinguish `movement` from `informational_breakdown`, preserve exact signed effects, and retain distinct printed transaction/posting/value dates without invention.
- Blocking preview issues produce no financial write; changed sources for occupied Account/periods are blocked in `ST-01`; closing-balance snapshots require deterministic sign and economic-nature mapping.

Consequences:

- `ST-01` is authorized for implementation and must remain in review pending external artifact acceptance.
- `ST-02`, `ST-03`, `ST-04`, private ingestion, and tax persistence are not authorized by this decision.
- The future Historian must use accepted semantic operations rather than generic database writes.

## DEC-0017 - Authorize ST-02 Provisional Matching And Exact Reconciliation

Date: 2026-08-04
Status: accepted
Source: RAVEN-INGEST-0023

Decision:
Accept final external closure of source-only ST-01 and authorize one separate bounded ST-02 main workline to resolve immutable statement movement components against provisional Transactions, explicitly materialize unmatched movements once, and prove exact Account-period reconciliation before private statement operation.

Binding boundaries:

- A confirmed source match makes an existing provisional Transaction statement-backed without creating another Transaction.
- Unmatched source movement becomes exactly one imported Transaction only through an explicit audited materialization command.
- Informational components remain non-movement and outside movement totals.
- Matching, source supersession, attestation, and reopening preserve immutable source truth and append-only history under transactional uniqueness, idempotency, and optimistic concurrency.
- Reconciliation uses checked integer minor-unit arithmetic, requires complete source/disposition/issue/claim authority and an exact zero difference, and remains independent of management and tax meaning.
- ST-02 remains ZAR-only with no FX and must use fictional fixtures plus disposable isolated database verification.

Consequences:

- ST-02 may begin as the next Past / Historian implementation workline.
- ST-02 remains in progress or review until external artifact acceptance; this authorization cannot mark it done.
- Private statement ingestion, ST-03 management meaning, ST-04 Historian operation/backfill, tax persistence, Workline 04, Elgiz, buckets, and Earn remain outside this authorization.

External-review closeout clarification:

`RAVEN-INGEST-0024` accepts the implemented ST-02 architecture as the closeout foundation but withholds overall acceptance. The existing authorization now requires one bounded closeout proving server-derived match evidence, cross-space transfer review, concurrency-safe reconciliation, one active source-authority projection, authoritative period placement, transactionally bound source replacement, readable superseded history, exact attestation-set coherence, and stable repository errors. This clarification does not widen ST-02 or authorize any later lane.

Final status:

`RAVEN-INGEST-0025` records external acceptance of the completed closeout. ST-02 is done for its bounded purpose; its architecture is not reopened.

## DEC-0018 - Accept ST-02 And Authorize HP-00 Controlled Pilot Readiness

Date: 2026-08-08
Status: accepted
Source: RAVEN-INGEST-0025

Decision:
Accept ST-02 Matching and Exact Reconciliation as externally reviewed and complete, and authorize one bounded Historian HP-00 Controlled Private Statement Pilot Readiness workline before any private statement is opened.

Binding boundaries:

- HP-00 is operational-readiness and runbook work, not another financial schema or architecture cycle.
- Verify semantic MCP, private-vault safety, and aggregate-only legacy compatibility without exposing private source details.
- The aggregate audit may report only counts and compatibility classes and may perform no write, replay, migration, replacement, or reconciliation.
- Define a recent closed ZAR multi-account selection protocol without choosing or revealing the real period or Accounts.
- Historian writes use only accepted semantic Raven MCP operations and require explicit Michael approval at every financial mutation gate.
- Check the user-managed Studio endpoint without starting a replacement development server.
- Leave HP-00 in review and stop before opening, previewing, or ingesting the first private statement.

Consequences:

- The ST-01/ST-02 implementation and acceptance sequence is closed.
- The controlled private pilot remains pending HP-00 readiness evidence and explicit end-state authorization.
- ST-03 management meaning, Tax & Transaction Meaning, Elgiz, Workline 04, Earn, and bulk historical backfill remain outside this authorization.

## DEC-0019 - Accept HP-00 And Establish HP-01 Schema Deployment Gate

Date: 2026-08-09
Status: accepted
Source: RAVEN-INGEST-0026

Decision:
Accept HP-00 as a correct, complete fail-closed readiness gate and establish HP-01 Accepted Statement Truth Schema Deployment and Readiness Recheck as the next bounded operational gate. This decision records the governing workline boundary; the Brainkeeper ingest does not execute HP-01.

Binding boundaries:

- Verify a private restorable recovery point and redacted configured-target fingerprint before schema apply.
- Use canonical MPDG validation/generation and Raven's accepted schema importer; stop on any destructive, row-changing, migration, replay, copy, or backfill plan item.
- Apply schema definitions only and prove all nine accepted Statement Truth tables are empty afterward.
- Prove every pre-existing aggregate table count is unchanged and rerun `pnpm historian:readiness` with schema readiness separate from legacy compatibility and pilot authorization.
- Do not access a private statement, inspect row bodies, migrate legacy imports, run semantic financial commands, start later lanes, start Studio, commit, merge, or push.

Consequences:

- HP-00 is accepted and complete; its fail-closed outcome is progress, not a product failure.
- At this decision point, HP-01 was unexecuted pending the primary workline's use of the exact governing prompt; `DEC-0020` records its later completion and acceptance.
- Successful HP-01 still does not authorize the first private source. HP-02 must privately establish selected-period compatibility first.
- Bulk migration of the 38 aggregate-level unmappable legacy imports is not authorized as a shortcut.

## DEC-0020 - Accept HP-01 And Authorize HP-02 Private Selection

Date: 2026-08-09
Status: accepted
Source: RAVEN-INGEST-0027

Decision:
Accept HP-01 Canonical Schema Deployment as externally reviewed and complete, and authorize HP-02 Private Selection and Compatibility as the next bounded local-private operator gate. This decision records authorization only; the Brainkeeper ingest does not execute HP-02.

Binding boundaries:

- Retain the verified private recovery artifact through HP-02 and acceptance of the first private pilot.
- Use only the configured Raven database and semantic Raven MCP after readiness passes; do not create a parallel environment or replacement development server.
- Privately select one recent complete closed ZAR period and the full interacting-Account set, and obtain Michael's explicit approval before the selected-period compatibility pass.
- Classify the exact set as one of the five prescribed compatibility outcomes; only `clean_for_first_preview` may proceed.
- Treat HP-02 authorization as distinct from source authorization. After a clean result, obtain the exact separate explicit approval before staging one source and running write-free preview/validation.
- Keep private Account, period, source, value, balance, path, hash, and record details out of Brain, Orbit, Git, normal logs, screenshots, fixtures, and external artifacts.
- Stop before source commit, matching, materialization, reconciliation, attestation, migration, replay, classification, tax meaning, later lanes, or bulk backfill.

Consequences:

- HP-01 is accepted and done; configured schema parity is no longer the active gate.
- HP-02 is authorized but remains unexecuted until a separate controlled operator session begins.
- The first private source remains unopened and unstaged.
- No-write preview and all write authority remain behind their own explicit gates.

## DEC-0021 - Accept HP-02 And Establish HP-03 Legacy Authority Crosswalk

Date: 2026-08-10
Status: accepted
Source: RAVEN-INGEST-0028
Governing execution contract: RAVEN-INGEST-0029

Decision:
Accept HP-02 Private Selection and Compatibility as complete with the fail-closed result `legacy_overlap_confirmed`, and establish HP-03 Selected-Period Legacy Authority Crosswalk and Resolution Contract as the next bounded gate. This Brainkeeper ingest records the decision but does not execute HP-03.

Binding boundaries:

- Limit HP-03 to the already selected complete Account/period set and one original source.
- Obtain Michael's explicit approval before opening or staging that source.
- Run at most one canonical ST-01 write-free preview and compare it privately against relevant legacy statement/import/Transaction evidence.
- Classify each relevant canonical component and legacy Transaction using the prescribed adoption, materialization, historical-only, transfer-review, informational, or ambiguous/conflicting classes.
- Produce a private owner-only exact crosswalk and a public aggregate-only contract; keep private facts out of Brain, Orbit, Git, logs, screenshots, fixtures, and AI-safe archives.
- Preserve source facts and existing meaning. Do not rewrite amount, flow, Account, currency, date, source evidence, Category, Merchant, management meaning, or tax meaning to force a fit.
- Stop without canonical source commit, financial mutation, compatibility apply, matching/adoption, materialization, reconciliation, attestation, bulk migration, management classification, tax classification, or a second period.

Consequences:

- HP-02 is accepted and done; its fail-closed stop is not a failed pilot.
- At this decision point, HP-03 was the next gate and remained unexecuted.
- Source staging and write-free preview require an explicit in-session approval.
- Any later compatibility implementation/apply and first canonical source commit require separate authorization and acceptance.

Later status:

`RAVEN-INGEST-0030` records HP-03 as externally accepted/done, accepts the resulting
six-decision bridge under `DEC-0022`, and authorizes fictional-only HP-04 under
`DEC-0023`. It does not retroactively widen `DEC-0021`.

## DEC-0022 - HP-03 Compatibility Bridge

Proposed: 2026-08-10
Accepted: 2026-08-11
Status: accepted
Source: RAVEN-INGEST-0030

Decision:
Accept HP-03 as an externally reviewed, complete, successful fail-closed workline and
accept its Strategy D outcome plus the six-decision compatibility bridge:

1. Add append-only `StatementLegacyResolution` and
   `StatementLegacyResolutionItem` records as the compatibility audit boundary.
2. Add `preview_legacy_statement_resolution` as the deterministic, side-effect-free
   crosswalk operation. Preview persists no resolution or item record.
3. Add `apply_legacy_statement_resolution` as the only guarded selected-source apply
   surface, with atomic commit and no force, tolerance, skip-conflict, best-effort,
   bulk, or generic override path.
4. Activate adopted legacy Transactions only through canonical confirmed matches and
   active component/Transaction claims; unclaimed legacy Transactions remain
   historical-only and retain their existing facts and meaning.
5. Block apply while any transfer-review or ambiguous/conflicting item remains. A
   client acknowledgement, free text, boolean, or supplied classification cannot
   release a blocker; the server must re-derive exact typed non-blocking evidence.
6. Keep fictional implementation acceptance, private re-preview, exact apply-intent
   approval, and private apply as separate gates.

Binding clarifications:

- Add `reverse_legacy_statement_resolution` as a distinct semantic command rather
  than an Apply mode; preview, apply, and reverse have distinct schemas, errors,
  idempotency identities, receipts, and authority meaning.
- Resolution events identify apply versus reversal, exact target or predecessor,
  operation/request identity, evidence and crosswalk hashes, and authority effect.
- Reversal releases only authority created by its exact target and fails when later
  dependent authority makes reversal unsafe.
- Transfer resolution preserves transfer semantics and requires exact counterpart
  evidence plus a typed reviewed outcome. The bridge does not auto-create an
  `AccountTransfer` without a separately supported exact semantic path satisfying
  existing transfer invariants.
- Apply and reversal bind the exact target database fingerprint, Account context,
  staged-source identities, canonical preview, legacy evidence, crosswalk,
  reconciliation, and active claim/revision set. The bridge remains
  selected-source-only.
- Exact crosswalk output remains confined to a controlled local private session;
  Brain, Orbit, logs, fixtures, screenshots, and AI-safe archives receive only
  fictional or aggregate-safe content.

Evidence boundary:

- The owner-only crosswalk covers every relevant canonical and legacy item.
- Brain stores aggregate classes and gate state only.
- HP-03 created no FinancialOperation and performed no financial database write.

Consequences:

- HP-04 may implement the compatibility bridge using fictional fixtures and a
  disposable database.
- Implementation acceptance does not authorize private apply.
- The first canonical source commit remains blocked until a fresh semantic preview has
  no unresolved transfer/conflict class and Michael explicitly approves the exact
  selected-source apply intent.

Acceptance:

The two overlapping external acceptance texts and the governing HP-04 authorization
preserved in `RAVEN-INGEST-0030` approve the same six decisions. They are represented
once here rather than as duplicate decision records. External acceptance covers the
aggregate contract and no-write outcome, not independent review of the excluded
owner-only row-level proof.

## DEC-0023 - Authorize HP-04 Fictional Compatibility Bridge

Date: 2026-08-11
Status: accepted
Source: RAVEN-INGEST-0030

Decision:
Authorize one HP-04 Selected-Period Resolution Implementation workline for fictional
implementation and external review through Phases A-H only.

Authorized boundary:

- Architecture confirmation, schema additions, deterministic domain planner,
  no-write preview, guarded apply and reversal, Studio/tRPC/MCP parity, fictional
  verification, and AI-safe external-review packaging.
- Fictional fixtures and an isolated disposable Surreal database only.
- A 31-operation paired Statement Truth catalog: the accepted 28 plus preview, apply,
  and reverse legacy resolution.
- HP-04 remains in review after implementation until separately externally accepted.

Explicit prohibitions:

- Do not execute Phase I private re-preview or Phase J private apply.
- Do not reopen or read the owner-only HP-03 crosswalk.
- Do not open, stage, read, or process a private source.
- Do not access or use the configured private Raven database.
- Do not ask for or execute private apply approval, commit the canonical source, or
  change active private ledger authority.
- Do not reinterpret or weaken Strategy D, the transfer-review blockers, or the
  ambiguous/conflicting blocker.
- Do not treat implementation or test success as authority for any private operation.

Consequences:

- HP-03 is accepted and done; HP-04 fictional implementation is the next workline.
- Private re-preview, exact blocker resolution, selected-source apply approval,
  canonical source commit, and first reconciled private pilot remain separate later
  gates.
- This Brainkeeper ingest records authorization but does not implement HP-04 or modify
  Orbit.

## DEC-0024 - Accept HP-04 Foundation And Authorize Separate HP-04A Closeout

Date: 2026-08-12
Status: accepted
Source: RAVEN-INGEST-0031

Decision:
Accept HP-04's fictional architecture and implementation as the correct foundation,
while keeping selected-source readiness and private authority behind the separate
HP-04A Selected-Source Activation Closeout.

HP-04A authorized boundary:

- Support the known old-renderer period/context shape through a selected-source-only
  immutable derived binding.
- Preserve eligible statement-closing balance snapshot semantics.
- Resolve transfer-review and ambiguous/conflicting items only through exact,
  server-derived, operator-selected dispositions.
- Complete the full fictional verification matrix before requesting permission to
  reopen any owner-only evidence.
- Preserve private re-preview, each reviewed item decision, exact apply approval,
  reconciliation, and attestation as distinct later controlled gates.

Separation:

- HP-04A is a Historian closeout, not Financial Read Analytics RA-00.
- RA-00 does not execute or inherit HP-04A's source, crosswalk, database, apply,
  reconciliation, or attestation authority.
- Foundation acceptance does not itself authorize a private source, configured
  private database, canonical source commit, or active private authority change.

## DEC-0025 - Authorize Financial Read Analytics RA-00

Date: 2026-08-12
Status: accepted
Source: RAVEN-INGEST-0031

Decision:
Authorize one bounded read-only Financial Read Analytics RA-00 vertical in its
isolated worktree.

Required surface:

- exact per-currency period financial summaries;
- exact category and Merchant spend summaries;
- exact fee summaries;
- exact monthly financial trends;
- uncategorized Transaction reads;
- financial data-quality summaries;
- shared semantics across Domain, Surreal repository, tRPC, semantic MCP, and minimal
  Raven Studio.

Required invariants:

- use exact integer minor-unit money and never convert or merge currencies;
- exclude transfers from income, outflow, spend, fee, Category, Merchant, and trend
  totals;
- separate existing canonical statement-backed, manual provisional, legacy
  unreconciled, unresolved, and excluded authority concepts rather than presenting a
  silently combined total;
- use fictional fixtures only and leave the workline in external review;
- remain read-only and preserve one shared Domain calculation contract across clients.

Explicit exclusions:

- no tax meaning, management classification, budget model or write, import, matching,
  reconciliation, attestation, source commit, migration, correction, or bulk
  backfill;
- no private source, owner-only crosswalk, configured private database, private
  fixture, or private financial record;
- no HP-04A implementation or Historian operation;
- no generic Surreal write.

Parallel condition:

RA-00 may proceed beside HP-04A only while the files actually edited by the two
isolated worktrees remain disjoint. A file-set collision ends valid parallel execution
until the work is sequenced or deliberately integrated.

## DEC-0026 - Emergency Intake Uses A Filesystem-Native Source Index

Date: 2026-08-17
Status: accepted
Source: RAVEN-INGEST-0035

Decision:
For the proposed Emergency Statement Intake lane, Phase C must use an owner-only,
rebuildable, filesystem-native deterministic JSON/NDJSON index with bounded local
query/report commands.

Supersession:

- This decision supersedes only the `DuckDB or equivalent embedded database`
  requirement in the otherwise byte-identical orchestrator packet preserved by
  `RAVEN-INGEST-0034` and `RAVEN-INGEST-0035` SOURCE-01.
- The separately preserved `RAVEN-INGEST-0035` SOURCE-02 user addendum has precedence
  wherever that Phase C requirement conflicts with the packet.
- No second database or new canonical Raven schema model may be added for this lane.
- No canonical Raven financial write is authorized.

Boundary:

- The filesystem index remains provisional source-only evidence infrastructure, not
  active ledger authority.
- Bounded local query/report commands may read the rebuildable private index only.
- All non-conflicting privacy, provenance, exact-money, uncertainty, reporting, and
  later canonical-activation boundaries remain unchanged.
- This decision does not authorize execution, private source access, or an operational
  result.

## DEC-0027 - Normal/Tax Lens Uses Sparse Live Inheritance

Date: 2026-08-26
Status: accepted
Source: RAVEN-LIVE-0001

Decision:
Raven's ordinary management interpretation is the Normal default. Tax mode uses a
separate Financial-Space-scoped `TaxCategory` hierarchy and an append-only,
revisioned `TransactionTaxDeclaration`. The effective Tax description and category
each use the explicit declared value when present and otherwise inherit the current
Normal value.

Boundary:

- A declaration never rewrites the statement-backed Transaction or changes monetary
  totals.
- Returning to Normal inheritance supersedes the current declaration and stores no
  copied Normal values.
- The baseline is a working reporting lens only. It does not determine deductibility,
  VAT, taxpayer/entity, exact allocation, professional review, workpapers, or filing.
- The broader Tax Treatment contract and shared domain/read-model/MCP operations
  remain open under `OL-0027`.
