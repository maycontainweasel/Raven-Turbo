# Distillation - RAVEN-INGEST-0022 - ST-01 Final Source-Authority Closeout

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0022-st01-final-source-authority-closeout/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0022-st01-final-source-authority-closeout/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0022-st01-final-source-authority-closeout/INGEST_RECORD-RAVEN-INGEST-0022.md`
- Source date: 2026-07-30; supplied 2026-08-04
- Ingest date: 2026-08-04
- Mode: external-validation / pre-work-primer

## Executive Distillation

The external reviewer accepts the substantial ST-01 integrity-closeout foundation preserved under `RAVEN-INGEST-0021`: contained private source vault, three-artifact identity, write-free preview, atomic Account/period and Account/source claims, replay before vault access, exact source components, checked arithmetic and running balances, explicit coverage, honest source state, Account-scoped timezone-aware snapshots, Studio intent, shared tRPC/MCP validation, runtime edges, and fictional implementation proof.

Overall ST-01 acceptance is still withheld. The packet identifies four final source-authority blockers: profile authority can still be contradicted by extraction assistance; paginated coverage and row ordering are not fully proven; actual old-shape legacy imports can evade period conflict detection; and commit-relevant Account/Financial Space context is not fully bound to the reviewed preview and atomic commit. Precise commit-time conflict codes are a related bounded correction.

SOURCE-02 is authorized workline input for the separate main implementation agent. This Brainkeeper sidecar preserves and distills it but does not execute it, infer that it passed, mark ST-01 done, or relax the external review gate. `DEC-0016` remains accepted and unchanged. ST-02 and private ingestion remain blocked.

## Review Gate

```text
ST-01 integrity foundations              accepted
ST-01 overall external acceptance        withheld
Required next action                     final bounded source-authority closeout
Main-workline implementation authority   granted
Brainkeeper implementation claim         none
ST-02 matching/reconciliation             blocked and unstarted
Private statement ingestion               unauthorized
```

The sources create a narrow sequencing tension that must remain visible: the implementation prompt permits the main workline to mark ST-01 done only if its complete matrix passes, while the accompanying reviews say ST-02 and private use must wait for the closeout to pass external review. This sidecar therefore keeps ST-01 in review and records neither completion nor acceptance.

## Durable Closeout Requirements

### Profile Authority Is Binding

Profile-specific adapters with `balanceConventionAuthority` must require exact equality between the profile convention and extraction-assistance convention. The selected Account normal nature must also be compatible with that profile. Either mismatch blocks preview and commit with zero writes; assistance cannot invert committed `sourceFlow` while merely suppressing a closing snapshot.

`normalized-json-v1` may remain operator-assisted, but its convention stays explicitly unverified, retains the `STATEMENT_BALANCE_CONVENTION_UNVERIFIED` warning, and cannot create a closing snapshot or masquerade as profile authority.

### Coverage And Canonical Row Sequence Fail Closed

Complete PDF/image coverage requires a positive source page count and processed pages exactly equal to `1..sourcePageCount`. Locator pages must be positive, in range, and processed; line and region geometry must also be valid. CSV, OFX, and QIF require an explicit documented non-paginated completeness rule rather than inheriting a null-page-count bypass.

For every source kind, Raven needs one deterministic neutral sequence before running-balance calculation, canonical hashing, persistence, and read projection. The prompt prefers rejecting row arrays unless declared row numbers are unique, positive, ascending, and contiguous `1..N`, while preserving printed source references separately.

The checked-in JSON Schema, fictional example, operator guide, runtime validator, implementation note, and tests must agree. Documentation cannot promise constraints that runtime intake does not enforce.

### Actual Legacy Shapes Block Period Duplication

The prior renderer's safe `statementDate` and date-prefixed import key evidence must participate in an internal compatibility projection because older imports may lack new `periodStart` and `periodEnd` authority fields. A deterministic same-period mapping blocks with `STATEMENT_LEGACY_PERIOD_CONFLICT`.

If an active legacy record for the selected Account cannot be mapped safely, Raven must fail closed with a stable compatibility-review outcome instead of allowing a potentially duplicate source. Only safe state/count/reason metadata may be returned. No private description, amount, Account name/number, filename, path, source text, audit, migration, mutation, or replay is authorized.

### Reviewed Account Context Is Atomic Commit Input

Preview identity must bind canonical Account and Financial Space record identity plus every field that can alter validation or snapshot output: Account currency, normal nature, Financial Space timezone, masked-account comparison context or its deterministic fingerprint, profile authority/version, and validation ruleset version.

The same expected context must be carried into the repository draft and re-read inside the transaction that creates claims and source authority. Any active-state, identity, currency, nature, timezone, or relevant fingerprint change returns `STATEMENT_PREVIEW_STALE` or another precise stable conflict and performs zero writes. Snapshot authority, economic nature, and timestamp must derive from the reviewed context.

### Stable Commit Outcomes Survive Revalidation

Commit-time races and replay must retain precise shared domain outcomes:

- exact source already present: `STATEMENT_DUPLICATE_SOURCE`;
- different source in an occupied exact period: `STATEMENT_IMMUTABLE_CONFLICT`;
- mapped or unmappable legacy compatibility blocker: precise legacy error;
- changed Account/Space context: `STATEMENT_PREVIEW_STALE` or precise context conflict;
- changed request under one idempotency key: `IDEMPOTENCY_CONFLICT`.

Studio and MCP must receive the same code. A revalidation blocker must not collapse these outcomes into generic `STATEMENT_EXTRACTION_INVALID`.

## Verification Contract

The prompt requires focused deterministic and concurrent fictional tests for profile mismatches, generic unverified convention, page/locator/geometry rules, non-paginated coverage, row ordering, realistic legacy shapes, unmappable legacy evidence, Account-context races, stable source/period race codes, replay before vault access, and absence of all later-lane records.

It also requires the existing strict MPDG, generation/import, domain, Surreal, MCP, Studio, JSON Schema, Atlas, renderer, archive-safety, Brain health, redaction, formatting, diff, disposable live-Surreal, and AI-safe archive matrix. This ingest does not attribute any future result to the main workline.

## Preserved Boundaries

- Do not inspect, stage, preview, query, audit, migrate, or modify private statements, Account records, transactions, tax records, or raw private evidence.
- Use fictional fixtures and an isolated disposable Surreal namespace/database only.
- Do not start ST-02, Transaction materialization, matching, disposition, reconciliation, management meaning, tax meaning, buckets, Workline 04, Elgiz, Earn, or private Historian operation.
- Do not redesign the Penpot-derived Account Ledger or statement workspace.
- Do not commit, merge, or push.
- Keep the Brainkeeper non-implementing and separate from the authorized main workline.

## Observed Facts And Attributed Claims

Observed from the supplied packet:

- the formal review explicitly accepts the prior integrity foundations;
- the same review explicitly withholds overall ST-01 acceptance;
- the packet supplies one final bounded implementation prompt covering four source-authority blockers and stable error semantics;
- the user authorizes the separate main agent to execute that prompt;
- ST-02 and private statement use remain blocked.

Attributed external-review claims not independently reverified by Brainkeeper:

- reviewed archive SHA-256 is `956f179780506c7e8fa8d24c4aba14a3971d691c3f8e88915e4a7939d5b16f7d`;
- the ZIP contains 2,603 entries and passes compressed-data integrity;
- the reviewer's prohibited-path checks found no named private paths;
- legacy renderer tests passed `2/2`;
- archive-safety tests passed `5/5`.

Open implementation truth:

- no final-closeout requirement is treated as corrected by this ingest;
- no product verification or external acceptance is treated as complete;
- ST-01 remains in review in Brain until implementation evidence and the preserved gate are reconciled.

## Decisions

- No new accepted decision.
- `DEC-0016` remains accepted and is not reopened.
- Final-closeout execution is authorized for the main workline; authorization is not completion or acceptance.

## Open Loops

- `OL-0028` advances from awaiting review of the integrity closeout to one final source-authority closeout.
- The four blockers and stable error correction must be implemented and verified with fictional evidence.
- ST-02, private ingestion, twelve-month backfill, and the Historian operator remain gated.

## Risks

- Assistance can contradict profile authority and invert committed source semantics.
- Incomplete paginated coverage or inconsistent row order can be canonized as complete evidence.
- Legacy imports without new period fields can coexist with duplicate ST-01 source authority.
- Concurrent Account/Space changes can alter commit or snapshot semantics after review.
- Generic commit errors can hide deterministic conflict outcomes from Studio and MCP.

## Opportunities

- Make source authority provable from the selected profile, source-kind completeness, legacy compatibility evidence, and one reviewed Account-context fingerprint.
- Establish precise semantic conflict outcomes before any private statement is admitted.

## Orbit Sync Candidates

- Keep the existing ST-01 Workline in review and set the final bounded objective to profile authority, source-kind coverage/sequence, legacy-period compatibility, Account-context binding, and stable commit errors.
- Record the prior integrity foundations as externally accepted but do not mark overall ST-01 done from this ingest.
- Keep ST-02, private statement ingestion, the Historian operator/backfill, and later lanes unstarted.
- Sync no private source path, filename, statement content, Account record, amount, credential, or live-database fact.

No Orbit or `.orbit` state was changed by this ingest.

## Routine Items Intentionally Excluded

- No product code, schema, generated artifact, architecture document outside Brain, Studio, tRPC, MCP, database, private source, service, archive, Orbit write, commit, merge, or push.
- No implementation or acceptance result inferred from the embedded prompt.
