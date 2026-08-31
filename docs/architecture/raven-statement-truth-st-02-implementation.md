---
status: complete
owner: Raven
last_reviewed: 2026-08-08
supersedes: []
superseded_by: []
---

# Raven Statement Truth ST-02 Implementation

## Scope

ST-02 implements the bounded bridge from committed source truth to one observed
ledger movement per exact movement component:

```text
committed source component
  -> deterministic no-write candidates
  -> audited proposal and explicit confirmation
  -> one existing statement-backed Transaction
  -> or explicit one-shot imported Transaction materialization
  -> exact period reconciliation
  -> attestation and append-only reopening
```

External review accepted ST-02 on 8 August 2026 for this bounded purpose. The accepted
archive is `raven-st02-financial-integrity-closeout-2026-08-06-ai-safe.zip` with
SHA-256 `6b379cd5eb5be7712bc2a1b95e36a8f279b1f5db22e8b2158735d766d904d2be`.
Acceptance does not add management or tax meaning, recurrence, buckets, or ST-03.

## Canonical Schema

The canonical MPDG adds five models:

| Model                                 | Identity                                    | Purpose                                                                |
| ------------------------------------- | ------------------------------------------- | ---------------------------------------------------------------------- |
| `StatementTransactionMatch`           | `stringID<statementImport, key>`            | Append-only audited proposal and confirmed evidence linkage            |
| `StatementComponentResolutionClaim`   | `stringID<statementRowComponent, "active">` | Transactional active uniqueness for one movement-component disposition |
| `StatementTransactionResolutionClaim` | `stringID<transaction, "active">`           | Transactional active uniqueness across statement imports               |
| `StatementReconciliation`             | `stringID<statementImport, "current">`      | Current exact Account-period equation, coverage, and attestation state |
| `StatementReconciliationEvent`        | `stringID<statementReconciliation, key>`    | Immutable attestation and reopening history                            |

`StatementImport` gains optimistic `revision`; `StatementIssue` gains explicit
review state, operation, actor, timestamps, and revision; and `Transaction` gains
an optional `statementMatch` evidence reference. Source rows, components, checksums,
dates, locators, amounts, and signed effects remain immutable.

## Resolution Invariants

- Match method, reason codes, confidence, signed component total, date distance,
  and transfer-candidate state are server-derived. External command schemas reject
  attempts to author those facts; only materialization can produce
  `created_from_component`.
- Candidate generation is deterministic and side-effect free. Existing confirmed
  links replay first, then explicit selection, exact reference, exact description,
  exact date, bounded date, and transfer-candidate evidence.
- Ordinary matching is limited to manual or generated provisional Transactions in
  the exact Account. Imported, legacy source-backed, already claimed, transfer-linked,
  unresolved, and ignored Transactions are ineligible.
- Transfer discovery spans every active tracked Account across Financial Spaces.
  An equal-magnitude, opposite-flow candidate remains review-only and blocks
  materialization with `STATEMENT_TRANSFER_REVIEW_REQUIRED`; ST-02 never creates an
  `AccountTransfer` automatically.
- Amount matching has no tolerance. Grouped components use checked safe-integer
  addition, must belong to one source row and one canonical financial date, and must
  equal the Transaction magnitude and direction exactly.
- Confirmation re-reads source state, component membership and checksums, Account,
  currency, amount, flow, accepted dates, Transaction eligibility, revisions, and
  both active claims inside the Surreal transaction.
- Matching an existing manual Transaction creates no Transaction and changes only
  its statement-evidence projection. Existing Category and management provenance
  remain untouched; tax remains `not_assessed`.
- Materialization creates exactly one deterministic imported Transaction, one
  confirmed `created_from_component` match, canonical row/account edges, and one
  `FinancialOperation` in one transaction. Replay returns those same records.
- Informational components have zero effect and cannot materialize.
- Every reconciliation-affecting write carries the reviewed reconciliation revision
  and calculation hash. Persistence checks both in the same transaction as the
  resolution write, with one bounded idempotent retry for a concurrent independent
  aggregate update. Surreal retryable write-conflict responses are translated into
  reconciliation staleness only after deterministic claim recovery finds no
  ownership conflict. Deterministic component and Transaction claims still serialize
  conflicting dispositions, while source replacement performs equivalent post-failure
  source, period, Account-context, and reconciliation recovery.
- Proposal rejection and match/source supersession preserve history. Confirmed match,
  issue-state, and source changes reopen an attested reconciliation atomically or
  fail.

## Financial Date And Active Authority

`Transaction.postedAt` remains the original observation date. A confirmed active
statement match projects the canonical source date into the existing optional
`Transaction.effectiveAt` field. Ledger ordering, month filtering, progress totals,
detail, tRPC, and MCP use `effectiveAt` only while that confirmed match and its import
remain committed; detail provenance exposes both dates.

Supersession clears `statementMatch` and `effectiveAt` from a previously matched
manual Transaction, returning it to provisional authority. A Transaction created
from a superseded source remains immutable history but receives
`canonical_historical_superseded` ledger authority and is excluded from active ledger
and month totals. Closing snapshots whose statement source is superseded are likewise
excluded from current-position selection.

Superseded imports, rows, matches, reconciliations, and attestation events remain
semantically readable. All mutation commands require the active committed source.

## Exact Reconciliation

The calculation is:

```text
openingBalanceMinor
+ sum(active movement component balanceEffectMinor)
= expectedClosingBalanceMinor

reportedClosingBalanceMinor
- expectedClosingBalanceMinor
= differenceMinor
```

Informational components contribute zero. All arithmetic is checked safe-integer
minor-unit arithmetic and remains ZAR-only.

Attestation requires an active authoritative import, unchanged Account/period/profile
identity, complete source coverage, exactly one confirmed disposition for every
movement component, no blocking issue or active uniqueness conflict, present opening
and closing balances, exact zero difference, current claims, matching calculation
hash, and expected reconciliation revision. Management Category, Merchant, tax,
recurrence, and buckets are deliberately not gates.

The final persistence check proves the exact movement-component set, active component
claim set, confirmed match set, active Transaction claim set, Transaction backrefs,
source claim, period claim, and current Account context in the attestation transaction.
Source replacement performs the same Account fingerprint and claim-ownership checks,
plus replacement profile, balance-authority, period, currency, count, and
reconciliation revision/hash checks before changing authority.

Attestation and reopening append immutable `StatementReconciliationEvent` records.
Reopening preserves the prior calculation snapshot. A fully valid reopened period
may be attested again at its new revision.

## Semantic Operations

ST-02 adds 14 shared operations, bringing Statement Truth to 28 camelCase tRPC and
snake_case MCP peers:

Queries:

- `listStatementMatchCandidates`
- `listStatementTransactionMatches`
- `getStatementTransactionMatch`
- `getStatementReconciliation`

Commands:

- `proposeStatementTransactionMatch`
- `confirmStatementTransactionMatch`
- `materializeStatementComponentTransaction`
- `rejectStatementTransactionMatch`
- `supersedeStatementTransactionMatch`
- `acknowledgeStatementIssue`
- `supersedeStatementImport`
- `recalculateStatementReconciliation`
- `attestStatementReconciled`
- `reopenStatementReconciliation`

Every command uses a retry-stable intent key, request hash, actor/channel provenance,
transactional final validation, replay, optimistic revision checks, and a
`FinancialOperation` receipt. The semantic MCP accepts typed operations only and no
raw SurrealQL or generic update/delete payload.

## Raven Studio

The existing Account Ledger design remains intact. The committed statement route,
`/accounts/{spaceKey}/{accountKey}/statements/{importKey}`, now has compact Ark UI
Source, Resolution, Reconciliation, and History tabs.

The route supports component dispositions, deterministic candidate inspection,
explicit propose/confirm/reject/supersede actions, one-shot materialization,
non-blocking issue acknowledgement, guarded source supersession, exact equation and
count drill-downs, recalculate, attest, reopen, and immutable operation/event history.
Command-intent keys survive failed requests and lost responses until success,
cancellation, or a changed reviewed payload. Raw local paths are never displayed.

The Account Ledger derives the period states `committed - resolution pending`,
`exceptions present`, `ready to attest`, `reconciled`, and `reopened`. Confirmed
manual matches do not add ledger rows; materialized movements appear once.

## Verification

The bounded fictional matrix is rerun for each closeout archive. The 6 August
financial-integrity pass includes:

- strict MPDG validation, spec generation, 28-model code generation, schema import
  dry-run, and full import into a temporary empty in-memory database on the configured
  loopback port;
- Raven Domain tests and typecheck, including server-derived evidence, strict grouped
  components, imported/source-backed exclusion, cross-space transfer candidates, and
  dual-date ledger projection;
- Raven Surreal tests and typecheck, including active ledger/snapshot projection,
  compare-and-swap guards, storage-level bundle checks, and transfer materialization
  blocking;
- Raven MCP: 5/5 tests, all 28 Statement Truth parity pairs, equivalent invalid-input
  handling, and typecheck;
- Raven Studio: 4/4 statement UI tests, 3/3 cashflow intent regressions, and Nuxt
  production build;
- disposable ST-02 live smoke covering matching, no duplication, cross-space transfer
  review and materialization blocking, replay, informational exclusion, exact
  reconciliation, exact-set attestation rejection, reopening, two independent
  concurrent confirmations, concurrent issue/match survival, exclusive component and
  Transaction races, source-created Transaction and closing-snapshot exclusion,
  readable superseded history, replacement re-resolution without an active duplicate,
  source/period ownership racing, Account-context racing, forced rollback, cleanup,
  and later-lane exclusions;
- disposable ST-01 live regression and 2/2 legacy renderer tests;
- strict Draft 2020-12 extraction-schema compilation and fictional-example
  validation.

The final Atlas, formatting, Brain, archive-safety, secret/path, and extracted-archive
checks are recorded in the review handoff. No development server, private Raven
record, commit, merge, or push was used.

No development server is started by this workline. Browser verification uses only a
user-managed endpoint when one is already available.

## Acceptance And Next Gate

ST-02 is done. HP-00 separately governs semantic MCP, private-vault, aggregate legacy
compatibility, and operator readiness before the first controlled private statement
pilot. ST-03 remains a separate future authorization for clarification and
management-meaning proposals. Tax meaning remains a separate lane.
