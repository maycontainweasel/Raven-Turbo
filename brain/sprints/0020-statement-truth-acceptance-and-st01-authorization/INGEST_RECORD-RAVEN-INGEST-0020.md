# Ingest Record - RAVEN-INGEST-0020

## Metadata

- Project: Raven
- Source date: 2026-07-29
- Ingest date: 2026-07-29
- Mode: external-validation / pre-work-primer
- Status: ingested

## Source Packet

- Manifest: `brain/source-material/external-review/RAVEN-INGEST-0020-statement-truth-acceptance-and-st01-authorization/SOURCE_MANIFEST.md`
- Raw source files: four byte-identical files in the same packet directory
- Distillation: `brain/distillations/RAVEN-INGEST-0020-statement-truth-acceptance-and-st01-authorization.md`
- Brain Patch: `brain/sprints/0020-statement-truth-acceptance-and-st01-authorization/BRAIN_PATCH.md`

## Source Roles

1. External review accepting the Statement Truth contract and approving all eight decisions.
2. Explicit approval wrapper authorizing the primary Raven developer to execute `ST-01`.
3. Full Statement Truth, Import and Reconciliation Contract v0.1.
4. Exact preserved `ST-01` Source Preview and Atomic Commit workline prompt.

## Accepted Decisions

The supplied approval event accepts the eight Statement Truth decisions:

1. Original evidence identity and canonical extraction identity are distinct.
2. Adapter detection is advisory; Account and exact profile/version selection require explicit confirmation.
3. A neutral `StatementRowComponent` represents zero, one, or many source components per printed row.
4. Preview is write-free; commit reopens, re-extracts, revalidates, and atomically writes source truth without creating a `Transaction` or component disposition.
5. Later matching is audited and may propose but never silently confirm.
6. `StatementIssue` and `StatementReconciliation` are separate authorities.
7. Private sources use opaque vault references; `ST-01` is ZAR-only, with no FX and no GBP ingestion before explicit later approval.
8. `ST-01`, `ST-02`, `ST-03`, and `ST-04` remain separate gated worklines.

## Binding Clarifications

- Original bank evidence, optional normalized-JSON/OCR extraction assistance, and Raven's canonical extraction are three separate identities when assistance is used.
- Local path staging is constrained to configured roots or exact connector mounts and must enforce containment, type/size checks, owner-only vault permissions, atomic staging, and absolute-path redaction.
- Components explicitly distinguish `movement` from `informational_breakdown`, use exact signed balance effects, avoid double counting, and preserve distinct printed transaction, posting, and value dates without invention.
- Blocking preview issues produce no financial write; changed source bytes for an occupied Account/period are blocked in `ST-01`; closing-balance snapshots require exact deterministic sign and economic-nature mapping.

## Sequence And Gates

- The Statement Truth contract is accepted.
- `ST-01` Source Preview and Atomic Commit is authorized for the primary implementation workline.
- This Brainkeeper ingest does not implement `ST-01` and makes no claim about its eventual implementation or acceptance.
- `ST-02` remains blocked until `ST-01` passes its source identity, preview purity, atomic replay, component/issue reads, Studio/tRPC/MCP parity, synthetic safety, and external artifact acceptance gate.
- `ST-03`, `ST-04`, private ingestion, Tax persistence, Workline 04, Elgiz, Earn, and buckets remain unauthorized by this packet.

## Operating Protocol

The local Codex agent remains Raven's primary solution developer and executes the authorized implementation prompt. Brainkeeper runs in parallel for raw preservation and durable distillation only; it must not replace, delay, terminate, or duplicate the main implementation workline.

## Handling

- Changed only `brain/**`.
- Did not inspect or modify product code, schema, docs outside Brain, Orbit, `.orbit`, databases, private financial sources, credentials, services, or runtime state.
- Did not execute any embedded implementation, private-ingestion, development-server, commit, merge, or push instruction.
- External test and archive claims remain attributed to their source; this Brainkeeper pass did not independently rerun product verification.
