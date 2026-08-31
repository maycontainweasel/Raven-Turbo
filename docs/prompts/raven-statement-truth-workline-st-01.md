---
status: working
owner: Raven
last_reviewed: 2026-07-29
contract: raven-statement-truth-contract-v0.1
workline: ST-01
supersedes: []
superseded_by: []
---

# Raven Statement Truth Workline ST-01 - Source Preview and Atomic Commit

```text
orbit-workline

Create and execute one bounded implementation workline under Past / Historian:

Raven ST-01 - Statement Source Preview and Atomic Commit

Authority

Read and follow:

- AGENTS.md and applicable nested AGENTS files.
- brain/START_HERE.md, NOW.md, DECISIONS.md, OPEN_LOOPS.md and RISK_REGISTER.md.
- docs/architecture/raven-statement-truth-contract-v0.1.md.
- docs/architecture/raven-account-control-contract-v0.1.md.
- docs/architecture/raven-account-ledger-and-mcp-readiness-v0.1.md.
- docs/architecture/raven-import-identity-and-migration.md.
- docs/architecture/raven-data-atlas.md.
- apps/schema/config/graph.mpdg.
- packages/raven-domain, packages/raven-surreal, apps/raven-mcp and the Raven
  Studio account page.
- scripts/generate-statement-import.mjs,
  scripts/render-statement-import.mjs and their tests.

Do not implement until the eight decisions in the Statement Truth contract have
been explicitly approved. If approval is not recorded, leave this workline waiting
and report the exact missing approvals.

Goal

Implement one complete source-truth vertical that lets Michael or a local agent:

1. stage one private statement source outside Git;
2. inspect detected profile suggestions;
3. explicitly select the target Raven account and versioned profile;
4. preview neutral extraction with no database write;
5. validate exact rows, components, balances, differences and issues;
6. commit immutable source truth atomically under one idempotency key;
7. replay safely;
8. read the committed import, rows, components and issues through Raven Studio,
   tRPC and the semantic Raven MCP.

This workline commits no accepted Merchant, Category, transfer, management or tax
meaning and creates no Transaction. Matching, transaction materialization,
reconciliation and attestation remain ST-02.

Privacy boundary

- Code, architecture, and wholly fictional fixtures only.
- Do not inspect the private database or any real statement, screenshot, account
  record, description, balance or amount.
- Do not copy private sources into Git, Brain, logs, fixtures, screenshots,
  generated docs, test snapshots, or AI-safe archives.
- Store staged bytes under an ignored local private vault such as
  .raven-private/statements/ with owner-only permissions.
- Persist only an opaque source reference. Never persist or return an absolute
  source path.
- The Studio upload and local MCP path input are transport boundaries. Redact paths
  from outputs, errors, operation audit metadata and logs.
- Do not start a development server unless Michael explicitly asks. Static, build
  and browser-independent component tests are sufficient for this workline.

Architecture

- Extend the existing StatementImport and StatementRow schema authority.
- Add StatementRowComponent and StatementIssue through canonical MPDG.
- Do not create a parallel ledger or page-owned persistence.
- Put semantic contracts, validation, canonicalization and orchestration in the
  shared Raven domain layer.
- Put Surreal persistence in the Raven Surreal repository adapter.
- Provide one shared local source/adapter composition used by Studio and MCP; do
  not duplicate extraction implementations per transport.
- Expose thin camelCase tRPC and snake_case MCP adapters with parity tests.
- Retain generated CRUD for administration; do not use it as the product command
  surface.
- Keep the current Penpot-derived account page design. Add only the Import
  statement action, preview/review workspace, committed source detail, and compact
  period source state required by the contract.

Required source identity

Implement distinct:

- originalFileSha256 over exact staged bytes;
- canonicalExtractionSha256 over canonical neutral extraction JSON;
- previewHash over source hash, extraction hash, selected account, profile ID,
  profile version, extractor version and validation ruleset version.

Match candidates and display-only values must not affect previewHash.

Commit must re-open the staged source, re-hash, re-extract and revalidate. It must
reject changed source, stale preview, changed account/profile/version, blocking
issues and unsupported currency before any database write.

Exact replay of the same idempotency key and request hash returns the original
import and original importedAt. A changed request under the same key returns
IDEMPOTENCY_CONFLICT.

Adapters

Refactor the existing profile logic into versioned, source-neutral adapters:

- nedbank-current;
- nedbank-credit;
- fnb-business;
- normalized-json-v1.

Remove institution- or user-specific account metadata from adapter code and
fixtures. Detection is advisory. Preview and commit require an explicit account
and profile.

Adapters may extract only:

- dates and period;
- raw printed descriptions/references;
- exact debit, credit, fee, source-labelled tax, or interest components;
- opening, closing and running balances;
- account/currency hints;
- source locators;
- confidence and extraction issues.

They must not accept Category, Merchant, management meaning, tax treatment,
transfer counterpart or clarified status.

The normalized JSON adapter validates a strict documented JSON schema and produces
the same neutral canonical extraction. It does not trust a vision model's supplied
checksum or interpretation.

Money

- Use safe integer minor units for all canonical monetary facts.
- ZAR is the only operational ST-01 currency.
- Reject unsupported currency with UNSUPPORTED_CURRENCY.
- Do not add GBP in this workline unless separately approved before
  implementation.
- Never silently round, coerce a float, or calculate with formatted money.
- Normalize adapter-specific balance conventions into signed
  balanceEffectMinor for each component.

Schema

Implement the accepted fields from the contract through MPDG and generated runtime.

StatementImport must include:

- opaque source reference;
- original source, canonical extraction, and preview hashes;
- source MIME type and byte size;
- profile ID/version, extractor version and validation ruleset;
- exact period and optional opening/closing balances;
- source-only state, replacement lineage and commit operation.

Preserve account-scoped identity and importedAt. Treat sourceFileName,
sourceChecksum, float balances, and the existing mixed status as migration-era
fields. Do not expose a private filename through semantic responses.

StatementRow must preserve printed source facts, locator, row hash, confidence, row
kind and component count. New semantic imports must not rely on the legacy row
transaction field or one-row/one-transaction assumption.

StatementRowComponent must use import-row ownership, exact positive amount,
currency, signed balance effect, source direction/flow, source kind, locator,
confidence, checksum and commit provenance.

StatementIssue must be separate from ClarificationTask and represent source,
extraction, duplicate, account, currency, period, component and balance issues.

Add canonical direct record references and only the reviewed runtime traversal
edges required by semantic queries. Update the Data Atlas generated projection
after accepted schema changes.

Operations

Implement shared domain operations and exact tRPC/MCP parity for:

- stageStatementSource / stage_statement_source
- listStatementProfiles / list_statement_profiles
- detectStatementProfile / detect_statement_profile
- previewStatementImport / preview_statement_import
- validateStatementPreview / validate_statement_preview
- commitStatementImport / commit_statement_import
- listStatementImports / list_statement_imports
- getStatementImport / get_statement_import
- listStatementRows / list_statement_rows
- getStatementRow / get_statement_row
- listStatementRowComponents / list_statement_row_components
- getStatementRowComponent / get_statement_row_component
- listStatementImportIssues / list_statement_import_issues
- getStatementImportIssue / get_statement_import_issue

Preview and validation are write-free queries. Source staging is local private
infrastructure. Commit is the only financial source command.

Stable errors and warnings

Implement the ST-01 subset from the contract, including:

- STATEMENT_SOURCE_NOT_FOUND
- STATEMENT_PROFILE_UNSUPPORTED
- STATEMENT_PROFILE_AMBIGUOUS
- STATEMENT_SOURCE_CHANGED
- STATEMENT_PREVIEW_STALE
- STATEMENT_DUPLICATE_SOURCE
- STATEMENT_ACCOUNT_MISMATCH
- STATEMENT_CURRENCY_MISMATCH
- STATEMENT_PERIOD_INVALID
- STATEMENT_EXTRACTION_INVALID
- STATEMENT_IMMUTABLE_CONFLICT
- STATEMENT_ROW_LOW_CONFIDENCE
- STATEMENT_ROW_UNRESOLVED
- STATEMENT_COMPONENT_UNRESOLVED
- STATEMENT_BALANCE_MISSING
- STATEMENT_BALANCE_DIFFERENCE
- STATEMENT_EXISTING_IMPORT_FOUND
- STATEMENT_PARTIAL_PERIOD

No error may expose raw bytes, private paths, raw descriptions or full account
identifiers.

Atomic persistence

One commit transaction must create or exact-replay:

- FinancialOperation receipt;
- StatementImport;
- all StatementRows;
- all StatementRowComponents;
- all StatementIssues;
- required owner/traversal edges;
- a statement-closing AccountBalanceSnapshot only when the closing balance is
  present and valid.

Any immutable conflict or failed row/component/issue write rolls back the whole
commit. Do not create Transaction, Merchant, Category, ClassificationRule,
ClarificationTask, StatementTransactionMatch or StatementReconciliation in ST-01.

Studio

Preserve the existing account ledger composition and styling.

Add:

- Import statement to AccountActionMenu and the command palette;
- /accounts/{spaceKey}/{accountKey}/statements/import;
- source staging and explicit profile selection;
- exact period/balance summary;
- rows with nested components;
- blocking/warning issue presentation;
- disabled commit while validation is blocked;
- /accounts/{spaceKey}/{accountKey}/statements/{importKey};
- committed source identity, adapter versions, rows, components and issues;
- compact account-period states for not loaded, previewing, committed/pending and
  exceptions.

Do not redesign the account header, month switcher, summary, ledger,
classification switcher, or transaction detail.

Fictional tests

Add focused unit, repository, transport-parity and synthetic end-to-end tests for:

- exact replay preserving importedAt;
- idempotency conflict;
- changed source bytes;
- stale extraction/profile/ruleset;
- duplicate same-account source;
- duplicate period with changed bytes;
- wrong account and wrong currency;
- unsupported currency;
- low-confidence monetary and informational rows;
- one row with principal plus bank fee;
- one row with fee plus a printed source-tax component;
- informational row with no component or transaction;
- malformed normalized JSON;
- ambiguous profile detection;
- all-or-nothing rollback;
- source-path redaction;
- no transaction/category/merchant/tax writes;
- Studio/tRPC/MCP contract-equivalent output;
- no private fixture values.

Retain the old statement renderer tests as migration regression coverage. Do not
delete the old scripts in ST-01 unless their replacement and compatibility status
are explicitly reviewed.

Verification

Run:

- focused domain, adapter, repository, tRPC/MCP parity and Studio tests;
- node --test scripts/tests/render-statement-import.test.mjs;
- schema graph strict validation and generation checks;
- pnpm docs:data-atlas and pnpm docs:data-atlas:check twice;
- package type checks and relevant builds without a dev server;
- formatting and git diff --check;
- root and nested repository diff/status checks;
- Brain health;
- secret scan;
- pnpm test:archive-safety;
- AI-safe archive dry-run/preflight.

Inspect the final AI-safe archive listing if one is generated. It must contain no
private vault, statement source, path, credential, raw Brain source, PDF,
screenshot, or source-derived fixture.

Brain and Orbit

- Run the Brainkeeper sidecar for the full orchestrator source when supplied.
- Record implementation facts and unresolved approval items, not private data.
- Keep the Past / Historian ST-01 Workline current at phase transitions.
- Leave ST-01 in review pending external artifact acceptance.
- Do not begin ST-02, ST-03, ST-04, private ingestion, Workline 04, Tax Lane,
  Elgiz, Earn or buckets.

Completion response

State:

- exact schema and model changes;
- exact shared operations and adapter versions;
- proof that preview is write-free;
- source, extraction and preview identity behavior;
- atomic replay and conflict behavior;
- Studio routes and user-visible result;
- semantic MCP tools and parity result;
- tests/checks and results;
- confirmation that no private data, transaction meaning, tax meaning, matching,
  reconciliation, dev server, commit or push occurred;
- exact remaining ST-02 gate.
```
