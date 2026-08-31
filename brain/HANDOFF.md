# Handoff

## Summary

Raven is a private financial operating system managed through Orbit project Financial Mastery. Raven Studio is the primary clean rebuild; Raven V1 is a behavioral reference. Account Control Worklines 01-03 are accepted and complete. The Generated Data Atlas is externally accepted, integrated into current main, verified, and complete.

## Current Direction

Preserve the current Penpot-derived Studio design and define the bounded Account Ledger operating loop: one recent month across relevant accounts, provisional current entries, immutable statement import, manual-to-statement matching, account-period reconciliation, exception handling, management classification, and semantic MCP support. Raven Studio now has the accepted bounded Normal/Tax lens from `DEC-0027`; full Tax Treatment and shared semantic MCP operations remain contract-gated.

`RAVEN-INGEST-0034` adds the urgent source-only reconstruction lane, and `RAVEN-INGEST-0035` is its governing Phase C correction. The primary operator has implemented and executed the corrected owner-only JSON/NDJSON intake under opaque reference `EI-2026-08-17-00`. Aggregate results are 462 inventory files, 386 unique source-evidence files, 257 previewed periods, 32 currently commit-eligible previews, 225 blocked previews, 47 legacy-overlap previews, 9,994 movement components, and 767 informational components. Canonical counts were invariant and no financial write occurred. The lane is not active Raven ledger authority and must not silently feed Account position, budgets, reconciled analytics, management meaning, tax meaning, accounting conclusions, or legal conclusions.

`RAVEN-INGEST-0031` preserves the HP-04 external review, the separate HP-04A prompt, and the governing RA-00 request. HP-04's fictional foundation is externally accepted. HP-04A is separately authorized under `DEC-0024` and is not being executed by RA-00. RA-00 remains governed by the fictional-only, read-only `DEC-0025` boundary. `RAVEN-INGEST-0032` records external acceptance of the RA-00 architecture and six bounded findings. `RAVEN-INGEST-0033` records acceptance of the resulting current-main integration, default active-ledger analytics, and seven operations plus authorization of the final RA-00B micro-closeout. RA-00B is now implemented and verified in current main.

## Accepted Decisions

- Raven Studio is the primary clean UX rebuild.
- Raven V1 remains a reference rather than the default new-UI surface.
- Raven is headless-first with UI/MCP command parity.
- Initial Studio UI is minimal, dense, and data-first.
- Present control is the next product slice.
- Raven owns financial meaning; Orbit owns work execution.
- Full orchestrator outputs trigger a Brainkeeper sidecar for raw preservation and durable distillation.
- Exact integer minor-unit money and transaction truth (`DEC-0011`).
- Immutable balance snapshots with freshness-first selection (`DEC-0012`).
- Neutral cashflow schedules and occurrences with the deferred occurrence-command correction (`DEC-0013`).
- Conservative per-currency Account Control calculations (`DEC-0014`).
- Workline 02 canonical transaction authority requires a complete, valid, coherent exact tuple; unresolved/default/sentinel semantics cannot invent expense, outflow, or transfer flow.
- Explicit empty account scope is empty, current-month cutoff uses `Africa/Johannesburg`, ignored/unresolved facts do not enter totals, and concurrent first-write races replay or conflict by request hash.
- Scoped import identity is account/import, import/row, account/transaction, space/category, space/merchant, space/rule, and transaction/task. Exact replay preserves `importedAt`; changed immutable evidence conflicts atomically; reviewed meaning cannot rewrite source truth.
- `DEC-0021` accepted HP-02 and established HP-03 as the next gate at that time; that decision did not itself authorize source staging, preview, compatibility apply, or financial writes.
- HP-03 is externally accepted/done and its six-decision compatibility bridge is accepted (`DEC-0022`).
- HP-04 is authorized only for fictional implementation and external review through Phases A-H (`DEC-0023`); implementation acceptance cannot confer private authority.
- HP-04's fictional foundation is externally accepted and HP-04A is a separate selected-source closeout with independent private gates (`DEC-0024`).
- RA-00 is authorized for exact per-currency, transfer-excluding, authority-separated financial reads only; tax, budgets, imports, reconciliation, writes, and private data are excluded (`DEC-0025`).
- Emergency intake Phase C uses deterministic filesystem-native JSON/NDJSON and bounded local query/report commands rather than DuckDB or another embedded database; execution remains separately gated (`DEC-0026`).
- Normal is the default transaction interpretation; Tax mode uses a separate hierarchy
  and sparse revisioned declaration with live field-level inheritance, without
  changing statement truth or monetary totals (`DEC-0027`).

## Decisions Still Open

- Final product terminology and generic Surreal MCP posture.

## Next Gate

Review the emergency intake blockers without disclosing private evidence. Michael must establish the unresolved tracked Account mapping where appropriate and approve any Account/profile metadata correction before a later canonical activation request. Extraction blockers and legacy-overlap periods remain explicit. Recipient/household schedules require exact owner-reviewed aliases. Do not commit, match, materialize, reconcile, attest, or otherwise activate the provisional index without a separate accepted ST-01/ST-02 or HP-04A gate.

Submit the final current-main RA-00B AI-safe artifact for external acceptance. The implementation derives immutable reverse `StatementTransactionMatch.transaction` history independently of the cleared active Transaction pointer, preserves default active-ledger byte/contract compatibility, and ensures optional legacy-inclusive totals contain only genuine renderer-era legacy rows. Verification used fictional fixtures, one bounded SELECT-only read, and zero financial writes or private-data access.

Keep HP-04A separate and unexecuted by RA-00. Any later parallel activity must still stop when actual edited file sets overlap.

HP-04A remains a separate authorized Historian closeout. RA-00 must not execute its old-renderer binding, snapshot, blocker-resolution, private re-preview, apply, reconciliation, or attestation steps. Pause concurrent work if either worktree's edited file set overlaps the other.

The working Normal/Tax lens baseline is implemented. The broader Tax & Transaction
Meaning lane remains open for entity, evidence, exact allocation, deductibility/VAT,
review authority, workpapers, filing semantics, shared read models/MCP, and a later
controlled private pilot.

Do not reopen ST-01/ST-02 architecture. Keep every further private source action and private re-preview/apply, plus ST-03 meaning, tax, Workline 04, Elgiz, Earn, buckets, and bulk backfill, unstarted until their explicit gates.

## Verification State

- Schema graph validation/spec/generation/import, generated authority inspection, focused domain/Surreal/MCP tests, package typechecks, production Studio build, archive-safety checks, and disposable live Surreal smoke passed.
- `RAVEN-INGEST-0008` preserves the exact Workline 02 implementation prompt verbatim.
- Whole-app Nuxt typecheck remains blocked by inherited generated Schema Kit and Helios errors outside the Account Control files.
- Final Workline 02 verification passes: 29 domain tests, 20 Surreal tests, two fictional statement-render tests, one 13-operation parity test, all focused package typechecks, Raven Studio production build, schema validation/generation/import, and consecutive fictional import live smokes. Archive and Brain-health evidence is recorded in the implementation note.
- The smoke proves transfer legs are excluded from income/outflow/net and movement commands do not change confirmed balance evidence. Fixtures were deleted in `finally` cleanup.
- No private migration audit/apply was run. Existing private records may require a later explicit composite-ID migration. Ambiguous legacy transfer flow, unsupported legacy precision/range/date rows, and formal append-only correction lineage remain deferred.
- Final Workline 03 verification passes: 58 domain tests, 24 Surreal tests, two MCP parity tests covering all 30 operations and lifecycle fields, three Studio intent tests, focused package typechecks, schema validation/spec/generation/dry-run import/live import, Raven Studio production build, two consecutive Atlas stale checks, nine Atlas tests, five archive-safety tests, and a disposable fictional live Surreal integrity smoke with cleanup.
- The final browser retry reached Nginx but returned `502 Bad Gateway` because the user-managed Raven Studio process was unavailable. No development server was started; the production build passed.
- External review accepted the canonical identities, immutable anchors, recurrence engine, operation catalog, adapter parity, and initial `/upcoming` surface as a base, but did not independently rerun the reported verification because the AI-safe archive excluded dependencies.
- Retry-stable action-scoped drawer intents, concurrent replay, paused-to-terminal lifecycle eligibility, monotonic materialization, atomic occurrence-history protection, canonical unique settlement evidence, certainty-separated summaries, schedule-timezone grouping, and explicit configured/effective/pending lifecycle truth are implemented and verified.
- Full Nuxt typecheck still reports inherited generated Schema Kit and Helios failures, but no Workline 03 Studio file remains in the filtered error set.
- No live private database state was established by `RAVEN-INGEST-0013`; the proposed Past audit and Elgiz workline were preserved but not run.
- `RAVEN-INGEST-0014` preserves the exact Data Atlas packet and authorization plus the separate Workline 03 closeout prompt; the Brainkeeper pass changed only `brain/**` and made no implementation claim.
- The follow-on `IMPLEMENTATION_CHECKPOINT-2026-07-13.md` records the main workline's Data Atlas outcome without creating another ingest. `RAVEN_SCHEMA_GRAPH_PATH` is the isolated-worktree fallback when `apps/schema` is not attached.
- `REVIEW_ARCHIVE_CHECKPOINT-2026-07-13.md` records the Atlas review artifact that was pending at that checkpoint; `RAVEN-INGEST-0015` records its later acceptance and integration.
- `RAVEN-INGEST-0015` preserves the external technical acceptance and safe integration prompt. Its main-integration checkpoint records the five-file transplant, additive authority merges, current-schema regeneration, required checks, and inspected primary-main AI-safe archive.
- `RAVEN-INGEST-0016` preserves the exact post-Atlas Workline 03 closeout prompt and its implementation checkpoint. The Atlas remains complete, Atlas checks remain in the verification matrix, and final packaging comes from current primary main.
- `RAVEN-INGEST-0017` preserves the external Tax & Transaction Meaning synthesis, proposed lane charter, and proposed architecture-only contract prompt. It creates no accepted decision, Workline, implementation, private-data claim, or Orbit status change.
- `RAVEN-INGEST-0018` preserves the Account Ledger orchestrator response and Michael's live direction. It identifies source-based MCP gaps but does not claim a fresh code audit, approve Tax vocabulary, inspect statements, or start implementation.
- `RAVEN-INGEST-0019` preserves six exact sources in one bounded packet: the master-orchestrator response, Statement Truth foundation, primary contract prompt, current-state review, dormant Historian starter, and attributable operating direction. This Brainkeeper pass did not verify the external repository/test claims or implement the embedded prompt.
- `RAVEN-INGEST-0020` preserves the four-source acceptance packet byte-for-byte, records all eight decisions and four binding clarifications, and authorizes the primary workline to execute `ST-01`. This sidecar did not implement, test, package, or accept `ST-01`, and it made no Orbit write.
- The main ST-01 workline extends canonical schema to `StatementRowComponent` and `StatementIssue`, adds the permissioned source vault, versioned adapters, pure preview, one-transaction source commit, exact replay, source reads, Studio routes, and fourteen equivalent tRPC/MCP operations. Domain 75/75, Surreal 26/26, MCP 3/3, Atlas 9/9, renderer 2/2, archive safety 5/5, strict graph validation, consecutive stale checks, and the Studio production build pass. No private data or live private database was used.
- The initial Nedbank current/credit, FNB business, and neutral profiles require a separate normalized JSON assistance artifact. Original evidence, assistance, and canonical extraction remain separately hashed; native bank-format extraction is future adapter work.
- `RAVEN-INGEST-0021` preserves three external-review sources byte-for-byte. The reviewer independently reports ZIP integrity, renderer `2/2`, archive safety `5/5`, and source inspection, but could not rerun dependency-backed tests. The review accepts ST-01's broad foundations, withholds overall acceptance, and requires one bounded closeout before private use. This ingest did not independently verify product claims or execute the closeout.
- The `RAVEN-INGEST-0021` implementation checkpoint records the completed integrity closeout: atomic source/period claims, strict extraction and coverage, honest legacy reads, replay before vault access, Account-scoped timezone-correct snapshots, complete runtime edges, retry-stable Studio intent, shared tRPC/MCP schemas, and fictional upload/live persistence proof. Domain `79/79`, Surreal `31/31`, MCP `5/5`, Studio UI `2/2`, Atlas `9/9`, renderer `2/2`, and archive safety `5/5` pass; focused typechecks, Studio build, schema generation/import, and disposable live smoke pass. External acceptance remains pending.
- `RAVEN-INGEST-0022` preserves the next three-source review packet byte-for-byte. The reviewer independently reports archive SHA-256 `956f179780506c7e8fa8d24c4aba14a3971d691c3f8e88915e4a7939d5b16f7d`, 2,603 ZIP entries, ZIP integrity, renderer `2/2`, and archive safety `5/5`; dependency-backed checks were not rerun. The prior integrity foundations are accepted, but overall ST-01 acceptance is withheld for four final source-authority blockers and precise commit errors. This sidecar did not execute or verify the authorized closeout.
- The `RAVEN-INGEST-0022` main implementation checkpoint closes those blockers with profile/account authority, exact source-kind coverage and row sequence, renderer-era/unmappable legacy protection, transactionally revalidated Account/Space context, and stable post-failure errors. Domain `83/83`, Surreal `32/32`, MCP `5/5`, Studio UI `2/2` plus cashflow UI `3/3`, Atlas `9/9`, renderer `2/2`, archive safety `5/5`, focused builds, strict graph validation, production Studio build, and the expanded disposable live smoke pass. No private source or configured private database was used.
- `RAVEN-INGEST-0023` preserves two sources byte-for-byte. The external review accepts ST-01 as done and attributes archive SHA-256 `7d306996a13659669eda095990ec0dadc2882283c8f321ab32d438cd2ac18ed5`, ZIP integrity, renderer `2/2`, archive safety `5/5`, and no prohibited private-path findings. The packet explicitly authorizes ST-02, but this Brainkeeper ingest does not implement it, rerun product verification, modify Orbit, or authorize private statements.
- `RAVEN-INGEST-0024` preserves three sources byte-for-byte. The external reviewer reports matching ST-02 archive SHA-256 `3a2b5bf6c12650aa9e9d34eaf428b081d1cb0c8c5b446b18dbb52f784bc250f9`, 2,776 entries, ZIP integrity, renderer `2/2`, archive safety `5/5`, and no prohibited private material. Dependency-backed checks were not independently rerun. The review accepts the implementation foundation but requires the bounded closeout before overall acceptance or private use. This sidecar did not execute it or modify Orbit.
- The bounded `RAVEN-INGEST-0024` closeout now passes Domain `98/98`, Surreal `40/40`, MCP `5/5`, Studio statement `4/4`, cashflow `3/3`, renderer `2/2`, Atlas `9/9`, two Atlas stale checks, strict schema generation/import, production Studio build, strict extraction-schema validation, and disposable ST-01/ST-02 live smokes. The extended ST-02 smoke includes independent and conflicting races, exact-set attestation, source/period and Account-context authority, active-ledger/snapshot supersession, replacement re-resolution, rollback, replay, and cleanup. No private data or configured private database was used.
- The fresh review artifact is `raven-st02-financial-integrity-closeout-2026-08-06-ai-safe.zip`; its final checksum must be reported from the regenerated archive at handoff.
- `RAVEN-INGEST-0025` preserves two sources byte-for-byte. The external reviewer reports accepted archive SHA-256 `6b379cd5eb5be7712bc2a1b95e36a8f279b1f5db22e8b2158735d766d904d2be`, 2,781 entries, ZIP integrity, renderer `2/2`, and archive safety `5/5`; dependency-backed suites and live smoke were not independently rerun from the AI-safe archive. ST-02 is accepted/done. HP-00 is authorized but was not executed by this sidecar, and no private statement was opened.
- The main HP-00 checkpoint is `brain/sprints/0026-historian-hp00-readiness/IMPLEMENTATION_CHECKPOINT-2026-08-08.md`. It records exact MCP/vault readiness, aggregate-only counts, the missing accepted database tables, Studio HTTP `502`, and the fail-closed pilot authorization result. No private source body or database write was used.
- `RAVEN-INGEST-0026` preserves the HP-00 acceptance/next-gate review and exact governing HP-01 prompt byte-for-byte. It records HP-00 as accepted/complete, separates HP-01 schema parity from HP-02 selected-period compatibility, and leaves both HP-01 execution and the first private statement unstarted. The ingest changed only `brain/**` and did not inspect the database, private financial material, Orbit, or services.
- The primary HP-01 checkpoint is `brain/sprints/0027-historian-hp01-schema-deployment/IMPLEMENTATION_CHECKPOINT-2026-08-09.md`. It records verified private recovery, a 45-definition additive plan, nine empty canonical tables plus nine empty admin views, 52-table count invariance, post-deployment readiness, and the unresolved HP-02 legacy gate. No private source or record body was opened.
- `RAVEN-INGEST-0027` preserves HP-01 external acceptance evidence and the governing HP-02 prompt byte-for-byte. It records HP-01 accepted/done and HP-02 authorized but unexecuted; this ingest changed only `brain/**` and did not inspect private data, databases, MCP, services, Orbit, or the recovery artifact.
- `RAVEN-INGEST-0030` preserves three sources byte-for-byte and records HP-03 external acceptance, one accepted six-decision bridge record, and the fictional-only HP-04 authorization. The supplied archive, test, operation-catalog, private-proof, and zero-write claims remain externally attributed; Brainkeeper verified only attachment hashes, raw preservation, and Brain integration and accessed no private crosswalk, source, or database.
- The HP-04 implementation checkpoint records fictional Phases A-H across schema, Domain, SurrealDB, Studio, tRPC, and semantic MCP. It records 113 Domain, 44 Surreal, 14 MCP, four Studio UI, nine Atlas tests, package typechecks, strict schema validation, Studio production build, and disposable live smoke as passing. No private source, crosswalk, configured private database, private commit, or private authority change was involved; `RAVEN-INGEST-0031` records external acceptance of this fictional foundation.
- `RAVEN-INGEST-0031` preserves four sources, records external acceptance of the HP-04 fictional foundation, separates HP-04A from RA-00, and records RA-00's direct authorization. The HP-04 archive and product claims remain externally attributed; Brainkeeper verified raw parity and Brain integration only.
- `RAVEN-INGEST-0032` preserves the RA-00 external review verbatim. The reviewer reports matching archive SHA-256, 1,605 entries, ZIP integrity, and archive safety `5/5`, accepts the read-only architecture, and requires six findings before integration. All six findings are implemented and verified in current main.
- `RAVEN-INGEST-0033` preserves the current-main acceptance review and exact RA-00B prompt verbatim. The reviewer reports archive SHA-256 `6d24050d1dfdb57fb39f5602f894fc5c010d262bbc793e2bcbb982078329552e`, 2,898 entries, ZIP integrity, and archive safety `5/5`; current-main integration and default analytics are accepted, with only optional legacy-inclusive reverse-history authority left in review.
- The RA-00B implementation checkpoint records the reverse canonical-match-history projection, final authority table, fictional regressions, current-main shared-file safety, and full verification. External artifact acceptance remains pending.
- `RAVEN-INGEST-0034` preserves the emergency statement intake orchestrator packet verbatim and distills only aggregate-safe operating boundaries. It does not prove a source inventory, private permission, preview, query index, financial result, canonical write, or workline execution.
- `RAVEN-INGEST-0035` preserves the byte-identical replacement packet and the separate governing user addendum. SOURCE-02 has precedence over SOURCE-01 for Phase C, replacing DuckDB/equivalent embedded storage with deterministic filesystem-native JSON/NDJSON and bounded local commands. It does not prove execution, private access, or an operational index.

## Privacy Boundary

Do not ingest, summarize, expose, or package statements, mediation exports, mailbox exports, dossiers, account records, Ground Zero evidence bodies, environment files, or credentials. Use the AI-safe archive command for external review packages.
