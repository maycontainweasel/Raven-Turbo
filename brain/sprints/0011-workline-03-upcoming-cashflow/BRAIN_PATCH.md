# Brain Patch - RAVEN-INGEST-0011 - Workline 03 Upcoming Cashflow Validation And Pre-Work Primer

## Sources Ingested

- `RAVEN-INGEST-0011` - one external Workline 02 completion/transition review and one authoritative Workline 03 pre-work prompt preserved verbatim.
- Source 1 SHA-256: `bf6813a661d68ed40d331d426ac22eac400cdd829a67d7a312b0c56d0202a5fe` (`8970` bytes, `219` lines).
- Source 2 SHA-256: `f95e73f913fa8d36d129c078de243797a9c8e0c949033f279873638f3ba9a9be` (`26131` bytes, `620` lines).
- Byte equality with both supplied files was verified using `cmp`.

## Files Created

- `brain/source-material/external-review/RAVEN-INGEST-0011-workline-03-upcoming-cashflow/01-workline-02-acceptance-and-workline-03-review.txt`
- `brain/source-material/external-review/RAVEN-INGEST-0011-workline-03-upcoming-cashflow/02-workline-03-upcoming-cashflow-prompt.md`
- `brain/sprints/0011-workline-03-upcoming-cashflow/INGEST_RECORD-RAVEN-INGEST-0011.md`
- `brain/distillations/RAVEN-INGEST-0011-workline-03-upcoming-cashflow.md`
- `brain/sprints/0011-workline-03-upcoming-cashflow/BRAIN_PATCH.md`

## Files Updated

- `brain/CHANGELOG.md`
- `brain/indexes/INGEST_INDEX.md`
- `brain/indexes/SOURCE_INDEX.md`
- `brain/indexes/THEME_INDEX.md`

## Source Authority Distinction

- Source 1 is external completion-review evidence and transition guidance. Its source-level findings and independently reported `2/2` renderer result are preserved with its explicit inability to rerun the wider package, live, and build verification.
- Source 2 is the authoritative Workline 03 implementation prompt.
- Neither source proves that Workline 03 has been implemented, verified, reviewed, or accepted.

## Identity Changes

- No accepted project-identity statement changed.
- The packet sharpens the future-money model: schedules represent accepted rules, while occurrences represent concrete due instances with immutable nominal-date identity.

## Tenets Changed

- None. The packet reinforces existing separation of observed, accepted, inferred, and possible money; exact-money handling; provenance; immutable history; idempotency; and explicit quality/state disclosure.

## Vision Deltas

- Upcoming Cashflow is framed as the next product vertical, answering what must be paid, what is expected to arrive, and when.
- Today Coverage remains a later vertical that consumes accepted future cashflow only after Upcoming is accepted.

## Decisions

- No Brain decision was added or changed by this sidecar.
- The prompt carries binding implementation invariants, but active decision reconciliation remains with the main agent.

## Open Loops

- Implement the bounded status/transaction-ID preflight and complete Workline 03 across schema, domain, Surreal, Studio, tRPC, and MCP.
- Prove recurrence, lifecycle, settlement, concurrency, and regression behavior with fictional data only.
- Reconcile active Brain and Orbit after implementation and verification.
- Leave Workline 03 in review and Workline 04 unstarted.
- `brain/OPEN_LOOPS.md` was intentionally not changed by this sidecar.

## Risks

- Preserved risks include observed/accepted truth conflation, recurrence date drift, duplicate occurrence identity after overrides, terminal-history mutation, false reconciliation, revision races, and premature replay of legacy private imports.
- No active risk record was added or changed; the main agent owns risk reconciliation after implementation and verification.

## Opportunities

- Establish the accepted-future-money foundation needed for later daily coverage and earning-rate calculations.
- Provide one transparent Upcoming view and one semantic API for human and agent use.

## Orbit Sync Candidates

- Establish the Workline 03 Upcoming Cashflow implementation workline.
- Leave it in `review` after implementation until Michael or external acceptance.
- Do not start Workline 04.
- No Orbit or `.orbit` state was inspected or changed.

## Active Brain Updates

- Intentionally did not update `brain/NOW.md`, `brain/HANDOFF.md`, `brain/DECISIONS.md`, `brain/OPEN_LOOPS.md`, `brain/ROADMAP.md`, `brain/EXECUTIVE_SUMMARY.md`, `brain/RISK_REGISTER.md`, or `brain/CAPTURE_QUEUE.md`.
- Those changes remain with the main agent after implementation and verification.

## Routine Items Intentionally Ignored

- Did not inspect or edit product code, schema, generated assets, architecture documentation, Studio UI, tRPC, MCP, repositories, migration code, or statement-rendering code.
- Did not run product tests, builds, schema imports, database queries, migrations, live smoke, archive generation, or a development server.
- Did not inspect or ingest private financial statements, transaction rows, account records, credentials, mailbox exports, dossiers, or secrets.
