# Ingest Record - RAVEN-INGEST-0008

## Metadata

- Source id: RAVEN-INGEST-0008
- Title: Account Control Workline 02 - Observed Transactions And Transfers
- Project: Raven
- Mode: pre-work-primer
- Source kind: implementation-prompt
- Source date: 2026-07-11
- Ingest date: 2026-07-12
- Raw source directory: `brain/source-material/pre-work/RAVEN-INGEST-0008-workline-02-observed-transactions-transfers/`
- Distillation: `brain/distillations/RAVEN-INGEST-0008-workline-02-observed-transactions-transfers.md`
- Brain patch: `brain/sprints/0008-workline-02-observed-transactions-transfers/BRAIN_PATCH.md`

## Raw Source

1. `01-workline-02-implementation-prompt.md`
   - Original path: `/Users/michaelpeters/Downloads/Daily/raven_account_control_workline_02_prompt.md`
   - Byte length: `22649`
   - Line count: `539`
   - SHA-256: `a993d27fa8b877672cd8b4283f17dc4d724d50fe200a2e07b1946238e37b3aa2`
   - Byte equality: verified with `cmp` on 2026-07-12

## Handling

- The supplied Workline 02 implementation prompt is preserved verbatim as one standalone raw source.
- This source is treated as a pre-work primer and implementation authorization for the main agent, not as evidence that Workline 02 has already been implemented or verified.
- Workline 01 remains accepted and complete. Its exact-money, account-identity, idempotency, balance-selection, note-persistence, and invalid-future invariants are preserved as predecessor constraints.
- Workline 02 must end in `review`; it must not be marked done during implementation, and Workline 03 must not start.
- Active `NOW`, `HANDOFF`, and `OPEN_LOOPS` closeout edits remain owned by the main agent after implementation and verification.
- No Orbit, product code, schema, implementation documentation, or active Brain closeout state was modified by this Brainkeeper sidecar.
- No statements, account records, credentials, mailbox exports, dossiers, or other private financial source material were inspected or ingested.

## Outcome

The Brain now preserves the authoritative Workline 02 implementation boundary for one complete observed-money loop: account-month ledger reads, expense and income entry, atomic linked transfers, exact month totals excluding transfers, semantic transaction inspection, and equivalent Raven MCP operations. The source also preserves the required schema-first workflow, audit-first legacy migration, UI/tRPC/MCP parity, fixed verification matrix, explicit exclusions, and review stop gate.
