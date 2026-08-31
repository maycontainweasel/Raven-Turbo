---
status: accepted
owner: Raven
last_reviewed: 2026-07-11
completed: 2026-07-11
contract: raven-account-control-contract-v0.1
---

# Account Control Workline 01 Implementation

## Product surface

Workline 01 is implemented in Raven Studio as the `/accounts` vertical. It includes the minimal application shell, central route/action registry, Ark UI command palette and overflow menu, account list grouped by financial space, current-position summary, account creation, and append-only balance confirmation.

The six semantic operations are:

- `list_accounts` / `accountControl.listAccounts`
- `get_account` / `accountControl.getAccount`
- `get_current_position` / `accountControl.getCurrentPosition`
- `get_account_freshness` / `accountControl.getAccountFreshness`
- `create_account` / `accountControl.createAccount`
- `confirm_account_balance` / `accountControl.confirmAccountBalance`

UI, tRPC, and MCP use the same `AccountControlApi` and shared transport handler map. Typesense is not used for critical reads.

## Persistence

Schema canon starts in `apps/schema/config/graph.mpdg`.

- `Account` adds `openingBalanceMinor`, `normalNature`, `liquidityClass`, and `freshnessWindowHours`.
- `AccountBalanceSnapshot` is immutable balance evidence with kind, exact minor units, currency, economic nature, as-of time, recording time, evidence level, source kind, source reference, and operation reference.
- `FinancialOperation` records command, idempotency key, request hash, channel, result references, warnings, status, and timestamps.

All domain arithmetic uses validated safe-integer minor units. Unknown balances remain unknown; stale evidence remains visible and makes totals provisional; informational available credit is excluded from assets and liquid cash.

## Acceptance hardening

The final Workline 01 hardening pass establishes these invariants:

- `accountKey` is unique within a Financial Space, not globally. Human account names and account keys may repeat in different spaces.
- The canonical Account record ID is `stringID(space, key)`. This matches existing Raven composite Account IDs, prevents new cross-space collisions, and requires no broad record-ID migration.
- Duplicate checks use `spaceKey + accountKey`, matching the composite storage identity. A remaining persistence race is mapped to stable `ALREADY_EXISTS` domain behavior rather than exposing a raw database error.
- Each open create-account or confirm-balance dialog owns one command-intent idempotency key. Failed submissions and lost-response retries reuse it. Success, cancellation, dialog closure, or selecting a new account clears it before the next command.
- Optional balance notes are carried into immutable snapshot persistence and returned in `BalanceView`; they are no longer accepted and discarded.

Focused tests cover command-intent retry reuse/reset, same-name/same-key accounts in different spaces, stable same-space duplicate errors, and balance-note persistence/return. A disposable live Surreal smoke also verifies composite identity and note replay without retaining fixture records.

## Invalid-future closeout

Future-dated balance evidence beyond the accepted five-minute tolerance is never selected or counted. When it is the only credible same-account, same-currency, non-informational evidence, the account exposes `invalid_future` freshness with the newest offending observation time while keeping `selectedBalance` null. Valid fresh or stale evidence continues to win when present.

Account queries return partial quality with `BALANCE_INVALID_FUTURE`. Current position reports affected accounts separately from ordinary missing balances, keeps known totals free of future amounts, and makes liquid cash unavailable when a material liquid account has only invalid-future evidence. Raven Studio renders `Invalid future`, the offending as-of time, and a precise excluded-observation notice.

## Migration behavior

`migrateAccountControlFoundation` in `packages/raven-surreal` is audit-first. Its default mode performs no writes and returns aggregate counts only.

- Existing canonical safe-integer `openingBalanceMinor` values are retained.
- Legacy opening balances are converted through the exact decimal parser.
- Unsupported precision, unsupported currencies, unsafe ranges, and absent values are counted as exceptions and are not coerced.
- Missing account classifications are counted for human review; suggested classifications are deterministic but are not silently applied.
- Only the latest imported transaction with statement-row provenance is eligible per account.
- Transaction-derived snapshots use the original `postedAt` as `asOf`, `evidenceLevel: observed`, and `sourceKind: transaction_observation`.
- Negative observed balances are represented as positive minor units with liability economic nature.
- Apply mode is explicit and idempotent by transaction source reference.

Generated schema assets for `Account`, `AccountBalanceSnapshot`, and `FinancialOperation` were imported into the local Raven database. The private-data backfill was not run automatically.

## Review boundary

Workline 01 is accepted and complete. The final fixed-clock regression suite, all domain/Surreal/MCP tests and typechecks, and the Raven Studio production build pass. Transaction commands, transfers, schedules, occurrences, upcoming cashflow, tax, invoicing, retainers, budgets, debt strategy, and buckets remain out of scope; Workline 02 has not started.
