---
status: complete
owner: Raven
last_reviewed: 2026-08-04
supersedes: []
superseded_by: []
---

# Raven Statement Truth ST-01 Implementation

## Scope

ST-01 implements the accepted source-only vertical:

```text
private evidence + optional extraction assistance
  -> advisory profile detection
  -> explicit Account and profile selection
  -> no-write neutral preview
  -> atomic immutable source commit
  -> source import, row, component, and issue reads
```

It does not create or resolve a `Transaction`, accepted Merchant, Category,
management meaning, tax meaning, match, disposition, or reconciliation.

## Source Bundle

The local vault defaults to `.raven-private/statements/`. Local-path MCP intake is
limited to `.raven-private/statement-inbox/` unless
`RAVEN_STATEMENT_INBOX_ROOTS` supplies another explicit root.

The vault:

- resolves real paths and requires containment in an allowed inbox;
- rejects traversal, symlinks, non-regular files, oversize sources, and
  MIME/signature mismatches;
- stages through an owner-only temporary directory and atomic rename;
- stores owner-readable/writable source files;
- returns and persists only an opaque `stmt-src-*` reference;
- never returns an absolute source path.

Studio sends uploaded bytes to the server-side vault. MCP accepts a contained local
path. These transport envelopes differ deliberately and return the same
`StatementSourceDescriptor`.

## Source Identity

ST-01 keeps three identities separate:

1. `originalFileSha256` hashes exact bank evidence bytes.
2. Optional `extractionInputSha256` hashes the separate OCR/vision/normalized-JSON
   assistance artifact.
3. `canonicalExtractionSha256` hashes Raven's deterministic neutral extraction.

`previewHash` binds these identities to the selected Account and Financial Space
context fingerprint, profile ID/version, extractor version, validation-ruleset
version, source coverage, and every source fact that affects commit. The context
fingerprint covers canonical IDs/keys, currency, Account nature, Space timezone, and
masked last-four account evidence. A new commit reopens and rehashes both vault artifacts,
re-extracts, and revalidates the preview before any database write. Exact replay
resolves the prior `FinancialOperation` from the submitted preview hash and command
metadata before vault access, so a committed operation remains replayable when its
staged source is temporarily unavailable.

Normalized JSON cannot provide Account authority, checksum authority, Merchant,
Category, transaction kind, or tax treatment. The normalized-JSON profile requires
the original evidence and a distinct JSON sidecar; JSON cannot impersonate the
source.

## Extraction Assistance Contract

The canonical operator packet is:

- `docs/contracts/statement-extraction-input-v0.1.schema.json`;
- `docs/contracts/statement-extraction-input-v0.1.example.json`;
- `docs/contracts/statement-extraction-input-v0.1.md`.

The JSON Schema rejects unknown structural fields and defines the versioned neutral
wire shape. Runtime validation additionally enforces exact Gregorian dates, unique
row/component keys, contiguous source-order row numbers `1..N`, arrays at every row/component boundary, safe
integers and checked accumulation, role/flow/effect coherence, printed-date
presence, running-balance reproduction, and zero-row rules.

Coverage declares `complete`, `incomplete`, or `indeterminate`, source page count,
processed pages, source and processed sections, and printed row count. Raven derives
the extracted row count. Complete PDF/image coverage requires a positive page count
and processed pages exactly `1..N`; CSV/OFX/QIF sources are explicitly nonpaginated.
Locator page/line and geometry bounds are checked against that source-kind contract.
Complete coverage also requires all declared sections and printed rows; incomplete
or indeterminate monetary coverage creates blocking `STATEMENT_PARTIAL_PERIOD`.

Bank-specific profiles own their balance convention. Assistance that contradicts
that convention is invalid, and the selected Account economic nature must match the
profile. `normalized-json-v1` remains explicitly `operator_unverified`, always emits
`STATEMENT_BALANCE_CONVENTION_UNVERIFIED`, and never creates a closing snapshot.

## Component And Date Truth

`StatementRowComponent` distinguishes:

- `movement`: positive `amountMinor`, a signed effect of the same absolute
  magnitude, known coherent flow, and at least one exact printed row/component date;
- `informational_breakdown`: positive `amountMinor`, zero balance effect, and no
  eligibility for later transaction materialization or movement totals.

Rows and components preserve separate printed transaction, posting, and value dates.
Adapters do not invent a missing date. Printed running balances remain source facts
and are checked row by row against the opening balance and accumulated signed
movement. All exact totals use checked safe-integer addition.

## Commit Boundary

Preview, profile detection, and preview validation call no repository write method
and create no `FinancialOperation`. Blocking issues keep commit disabled and cause
zero database writes.

One Surreal transaction creates:

- one `FinancialOperation`;
- one deterministic `StatementSourceClaim` scoped by Account and original source
  hash;
- one deterministic `StatementPeriodClaim` scoped by Account and exact start/end
  dates;
- one `StatementImport`;
- all `StatementRow` records;
- all `StatementRowComponent` records;
- committed non-blocking `StatementIssue` records;
- `AccountStatementImports`, `StatementImportRows`,
  `StatementRowComponents`, and `StatementImportIssues` traversal edges;
- an observed statement-closing `AccountBalanceSnapshot` only when the signed
  closing value, complete coverage, profile-owned balance convention, and Account
  nature determine an exact magnitude and economic nature.

The transaction re-reads and exactly revalidates the reviewed Account/Space context
before creating source authority. Context drift returns `STATEMENT_PREVIEW_STALE`
and rolls back every attempted write. Claims make different-source first writes
for one Account/period and same-source writes under another identity mutually
exclusive. A bounded Surreal write-conflict retry resolves against the durable claim
and returns `STATEMENT_DUPLICATE_SOURCE` or
`STATEMENT_IMMUTABLE_CONFLICT`. Stable post-failure inspection also preserves precise
legacy-period and preview-stale errors when the Surreal client masks an intentional
transaction throw. Failed row, component, or issue writes roll back the
operation, claims, import, edges, and snapshot together.

The same idempotency key and request hash returns the original import, `importedAt`,
records, edges, source references, operation, and snapshot identity. A changed
request under the same key returns `IDEMPOTENCY_CONFLICT`. A changed source for an
occupied Account/period is blocked; replacement and supersession remain later
commands.

The closing snapshot key hashes Financial Space, Account, and import identity. Its
`asOf` is the end of the statement period date in the owning Financial Space
timezone; `2026-07-31` in `Africa/Johannesburg`, for example, resolves to
`2026-07-31T21:59:59.999Z`. An assistance assertion without compatible
profile/account convention preserves the source closing value and warning but
creates no snapshot.

## Legacy Fidelity

Statement reads return the persisted source state, profile version, extractor
version, currency, and validation ruleset. Missing or unrecognized ST-01 authority
fields are exposed as `legacy` / `legacy-unverified`; they are never upgraded by a
read adapter.

Studio labels source states as:

- `ST-01 committed source`;
- `Legacy import — source authority not yet verified`;
- `Superseded source`.

The historical renderer shape is recognized from `statementDate` plus its
date-prefixed key without inventing a period start. A matching renderer-era closing
date creates blocking `STATEMENT_LEGACY_PERIOD_CONFLICT`; an active legacy import
without safe period clues creates `STATEMENT_LEGACY_COMPATIBILITY_REQUIRED`.
Inspecting or migrating private legacy records remains a separately authorized
aggregate-only compatibility gate.

## Product Surfaces

Raven Studio adds:

- `Import statement` to Account actions and the command palette;
- `/accounts/{spaceKey}/{accountKey}/statements/import`;
- `/accounts/{spaceKey}/{accountKey}/statements/{importKey}`;
- compact selected-month source state on the existing Account Ledger.

The source workspace supports original evidence and extraction-assist selection,
explicit adapter selection, exact balance and issue preview, nested row components,
blocked commit state, atomic commit, and committed source inspection.

One reviewed preview owns one Studio command-intent key. Failed requests and lost
responses reuse it. A successful commit, route abandonment, changed source,
Account/profile change, or newly generated preview clears it. Source/profile changes
also clear stale preview state and disable commit. A sidecar `profileHint` is shown
only as an extraction-assistance hint.

The shared domain/tRPC camelCase and MCP snake_case surface contains 14 operation
pairs from `stageStatementSource` through `getStatementImportIssue`.
Both transports use shared strict Zod input schemas. A fictional bounded multi-page
PDF-sized upload and JSON sidecar regression proves SuperJSON serialization, server
validation, private vault staging, and path redaction.

## Verification

- strict canonical MPDG validation, live spec generation, current-project
  generation, import dry-run, and configured-target import passed; the import proof
  used an empty in-memory server on the configured loopback endpoint and refused to
  run if that port was occupied;
- the extraction JSON Schema compiled in strict Draft 2020-12 mode and validated
  the fictional example;
- Raven Domain typecheck and 83/83 tests passed;
- Raven Surreal typecheck and 32/32 tests passed;
- Raven MCP typecheck and 5/5 tests passed, including all 14 ST-01 operation pairs
  and the fictional upload transport;
- Raven Studio production build passed without starting a development server;
- Raven Studio source-state and retry-intent regressions passed 2/2;
- a disposable in-memory SurrealDB smoke passed profile mismatch, complete-PDF
  coverage bypass rejection, actual renderer-era legacy collision, commit-time
  Account-context rollback, stable source/period claim errors, successful commit,
  exact replay after staged-source removal, changed-request conflict, concurrent
  same-period/different-source exclusion, row/component/issue rollback, exact source
  records and runtime edges, Johannesburg snapshot time, and zero
  Transaction/meaning/tax/match/reconciliation records;
- Data Atlas tests passed 9/9 and consecutive stale checks reported 23 current
  models;
- fictional legacy statement-render tests passed 2/2;
- archive-safety tests passed 5/5 and the AI-safe dry-run excluded private statement,
  raw Brain, environment, and credential-bearing paths;
- Brain health and scoped secret/path-redaction checks passed.

The live smoke started its own loopback-only in-memory Surreal process, namespace,
database, and temporary vault and removed them in `finally`. It never read or wrote
the configured private Raven database.

## Current Limitations

- ST-01 is ZAR-only.
- The first four adapters consume the strict neutral extraction-assist contract.
  Native PDF/CSV/OFX/QIF parsing without a sidecar is not yet implemented.
- Blocking preview issues are intentionally not persisted.
- Same-period source replacement is blocked rather than superseded.
- Native bank-format detection remains separate from assistance hints.
- Staged-but-uncommitted source retention remains a later private-vault operating
  policy.
- Private legacy compatibility remains unaudited and unmigrated.
- Matching, transaction materialization, duplicate-event prevention, and exact
  period reconciliation remain the separately authorized, unstarted ST-02 workline.
- No private statement has been staged or inspected during implementation.
