# Distillation - RAVEN-INGEST-0010 - Workline 02 Final Import Identity And Immutability Closeout

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0010-workline-02-import-identity-closeout/`
- Ingest record: `brain/sprints/0010-workline-02-import-identity-closeout/INGEST_RECORD-RAVEN-INGEST-0010.md`
- Source date: 2026-07-12
- Ingest date: 2026-07-12
- Mode: external-validation / pre-work-primer
- Source kind: linked external AI final-acceptance review and authoritative closeout prompt

## Executive Distillation

The external review accepts the completed Workline 02 financial-truth hardening for manual expense and income, atomic tracked-account transfers, transfer exclusion, account and currency isolation, Johannesburg-local month progress, ignored and unresolved fact handling, concurrent idempotency, Raven Studio, tRPC, and semantic MCP parity. It does not accept the statement-import boundary as safe for real multi-account replay. Workline 02 therefore remains in review, and Workline 03 must remain unstarted.

The linked execution prompt authorizes one final bounded closeout. Imported identities must be scoped to their owning Financial Space, account, StatementImport, or source row as appropriate; raw import facts must use deterministic identity and immutable checksums; replay must ensure equality or return a stable conflict atomically; local category and merchant keys must safely repeat across spaces; migration reports must not misclassify complete manual/generated canonical rows; and Studio must disclose whole-month quality even when the problematic row is outside the current page. Neither review source proves that this closeout is already implemented.

## Externally Accepted Areas

- Exact canonical expense and income semantics.
- Atomic linked transfers and their exclusion from income, outflow, and net.
- Explicit empty account scope and account/currency isolation.
- Johannesburg-local `asOf` month calculations and exclusion of ignored, unresolved, future-dated, and transfer facts from ordinary totals.
- Concurrent idempotency replay and stable conflicts for the existing command surface.
- Account-detail currency gating and Studio, tRPC, and MCP parity across the 13 Account Control operations.
- The external reviewer independently reran the archive's pure Node statement-renderer regression and reports it passed `1/1`; package tests and the Nuxt build were not independently rerun because dependencies were absent from the AI-safe archive.

These are external-review findings, not verification performed by this Brainkeeper.

## Final Blocking Boundary

### Scoped Record Identity

- Imported transaction and clarification identities currently derive from statement end date and row number, which can collide across accounts and Financial Spaces.
- `StatementImport`, `Transaction`, `ClarificationTask`, `Category`, `Merchant`, and `ClassificationRule` carry narrower domain scope than their current global record identity expresses.
- `StatementRow` lacks deterministic source-row identity, so exact replay can append duplicate raw evidence.
- The final invariant must allow local semantic keys to repeat across spaces while persisted identities include their owning scope.
- Public APIs may continue exposing local keys; callers should not need to construct composite Surreal record IDs.

### Immutable Import Facts And Replay

- Unconditional import-path `UPSERT`, generated StatementRow IDs, regenerated `importedAt`, and an empty `sourceChecksum` do not preserve immutable source truth.
- Exact replay must reuse the original records, source links, and observation timestamp without duplicates.
- Reuse of an existing identity with a changed immutable amount, currency, financial date, raw source fingerprint, source account, or source import must return a stable conflict with no partial write.
- Classification-only review may change audited meaning only through an explicit path that cannot mutate immutable monetary or source fields.
- Actual source corrections remain append-only or use explicit replacement/correction lineage.

## Bounded Secondary Corrections

- A complete coherent canonical manual or generated transaction must count as `alreadyCanonical`; its legitimate `entrySource` must not be treated as conflicting merely because a legacy-derived proposal assumes `imported`.
- Whole-month progress quality and warnings must be unioned and deduplicated with current ledger-page warnings so partial or provisional totals remain visible even when the responsible row is on another page.
- Ignored rows remain inspectable but do not independently degrade ordinary month-total quality after exclusion.

## Required Fictional Evidence

- Cross-space statements with the same period end, row numbers, local category keys, and merchant slug preserve distinct scoped identities.
- Exact source replay produces one import, row, transaction, task, and edge set while preserving the original import observation time.
- Changed immutable facts under an existing identity return a stable conflict and preserve the original records without partial writes.
- Classification-only review preserves immutable monetary and source fields.
- Personal and Business may each own `fees` and the same normalized merchant key while transactions resolve within their account's Financial Space.
- Complete manual canonical transactions do not produce false imported-source migration conflicts.
- Account detail exposes whole-month warnings outside the current ledger page without ignored warnings degrading ordinary totals.
- Existing Workline 01 and Workline 02 expense, income, transfer, balance, month, tRPC, and MCP behavior remains unchanged.

## Decisions

- No new Brain decision is created by this sidecar.
- The packet establishes the bounded final closeout contract, but Workline 02 completion remains contingent on implementation and fictional verification.

## Open Loops For Main Agent

- Implement and document scoped identity for all affected models through the schema canon where required, then regenerate and inspect generated authority.
- Implement deterministic source/import identity, immutable checksums, and atomic ensure-or-conflict replay without exposing raw generated CRUD as the normal import surface.
- Correct scoped category/merchant resolution, migration-audit truth, and whole-month warning disclosure.
- Produce an aggregate-only compatibility/migration report and later apply plan if existing private records require identity migration; do not run a private migration in this workline.
- Run the complete fictional regression and verification matrix, then update active Brain and Orbit state honestly.
- Mark Workline 02 done only if all acceptance criteria are proven. Do not start Workline 03.

## Risks Preserved From The Packet

- Global record identities can let a later cross-account import overwrite or rebind an earlier financial fact.
- Non-deterministic raw-row identity can duplicate source evidence on exact replay.
- Unconditional source-fact upserts can mutate imported money, date, account, provenance, or observation time.
- Globally keyed categories, merchants, rules, and tasks can leak meaning across Personal and Business spaces.
- Aggregate migration reporting can falsely label legitimate manual/generated canonical rows as conflicts.
- Page-only warnings can conceal why a whole-month total is partial or provisional.

## Repeated Themes

- Persistence identity must express the same ownership scope as domain identity.
- Imported monetary and source facts are immutable; corrections require explicit lineage rather than overwrite.
- Idempotent replay means same identity plus same immutable facts, while changed facts must fail atomically.
- Local semantic keys may repeat across Financial Spaces without sharing persisted records.
- Financial quality disclosure must follow the scope of the calculation, not only the currently visible page.
- External review, implementation evidence, and final workline completion remain separate gates.

## Orbit Sync Candidates For Main Agent

- Keep Workline 02 in `review` until all final closeout criteria are implemented and proven.
- Mark Workline 02 done only after the fictional acceptance matrix and required verification pass.
- Keep Workline 03 unopened and unstarted in this closeout.
- No Orbit or `.orbit` state was inspected or changed by this Brainkeeper sidecar.
