# Risk Register

## RISK-0001 - Private Financial Material Exposure

Status: active

Raven contains or may reference private financial documents, statements, mail exports, and operational dossiers. The Brain must not ingest, expose, or summarize this material by default.

## RISK-0002 - Dirty Worktree Separation

Status: active

The repo has pre-existing uncommitted changes. Brain installation and future Brain updates should remain easy to distinguish from unrelated app or financial-source work.

## RISK-0003 - Vision Not Yet Backfilled

Status: closed

The July 2026 reinstatement review and direction package has been ingested and active Brain files now reflect current product reality.

## RISK-0004 - Prototype Folder Contains Private Source Material

Status: active

The referenced Buckets Lab prototype folder contains app code as well as private financial source material. Use it selectively as an implementation reference; do not bulk-ingest or summarize private statement PDFs, exports, credentials, or operational documents.

## RISK-0005 - Unsafe Repository Sharing

Status: reduced

`pnpm zip` is now fail-closed and AI-safe by default. Residual risk remains if a user deliberately runs and shares the explicitly named `zip:developer-unsafe` profile.

## RISK-0006 - Fragmented Product Authority

Status: reduced

Current product authority is now indexed, but historical UX documents remain in the repo and must stay labeled as reference unless promoted explicitly.

## RISK-0007 - Domain Logic Duplication

Status: reduced

The shared `AccountControlApi` and domain service now own 30 Studio/tRPC/MCP operations. Residual risk is regression or future bypass through raw generated CRUD; semantic financial behavior must continue to route through the shared service.

## RISK-0008 - Inexact Money Arithmetic

Status: closed

Exact integer minor-unit money is accepted and implemented across Worklines 01 and 02. Residual legacy risk is bounded to audit-reported unsupported precision/range/date conflicts and canonical conflicts; no unsafe row is silently promoted.

## RISK-0009 - Financial Certainty State Collapse

Status: active

Observed transactions, accepted future cashflows, inferred recurring suggestions, and possible opportunities can produce misleading coverage or earning figures if silently converted, combined, or treated as equally certain.

## RISK-0010 - Stale Balance Kind Masks Fresher Evidence

Status: closed
Source: RAVEN-INGEST-0005

Freshness-first selection is implemented and covered by fixed-clock tests: Raven searches preferred kinds for fresh eligible evidence first, then falls back to the newest eligible stale observation with kind preference only as a tie-breaker.

## RISK-0011 - Workline 01 Command And Evidence Integrity

Status: closed
Source: RAVEN-INGEST-0006

The bounded hardening is complete: dialog intents retain retry-stable keys, notes round-trip through snapshot persistence, and Account records use composite `stringID(space, key)` identity with stable duplicate errors. Focused and live verification pass.

## RISK-0012 - Invalid Future Evidence Collapses To Unknown

Status: closed
Source: RAVEN-INGEST-0007

Future-dated balance evidence remains unselected and uncounted, while account freshness now exposes `invalid_future`, the newest offending observation time, a stable warning, and separate current-position metadata. Fixed-clock regressions and the full Workline 01 verification matrix pass.

## RISK-0013 - Imported Defaults And Scope Leakage Distort Financial Truth

Status: closed
Source: RAVEN-INGEST-0009

Workline 02 hardening removed economically meaningful generated defaults, requires complete coherent canonical authority, preserves unresolved imported evidence, prevents partial migration overwrite, isolates explicit empty scopes, applies Johannesburg-local month cutoffs and ignored-status exclusion, and closes concurrent first-write replay races. Fictional regression, live smoke, and build evidence pass. Residual legacy exceptions remain aggregate-auditable and unapplied.

## RISK-0014 - Imported Record Identity Collision Or Source Rewrite

Status: closed
Source: RAVEN-INGEST-0010

Scoped composite identities, deterministic source checksums, atomic ensure-or-conflict writes, checksum-gated review, and idempotent source links now prevent cross-space overwrite and mutable import replay. Consecutive fictional live smokes prove exact replay, conflict rollback, reviewed meaning, and cleanup. Residual existing-record migration risk is deferred in `OL-0022`; no private audit or migration was run.

## RISK-0015 - Cashflow Lifecycle, Reconciliation, And Presentation Integrity

Status: closed
Source: RAVEN-INGEST-0011, RAVEN-INGEST-0012, RAVEN-INGEST-0014, RAVEN-INGEST-0016

The final closeout prevents paused schedules from creating or re-exposing due rows after `pausedOn` when ended or cancelled, terminalizes only mutable due gap rows, and preserves terminal occurrence history. One shared eligibility rule governs reads and summaries; configured/effective/pending lifecycle truth uses explicit schedule-local `asOf`; Studio term and lifecycle action state is separate and retry-stable. Focused tests, production build, schema checks, adapter parity, and disposable fictional live smoke pass. Workline 03 is complete; Workline 04 remains unstarted.

## RISK-0016 - Parallel Worktree Authority Collision

Status: active
Source: RAVEN-INGEST-0013, RAVEN-INGEST-0015, RAVEN-INGEST-0031

Past, Elgiz, and Account Control work can all touch shared schema/domain/MCP authority. Concurrent edits in one root or nested schema worktree risk overwritten changes, conflicting generation, and unverifiable merges.

The Data Atlas lane demonstrated the mitigation: its stale isolated branch was integrated surgically, shared authority files were merged additively, and current main was regenerated and verified without using the isolated lockfile or wholesale branch content. The broader risk remains active for future schema/domain/MCP lanes.

RA-00 may proceed beside HP-04A only while their actual edited file sets remain disjoint. Isolation by worktree name is insufficient if both lanes edit the same schema, Domain, repository, tRPC, MCP, Studio, generated, or package file.

## RISK-0017 - Historian Bypasses Semantic Import Invariants

Status: active
Source: RAVEN-INGEST-0013, RAVEN-INGEST-0019, RAVEN-INGEST-0020, RAVEN-INGEST-0021, RAVEN-INGEST-0022, RAVEN-INGEST-0025, RAVEN-INGEST-0026, RAVEN-INGEST-0027, RAVEN-INGEST-0028, RAVEN-INGEST-0030, RAVEN-INGEST-0031

A statement operator or generic database writer could bypass original-byte identity, deterministic preview/commit, immutable evidence, row-component truth, provisional matching, exact reconciliation, issue handling, provenance, privacy, and idempotency rules. `DEC-0016` and externally accepted ST-01/ST-02 establish the semantic boundary and complete its source and resolution operations. HP-00 proves that the dedicated Historian can reach the semantic catalog without raw Surreal writes and that private vault/source detail remains contained.

HP-01 closes deployment parity with a verified additive schema deployment and aggregate count invariance. HP-02 is externally accepted after confirming selected-period legacy overlap and stopping before source access. HP-03 is externally accepted after a write-free comparison, and its six-decision bridge is accepted. HP-04's fictional foundation is externally accepted. HP-04A remains a separate selected-source closeout with explicit private permission and apply gates; RA-00 has no Historian or write authority.

## RISK-0018 - Virtual Buckets Masquerade As Real Money

Status: proposed
Source: RAVEN-INGEST-0013

Mutable bucket balances or simulation writes can make planned allocation appear to be observed cash, a physical account balance, or accepted settlement. Elgiz must preserve a structural truth boundary before persistence or UI integration.

## RISK-0019 - Tax Meaning Collapses Truth, Authority, Or Privacy Boundaries

Status: proposed
Source: RAVEN-INGEST-0017

A future Tax & Transaction Meaning layer could mutate observed Transaction truth, overload Category with accounting/tax/legal meaning, treat `FinancialSpace` as a legal taxpayer, leak restricted Ground Zero evidence, or promote an AI/user proposal into professional review or filed truth. The lane must remain architecture-gated, exact-allocation based, versioned or append-only above immutable facts, role-authorized, and limited to opaque evidence references before any implementation or private pilot.

## RISK-0020 - Provisional And Statement Evidence Double Count One Movement

Status: mitigated and externally accepted; private compatibility gate active
Source: RAVEN-INGEST-0018, RAVEN-INGEST-0019, RAVEN-INGEST-0020, RAVEN-INGEST-0023, RAVEN-INGEST-0024, RAVEN-INGEST-0025

Accepted source-only `ST-01` creates no `Transaction`. Externally accepted ST-02 implements audited existing-Transaction matching, explicit one-shot materialization, component/Transaction claims, exact period proof, source replacement, issue handling, attestation, and reopening. Its closeout derives evidence server-side, discovers cross-space counterpart candidates, serializes aggregate changes, projects active statement authority by canonical financial date, excludes superseded authority from current truth, revalidates replacement claims/context, and proves exact claim sets at attestation. The bounded double-counting risk is closed in architecture and implementation. The selected legacy period still requires the separate HP-04A closeout and its exact private permission/apply gates before canonical authority can change.

## RISK-0021 - Private Pilot Starts Before Operational Boundaries Are Proven

Status: active operational gate
Source: RAVEN-INGEST-0025; updated by RAVEN-INGEST-0026, RAVEN-INGEST-0027, RAVEN-INGEST-0028, RAVEN-INGEST-0030, and RAVEN-INGEST-0031

Opening a real statement before semantic MCP reachability, private-vault containment, aggregate-only legacy compatibility, interacting-Account coverage, explicit approval gates, and AI-safe exclusions are proven could expose private material or duplicate legacy authority despite accepted ST-01/ST-02 semantics. HP-00 must fail closed, reveal only aggregate compatibility states, stop before the first private statement, and explicitly report any blocker to a no-write preview.

HP-00 failed closed as designed and is externally accepted. HP-01 preserved a verified recovery point, rejected destructive or row-changing schema plans, deployed the accepted schema additively, proved aggregate count invariance, and is externally accepted. Studio remains degraded at the last recorded HTTP check. HP-02 proved complete interacting-Account coverage, returned `legacy_overlap_confirmed`, stopped before source access, and is externally accepted. HP-03 is externally accepted and done with Strategy D still blocking canonical commit. HP-04's fictional foundation is externally accepted; HP-04A now owns the separate closeout and later private gates. RA-00 must not open the owner-only crosswalk, use a private source or configured private database, or change private ledger authority.

## RISK-0022 - Analytical Totals Collapse Currency Or Authority

Status: active
Source: RAVEN-INGEST-0031; sharpened by RAVEN-INGEST-0032 and RAVEN-INGEST-0033

Cross-currency addition, transfer leakage, incomplete pagination, or silent combination of canonical statement-backed, manual provisional, legacy unreconciled, unresolved, and excluded evidence can turn a read-only summary into a false financial claim. RA-00 must calculate once in shared Domain semantics, preserve exact minor units, group by currency, exclude transfers, disclose authority classes separately, and keep Studio and MCP from reconstructing totals independently.

## RISK-0023 - RA-00 Read Integrity, Scope, Time, And Scale Drift

Status: mitigated in RA-00B; external acceptance pending
Source: RAVEN-INGEST-0032, RAVEN-INGEST-0033

The six prior controls and current-main integration are externally accepted, and default active-ledger analytics are not implicated. RA-00B mitigates the optional legacy-inclusive defect with one bounded reverse `StatementTransactionMatch.transaction` projection after ST-02 clears `Transaction.statementMatch` and `effectiveAt`. Formerly canonical imported source-row Transactions remain historical, cleared manual/generated matches return to active provisional observation-date authority, and only genuine no-history renderer rows enter `legacy_unreconciled`. Focused and full regression suites pass; final external artifact acceptance is pending.

## RISK-0024 - Emergency Source Intake Leaks Or Masquerades As Canonical Truth

Status: contained in implementation; activation risk remains
Source: RAVEN-INGEST-0034, RAVEN-INGEST-0035

An urgent bulk source index could expose private evidence, execute unsafe historical artifacts, lose source provenance, combine currencies, or let provisional candidates and owner explanations masquerade as active ledger, management, accounting, tax, or legal truth. The implementation contains this risk through an owner-only deterministic JSON/NDJSON index outside Git, read-only database enforcement, approved stage/preview/validate calls only, checked minor units, explicit `provisional_source_only` authority, aggregate-safe handoff, archive exclusion, and before/after canonical count invariance. Activation risk remains: blocked mappings, extraction issues, legacy overlap, owner explanations, and candidate schedules cannot become canonical or accepted meaning without separate review and authorization.
