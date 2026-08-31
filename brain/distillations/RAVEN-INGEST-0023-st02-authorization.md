# Distillation - RAVEN-INGEST-0023 - ST-02 Authorization

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0023-st02-authorization/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0023-st02-authorization/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0023-st02-authorization/INGEST_RECORD-RAVEN-INGEST-0023.md`
- Source date: 2026-08-04
- Ingest date: 2026-08-04
- Mode: external-validation / pre-work-primer

## Executive Distillation

The final external review accepts Statement Truth ST-01 as complete. Its accepted boundary ends at one deterministic, immutable, source-only statement commit and safe source reads; it creates no `Transaction`, makes no component disposition, and cannot itself double count provisional ledger activity.

The packet explicitly authorizes the separate ST-02 main workline: Provisional Matching and Exact Statement Reconciliation. ST-02 must make one manual provisional Transaction and its later bank component become one statement-backed economic movement, never two. An unmatched movement component may become a Transaction only through an explicit audited materialization command. Informational components remain non-movements.

This Brainkeeper ingest records the authorization as `DEC-0017` but does not execute the workline or infer implementation. ST-02 must remain authorized, in progress, or in review according to separate main-workline evidence and cannot become done without external artifact acceptance. Private statement ingestion remains unauthorized.

## Authoritative Status

```text
Statement Truth contract                   approved
ST-01 Source Preview and Atomic Commit     accepted and done
ST-02 Matching and Reconciliation          authorized; separate main workline
ST-02 completion                           not established by this ingest
Private statement ingestion               not authorized
Historian operator                        dormant
Twelve-month backfill                     not started
```

## Core Economic Identity

ST-02 exists to prevent two records from counting one economic movement:

```text
manual provisional Transaction
+ immutable StatementRowComponent evidence
-> audited confirmed StatementTransactionMatch
-> one statement-backed Transaction
```

When no eligible Transaction exists:

```text
unmatched movement component
-> explicit materialization command
-> exactly one imported Transaction
+ one confirmed source-evidence match
```

Candidate generation is side-effect free. Proposal is not confirmation. Confidence and reason codes explain ranking but do not confer authority.

## Canonical Model Direction

The authorized prompt proposes canonical `StatementTransactionMatch` and `StatementReconciliation`, plus the narrowest append-only reconciliation-event or uniqueness-claim authority needed to preserve history and concurrency guarantees. It permits only required `StatementIssue` acknowledgement and source-supersession extensions.

Schema changes must begin in `apps/schema/config/graph.mpdg`, regenerate through the schema authority workflow, and update the Data Atlas. These models and changes are authorized workline requirements, not current implementation facts from this ingest.

## Binding Truth Invariants

- ST-01 source facts, hashes, locators, dates, exact amounts, signed balance effects, and issues remain immutable.
- A match links evidence; it cannot rewrite Transaction money, date, Account, currency, provenance, management meaning, or tax meaning.
- Each movement component has at most one active confirmed resolution.
- A Transaction cannot be actively claimed by two statement imports, and no one source period may count it twice.
- Matching an existing provisional Transaction creates no second Transaction.
- Materialization is explicit, creates exactly one imported Transaction and one confirmed match atomically, and replays to the same entities.
- Informational components have zero balance effect, cannot become Transactions, and never enter movement totals.
- All arithmetic uses checked safe-integer minor units with no tolerance, float arithmetic, or silent rounding.
- Reconciliation is independent of Category, Merchant, tax, accounting, recurrence, buckets, and other later meaning.
- Every mutation is idempotent, optimistic-concurrency protected, transactional, and safe under concurrent first writes.
- Any accepted post-attestation change must atomically reopen reconciliation or be rejected; Raven may never retain a false reconciled state.
- ST-02 remains ZAR-only and single-currency; no FX.

## Match And Source Lifecycles

The match lifecycle is append-only: propose, confirm, reject, and supersede with actor, operation, timestamp, revision, reason, and lineage. Active component and Transaction uniqueness must be enforced transactionally rather than by application precheck.

Candidate hierarchy favors exact replay/reference, explicit operator selection, exact source reference or normalized-description evidence, exact date, configured bounded date, and finally cross-Account transfer candidates. Transfer candidates remain suggestions and never silently create `AccountTransfer`.

`supersedeStatementImport` is the only authorized source-replacement path. It must atomically create the replacement source authority, preserve prior imports/components/matches/operations/attestations, transfer claims safely, and reopen reconciliation without silently migrating old matches. Failure must roll back completely.

## Exact Reconciliation

The authorized equation is:

```text
openingBalanceMinor
+ sum(active movement-component balanceEffectMinor)
= expectedClosingBalanceMinor

reportedClosingBalanceMinor
- expectedClosingBalanceMinor
= differenceMinor
```

Attestation requires active source and Account authority, complete source coverage, exactly one active confirmed Transaction resolution for every movement component, informational components remaining non-movement, no blocking issue or uniqueness conflict, present opening/closing balances, exact zero difference, and current hash/revision/claim identity. Attestation and reopening are immutable events; later relevant changes reopen atomically.

## Semantic Operation Catalog

The prompt authorizes fourteen additional shared operations, bringing Statement Truth to twenty-eight tRPC/MCP parity pairs:

- Queries: list candidates, list matches, get match, and get reconciliation.
- Commands: propose, confirm, materialize, reject, and supersede a match; acknowledge a non-blocking issue; supersede an import; recalculate, attest, and reopen reconciliation.

All commands require retry-stable idempotency, actor/channel provenance, request hashing, transactional final validation, concurrent replay/conflict handling, and a `FinancialOperation` receipt. MCP remains semantic and may not accept raw SurrealQL or generic mutation payloads.

## Studio And Operator Boundary

Preserve the Penpot-derived Account Ledger and committed-statement visual language. Extend the committed statement route with Source, Resolution, Reconciliation, and History capabilities, exact drill-down, guarded mutations, action-scoped retry identity, keyboard access, and bounded desktop/mobile behavior. A confirmed manual match must not create a second ledger row; a materialized source movement appears once.

MCP descriptions must say candidates are suggestions, confirmation is audited, materialization creates no accepted management or tax meaning, reconciliation is not tax/category completion, and private Historian operation remains unauthorized.

## Verification And Acceptance Gate

The prompt requires fictional fixed-clock tests, focused package and Studio checks, a disposable isolated Surreal lifecycle with cleanup, strict schema generation/import, twenty-eight-operation parity, Atlas and renderer regressions, extraction-schema validation, formatting/diff/Brain/privacy/archive checks, and an AI-safe review artifact. No real statement, private record, configured private database, or development server is authorized.

The main workline must finish in review and await external artifact acceptance. This ingest performs none of that product verification.

## Observed Facts And Attributed Claims

Observed from the supplied packet:

- the external review explicitly accepts ST-01 as complete;
- the separate ST-02 main workline is explicitly authorized;
- ST-02 is bounded to matching, materialization, reconciliation, attestation, reopening, source supersession, and equivalent semantic surfaces;
- private ingestion, ST-03 meaning, tax, Historian operation, and backfill remain outside authorization.

Attributed external-review claims not independently reverified by Brainkeeper:

- accepted ST-01 archive SHA-256 is `7d306996a13659669eda095990ec0dadc2882283c8f321ab32d438cd2ac18ed5`;
- the archive contains 2,607 files and passes ZIP integrity;
- renderer tests passed `2/2`, archive-safety tests passed `5/5`, and prohibited private-path inspection found nothing;
- source inspection was consistent with the local verification report, while dependency-backed checks could not be independently rerun from the AI-safe archive.

## Decisions

- `DEC-0017` accepts ST-01 final external closure and authorizes the bounded ST-02 main workline.
- Authorization does not mark ST-02 implemented, reviewed, accepted, or done.
- `DEC-0016` remains unchanged.

## Open Loops

- `OL-0028` now records ST-01 complete and ST-02 explicitly authorized.
- Implement and externally review ST-02 before any private statement is ingested.
- Keep ST-03, private Historian operation, twelve-month backfill, tax persistence, and later lanes gated.

## Risks

- Manual provisional Transactions and source movements can double count one event until transactional match uniqueness and reconciliation are implemented.
- Candidate confidence can be mistaken for authority unless proposal and confirmation remain distinct.
- Attestation can become false if later match, issue, or source changes do not reopen atomically.
- Source replacement can split authority or lose history unless claim transfer is append-only, transactional, and rollback-safe.
- Reconciliation can be misrepresented as management or tax completion unless those dimensions stay separate.

## Opportunities

- Make the Account Ledger operationally trustworthy by unifying manual timing evidence and later bank evidence without losing either provenance layer.
- Give agents an explainable, semantic matching and reconciliation surface instead of generic database writes.
- Establish exact Account-period proof before authorizing the first private statement or historical backfill.

## Orbit Sync Candidates

- Create or resume one bounded Past / Historian ST-02 Workline under the primary main agent.
- Preserve ST-01 as done and leave ST-02 in progress or review until external artifact acceptance.
- Keep private ingestion, Historian operation/backfill, ST-03, Tax, Workline 04, Elgiz, buckets, and Earn unstarted or separate.
- Sync no private source path, filename, statement text, Account record, amount, credential, or live-database fact.

No Orbit or `.orbit` state was inspected or changed by this ingest.

## Routine Items Intentionally Excluded

- No product/schema implementation, generated artifact, architecture document outside Brain, database, private financial source, service, review archive, Orbit write, commit, merge, or push.
- No ST-02 implementation or acceptance result inferred from the embedded prompt.
