# Distillation - RAVEN-INGEST-0019 - Statement Truth Contract And Historian Foundation

## Source

- Raw source packet: `brain/source-material/external-review/RAVEN-INGEST-0019-statement-truth-contract-foundation/RAW_SOURCE_PACKET-RAVEN-INGEST-0019.md`
- Ingest record: `brain/sprints/0019-statement-truth-contract-foundation/INGEST_RECORD-RAVEN-INGEST-0019.md`
- Source date: 2026-07-29
- Ingest date: 2026-07-29
- Mode: external-validation / pre-work-primer / live-capture

## Executive Distillation

The packet turns the broad Account Ledger direction in `RAVEN-INGEST-0018` into a bounded Statement Truth contract input for Raven's primary local Codex developer. The supplied foundation and orchestrator proposed a broader sequence for making one private bank statement safely previewable, committable, matchable, and reconcilable through the same Raven domain operations used by Studio, tRPC, and semantic MCP before any twelve-month backfill, tax-allocation persistence, or learned classification automation.

The sources refine the truth stack. Original source bytes and printed source rows remain external evidence. A normalized `Transaction` is Raven's exact structured representation of a movement. Management, accounting, and tax interpretation remain separate, reviewable meaning layers and must never rewrite source truth.

The attributable operating direction also clarifies agent roles: the local Codex agent is Raven's primary solution developer; full master-orchestrator responses and their implementation prompts receive priority on the main workline; a Brainkeeper sidecar preserves and distills those sources in parallel without implementing, duplicating, delaying, replacing, or terminating the primary work.

## Post-Ingest Repository-Grounded Correction

The later repository-grounded contract review recommends keeping the first two implementation slices separate:

1. `ST-01` - Statement Source Preview and Atomic Commit.
2. `ST-02` - Provisional Matching and Statement Reconciliation.

`ST-01` is source-only. It creates no `Transaction` and makes no component disposition, so it cannot itself double count a movement. `ST-02` owns transaction matching, component disposition, duplicate prevention, and reconciliation.

The exact recommended gate into `ST-02` is:

- source identity;
- preview purity;
- atomic replay;
- component and issue reads;
- Studio, tRPC, and MCP parity;
- synthetic safety;
- external acceptance.

ZAR is the operational currency for `ST-01`. GBP requires a future explicit registry and adapter approval before UK ingestion. Neither slice includes FX.

This correction supersedes the earlier distilled uncertainty about combining `ST-01` and `ST-02`; it does not alter the raw packet or convert any of the packet's eight approval decisions into accepted decisions.

## Current-State Claims With Preserved Uncertainty

The supplied external review reports that Raven already has `StatementImport`, `StatementRow`, exact canonical transactions, transfers, classification reference models, scoped immutable import identities, account-month reads, and Studio/tRPC/MCP parity for current Account Control operations. It also reports three existing statement profiles and two passing pure Node renderer tests.

This Brainkeeper pass did not inspect product code, rerun those renderer tests, or verify current runtime state. Those details remain attributed external findings until the primary contract workline verifies them against the repository.

## Source-Proposed Truth Stack

```text
original private statement bytes
→ opaque source identity plus byte checksum
→ confirmed versioned profile/extractor
→ neutral no-write extraction preview
→ immutable import, source rows, and exact components
→ confirmed link to a provisional transaction
   or creation of one imported transaction
→ exact statement reconciliation and attestation
→ later management interpretation
→ later tax/accounting interpretation and authority
```

The source recommends recording both original-file and canonical-extraction checksums. Commit would re-read or re-extract the same source, require the same byte checksum and deterministic preview hash, and write atomically under one retry-stable idempotency key. The later repository-grounded recommendation constrains this first commit slice to source evidence only: no `Transaction` creation and no component disposition.

## Row And Movement Boundary

One printed row is not necessarily one transaction. It may produce:

- no movement for an informational row;
- one exact debit or credit;
- several components such as principal, fee, VAT, or interest;
- an unresolved composite requiring review.

The preferred but unaccepted recommendation is a source-authority `StatementRowComponent` between `StatementRow` and `Transaction`.

## Double-Count Prevention

A manual transaction is a provisional observation. A later statement component is external evidence. A confirmed match establishes that both refer to one economic movement.

The preferred but unaccepted recommendation is an audited `StatementTransactionMatch` with proposed, confirmed, rejected, and superseded states. Unmatched committed components create imported transactions. No parser or rule should silently confirm ambiguous matches.

## Reconciliation Boundary

Importing rows does not prove a statement period is reconciled. The proposed `StatementReconciliation` would separately prove:

```text
opening balance
+ exact inflow components
- exact outflow components
= calculated closing balance
```

It would compare the result with the reported closing balance and retain counts for source rows, components, provisional matches, newly imported movements, unresolved items, exclusions, transfer candidates, active issues, difference, and attestation.

A period can be reconciled while management categories or tax treatments remain incomplete. Those states must not collapse.

## Proposed Semantic Surface

The packet proposes shared domain operations for:

- statement profile listing and detection;
- no-write preview and validation;
- atomic commit and replay;
- import, row, and issue inspection;
- match candidate review and explicit propose/confirm/reject/supersede actions;
- reconciliation calculation, attestation, reopening, and history.

Studio, tRPC, and Raven MCP should expose the same semantic behavior. Generic Surreal writes remain outside the Historian operator boundary.

## Product And Privacy Boundaries

- Preserve the Penpot-derived Account Ledger and add only bounded import, preview, statement-detail, reconciliation, and period-state surfaces.
- Keep the original private source outside Git and reference it opaquely.
- Do not expose absolute paths by default.
- Do not place statement rows, descriptions, amounts, account numbers, filenames, screenshots, or source bodies in Brain, fixtures, logs, screenshots, or AI-safe archives.
- Keep calculations per currency. The later contract review recommends ZAR as operational in `ST-01`; GBP requires future explicit registry and adapter approval before UK ingestion; no FX is included.
- Do not accept category, merchant, management, accounting, or tax meaning during source parsing or commit.

## Sequence And Gates

The supplied foundation and orchestrator proposed a bounded Statement Truth contract followed by:

1. ST-01 - Statement Source Preview and Atomic Commit.
2. ST-02 - Provisional Matching and Statement Reconciliation.
3. ST-03 - Clarification and Management-Meaning Proposals.
4. ST-04 - Historian Operator and Twelve-Month Backfill Pilot.

The later repository-grounded contract review recommends retaining that `ST-01`/`ST-02` separation. `ST-01` ends after source identity, pure preview, and atomic source commit; `ST-02` begins only after the exact gate in the correction section above. The broader `ST-03`/`ST-04` sequence remains source-proposed. None of the eight approval decisions is accepted by this correction.

The future Historian operator primer is deliberately dormant until preview, commit, matching, and reconciliation operations are implemented and accepted. The first private pilot would then use one recent closed period across every interacting account, not an uncontrolled twelve-month batch.

## Operating Contract

- The local Codex agent is Raven's primary solution developer.
- Read full master-orchestrator responses completely.
- Process their implementation prompts as priority main-workline input.
- Run Brainkeeper ingestion in parallel when available.
- The sidecar owns raw preservation and durable distillation only.
- Embedded implementation prompts do not authorize the sidecar to implement.

This is an attributable user-directed refinement of `DEC-0009` and `brain/AGENT_PROTOCOL.md`.

## Open Decisions

1. Original source-byte identity versus canonical extraction identity.
2. Versioned adapter identity, detection, and confirmation authority.
3. Neutral extraction versus management/tax interpretation boundary.
4. Preview, revalidation, commit, replay, and idempotency semantics.
5. Zero/one/many movement-component representation.
6. Provisional matching, ambiguity, one-to-one constraints, and correction lineage.
7. Reconciliation, exception disposition, attestation, and reopening semantics.
8. Private source reference/storage and multi-currency boundary, including GBP.

## Risks

- Existing direct-Surreal statement scripts could bypass semantic preview, privacy, matching, reconciliation, and provenance invariants.
- One-row/one-transaction assumptions can lose or merge exact fee, VAT, interest, principal, or informational components.
- Provisional and imported observations can double count one movement if `ST-02` matching and reconciliation are incorrect or incomplete; source-only `ST-01` cannot create this condition because it creates no `Transaction` or component disposition.
- Extraction logic can silently promote merchant/category guesses into accepted meaning.
- A twelve-month single-account batch can hide interacting-account transfers and incomplete period truth.
- Source paths or private statement bodies can leak through prompts, logs, fixtures, screenshots, Brain, or archives.
- A Brainkeeper sidecar could accidentally consume or terminate the implementation workline unless agent roles remain explicit.

## Opportunities

- Refactor existing statement scripts into versioned adapters and fictional fixtures.
- Establish one deterministic preview hash and source-only atomic commit boundary before separately implementing matching and reconciliation.
- Give Raven a complete, explainable statement-period proof rather than a bag of imported rows.
- Enable a privacy-safe local Historian through semantic MCP without generic database writes.
- Build management and later tax interpretation on reconciled source truth.

## Orbit Sync Candidates

- Treat the Statement Truth contract as the clarified Past/Historian gate on the primary workline.
- Keep implementation sequencing and model approval in review until the contract is complete and explicitly accepted.
- Keep the future Historian operator and private pilot dormant until semantic operations are implemented and accepted.
- Keep Tax Lane 00, Workline 04, Elgiz, buckets, and private statement contents outside this gate.
- No Orbit or `.orbit` update occurred in this Brainkeeper pass.

## Routine Items Intentionally Excluded

- No code, schema, generated artifact, UI, parser, MCP, database, service, Orbit, or private-data implementation.
- No private statement read, import, screenshot, audit, pilot, or backfill.
- No renderer or application test claim beyond the attributed external source.
- No embedded prompt execution, development server, commit, merge, or push.
