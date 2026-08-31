---
status: accepted
owner: Raven
last_reviewed: 2026-08-04
supersedes: []
superseded_by: []
---

# Raven Statement Truth, Import and Reconciliation Contract v0.1

## Decision Status

This bounded architecture gate was accepted on 2026-07-29. All eight decisions at
the end of this document are canonical for the Statement Truth vertical.

This pass changes no product code, schema, database, private source, or financial
record. It does not authorize a twelve-month import, tax persistence, management
classification automation, buckets, Workline 04, or a broad Raven Studio redesign.

The acceptance includes four binding implementation clarifications:

1. Original evidence bytes, optional OCR/normalized-JSON assistance, and Raven's
   canonical extraction are separate artifacts with separate identities.
2. Local-path intake is limited to configured inbox roots and must enforce real-path
   containment, regular-file and symlink checks, size/signature limits, owner-only
   vault permissions, atomic staging, and path redaction.
3. Components explicitly distinguish `movement` from
   `informational_breakdown`, preserve separate printed transaction/posting/value
   dates, and use safe signed balance effects without double-counting.
4. Blocking preview issues remain no-write; changed sources for an occupied
   Account/period are blocked in ST-01; closing snapshots require deterministic
   signed-balance and economic-nature mapping.

The ST-01 integrity closeout records these implementation clarifications without
reopening the eight accepted decisions:

1. Deterministic Account/source and Account/exact-period claim records make the
   source-authority decision inside the same transaction as the import. Retryable
   datastore write conflicts resolve against those claims and return stable Raven
   errors.
2. `statement-extraction-input-v0.1` is published as JSON Schema, a fictional
   example, and an operator guide. Coverage is explicit; incomplete or
   indeterminate monetary coverage blocks commit.
3. Legacy imports remain visible as unverified legacy source state and cannot
   silently occupy or be presented as new ST-01 authority.
4. Applied-operation replay occurs before vault access; new commands still reopen,
   rehash, extract, and validate the source.
5. Closing snapshots are Account/Financial-Space scoped, use the owning space
   timezone, and require authoritative profile/account balance compatibility.
6. Studio retains one idempotency key for one reviewed preview intent, and tRPC/MCP
   share one strict input-validation contract.

The final ST-01 source-authority closeout adds these binding clarifications without
reopening the accepted decisions:

1. A bank-specific profile owns its balance convention, and the selected Account
   economic nature must match it. Contradictory assistance is blocking. Generic
   normalized assistance remains explicitly operator-unverified and snapshot-ineligible.
2. Complete PDF/image evidence requires a positive page count and exact processed
   pages `1..N`; CSV, OFX, and QIF evidence is explicitly nonpaginated. Every source
   kind retains exact section and printed-row coverage, validated locators, and one
   contiguous canonical row sequence `1..N` in source order.
3. Known renderer-era `statementDate` and date-prefixed key evidence participates in
   exact-period conflict protection. Active legacy evidence that cannot be mapped
   safely fails closed for compatibility review.
4. Preview identity binds canonical Account/Financial Space identity, currency,
   Account nature, Space timezone, masked-account comparison context, profile
   authority/version, and validation-ruleset version through a deterministic context
   fingerprint. The source-authority transaction revalidates that context before any
   write; drift returns `STATEMENT_PREVIEW_STALE` and rolls back.
5. Post-preview source, period, legacy, stale-context, and idempotency races preserve
   their precise stable Raven errors across Studio and MCP.

With these clarifications and the full fictional verification matrix passing,
source-only ST-01 is complete. ST-02 is implemented in product and schema code and
remains in external review. Private ingestion remains a separate, unstarted
authorization gate.

The ST-02 implementation preserves this contract and adds five canonical models,
transactional active-resolution claims, deterministic no-write candidate generation,
explicit match/materialization commands, exact reconciliation, append-only
attestation/reopening history, Raven Studio workflow, and 28-operation Statement
Truth tRPC/MCP parity. Its implementation record is
`docs/architecture/raven-statement-truth-st-02-implementation.md`.

## Objective

Raven must safely process one private statement and one account period at a time:

```text
private source
  -> no-write neutral preview
  -> immutable source commit
  -> explicit transaction resolutions
  -> exact statement reconciliation
  -> attestation
  -> later management and tax interpretation
```

Raven Studio, tRPC, and Raven MCP must use one shared semantic domain
implementation. A Historian operator must never write financial records through raw
SurrealQL or generated CRUD.

## Repository-Grounded Audit

### Reusable now

| Existing surface          | Reusable capability                                                                                                                                 |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `StatementImport`         | Account-scoped import identity and immutable checksum guard.                                                                                        |
| `StatementRow`            | Import-scoped row identity, source preservation, confidence, and raw-data storage.                                                                  |
| `Transaction`             | Exact `amountMinor`, currency, source provenance, entry source, and immutable imported transaction checks.                                          |
| `FinancialOperation`      | Retry-stable command idempotency, request hashing, provenance, result references, warnings, and failure receipts.                                   |
| Import override functions | Exact replay, immutable-conflict detection, and transaction-scoped Surreal commits.                                                                 |
| Runtime relation tables   | Account to import, import to row, row to transaction, account to transaction, and transaction to current meaning records.                           |
| Shared Raven domain       | Exact money, account identity, transaction reads, command receipts, and transport parity conventions.                                               |
| Raven Surreal adapter     | Shared repository pattern, result normalization, error translation, and atomic command patterns.                                                    |
| Raven Studio              | Existing Penpot-derived Account Ledger, schema-generated controllers, custom router extension points, and semantic Account Control transport.       |
| Raven MCP                 | One semantic server with snake_case operations mapped to the same camelCase domain API used by tRPC.                                                |
| Statement generator       | Three useful profile parsers and PDF text-extraction prior art.                                                                                     |
| Statement renderer tests  | Fictional source fixtures proving exact minor units, scoped identities, replay, immutable conflicts, and classification-only checksum independence. |
| Generated Data Atlas      | Canonical model references plus the reviewed runtime import-edge registry.                                                                          |

### Verified limitations

The current statement scripts are useful migration material, not a safe Historian
interface:

1. The generator is selected by a command-line profile and contains profile-specific
   parsing, account assumptions, merchant guesses, categories, and some
   pre-clarified meaning.
2. Its editable Markdown format combines raw source, normalized movement, merchant,
   category, fee meaning, and clarification state.
3. The renderer writes SurrealQL directly instead of calling the shared Raven
   domain.
4. It hashes a canonical extraction object, not the original source bytes.
5. It stores and emits source filenames and source-derived notes beyond the proposed
   opaque-source boundary.
6. It generally creates one `StatementRow` and one `Transaction` per printed row.
   A separate fee column is not persisted as an independent exact source component.
7. It maps source debit to accepted expense/outflow and source credit to accepted
   income/inflow. A bank movement alone does not prove that management meaning.
8. It creates or links accepted Merchant and Category records in the source commit
   path and can mark rows and transactions clarified.
9. `StatementImport.status` currently combines parsing, matching, review, and error
   concepts.
10. `StatementRow.status` similarly combines source normalization, matching,
    clarification, and ignoring.
11. `StatementRow.amount` and `balance` remain legacy numeric fields. Exact source
    component money does not yet exist.
12. The generated StatementImport and StatementRow tRPC surfaces are generic CRUD.
    Their custom routers do not provide semantic preview, commit, matching, issue,
    or reconciliation operations.
13. The shared domain and Raven MCP have no statement semantic operations.
14. The only supported exact-money exponent is currently ZAR.
15. There is no audited manual-to-statement match, statement issue, component
    disposition, or period reconciliation aggregate.

The repository archive policy explicitly excludes `.raven-private/`,
`docs/statements/`, PDFs, and private-status documents from AI-safe archives. This
audit inspected that policy and did not inspect any private statement directory or
source file.

## Truth Stack

```text
Original private source bytes
    authority: external bank evidence

Opaque source reference + original SHA-256
    authority: source identity

Versioned adapter output
    authority: derived extraction, replayable but not original

Statement rows and components
    authority: immutable normalized source evidence

Confirmed component-to-transaction resolution
    authority: audited evidence link

Canonical Transaction
    authority: exact observed movement

Management meaning
    authority: reviewed interpretation

Tax and accounting meaning
    authority: evidence-backed, versioned, authorized interpretation
```

Every layer may add information. No later layer may rewrite an earlier source fact.

## Immutable Source Invariants

1. Original bytes remain outside Git and the Raven database in a private local
   source vault.
2. Raven persists an opaque source reference, never an absolute path.
3. Original-file SHA-256 and canonical-extraction SHA-256 are different identities.
4. The selected profile ID/version and extractor version are part of extraction
   identity.
5. A preview writes no financial database record.
6. Commit reopens the source, recomputes both hashes, and requires the approved
   preview hash.
7. Commit persists source claims, rows/components, issues, reviewed traversal edges,
   and any eligible closing snapshot atomically under one idempotent operation.
8. Exact replay returns the prior import and operation.
9. Changed bytes, extraction, target account, profile version, or validation
   ruleset cannot reuse the prior preview.
10. Source rows/components are append-only. A corrected statement is a new import
    with explicit replacement lineage.
11. The source commit path never accepts Merchant, Category, management kind, tax
    treatment, or business-purpose meaning.
12. Unknown, low-confidence, and unsupported source facts remain explicit.

## Contract Recommendations

### 1. Dual source identity

Record both:

- `originalFileSha256`: SHA-256 over the exact original bytes;
- `canonicalExtractionSha256`: SHA-256 over deterministic normalized adapter
  output.

The deterministic preview hash covers:

```text
target account
currency
original-file SHA-256
profile ID and version
extractor version
canonical extraction SHA-256
normalization contract version
coverage and every commit-relevant extracted source fact
```

Advisory match/transfer candidates and display-only metadata are excluded from the
preview hash because they depend on mutable database state. ST-02 re-reads candidates
before any transaction disposition.

The existing account plus import-key identity remains compatible, but new semantic
imports use a deterministic key derived from the original source hash and enforce
source-hash and exact-period uniqueness through explicit database claims. Different
bytes for the same period require a later append-only replacement/supersession
command; they are not an in-place update.

### 2. Versioned adapter authority

Detection is advisory. It returns ranked candidates and evidence. Preview requires
an explicit target Account and confirmed profile ID/version.

The first registry contains:

- `nedbank-current`;
- `nedbank-credit`;
- `fnb-business`;
- `normalized-json-v1`.

The first three are refactored from existing parser logic with all private account
metadata and accepted meaning removed. The normalized JSON adapter lets a local
vision process transcribe a screenshot or scanned source into the same neutral
contract. The original image remains the checksummed source.

No adapter may:

- choose or create an Account;
- accept management or tax meaning;
- mark a transaction clarified;
- write Raven records;
- silently discard an unsupported row;
- hide extraction confidence or source coordinates.

### 3. Neutral rows and exact components

Add `StatementRowComponent`. A printed row can contain:

- zero components for an informational row;
- one component for a simple movement;
- several components for principal, bank charge, VAT, interest, or another
  separately printed amount;
- one or more unresolved components when extraction cannot safely separate them.

Each component carries positive exact money plus a signed `balanceEffectMinor`.
Reconciliation uses the signed source effect rather than assuming that every account
uses the same asset-style debit/credit equation.

Source debit/credit does not become accepted expense/income. A new imported
Transaction starts with unresolved management meaning. A confirmed match to a
provisional manual Transaction preserves that Transaction's previously asserted
management meaning while adding statement evidence.

### 4. Preview, revalidation, and atomic commit

`previewStatementImport`:

- resolves a private source through a vault interface;
- computes original source identity;
- detects and applies a confirmed adapter;
- validates account, currency, period, balances, row/component coverage, and
  duplicate sources;
- finds provisional match and transfer candidates;
- calculates source reconciliation;
- returns warnings, blocking errors, and a deterministic preview hash;
- performs no financial database write.

`commitStatementImport`:

- requires `idempotencyKey`, source hash, preview hash, target account, and profile
  version;
- reopens and re-extracts the source;
- reruns duplicate, account, currency, profile, extraction, and validation checks;
- writes StatementImport, StatementRow, StatementRowComponent, StatementIssue,
- operation receipt, and deterministic edges in one transaction;
- creates no Transaction or component disposition in ST-01;
- creates no accepted management or tax meaning.

Committed components remain pending until ST-02 resolves each through an audited
match, imported-transaction materialization, or reviewed non-movement disposition.
This source-only commit cannot double count provisional activity.

### 5. Audited transaction resolution

Add `StatementTransactionMatch` as the audited link between one or more source
components and one Transaction.

It supports:

- `proposed`;
- `confirmed`;
- `rejected`;
- `superseded`.

A confirmed match:

- has one Account and one currency;
- links one or more exact components to one Transaction;
- requires the signed component total to equal the Transaction magnitude and
  compatible direction;
- does not mutate amount, date, account, currency, or original manual provenance;
- causes the transaction evidence projection to become statement-backed;
- is protected by expected revision and active-link uniqueness.

An explicit `create_imported` decision creates an unresolved-management imported
Transaction and a confirmed `created_from_component` match in the same atomic
operation.

No v0.1 matching rule silently confirms a provisional match. Exact replay of an
already confirmed source link is idempotent reuse, not automatic matching.

### 6. First-class issues and reconciliation

Add `StatementIssue` for extraction, source, component, matching, and reconciliation
exceptions. Do not overload `ClarificationTask`, which remains a management-meaning
review record.

Add `StatementReconciliation` for one Account and StatementImport. It stores exact
source equation inputs, component coverage, issue counts, calculation hash, revision,
state, and append-only attestation/reopening operations.

Source reconciliation and management/tax completion remain separate dimensions.

### 7. Private source and currency boundary

The source vault returns an opaque reference and byte stream. Semantic responses may
return source hash, MIME type, byte size, and safe display metadata, but not absolute
paths or raw source text by default.

ZAR is the only operational currency in ST-01. GBP must be added explicitly to the
exact-money exponent registry, adapters, and fictional fixtures before the first
UK-account preview. Every preview, match, and reconciliation is single-currency.
Cross-currency totals and FX gains/losses remain out of scope.

### 8. Keep source commit and matching/reconciliation as separate worklines

The repository does not support safely combining these scopes into one bounded first
vertical. ST-01 already crosses private source handling, adapter versioning, source
identity, schema extension, atomic persistence, Studio, tRPC, MCP, and synthetic
end-to-end verification. ST-02 adds a separate concurrency and attestation domain.

ST-01 commits no Transaction and no component disposition. It therefore cannot
double count provisional activity. The committed import is independently useful as
neutral source truth and review evidence while its components remain visibly
pending.

Keep the sequence:

> ST-01 - Statement Source Preview and Atomic Commit
>
> ST-02 - Provisional Matching and Statement Reconciliation

ST-02 begins only after ST-01 source-byte identity, preview purity, atomic replay,
component/issue reads, Studio flow, and tRPC/MCP parity are externally accepted.

## Typed Contract Sketches

These sketches define shape and responsibility. Exact names may change during
schema authoring only when the generated MPDG/runtime contract requires it.

### Core source types

```ts
type Sha256 = string & { readonly __sha256: unique symbol };
type StatementSourceRef = string & {
  readonly __statementSourceRef: unique symbol;
};

type StatementSourceKind =
  | "pdf"
  | "csv"
  | "ofx"
  | "qif"
  | "image"
  | "normalized_json";

type StatementSourceDescriptor = Readonly<{
  sourceRef: StatementSourceRef;
  sourceKind: StatementSourceKind;
  mimeType: string;
  byteSize: number;
  originalFileSha256: Sha256;
}>;

interface StatementSourceVault {
  stage(input: {
    bytes: AsyncIterable<Uint8Array>;
    mimeType: string;
    safeDisplayLabel?: string;
  }): Promise<StatementSourceDescriptor>;
  describe(sourceRef: StatementSourceRef): Promise<StatementSourceDescriptor>;
  read(sourceRef: StatementSourceRef): Promise<Uint8Array>;
}
```

### Profile detection and extraction

```ts
type StatementProfileRef = Readonly<{
  profileId: string;
  profileVersion: string;
  extractorVersion: string;
}>;

type ProfileDetection = Readonly<{
  profile: StatementProfileRef;
  confidence: number;
  evidenceCodes: string[];
  warnings: StatementWarning[];
}>;

interface StatementAdapter {
  readonly profile: StatementProfileRef;
  readonly institution: string;
  readonly sourceKinds: readonly StatementSourceKind[];

  detect(
    source: StatementSourceDescriptor,
    bytes: Uint8Array,
  ): Promise<ProfileDetection | null>;

  extract(
    source: StatementSourceDescriptor,
    bytes: Uint8Array,
  ): Promise<NormalizedStatementExtraction>;
}
```

### Normalized extraction

```ts
type SourceLocator = Readonly<{
  page?: number;
  line?: number;
  region?: Readonly<{ x: number; y: number; width: number; height: number }>;
  sourceToken?: string;
}>;

type StatementComponentKind =
  | "principal"
  | "bank_fee"
  | "vat"
  | "interest"
  | "adjustment"
  | "unknown";

type StatementSourceComponent = Readonly<{
  componentKey: string;
  componentKind: StatementComponentKind;
  postedOn?: string;
  description: string;
  amount: MoneyWire;
  sourceDirection: "debit" | "credit" | "unknown";
  balanceEffectMinor: number;
  locator?: SourceLocator;
  confidence: number;
  sourceChecksum: Sha256;
  warnings: StatementWarning[];
}>;

type StatementSourceRow = Readonly<{
  rowKey: string;
  rowNumber: number;
  rowKind: "movement" | "informational" | "composite" | "unresolved";
  postedOn?: string;
  rawText: string;
  reportedBalanceMinor?: number;
  locator?: SourceLocator;
  confidence: number;
  sourceChecksum: Sha256;
  components: readonly StatementSourceComponent[];
  warnings: StatementWarning[];
}>;

type NormalizedStatementExtraction = Readonly<{
  contractVersion: "statement-extraction-v0.1";
  profile: StatementProfileRef;
  institution: string;
  accountHints: Readonly<{
    maskedAccount?: string;
    sourceAccountType?: string;
  }>;
  currency: string;
  periodStart: string;
  periodEnd: string;
  balanceConvention: string;
  openingBalanceMinor?: number;
  closingBalanceMinor?: number;
  rows: readonly StatementSourceRow[];
  canonicalExtractionSha256: Sha256;
  warnings: StatementWarning[];
}>;
```

`rawText` is private product evidence. It is permitted in Raven's private database
and operator UI, but prohibited from Brain, logs, test snapshots, and AI-safe
archives.

### Preview and future explicit resolutions

`ComponentResolution` belongs to ST-02. It is not part of the ST-01 preview hash or
source commit request.

```ts
type ComponentResolution =
  | Readonly<{
      componentKeys: readonly string[];
      action: "match_existing";
      transactionId: string;
      expectedTransactionRevision: number;
    }>
  | Readonly<{
      componentKeys: readonly string[];
      action: "create_imported";
    }>
  | Readonly<{
      componentKeys: readonly string[];
      action: "defer";
      reasonCode: string;
    }>;

type StatementMatchCandidate = Readonly<{
  candidateKey: string;
  componentKeys: readonly string[];
  transactionId: string;
  method:
    | "existing_source_link"
    | "exact_reference"
    | "exact_amount_date_description"
    | "exact_amount_date"
    | "amount_date_window";
  confidence: number;
  reasonCodes: string[];
  blockingWarnings: StatementWarning[];
}>;

type StatementPreviewResult = Readonly<{
  source: StatementSourceDescriptor;
  profile: StatementProfileRef;
  account: Readonly<{ spaceKey: string; accountKey: string; currency: string }>;
  extraction: NormalizedStatementExtraction;
  rowCount: number;
  componentCount: number;
  informationalRowCount: number;
  inflowMinor: number;
  outflowMinor: number;
  expectedClosingBalanceMinor?: number;
  reportedClosingBalanceMinor?: number;
  differenceMinor?: number;
  duplicateImports: readonly string[];
  matchCandidates: readonly StatementMatchCandidate[];
  transferCandidates: readonly StatementMatchCandidate[];
  issues: readonly StatementIssueView[];
  warnings: readonly StatementWarning[];
  errors: readonly StatementError[];
  previewHash: Sha256;
  commitAllowed: boolean;
  meta: StatementQueryMeta;
}>;

type StatementTransactionMatchView = Readonly<{
  id: string;
  componentIds: readonly string[];
  transactionId: string;
  state: "proposed" | "confirmed" | "rejected" | "superseded";
  method: StatementMatchCandidate["method"] | "created_from_component";
  confidence: number;
  reasonCodes: readonly string[];
  revision: number;
  proposedOperationId: string;
  resolutionOperationId?: string;
  reviewedAt?: string;
  notes?: string;
}>;

type StatementIssueView = Readonly<{
  id: string;
  importId: string;
  rowId?: string;
  componentId?: string;
  code: StatementWarningCode | StatementErrorCode;
  severity: "info" | "warning" | "blocking";
  state: "open" | "acknowledged" | "resolved" | "superseded";
  message: string;
  revision: number;
  dispositionOperationId?: string;
}>;

type StatementReconciliationResult = Readonly<{
  id: string;
  statementImportId: string;
  account: Readonly<{ spaceKey: string; accountKey: string }>;
  currency: string;
  periodStart: string;
  periodEnd: string;
  openingBalanceMinor: number;
  componentBalanceEffectMinor: number;
  expectedClosingBalanceMinor: number;
  reportedClosingBalanceMinor: number;
  differenceMinor: number;
  counts: Readonly<{
    rows: number;
    components: number;
    matched: number;
    imported: number;
    excluded: number;
    pending: number;
    unresolved: number;
    activeIssues: number;
  }>;
  drillDown: Readonly<{
    pendingComponentIds: readonly string[];
    unresolvedComponentIds: readonly string[];
    blockingIssueIds: readonly string[];
    conflictingMatchIds: readonly string[];
  }>;
  calculationState: "unavailable" | "difference" | "balanced";
  coverageState: "incomplete" | "complete";
  attestationState: "open" | "ready" | "reconciled" | "reopened";
  revision: number;
  attestationOperationId?: string;
  attestedAt?: string;
  warningCodes: readonly StatementWarningCode[];
}>;
```

### Query and command metadata

```ts
type StatementQueryMeta = Readonly<{
  requestId: string;
  generatedAt: string;
  contractVersion: "statement-truth-v0.1";
  warnings: readonly StatementWarning[];
}>;

type StatementCommandMeta = Readonly<{
  idempotencyKey: string;
  channel: "ui" | "mcp" | "import" | "system";
  actorId?: string;
  requestedAt: string;
  expectedRevision?: number;
}>;

type StatementCommandReceipt = Readonly<{
  operationId: string;
  status: "applied" | "replayed";
  resultRefs: readonly string[];
  warningCodes: readonly StatementWarningCode[];
  completedAt: string;
}>;
```

### Stable warnings and errors

```ts
type StatementWarningCode =
  | "STATEMENT_ROW_LOW_CONFIDENCE"
  | "STATEMENT_ROW_UNRESOLVED"
  | "STATEMENT_COMPONENT_UNRESOLVED"
  | "STATEMENT_BALANCE_MISSING"
  | "STATEMENT_BALANCE_DIFFERENCE"
  | "STATEMENT_MANUAL_MATCH_CANDIDATE"
  | "STATEMENT_TRANSFER_CANDIDATE"
  | "STATEMENT_EXISTING_IMPORT_FOUND"
  | "STATEMENT_PARTIAL_PERIOD"
  | "STATEMENT_MATCH_DATE_DIFFERENCE";

type StatementErrorCode =
  | "STATEMENT_SOURCE_NOT_FOUND"
  | "STATEMENT_PROFILE_UNSUPPORTED"
  | "STATEMENT_PROFILE_AMBIGUOUS"
  | "STATEMENT_SOURCE_CHANGED"
  | "STATEMENT_PREVIEW_STALE"
  | "STATEMENT_DUPLICATE_SOURCE"
  | "STATEMENT_ACCOUNT_MISMATCH"
  | "STATEMENT_CURRENCY_MISMATCH"
  | "STATEMENT_PERIOD_INVALID"
  | "STATEMENT_EXTRACTION_INVALID"
  | "STATEMENT_IMMUTABLE_CONFLICT"
  | "STATEMENT_MATCH_CONFLICT"
  | "STATEMENT_COMPONENT_ALREADY_DISPOSED"
  | "STATEMENT_RECONCILIATION_INCOMPLETE"
  | "STATEMENT_RECONCILIATION_DIFFERENCE";

type StatementWarning = Readonly<{
  code: StatementWarningCode;
  message: string;
  rowKey?: string;
  componentKey?: string;
}>;

type StatementError = Readonly<{
  code: StatementErrorCode;
  message: string;
  retryable: boolean;
  rowKey?: string;
  componentKey?: string;
}>;
```

## Schema Comparison and Recommendation

### StatementImport

Retain account-scoped identity and extend it with:

- opaque `privateSourceRef`;
- `originalFileSha256`;
- `sourceMimeType` and `sourceByteSize`;
- `profileId`, `profileVersion`, and `extractorVersion`;
- `canonicalExtractionSha256` and `previewHash`;
- exact `periodStart` and `periodEnd`;
- `currency`;
- exact optional opening and closing balance minor units;
- `commitOperation`, `committedAt`, and replacement lineage;
- source-only state.

Deprecate `sourceFileName` from semantic responses. Split the overloaded current
status into source commit state and separate reconciliation state.

### StatementRow

Retain import-scoped identity and raw evidence. Add:

- stable source locator;
- row kind;
- exact optional reported balance minor units;
- extraction confidence;
- immutable row checksum.

Treat current `amount`, `direction`, `transaction`, and meaning-oriented status as
legacy compatibility. One row is no longer assumed to be one movement or one
Transaction.

### StatementRowComponent

Add a source-authority model with identity:

```text
StatementRow + component key
```

Required fields:

- owning Space, Account, StatementImport, and StatementRow;
- component key and kind;
- source date and description;
- exact positive amount minor units and currency;
- source debit/credit/unknown direction;
- signed source `balanceEffectMinor`;
- locator, confidence, checksum, and source state.

No Merchant, Category, tax, project, client, or accepted purpose field is allowed.

### StatementTransactionMatch

Add an audited aggregate containing:

- one or more component references;
- one Transaction;
- state, method, confidence, and reason codes;
- proposed, confirmed, rejected, and superseded operation references;
- reviewer identity and timestamps;
- revision and supersession lineage.

Enforce:

- one active confirmed match per component;
- one active statement match per Transaction within the source period;
- exact account, currency, signed-total, and direction compatibility;
- optimistic concurrency for confirmation and supersession.

### StatementIssue

Add a dedicated source/reconciliation issue model with:

- import, optional row, and optional component;
- stable code, severity, blocking flag, and message;
- open/resolved/rejected/superseded state;
- detected and resolution operations;
- reviewer, timestamps, notes, and revision.

`ClarificationTask` remains management-meaning review and is not reused.

### StatementReconciliation

Add one reconciliation aggregate per Account and StatementImport:

- period and currency;
- exact opening, movement effect, expected closing, reported closing, and
  difference minor units;
- row/component coverage counts;
- confirmed existing matches and newly imported transaction counts;
- deferred, unresolved, informational, transfer-candidate, and active-issue counts;
- calculation hash and revision;
- calculation, coverage, and attestation states;
- attestation/reopening operations and timestamps.

### Transaction

Retain exact transaction money and current import compatibility. Add or project a
source-component evidence link through confirmed `StatementTransactionMatch`.

New source-created Transactions remain management `unresolved` and have no accepted
Merchant or Category. Existing provisional Transactions keep their manual meaning
when matched. The account-ledger evidence projection must recognize a confirmed
StatementTransactionMatch as statement-backed.

### Runtime relations

Extend the reviewed runtime-edge registry only after schema acceptance:

```text
StatementRowComponents
StatementComponentIssues
StatementComponentMatches
StatementMatchTransactions
StatementImportIssues
StatementImportReconciliation
```

The final names must follow generated Schema conventions. Direct record fields
remain canonical schema authority; relation-table names remain explicit runtime
registry entries.

## Semantic Operation Catalog

All camelCase operations live in the shared Raven domain. tRPC exposes camelCase.
Raven MCP exposes the exact snake_case peer.

| Kind    | Domain/tRPC                                | MCP                                           | Contract                                                                                   |
| ------- | ------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Command | `stageStatementSource`                     | `stage_statement_source`                      | Copy bytes into the private local vault and return opaque identity; no financial DB write. |
| Query   | `listStatementProfiles`                    | `list_statement_profiles`                     | List versioned adapters and supported source kinds.                                        |
| Query   | `detectStatementProfile`                   | `detect_statement_profile`                    | Return ranked candidates and evidence; never confirm.                                      |
| Query   | `previewStatementImport`                   | `preview_statement_import`                    | No-write source extraction, validation, candidates, and equation.                          |
| Query   | `validateStatementPreview`                 | `validate_statement_preview`                  | Revalidate an existing preview hash without commit.                                        |
| Command | `commitStatementImport`                    | `commit_statement_import`                     | Re-extract and atomically commit immutable source, rows, components, and issues only.      |
| Query   | `listStatementImports`                     | `list_statement_imports`                      | List safe import summaries by account/period/state.                                        |
| Query   | `getStatementImport`                       | `get_statement_import`                        | Read import identity, counts, states, and provenance.                                      |
| Query   | `listStatementRows`                        | `list_statement_rows`                         | Page private source rows and component summaries.                                          |
| Query   | `getStatementRow`                          | `get_statement_row`                           | Read one row, components, issues, and source-safe metadata.                                |
| Query   | `listStatementRowComponents`               | `list_statement_row_components`               | Page exact source components for one row or import.                                        |
| Query   | `getStatementRowComponent`                 | `get_statement_row_component`                 | Read one exact component, locator, checksum, and disposition state.                        |
| Query   | `listStatementImportIssues`                | `list_statement_import_issues`                | List source/reconciliation exceptions separately from meaning tasks.                       |
| Query   | `getStatementImportIssue`                  | `get_statement_import_issue`                  | Read one source issue and its audited disposition.                                         |
| Query   | `listStatementMatchCandidates`             | `list_statement_match_candidates`             | Deterministically rank provisional candidates.                                             |
| Query   | `listStatementTransactionMatches`          | `list_statement_transaction_matches`          | List audited proposals and resolutions for an import or component.                         |
| Query   | `getStatementTransactionMatch`             | `get_statement_transaction_match`             | Read one match, evidence, revision, and operation history.                                 |
| Command | `proposeStatementTransactionMatch`         | `propose_statement_transaction_match`         | Persist an audited proposal after source commit.                                           |
| Command | `confirmStatementTransactionMatch`         | `confirm_statement_transaction_match`         | Confirm exact existing-transaction evidence with concurrency guards.                       |
| Command | `materializeStatementComponentTransaction` | `materialize_statement_component_transaction` | Explicitly materialize an unmatched component as an unresolved imported Transaction.       |
| Command | `rejectStatementTransactionMatch`          | `reject_statement_transaction_match`          | Reject a proposal without changing source or Transaction.                                  |
| Command | `supersedeStatementTransactionMatch`       | `supersede_statement_transaction_match`       | Append replacement match lineage and reopen reconciliation.                                |
| Command | `acknowledgeStatementIssue`                | `acknowledge_statement_issue`                 | Record review of a non-blocking issue without rewriting source.                            |
| Command | `supersedeStatementImport`                 | `supersede_statement_import`                  | Replace a committed source through explicit immutable lineage.                             |
| Query   | `getStatementReconciliation`               | `get_statement_reconciliation`                | Return equation, coverage, issues, revision, and history.                                  |
| Command | `recalculateStatementReconciliation`       | `recalculate_statement_reconciliation`        | Deterministically refresh equation and completeness state.                                 |
| Command | `attestStatementReconciled`                | `attest_statement_reconciled`                 | Attest only when exact balance and completeness gates pass.                                |
| Command | `reopenStatementReconciliation`            | `reopen_statement_reconciliation`             | Append reopening reason and preserve prior attestation.                                    |

Generic generated CRUD remains available for schema administration. It is not the
Historian product contract.

## Deterministic Matching Hierarchy

Candidate generation is deterministic and side-effect free:

1. Existing confirmed source link with the same hashes: exact replay.
2. Explicit operator-selected Transaction that passes all exact invariants.
3. Unique exact account, currency, amount, compatible direction, date, and source
   reference.
4. Unique exact account, currency, amount, compatible direction, date, and strong
   normalized-description evidence.
5. Exact account, currency, amount, and date.
6. Exact account, currency, amount, compatible direction, and bounded date window.
7. Transfer candidate across tracked accounts with equal currency/magnitude and
   opposite source effects.

Safety rules:

- Candidate rules only propose.
- A confidence score is explanatory, not authority.
- No amount tolerance exists.
- The date window is profile-configured and shown.
- One-to-many component bundles must sum exactly.
- One source component cannot be actively confirmed twice.
- One Transaction cannot be actively matched to two statement imports.
- Concurrent confirmation uses expected revisions and returns
  `STATEMENT_MATCH_CONFLICT`.
- A rejected candidate remains in audit history.
- Supersession reopens an attested reconciliation.
- Ambiguous transfer evidence does not become an AccountTransfer automatically.
- Management similarity and historical categories never confirm source identity.

## Reconciliation

### Equation

Use the source adapter's signed balance convention:

```text
openingBalanceMinor
+ sum(component.balanceEffectMinor)
= expectedClosingBalanceMinor

reportedClosingBalanceMinor
- expectedClosingBalanceMinor
= differenceMinor
```

This supports asset accounts, liability statements, reversals, fees, and
institution-specific printed balance conventions without inventing FX or management
meaning.

### Completeness gates

Attestation requires:

1. original source and extraction hashes are present;
2. target Account, currency, and period are confirmed;
3. every printed row is informational or has complete component coverage;
4. every component has known exact money and balance effect;
5. every movement component has one confirmed Transaction resolution;
6. no active blocking StatementIssue exists;
7. no unresolved duplicate source or period conflict exists;
8. opening and closing balances are present;
9. difference is exactly zero;
10. the calculation hash and revision still match the attestation request.

### Independent quality states

```text
calculationState: unavailable | difference | balanced
coverageState: incomplete | complete
attestationState: open | ready | reconciled | reopened
```

The Account Ledger derives period source state from these dimensions. It must not use
management category coverage or tax assessment to decide reconciliation.

### Reopening

Reopening is append-only. It records reason, actor, operation, prior attestation,
revision, and timestamp. A later recalculation does not delete or rewrite the former
attestation.

## Raven Studio Text Wireframes

The current visual design remains authoritative. These are information and action
placements, not a redesign.

### Account Ledger

```text
Account
  [existing balance and month controls]

  Period source: Statement not loaded
  [Import statement]

  [existing Management | Tax lenses]
  [existing ledger table]
```

Derived period source labels:

```text
Manual activity present
Statement not loaded
Preview ready
Committed - reconciliation pending
Exceptions present
Ready to attest
Reconciled
Reopened
```

### Import workspace

Route:

```text
/accounts/{spaceKey}/{accountKey}/statements/import
```

```text
Import statement

Source          opaque safe label, source kind, byte hash
Profile         detected candidates, explicit selected version
Target          account and currency
Period          opening, expected, reported closing, difference
Coverage        rows, components, informational, unresolved
Candidates      provisional matches and transfers
Issues          blocking errors and warnings

[Review rows/components]
[Preview again] [Commit]
```

Commit remains disabled while source/account/currency/extraction errors exist.
ST-01 commits source truth with every movement component visibly pending. ST-02
activates explicit match, materialize, or non-movement disposition controls.

### Statement detail and reconciliation

Route:

```text
/accounts/{spaceKey}/{accountKey}/statements/{importKey}
```

```text
Statement source
  source and extraction identities
  profile/extractor versions
  operation provenance

Rows and components
  source locator
  exact amount and balance effect
  confidence, issue, and transaction-resolution state

Reconciliation
  opening
  signed component movement
  expected closing
  reported closing
  exact difference
  coverage and active issues
  attestation/reopening history

[Resolve issues] [Recalculate] [Attest / Reopen]
```

Raw source text is shown only in the private operator workspace and never copied into
general telemetry.

## Historian Operator Boundary

The future local Historian:

- uses semantic Raven MCP only;
- handles one source and account period at a time;
- confirms Account and profile explicitly;
- previews before any Raven database write;
- reports safe aggregate metadata and focused exceptions;
- asks Michael about genuine ambiguous matches;
- never accepts management or tax meaning during source ingestion;
- never receives unrestricted Surreal write tools;
- never writes source paths or contents into Brain, Git, logs, fixtures, screenshots,
  or external archives;
- does not run the twelve-month backfill until one recent closed multi-account pilot
  is reconciled and externally accepted.

## Fictional Fixture Matrix

All fixtures use fictional institutions, accounts, descriptions, dates, and amounts.

| Fixture                             | Required result                                                                                                 |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| Exact source replay                 | Same source, preview, and idempotency key return prior import and operation.                                    |
| Changed source bytes                | Original hash changes; old preview is stale and cannot commit.                                                  |
| Same bytes, changed adapter version | Extraction identity and preview hash change; explicit new preview required.                                     |
| Duplicate account/period source     | Warning or blocking duplicate issue; no silent replacement.                                                     |
| Wrong target account                | Account fingerprint mismatch blocks commit.                                                                     |
| Wrong currency                      | Currency mismatch blocks commit.                                                                                |
| Low-confidence row                  | Row is preserved; blocking issue remains visible.                                                               |
| Fee column                          | One printed row yields principal and fee components with exact effects.                                         |
| Informational row                   | Row commits with zero movement components and explicit row kind.                                                |
| Unresolved monetary composite       | Preview is blocked; no source commit occurs until exact components are available.                               |
| Provisional manual candidate        | Candidate is proposed but not confirmed automatically.                                                          |
| Explicit grouped match              | Multiple components may confirm against one exact provisional Transaction only when their signed total matches. |
| Concurrent match confirmation       | One succeeds; stale revision returns `STATEMENT_MATCH_CONFLICT`.                                                |
| Unmatched component                 | Explicit command creates one unresolved-management imported Transaction and confirmed evidence link.            |
| Rejected match                      | Candidate remains audited and source truth is unchanged.                                                        |
| Exact zero reconciliation           | Balanced and complete source becomes ready for attestation.                                                     |
| Non-zero difference                 | Exact difference is returned and attestation is rejected.                                                       |
| Active blocking issue               | Balanced arithmetic alone cannot attest.                                                                        |
| Reopened attestation                | Prior attestation remains immutable and new revision is open.                                                   |
| Liability balance convention        | Signed component effects reconcile without asset-account sign assumptions.                                      |
| GBP before registry approval        | `UNSUPPORTED_CURRENCY`; no preview commit until GBP registry and adapter support are accepted.                  |
| Cross-currency request              | No aggregate or invented FX value is returned.                                                                  |
| Privacy fixture                     | Responses and snapshots contain no absolute paths or real source text.                                          |

## Ordered Implementation Worklines

### ST-01 - Statement Source Preview and Atomic Commit

Implement a complete, independently usable source-truth vertical:

- accepted StatementImport/StatementRow extensions plus StatementRowComponent and
  StatementIssue;
- ZAR exact-money support;
- private source-vault interface;
- adapter registry and four neutral adapters;
- no-write preview and deterministic hashes;
- atomic source commit and replay;
- import/row/component/issue reads;
- minimal Studio import and source-detail routes preserving current design;
- camelCase tRPC and snake_case MCP parity;
- fictional/adversarial tests and AI-safe verification.

The exact prompt is:

`docs/prompts/raven-statement-truth-workline-st-01.md`

Gate before ST-02: source staging remains private; all four adapters produce neutral
canonical previews; preview is proven write-free; commit is atomic, immutable, and
retry-stable; source reads work in Studio/tRPC/MCP; the required synthetic cases and
repository safety checks pass; and ST-01 receives external acceptance.

### ST-02 - Provisional Matching and Statement Reconciliation

Add deterministic candidates, audited match lifecycle, explicit unmatched-component
transaction materialization, one-to-one concurrency constraints, statement-backed
evidence reads, exact reconciliation, drill-down, attestation, and reopen across the
shared domain, Studio, tRPC, and MCP.

Implementation status: complete in the local worktree and left in review. The
fictional matrix proves no double counting, concurrent claim exclusion, exact
reconciliation, attestation, reopening, source supersession, and rollback. External
artifact acceptance remains the gate before private ingestion or ST-03.

### ST-03 - Clarification and Management-Meaning Proposals

Build proposal, confirmation, rejection, supersession, Merchant, Category, recurrence
candidate, and exact management-allocation workflows on reconciled transaction truth.
Do not add tax meaning.

Gate: one accepted reconciled synthetic period and accepted proposal authority.

### ST-04 - Historian Operator and Twelve-Month Backfill Pilot

Enable the dedicated local Historian with semantic MCP, then reconcile one recent
closed multi-account period. Review it externally before processing remaining history
period by period.

Gate: accepted pilot, private-source handling proof, and zero unresolved
double-counting or reconciliation defects.

Tax and Transaction Meaning remains an independent later contract and workline.

## Contract Verification

This documentation-only pass changed no MPDG schema source, generated runtime,
product code, database, or private financial data. No development server was
started.

Completed checks:

- existing fictional statement renderer tests: 2/2 passed;
- strict MPDG validation: passed with no issues;
- Data Atlas focused tests: 9/9 passed;
- Data Atlas stale check: passed twice with 19 current models;
- scoped Prettier check: passed;
- contract structure check: passed for required sections, typed sketches, operation
  coverage, exactly eight approval decisions, and the ST-01/ST-02 boundary;
- archive-safety tests: 5/5 passed;
- AI-safe list/preflight: passed; private statements, private workpads, raw Brain
  sources, credentials, and other prohibited classes were excluded fail-closed;
- scoped secret scan: passed without exposing any value;
- Brain structure, concision, and `RAVEN-INGEST-0019` traceability check: passed;
- scoped `git diff --check`: passed.

## Approval Decisions

Michael approved these eight decisions together on 2026-07-29:

1. **Dual identity:** original-byte SHA-256 and canonical-extraction SHA-256 are
   distinct required identities.
2. **Adapter authority:** detection suggests, while Account and profile/version
   selection require explicit confirmation; the first registry contains the three
   refactored profiles plus normalized JSON.
3. **Neutral component model:** add StatementRowComponent with exact positive money,
   signed balance effect, and zero/one/many components per row; source debit/credit
   does not auto-accept income/expense.
4. **Commit contract:** preview is no-write; commit re-extracts, revalidates, and
   atomically writes immutable import, rows, components, and issues, but no
   Transaction or component disposition.
5. **Match authority:** add audited StatementTransactionMatch; v0.1 rules propose but
   never silently confirm provisional matches.
6. **Reconciliation authority:** add separate StatementIssue and
   StatementReconciliation aggregates with exact equation, coverage gates,
   append-only attestation, and reopening.
7. **Privacy/currency:** use an opaque external source vault; operate ZAR first, add
   GBP explicitly before UK ingestion, and perform no FX aggregation.
8. **Implementation order:** keep ST-01 source preview/commit separate from ST-02
   matching/reconciliation, with the exact external-acceptance gate above; management
   meaning and the Historian pilot follow as ST-03 and ST-04.

## Final Recommendation

The eight decisions are accepted. ST-01 is complete and ST-02 is implemented in
review. Together they can preserve one immutable source, resolve every exact movement
to one observed Transaction, and prove an Account period without inventing management
or tax meaning. No private pilot or ST-03 work begins until ST-02 receives external
artifact acceptance.
