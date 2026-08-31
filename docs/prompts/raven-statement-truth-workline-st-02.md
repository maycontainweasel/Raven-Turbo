status: readyowner: Ravenlast_reviewed: 2026-08-04contract: raven-statement-truth-contract-v0.1workline: ST-02requires:

ST-01 accepted and donesupersedes: []superseded_by: []

Raven Statement Truth Workline ST-02 — Provisional Matching and Exact Reconciliation

orbit-workline

Create and execute one bounded implementation workline under Past / Historian:

Raven ST-02 — Provisional Matching and Exact Statement Reconciliation

This is the main implementation workline. The Brainkeeper sidecar may run under the
standing Raven protocol, but it must not replace, defer, or terminate the main
workline. Continue through implementation, verification, and review handoff in this
same run.

Accepted starting state

- ST-01 — Statement Source Preview and Atomic Commit is externally accepted and
  complete.
- The Generated Data Atlas is accepted and integrated.
- Account Balance Truth, Transactions and Transfers, and Upcoming Cashflow are
  accepted foundations.
- Raven Studio is the priority product application.
- ST-01 source truth remains immutable and source-only.
- Do not reopen ST-01 architecture or repeat its ingest/review work.

Authority

Read and follow:

- AGENTS.md and all applicable nested AGENTS files.
- brain/START_HERE.md, NOW.md, DECISIONS.md, OPEN_LOOPS.md, RISK_REGISTER.md,
  ROADMAP.md, HANDOFF.md, and ORBIT_SYNC.md.
- docs/architecture/raven-statement-truth-contract-v0.1.md.
- docs/architecture/raven-statement-truth-st-01-implementation.md.
- docs/prompts/raven-statement-truth-workline-st-01.md as historical boundary
  reference only.
- docs/architecture/raven-account-control-contract-v0.1.md.
- docs/architecture/raven-account-control-workline-02-implementation.md.
- docs/architecture/raven-account-ledger-and-mcp-readiness-v0.1.md.
- docs/architecture/raven-import-identity-and-migration.md.
- docs/architecture/raven-data-atlas.md.
- apps/schema/config/graph.mpdg.
- packages/raven-domain, packages/raven-surreal, apps/raven-mcp, Raven Studio's
  Account Ledger and committed-statement routes, and the existing shared tRPC/MCP
  schemas and parity tests.

Goal

Implement the complete ST-02 vertical so Raven can take an already committed ST-01
source and safely turn every exact movement component into one and only one observed
ledger movement, then prove and attest the Account period exactly.

The user flow must be:

Committed statement source
  → list exact movement components
  → generate deterministic provisional-Transaction candidates
  → propose, confirm, reject, or supersede audited matches
  → explicitly materialize unmatched components as imported Transactions
  → preserve informational components as non-movements
  → prevent duplicate evidence and duplicate ledger movements
  → calculate exact statement reconciliation
  → drill into every unresolved component and issue
  → attest only when all source and equation gates pass
  → reopen append-only when later evidence changes

After ST-02, a manually entered provisional movement and its later bank evidence must
appear as one Transaction with two evidence layers, never as two counted movements.

Scope boundary

Implement only:

- StatementTransactionMatch;
- StatementReconciliation and append-only reconciliation history/equivalent;
- deterministic candidate generation;
- proposal, confirmation, rejection, supersession, and explicit imported-Transaction
  materialization;
- non-blocking StatementIssue acknowledgement;
- immutable source supersession through explicit lineage;
- exact reconciliation calculation, attestation, and reopening;
- Account Ledger evidence projection and no-double-counting behavior;
- Raven Studio, tRPC, and semantic Raven MCP parity for the remaining Statement Truth
  operations;
- fictional tests and isolated disposable database verification.

Do not implement:

- management classification proposal or approval;
- Merchant or Category learning/CRUD;
- split management allocations;
- recurrence inference or CashflowSchedule creation;
- accounting or tax treatment;
- evidence-document attachment beyond existing source references;
- workpaper export;
- buckets, Elgiz, Today Coverage, Earn, or another product lane;
- private statement ingestion or private database audit;
- the dedicated Historian operator or twelve-month backfill.

Privacy and operational boundary

- Code and wholly fictional fixtures only.
- Do not inspect, query, export, migrate, or modify private Raven records.
- Do not read real statement PDFs, screenshots, descriptions, accounts, balances, or
  transactions.
- Do not print private source text or absolute vault paths into Brain, logs, tests,
  snapshots, operation metadata, screenshots, or AI-safe archives.
- Any live database verification must use a disposable isolated namespace/database,
  fictional records only, and cleanup in `finally`.
- Do not start a development server. Browser verification may use Michael's already
  user-managed Raven Studio process after the production build, if available.

Financial truth invariants

1. StatementImport, StatementRow, StatementRowComponent, original hashes, locators,
   checksums, dates, amounts, signed balance effects, and source issues remain
   immutable source truth.
2. A StatementTransactionMatch is interpretation/evidence linkage. It never rewrites
   source truth or Transaction money, date, Account, currency, original manual
   provenance, management meaning, or tax meaning.
3. Every movement component has at most one active confirmed resolution.
4. One Transaction has at most one active Statement Truth match within one source
   period and cannot be actively claimed by two statement imports.
5. A source component and a provisional Transaction become one observed economic
   movement through a confirmed match; no second Transaction is created.
6. An unmatched movement component creates a Transaction only through the explicit
   semantic materialization command. No candidate or preview auto-writes it.
7. Informational components have zero balance effect, cannot become Transactions, and
   never enter movement counts or reconciliation movement totals.
8. No amount tolerance exists. All money and signed totals use checked safe-integer
   minor-unit arithmetic.
9. Reconciliation completion is independent of management Category, Merchant, tax,
   accounting treatment, recurrence, or buckets.
10. Every mutation is idempotent, optimistic-concurrency protected, and safe under
    concurrent first writes.
11. Any accepted change to source resolution that makes an attested result stale must
    atomically reopen reconciliation or reject the mutation. Raven must never retain a
    false `reconciled` state.
12. All calculations remain single-currency. ST-02 remains ZAR-only unless GBP support
    is separately approved before implementation. No FX conversion.

Observed movement versus later meaning

Use the existing Account Control transaction contract without inventing tax or
management meaning:

- `flowDirection` records bank-observed inflow or outflow.
- The persisted Transaction kind needed for current Account movement totals must be
  derived only from coherent source movement semantics.
- Management meaning remains `unclassified` for a newly materialized source
  Transaction.
- Tax meaning remains `not_assessed`.
- Do not assign Category, Merchant, client, project, purpose, recurring state, tax
  treatment, or clarified status during materialization.
- A plausible transfer remains a candidate only. It must not silently become an
  AccountTransfer. Where transfer identity is not confirmed, preserve explicit
  unresolved/partial quality rather than manufacturing ordinary income or spending.
- Preserve any already accepted management meaning on an existing manual Transaction
  when statement evidence is matched to it.

Schema authority

Begin every schema change in `apps/schema/config/graph.mpdg`, validate strictly, then
regenerate and inspect all generated specifications, models, routers, migrations, and
Data Atlas output. Do not hand-edit generated artifacts as source authority.

Add canonical StatementTransactionMatch.

It must support:

- owning Financial Space, Account, StatementImport, and one or more exact
  StatementRowComponent references;
- one target Transaction;
- stable local key and canonical identity;
- state: proposed | confirmed | rejected | superseded;
- method: explicit | exact_reference | exact_description | exact_date |
  bounded_date | grouped_exact | created_from_component | other reviewed method;
- deterministic reason codes and explanatory confidence;
- exact signed component total and currency;
- expected revision and optimistic concurrency;
- proposed, confirmed, rejected, and superseded FinancialOperation references;
- actor/reviewer and timestamps;
- revision and supersession lineage;
- immutable component membership and target Transaction once confirmed, except
  through explicit append-only supersession.

Enforce active uniqueness transactionally. If deterministic claim records or another
internal constraint are required to prevent races, add the narrowest canonical
source-authority mechanism and document it in the Data Atlas. Never rely on an
application-level precheck alone.

Add canonical StatementReconciliation.

Use one current aggregate per Account and StatementImport, containing:

- period and currency;
- exact opening balance;
- exact signed movement effect;
- exact expected closing balance;
- exact reported closing balance;
- exact difference;
- printed-row and component coverage counts;
- informational component count;
- pending, proposed, confirmed-existing, newly-materialized, unresolved,
  transfer-candidate, and active-issue counts;
- calculationState: unavailable | difference | balanced;
- coverageState: incomplete | complete;
- attestationState: open | ready | reconciled | reopened;
- calculation hash and revision;
- calculatedAt;
- latest attestation/reopening references and timestamps;
- provenance and operation references.

Prior attestation and reopening history must be append-only and queryable. If the
aggregate alone cannot preserve every event safely, add a minimal
StatementReconciliationEvent or equivalent canonical append-only history model.
Never overwrite or delete a former attestation.

Extend StatementIssue only as required for reviewed non-blocking acknowledgement and
reconciliation/source state. Do not repurpose ClarificationTask.

Source component disposition

Do not mutate immutable StatementRowComponent source fields to express disposition.
Derive disposition from active StatementTransactionMatch and reconciliation state.
The semantic component view should expose one of at least:

- informational;
- pending;
- proposed;
- matched_existing;
- materialized_imported;
- rejected_proposal_present;
- conflict;
- superseded_source.

Deterministic matching hierarchy

Implement side-effect-free candidate generation in this order:

1. Existing active confirmed source link with the same source identities: exact
   replay/reference.
2. Explicit operator-selected Transaction that passes every exact invariant.
3. Unique exact Account, currency, amount, compatible direction, date, and source
   reference.
4. Unique exact Account, currency, amount, compatible direction, date, and strong
   normalized-description evidence.
5. Exact Account, currency, amount, and date.
6. Exact Account, currency, amount, compatible direction, and a profile-configured,
   visible bounded date window.
7. Equal-currency/equal-magnitude opposite-effect transfer candidates across tracked
   Accounts.

Rules:

- Candidate generation never writes.
- Confidence explains ranking; it is never authority.
- Candidate reason codes and every matched input are returned for inspection.
- No amount tolerance, float arithmetic, or silent rounding.
- Component groups may target one Transaction only when their checked signed total
  exactly equals the Transaction magnitude and direction.
- Every candidate query is scoped to the exact Account and source period unless the
  transfer-candidate rule explicitly searches tracked counterpart Accounts.
- Ignored, superseded, invalid, unresolved-money, or already actively matched
  Transactions are ineligible.
- Matching date derivation is deterministic and documented. Preserve all transaction,
  posting, and value dates; do not overwrite source dates.
- Historical Category, Merchant, client, project, or tax similarity must never confirm
  source identity.

Match lifecycle commands

`proposeStatementTransactionMatch`

- Accept one or more component IDs and one Transaction ID.
- Re-read all records and exact invariants transactionally.
- Persist an audited proposal only; do not change evidence projection yet.
- Exact replay returns the existing proposal.

`confirmStatementTransactionMatch`

- Require expected match revision and active source/import state.
- Verify Account, currency, signed amount, direction compatibility, date policy,
  component source state, Transaction eligibility, and uniqueness inside one Surreal
  transaction.
- Mark the match confirmed and make the Transaction evidence projection
  statement-backed without rewriting its monetary/source/manual fields.
- Atomically recalculate or invalidate/reopen the StatementReconciliation.

`rejectStatementTransactionMatch`

- Preserve the proposal and append rejection operation, reason, actor, timestamp, and
  revision.
- Source and Transaction remain unchanged.

`supersedeStatementTransactionMatch`

- Append a replacement lineage under expected revision.
- Preserve prior proposal/confirmation/rejection history.
- Release and acquire active uniqueness claims atomically.
- Atomically reopen any affected attested reconciliation.

Explicit imported-Transaction materialization

`materializeStatementComponentTransaction` must:

- accept one component or an exact reviewed component bundle;
- reject informational, superseded, already disposed, unsafe, cross-Account,
  cross-currency, unknown-money, or contradictory components;
- derive exact canonical money and source flow from immutable source components;
- create one Account-scoped imported Transaction and one confirmed
  `created_from_component` StatementTransactionMatch in the same transaction;
- use a deterministic Transaction key and preserve source/component checksums and
  provenance through the match;
- create one FinancialOperation receipt;
- create no Category, Merchant, ClassificationRule, ClarificationTask, tax record,
  AccountTransfer, CashflowSchedule, or accepted meaning;
- return the Transaction once and make replay return the same entities;
- atomically refresh/reopen reconciliation.

No command may create both an imported Transaction and match an existing provisional
Transaction for the same component.

Evidence projection and Account Ledger

Update shared Transaction reads so:

- a manual/generated Transaction with an active confirmed StatementTransactionMatch
  reports `evidenceState = statement_backed`;
- a newly materialized imported Transaction reports statement-backed evidence through
  its confirmed match;
- source evidence is drillable through match/import/row/component references;
- no matched source component appears as a second ledger Transaction;
- ledger and month totals count one economic movement exactly once;
- rejected or proposed matches do not change Transaction evidence state;
- superseded matches stop being active but remain visible in history;
- Management and Tax lenses remain as currently implemented: management meaning is
  not invented and tax remains `not_assessed`.

Statement issue acknowledgement

`acknowledgeStatementIssue` may acknowledge only a non-blocking issue under expected
revision. It records actor, operation, note, and timestamp without changing source
facts or pretending the issue is resolved.

A blocking source issue cannot be waived into reconciliation. It requires source
replacement/supersession or another contract-authorized correction.

Immutable source supersession

Implement `supersedeStatementImport` as the only source-replacement path.

- It requires an existing active committed import, expected source/reconciliation
  revision, a separately staged and currently valid replacement preview, an
  idempotency key, actor, and reason.
- Reopen/revalidate the replacement source and reviewed Account context using the
  accepted ST-01 authority rules.
- In one transaction, create the new immutable import/rows/components/issues/edges,
  mark the old source superseded, append replacement lineage, transfer source/period
  claims, and reopen/supersede reconciliation state.
- Preserve old imports, rows, components, matches, operations, and attestations for
  history.
- Do not silently migrate old confirmed matches to changed source components.
- If an identical replacement source is already active, replay; if immutable evidence
  differs under the same request or claims race, return a stable conflict.
- No delete or in-place source rewrite.

If safe claim transfer and full rollback cannot be proven in one transaction, leave
ST-02 in review and report the blocker. Do not weaken the invariant.

Exact reconciliation

Use the committed source equation:

openingBalanceMinor
+ sum(all active movement-component balanceEffectMinor)
= expectedClosingBalanceMinor

reportedClosingBalanceMinor
- expectedClosingBalanceMinor
= differenceMinor

Use checked safe-integer addition and the committed source's authoritative balance
convention. Informational components contribute zero.

`recalculateStatementReconciliation` must deterministically derive:

- source equation values;
- row/component coverage;
- every active component disposition;
- active issue counts;
- candidate/proposal/confirmed/materialized counts;
- calculation, coverage, and attestation readiness;
- calculation hash over every authority input;
- revision and exact drill-down references.

Attestation gates

`attestStatementReconciled` must require all of the following inside one transaction:

1. active committed StatementImport with original, assistance where applicable,
   canonical extraction, preview, Account-context, profile, and ruleset identities;
2. exact Account, currency, and period authority still matches;
3. complete printed-row/source coverage;
4. every movement component has exactly one active confirmed Transaction resolution;
5. every informational component remains non-movement;
6. no active blocking StatementIssue;
7. no active match/source/period uniqueness conflict;
8. opening and reported closing balances are present;
9. differenceMinor is exactly zero;
10. submitted calculation hash, expected reconciliation revision, and every active
    claim still match current state.

Management classification, tax assessment, Merchant, Category, recurrence, evidence
attachments, and buckets are not attestation gates.

A successful attestation:

- appends an immutable attestation event/operation;
- records actor, channel, calculation hash, revision, and timestamp;
- moves current attestationState to `reconciled`;
- preserves every prior event.

`reopenStatementReconciliation`

- requires expected revision and a reason;
- appends an immutable reopening event/operation;
- retains the prior attestation and calculation snapshot;
- moves current state to `reopened` and increments revision;
- does not alter source or Transaction facts.

Any later confirmed-match change, supersession, issue-state change, or source
replacement that affects reconciliation must use the same reopening mechanism
atomically or reject with a stable stale/conflict error.

Stable errors and warnings

Implement and document the ST-02 subset, including at least:

- STATEMENT_MATCH_CONFLICT
- STATEMENT_COMPONENT_ALREADY_DISPOSED
- STATEMENT_TRANSACTION_INELIGIBLE
- STATEMENT_TRANSACTION_ALREADY_MATCHED
- STATEMENT_COMPONENT_TOTAL_MISMATCH
- STATEMENT_RECONCILIATION_INCOMPLETE
- STATEMENT_RECONCILIATION_DIFFERENCE
- STATEMENT_RECONCILIATION_STALE
- STATEMENT_RECONCILIATION_ALREADY_ATTESTED
- STATEMENT_BLOCKING_ISSUE_ACTIVE
- STATEMENT_SOURCE_SUPERSESSION_CONFLICT
- STATEMENT_IMPORT_SUPERSEDED
- IDEMPOTENCY_CONFLICT

Use stable Raven domain codes across Studio, tRPC, and MCP. Do not expose private
source text or paths in errors.

Shared semantic operation catalog

Implement exact shared-domain, camelCase tRPC, and snake_case MCP parity for the 14
remaining Statement Truth operations:

Queries:

- listStatementMatchCandidates / list_statement_match_candidates
- listStatementTransactionMatches / list_statement_transaction_matches
- getStatementTransactionMatch / get_statement_transaction_match
- getStatementReconciliation / get_statement_reconciliation

Commands:

- proposeStatementTransactionMatch / propose_statement_transaction_match
- confirmStatementTransactionMatch / confirm_statement_transaction_match
- materializeStatementComponentTransaction /
  materialize_statement_component_transaction
- rejectStatementTransactionMatch / reject_statement_transaction_match
- supersedeStatementTransactionMatch / supersede_statement_transaction_match
- acknowledgeStatementIssue / acknowledge_statement_issue
- supersedeStatementImport / supersede_statement_import
- recalculateStatementReconciliation / recalculate_statement_reconciliation
- attestStatementReconciled / attest_statement_reconciled
- reopenStatementReconciliation / reopen_statement_reconciliation

Together with the accepted 14 ST-01 source operations, the Statement Truth catalog
must contain 28 parity-matched operation pairs.

Every command requires one retry-stable idempotency key, actor/channel provenance,
request hash, transactional final validation, concurrent-first-write replay, and a
FinancialOperation receipt. Extend the FinancialOperation command union through
canonical source authority and regenerate all consumers.

Raven Studio

Preserve the current Penpot-derived Account Ledger and statement-source visual
language. Do not redesign the application.

Extend the committed statement route:

/accounts/{spaceKey}/{accountKey}/statements/{importKey}

Add compact source-detail sections or tabs for:

- Source;
- Resolution;
- Reconciliation;
- History.

Required capabilities:

- row/component resolution state;
- deterministic candidate list with exact reasons, dates, amount, Account, evidence
  state, and confidence;
- explicit candidate selection;
- propose and confirm match;
- reject and supersede match;
- explicit materialize imported Transaction action;
- informational component display with no movement action;
- non-blocking issue acknowledgement;
- source replacement/supersession in a secondary guarded action;
- reconciliation equation and exact counts;
- drill-down lists for every pending, proposed, confirmed, materialized, blocking,
  informational, and transfer-candidate count;
- Recalculate;
- Attest reconciled;
- Reopen with reason;
- immutable match, operation, attestation, and reopening history.

The Account Ledger must display the derived period source states:

- committed — resolution pending;
- exceptions present;
- ready to attest;
- reconciled;
- reopened.

The Account Ledger must show one Transaction per economic movement. A confirmed
manual match must not add another ledger row. A materialized source component must
appear once. Month totals must remain exact with transfer and unresolved-quality rules
preserved.

All mutation surfaces must use one command-intent idempotency key per open intent and
retain it across failed submissions or lost responses. Reset only after success,
explicit cancellation/closure, selection of a genuinely new action, or a changed
reviewed payload.

The UI must expose loading, empty, partial, conflict, stale revision, blocking issue,
replay, and success states. Preserve keyboard operation and bounded desktop/mobile
layout. Do not display raw local paths.

MCP operator safeguards

MCP descriptions must state clearly:

- candidates are suggestions only;
- confirmation is an explicit audited act;
- materialization creates one observed Transaction but no accepted management or tax
  meaning;
- reconciliation does not mean Category or tax completion;
- real/private Historian operation is not yet authorised by this workline.

The semantic MCP must never accept raw SurrealQL or generic update/delete payloads for
these operations.

Fictional test matrix

Add deterministic fixed-clock unit, repository, adapter/read-model, Studio, tRPC/MCP,
and isolated-live-Surreal coverage for at least:

1. Exact manual candidate proposed but not auto-confirmed.
2. Confirmed exact match creates no new Transaction and changes evidence projection to
   statement-backed.
3. Confirmed match preserves manual Category/meaning and original operation.
4. Unmatched component explicitly materializes exactly one imported Transaction and
   one confirmed match.
5. Replayed materialization returns the same Transaction and match.
6. Informational component cannot materialize or enter reconciliation movement count.
7. Exact grouped components can match one Transaction only when checked signed total
   is exact.
8. Amount, Account, currency, direction, date-policy, source-state, and ignored/
   superseded Transaction mismatches are rejected.
9. Transfer candidates remain proposals and never auto-create AccountTransfer.
10. One component cannot be actively confirmed twice under concurrent requests.
11. One Transaction cannot be actively matched to two imports under concurrent
    requests.
12. Same idempotency key/request replays; changed hash returns IDEMPOTENCY_CONFLICT.
13. Rejection preserves proposal history and changes no financial fact.
14. Supersession preserves history, moves active claims atomically, and reopens an
    attested reconciliation.
15. Non-blocking issue acknowledgement is audited; blocking issue cannot be waived.
16. Source supersession is atomic, append-only, claim-safe, and rolls back completely
    on one failed row/component/edge.
17. Exact asset-account equation.
18. Exact liability-account equation.
19. Missing opening/closing balance returns unavailable/incomplete.
20. One unresolved movement component blocks readiness.
21. One active blocking issue blocks readiness even when difference is zero.
22. Non-zero difference returns exact amount and rejects attestation.
23. Complete zero-difference period becomes ready and can be attested.
24. Stale calculation hash or reconciliation revision rejects attestation.
25. Reopen preserves prior attestation and records a new event.
26. A post-attestation match/source/issue change cannot leave false reconciled state.
27. Account ledger and month totals contain no manual-plus-import duplicate.
28. Statement detail drills from reconciliation counts to exact fictional records.
29. Studio and MCP return contract-equivalent shapes and stable errors.
30. Full 28-operation tRPC/MCP parity catalog passes.
31. Desktop and 390px mobile statement-detail verification has no horizontal overflow
    or new hydration mismatch in ST-02 surfaces.
32. Disposable live Surreal lifecycle proves atomic match, materialization,
    reconciliation, attestation, reopening, concurrency, rollback, replay, edges, and
    cleanup.
33. No tax, management proposal, Merchant, Category, recurrence, bucket, private data,
    or unrestricted database-write operation is created.

Use fictional institutions, accounts, descriptions, dates, IDs, and amounts only.

Verification

Run the complete bounded matrix:

- strict MPDG graph validation;
- schema spec generation;
- generated code generation and inspection;
- configured schema import dry-run and local import against the approved development
  environment only;
- @raven/domain tests and typecheck;
- @raven/surreal tests and typecheck;
- Raven MCP tests, 28-operation parity test, and typecheck;
- Raven Studio focused tests and production build;
- disposable fictional live-Surreal smoke with cleanup;
- existing ST-01 source tests and live-smoke regression;
- existing Account Control and cashflow focused regressions affected by shared
  Transaction reads;
- legacy statement renderer tests;
- pnpm test:data-atlas;
- pnpm docs:data-atlas;
- pnpm docs:data-atlas:check twice;
- strict statement-extraction JSON Schema validation;
- formatting and git diff --check;
- root and nested schema repository status/diff checks;
- Brain health and source traceability;
- bounded credential/private-path scan;
- pnpm test:archive-safety;
- AI-safe archive preflight and final extracted-payload inspection.

Do not treat inherited whole-app Helios or Schema Kit failures as ST-02 failures when
focused checks and production build pass, but report them exactly and prove that no
new ST-02 file contributes to them.

Documentation and Data Atlas

Update:

- docs/architecture/raven-statement-truth-contract-v0.1.md status/implementation
  record without weakening accepted invariants;
- a new docs/architecture/raven-statement-truth-st-02-implementation.md;
- docs/README.md;
- docs/architecture/raven-data-atlas.md through deterministic regeneration;
- runtime-edge and truth-class registries for accepted new models/edges;
- MCP operation documentation;
- the exact future ST-03 boundary, without implementing it.

Record durable product decisions and implementation facts in Brain. Never ingest
private financial source, descriptions, amounts, paths, or database records into
Brain.

Orbit and completion state

- Create/use one bounded Past / Historian ST-02 Orbit Workline.
- Keep it current through schema, domain, persistence, Studio/MCP, verification, and
  handoff phases.
- Leave ST-02 in `review` with explicit external-review attention.
- Do not mark ST-02 done without external artifact acceptance.
- Do not start ST-03, ST-04, private statement ingestion, the Historian operator,
  twelve-month backfill, Tax Lane, Elgiz, buckets, Earn, or another mainline.
- Do not commit, merge, or push.

Completion response

State unambiguously:

- whether product and schema code changed;
- every canonical model and identity added or extended;
- every exact transaction-resolution and reconciliation invariant implemented;
- the 14 new operations and total 28-operation parity result;
- how a manual Transaction becomes statement-backed without duplicate creation;
- how an unmatched component becomes exactly one imported Transaction;
- how active uniqueness is enforced under concurrency;
- the exact reconciliation equation, readiness gates, attestation, and reopening
  behavior;
- source supersession and rollback behavior;
- Studio routes and working interactions;
- MCP safeguards;
- all tests, builds, smokes, and results;
- confirmation that no private data, management/tax meaning, Historian operation,
  dev server, commit, merge, or push occurred;
- known limitations and the exact ST-03/private-pilot gate;
- the AI-safe review archive path, SHA-256, entry count, and prohibited-path scan.