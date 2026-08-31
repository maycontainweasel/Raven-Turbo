# Distillation - RAVEN-INGEST-0020 - Statement Truth Acceptance And ST-01 Authorization

## Source

- Packet: `brain/source-material/external-review/RAVEN-INGEST-0020-statement-truth-acceptance-and-st01-authorization/`
- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0020-statement-truth-acceptance-and-st01-authorization/SOURCE_MANIFEST.md`
- Ingest record: `brain/sprints/0020-statement-truth-acceptance-and-st01-authorization/INGEST_RECORD-RAVEN-INGEST-0020.md`
- Source date: 2026-07-29
- Ingest date: 2026-07-29
- Mode: external-validation / pre-work-primer

## Executive Distillation

This packet is the explicit acceptance event that `RAVEN-INGEST-0019` lacked. It accepts the Statement Truth contract, all eight decisions, and the separate source-only `ST-01` / gated `ST-02` sequence. It authorizes Raven's primary local Codex developer to execute `ST-01` while the Brainkeeper sidecar preserves this packet without implementing it.

`ST-01` establishes immutable bank-source truth only. It stages private evidence outside Git, suggests versioned extraction profiles, requires explicit Account/profile confirmation, produces a deterministic no-write preview, and atomically commits imports, rows, exact components, non-blocking source issues, and an exact closing-balance snapshot when its mapping is provable. It creates no `Transaction`, component disposition, management meaning, tax meaning, match, or reconciliation.

## Accepted Statement Truth Contract

The eight decisions are now accepted:

1. **Separate source identities.** Original bank-evidence bytes and Raven's deterministic canonical extraction have distinct SHA-256 identities.
2. **Explicit adapter authority.** Detection is advisory. Preview and commit require explicit target Account and exact profile/version confirmation.
3. **Neutral zero/one/many components.** A printed row can produce no movement, one movement, several exact components, or a blocked unresolved composite.
4. **Pure preview and atomic source commit.** Preview and validation create no financial records or operation receipts. Commit reopens and revalidates source evidence, then atomically writes immutable source truth only.
5. **Audited later matching.** Matching proposals are not authority. Confirmation, rejection, supersession, and materialization belong to later audited operations.
6. **Separate issue and reconciliation authority.** Source uncertainty is not management clarification, and period proof is not an import status.
7. **Opaque private sources and ZAR first.** Raven persists opaque references rather than absolute paths. `ST-01` supports ZAR only; GBP and FX remain outside the accepted slice.
8. **Ordered worklines.** `ST-01` owns preview/commit, `ST-02` matching/materialization/reconciliation, `ST-03` management meaning, and `ST-04` the private Historian pilot.

These accepted decisions are recorded together as `DEC-0016`.

## Four Binding Implementation Clarifications

### Three Artifact Identities

When OCR, vision, or operator-normalized JSON assists extraction, Raven distinguishes:

```text
original bank evidence bytes
  -> originalFileSha256

optional extraction-assist artifact
  -> extractionInputSha256

Raven canonical normalized extraction
  -> canonicalExtractionSha256
```

The assistance artifact never impersonates original bank evidence. `normalized-json-v1` must re-open and re-hash both artifacts during preview and commit, or remain explicitly unavailable with a stable unsupported-capability result.

### Contained Private Ingress

A local path is not blanket filesystem authority. MCP path staging is restricted to configured statement-inbox roots or exact connector mounts, canonical containment, regular non-symlink files, explicit size limits, MIME/signature validation, owner-only vault permissions, atomic staging, failed-temporary cleanup, and path-redacted results/errors/audit metadata. Studio upload and MCP path intake may use different bounded transport envelopes while returning one semantic source descriptor.

### Exact Component Effects And Source Dates

Each source component has an explicit role:

- `movement`: positive exact `amountMinor` and non-zero signed `balanceEffectMinor`;
- `informational_breakdown`: zero `balanceEffectMinor`, no Transaction eligibility, and no reconciliation movement contribution.

This prevents a printed VAT or tax breakdown already included in a fee total from being counted twice. Transaction, posting, and value dates remain distinct optional source facts; adapters may not invent a missing date.

### Blocking, Occupied Periods, And Closing Balances

Uncertainty affecting Account, currency, period, exact money, component effect, complete source coverage, or source identity is blocking and produces no financial write. A changed source for an already occupied Account/period is blocked in `ST-01`; replacement/supersession remains a later explicit operation.

A closing `AccountBalanceSnapshot` may be created only when Raven can map the statement's signed closing value, convention, Account, currency, and economic nature exactly into a non-negative magnitude and explicit nature. Ambiguity preserves source evidence and an issue but creates no snapshot.

## Operational Result Contract

The accepted `ST-01` semantic surface comprises fourteen camelCase domain/tRPC operations with exact snake_case MCP peers:

- stage source;
- list and detect profiles;
- preview and validate;
- commit;
- list/get imports;
- list/get rows;
- list/get row components;
- list/get import issues.

Studio adds only the bounded account-ledger integrations: `Import statement`, the account-scoped import route, committed statement-source detail, and compact period-source state. The current Penpot-derived Account Ledger remains authoritative and is not redesigned.

## Sequence And Gates

Current accepted sequence:

```text
Statement Truth contract
  -> accepted

ST-01 Source Preview and Atomic Commit
  -> authorized for implementation
  -> must remain in Orbit review pending external artifact acceptance

ST-02 Matching and Reconciliation
  -> blocked until ST-01 acceptance gate passes

ST-03 Management Meaning
  -> later

ST-04 Private Historian pilot and backfill
  -> later and separately authorized

Tax & Transaction Meaning
  -> separate lane
```

The exact `ST-02` gate remains source identity, preview purity, atomic replay, component and issue reads, Studio/tRPC/MCP parity, synthetic safety, and external acceptance.

## Observed Facts, Attributed Claims, And Uncertainty

Observed from the supplied packet:

- the approval wrapper explicitly accepts all eight decisions and authorizes `ST-01`;
- the four clarifications are binding;
- the original contract and exact workline prompt are preserved in full.

Attributed external-review claims not independently reverified by Brainkeeper:

- the documentation-only contract pass changed no product/schema files;
- the prior fictional renderer suite passed `2/2`;
- the reviewed AI-safe archive passed integrity checks.

Open implementation truth:

- this ingestion does not establish whether `ST-01` code has been implemented, tested, packaged, or externally accepted;
- Orbit status is owned by the primary workline; this sidecar records an Orbit sync candidate only.

## Risks

- A normalized transcription can corrupt provenance if treated as original evidence.
- Unrestricted path staging can expose unrelated local files.
- Informational monetary breakdowns can double count account effects.
- Collapsing multiple printed dates can invent evidence.
- Persisting blockers can misrepresent incomplete extraction as committed truth.
- Ambiguous closing-balance sign semantics can create false balance evidence.
- Starting `ST-02` before source acceptance can introduce double counting and incomplete reconciliation.

## Opportunities

- Establish a privacy-safe local statement vault with transport-specific ingress and one semantic descriptor.
- Turn the existing three statement profiles into neutral, versioned adapters while preserving migration regression coverage.
- Give Studio and agents one explainable source-truth workflow before transaction materialization.
- Create exact historical balance evidence only when statement semantics prove it.

## Orbit Sync Candidates

- Record the Statement Truth contract and eight decisions as accepted.
- Record `ST-01` as authorized/active on the primary Past / Historian workline.
- Keep `ST-01` in review after implementation until external artifact acceptance.
- Keep `ST-02`, `ST-03`, `ST-04`, private ingestion, and the Tax lane blocked or separate.
- Do not sync private source paths, filenames, statement contents, account records, or values.

## Routine Items Intentionally Excluded

- No code, schema, generated artifact, UI, MCP, database, service, private data, Orbit write, commit, merge, push, or development server.
- No implementation claim derived from the embedded workline prompts.
- No private source, database record, account identifier, statement row, amount, or credential.
