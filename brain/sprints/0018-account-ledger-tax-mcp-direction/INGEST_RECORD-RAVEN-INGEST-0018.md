# Ingest Record - RAVEN-INGEST-0018

## Metadata

- Ingest id: `RAVEN-INGEST-0018`
- Title: Account Ledger, Statement Reconciliation, Tax, And MCP Direction
- Project: Raven
- Orbit project: Financial Mastery
- Mode: external-validation / live-capture / pre-work-primer
- Source kind: external orchestrator synthesis plus attributable live user direction
- Source date: 2026-07-28
- Ingest date: 2026-07-28
- Status: complete
- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0018-account-ledger-tax-mcp-direction/`
- Distillation: `brain/distillations/RAVEN-INGEST-0018-account-ledger-tax-mcp-direction.md`
- Brain patch: `brain/sprints/0018-account-ledger-tax-mcp-direction/BRAIN_PATCH.md`

## Source Mapping

1. `01-account-ledger-tax-orchestrator-response.txt`
   - Role: external architecture synthesis for the Account Ledger, statement reconciliation, management/tax lenses, and agent-assisted meaning
   - Original path: `/Users/michaelpeters/.codex/attachments/c2aa8329-ebb6-4f25-b13a-1dbbdc9c9e5a/pasted-text.txt`
   - Byte length: `17485`
   - Newline count: `663`
   - SHA-256: `89ca143e2fa88be60c62797708046fcfd7be329098097e6e29470509f0c36651`
   - Byte equality: verified with `cmp` on 2026-07-28

2. `02-michael-account-ledger-tax-mcp-direction.md`
   - Role: attributable live direction from Michael
   - Source date: 2026-07-28
   - SHA-256: `e8255df7a7413c7ffd1e93e1f8cf0751cf72eb38da70e53bbd37f76c228c0949`
   - Preservation: the user message is stored verbatim inside the raw-source wrapper

## Authority And Status

### Accepted Existing Architecture

- Imported statement evidence and observed transactions remain immutable facts.
- Transfers remain separate from income and expenditure.
- Exact money, provenance, uncertainty, and Studio/tRPC/MCP semantic-operation parity remain binding Account Control architecture.
- Account Control Worklines 01-03 and the Generated Data Atlas remain complete.

### Attributable Current User Direction

- Make account pages and transaction ingestion operational as the next practical focus.
- Treat bank-statement movements as the backbone truth from which later meaning is built.
- Begin with one recent month across the relevant accounts, then work backward month by month.
- Support provisional current-month expense entry followed by statement-backed matching and reconciliation.
- Preserve the current Penpot-derived visual design; wire existing views rather than redesigning them without discussion.
- Improve agent and MCP support for transaction review, categorization, fee understanding, period access, and tax-related proposals.
- Leave buckets to the separate active lane.

### Orchestrator Recommendations

- Make the Account Ledger the primary Past-lane workspace.
- Treat manual entries as provisional observations and statement rows as independent external evidence.
- Reconcile manual and statement evidence without double counting.
- Separate permanent source facts from Management and Tax interpretation lenses.
- Keep evidence, management meaning, and tax/review status as independent dimensions.
- Use exact split allocations and allow agents to suggest, explain, confirm, reject, and supersede meaning rather than silently assigning it.

### Proposed, Not Accepted

- The `Management | Tax` lens vocabulary.
- `AccountPeriodReconciliation` or any other reconciliation persistence model.
- Exact management/tax allocation persistence and versioning.
- Tax-state vocabulary, professional authority, evidence-reference, workpaper, and filed-position contracts.
- Tax Lane 00-05 implementation sequencing.

## MCP Gap Candidates

The source identifies candidate semantic gaps rather than proving the current implementation status of every operation:

- statement preview and commit;
- manual-to-statement candidate matching and explicit match confirmation;
- account-period reconciliation status, balance proof, exceptions, and attestation;
- clarification/review queues;
- fee and category analysis;
- explainable learned management suggestions;
- suggestion confirmation, rejection, and supersession;
- exact split-allocation review;
- period-level classification and evidence coverage;
- tax-treatment proposals, evidence sufficiency, and professional review, blocked behind `OL-0027`;
- bounded report or workpaper reads by account, period, classification, and review state.

## Handling

- The orchestrator output was preserved byte-for-byte.
- The attributable user direction was preserved verbatim.
- No private statement, account record, tax source, database, mailbox, or Ground Zero evidence was inspected or ingested.
- No product code, schema, generated artifact, UI, Orbit state, service, commit, or push was changed.
- No Tax lane, Workline 04, or buckets workline was started.

## Outcome

The Brain now records Account Ledger operationalization and statement reconciliation as the next user-directed Past-lane focus, with MCP gap analysis as a required planning input. It does not accept the separate Tax & Transaction Meaning contract, its candidate vocabulary, or Tax Lane 00-05.
