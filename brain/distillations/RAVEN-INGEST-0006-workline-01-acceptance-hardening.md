# Distillation - RAVEN-INGEST-0006 - Workline 01 Acceptance And Hardening Review

## Source

- Raw source directory: `brain/source-material/external-review/RAVEN-INGEST-0006-workline-01-acceptance-hardening/`
- Ingest record: `brain/sprints/0006-workline-01-acceptance-hardening/INGEST_RECORD-RAVEN-INGEST-0006.md`
- Source and ingest date: 2026-07-11
- Mode: external-validation
- Source kind: external-review / orchestrator-output

## Executive Distillation

The external reviewer inspected a fresh AI-safe archive and accepted the black-canvas and first-load fixes. It also reported that Workline 01 is now represented in product code across the Accounts route, shell, commands, balance truth, shared domain and Surreal layers, tRPC, semantic MCP, migration reporting, and focused tests. The reviewer could not independently rerun the production build because dependencies were excluded and registry access was unavailable, so the build result remains a reported local result rather than independently reproduced evidence.

The review does not recommend beginning Workline 02 yet. It identifies three bounded integrity issues to correct while Workline 01 remains in review: idempotency keys must survive failed UI retries, balance notes must be persisted rather than discarded, and account identity must use a globally collision-safe key rule consistent across UI, domain duplicate detection, and Surreal record identity.

## Externally Validated Observations

These are observations made by the external reviewer from the reviewed archive, not facts independently re-executed by this Brain-only ingest:

- The Accounts operational queries are client-only and expose loading, error, and Retry states.
- The dark system theme uses a true-black canvas with neutral-black panels and restrained borders.
- Light mode remains available when the operating system prefers light mode, consistent with the accepted system-aware theme direction.
- Workline 01 implementation exists across the expected Studio, domain, persistence, transport, MCP, migration, and focused-test surfaces.
- The source accepts the black-canvas and first-load fixes.
- The reviewer could not independently rerun the production build.

## Integrity Findings

### Retry-stable idempotency

The review reports that account creation and balance confirmation generate a new idempotency key inside each submit attempt. If a command succeeds but its response is lost, a user retry can become a second command. The recommended invariant is intent-scoped identity: generate the key when a dialog intent opens, retain it across failed retries, and replace it only after success, cancellation, or a genuinely new intent.

### Balance-note preservation

The UI and domain accept an optional balance note, but the reviewed Surreal adapter reportedly persists an empty string. Because notes can explain unusual balances, overdrafts, delays, or discrepancies, silently discarding them weakens evidence provenance. The review recommends carrying notes through the snapshot draft and persistence layer.

### Globally coherent account identity

The review reports a mismatch between globally keyed Surreal Account record IDs and domain duplicate detection scoped by financial space. Name-only slugs such as `current-account` can collide across Personal and Business. The recommended bounded correction is a space-qualified default key and one global uniqueness rule, with a clean domain error for collisions and compatibility for existing records.

## Decisions

No new product or architecture decision is established by this source. The review validates accepted Workline 01 direction and proposes implementation hardening within that contract.

## Open Loops

- Keep `OL-0019` in review until retry-stable idempotency, note persistence, and account-key collision handling are corrected and verified.
- Rerun focused package tests and the Raven Studio build after the corrections.
- Only after final Workline 01 acceptance should the observed transaction and transfer vertical begin.

## Risks

- A retry after a lost response can duplicate an otherwise successful command when request identity changes per submit attempt.
- Silently discarded balance notes can erase useful evidence context.
- Inconsistent account-key uniqueness can produce unexpected persistence collisions across financial spaces.

## Opportunities

- The next recommended vertical remains observed transactions and transfers: account detail, expense and income entry, linked transfers, categories, month-to-date totals, history, semantic MCP parity, and transfer exclusion from income and expense totals.
- This is sequencing guidance, not authorization to begin Workline 02.

## Repeated Themes

- Command identity belongs to the user's intent, not an individual transport attempt.
- Evidence metadata must survive every layer without silent loss.
- Domain uniqueness rules must match persistence identity rules.
- External archive inspection can validate source presence while preserving uncertainty about tests it could not rerun.

## Orbit Sync Candidates

- Keep Workline 01 in review with the three acceptance-hardening findings.
- Mark Workline 01 done only after focused corrections and verification.
- Sequence the observed transaction and transfer vertical after final acceptance.
- No Orbit or `.orbit` state was changed in this Brain-only sidecar.
