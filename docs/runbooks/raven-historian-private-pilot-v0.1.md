---
status: working
owner: Raven
last_reviewed: 2026-08-08
supersedes: []
superseded_by: []
---

# Raven Historian Private Pilot v0.1

## Purpose

This runbook governs one controlled private Statement Historian pilot for one recent,
complete, closed ZAR period. It uses ST-01 source truth and ST-02 ledger resolution
through Raven's semantic MCP. It does not authorize ST-03, tax treatment, recurrence,
buckets, Workline 04, or bulk historical backfill.

Private statement bodies remain in Raven's local private inbox and vault. They must
not enter Git, Brain source material, Orbit prose, logs, screenshots, fixtures, or
external archives. Generic Surreal access is diagnostic and read-only; every financial
write uses a named semantic Raven MCP operation.

## Pilot Selection Checklist

Michael selects the real account/period set. Do not record its private identity in
this runbook or any project-memory artifact.

- [ ] The period is recent, complete, closed, and explicitly confirmed as final.
- [ ] The period and every participating account use ZAR; no FX conversion is needed.
- [ ] Opening and closing balances are present for each statement source.
- [ ] Every tracked account that sent money to or received money from the target
      account during the period is included in the pilot set.
- [ ] Each source has an accepted adapter or an approved normalized JSON
      extraction-assistance route.
- [ ] The aggregate-only compatibility audit has established the selected period's
      occupancy class without exposing account or transaction details.
- [ ] No selected period is replayed over a legacy or canonical import without an
      explicit later replacement/migration decision.
- [ ] Michael has approved the account/period set before any source is staged.

## Operator Sequence

### A. Inventory and select account/period

Use the checklist above. Work with one statement and one controlled period at a time,
while keeping the full interacting-account set visible for transfer review. Stop if
currency, period closure, source completeness, or legacy occupancy is uncertain.

### B. Stage source privately

Place the original source and any separate normalized extraction-assistance artifact
inside the configured private inbox. `stage_statement_source` copies bounded evidence
into the owner-only vault and returns an opaque source reference. Never echo a local
path or source body into chat, logs, Brain, Orbit, Git, or an archive.

### C. Detect/select adapter and Account

Use `list_statement_profiles` and `detect_statement_profile` for advisory detection.
Michael explicitly confirms the Raven Account and exact versioned profile. Detection
never selects either authority automatically.

### D. Run write-free preview

Use `preview_statement_import`. Preview writes no financial database records. If the
profile uses normalized JSON assistance, preserve the original evidence and the
assistance artifact as separately hashed inputs.

### E. Inspect preview evidence

Review source coverage, source and extraction hashes, period, currency, opening and
closing balances, printed rows, movement and informational components, issues, and
all blockers. Use `validate_statement_preview` immediately before requesting commit
approval. Any blocking issue remains no-write.

### F. Commit source only after explicit approval

Show Michael the redacted preview summary and ask a direct approval question. Only
after explicit approval use `commit_statement_import` with a retry-stable idempotency
key. The commit is atomic and creates immutable source truth, not Transactions.

### G. Inspect movement components

Use the committed-source read operations to inspect source rows, neutral components,
and source issues. Informational breakdown components have zero ledger effect and are
never materialized as movements.

### H. Review cross-account transfers first

Use `list_statement_match_candidates` across the selected interacting-account set.
Opposite-account evidence is a review candidate only. Never infer a transfer merely
from equal magnitude or opposing flow, and never materialize while transfer review is
required.

### I. Match provisional Transactions explicitly

For a reviewed existing provisional Transaction, explain the candidate, uncertainty,
exact source component set, amount, direction, financial date, and Account. A proposal
is not confirmation. Ask Michael before `confirm_statement_transaction_match`.

### J. Materialize unmatched components explicitly

For a reviewed movement with no existing provisional Transaction, explain why it is
unmatched and ask Michael before
`materialize_statement_component_transaction`. One command creates exactly one
observed imported Transaction plus its confirmed evidence linkage.

### K. Recalculate reconciliation

Use `recalculate_statement_reconciliation` after resolution changes. Prove:

```text
opening balance
+ exact signed movement effects
= calculated closing balance

reported closing balance
- calculated closing balance
= zero
```

### L. Resolve or acknowledge eligible issues

Blocking issues cannot be waived. Explain each eligible non-blocking issue and ask
Michael before `acknowledge_statement_issue`. Preserve the issue and audited
disposition; do not rewrite source facts.

### M. Attest only at exact zero

Attestation requires complete source coverage, exact zero difference, no blocking
issue, one active resolved disposition for every movement component, and complete
component/match/Transaction claim-set proof. Show the current revision and calculation
hash, ask Michael explicitly, then use `attest_statement_reconciled`.

### N. Export an aggregate pilot report

Report only counts, compatibility/reconciliation states, operation receipts, whether
the exact equation passed, and open blocker classes. Exclude source bodies,
descriptions, amounts, filenames, account identities/numbers, local paths, and notes.

### O. Stop for external pilot review

Stop after the first controlled period. Do not process a second period or begin bulk
backfill until the pilot artifact and operator behavior are reviewed and accepted.

## Meaning Boundary

Reconciliation proves source-backed movement truth. Category, Merchant, management
classification, tax treatment, recurring schedules, and bucket allocations are not
required for reconciliation and must not be invented by the Historian.

## Service Boundary

The semantic MCP can operate independently of Raven Studio. If
`https://raven.studio:4443` returns `502`, visual review is degraded but a no-write MCP
preview is not blocked. The bounded recovery action is for Michael to restart the
user-managed Studio service with `pnpm -C apps/raven-studio run dev`; the Historian
must not start a second development server.

## First Operator Instruction

> Start the controlled Raven Historian pilot in inventory-and-selection mode only.
> Help me select one recent, complete, closed ZAR period and every interacting tracked
> account using the HP-00 checklist. Do not open or stage a statement until I explicitly
> approve the account/period set.
