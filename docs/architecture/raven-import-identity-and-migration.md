---
status: canonical
owner: Raven
last_reviewed: 2026-07-12
---

# Raven Import Identity And Migration

## Identity Rule

Public callers use local keys. Surreal record IDs include the owning scope:

| Model | Scope |
| --- | --- |
| StatementImport | account + import key |
| StatementRow | StatementImport + row key |
| imported Transaction | account + import/row key |
| Category | Financial Space + key |
| Merchant | Financial Space + key |
| ClassificationRule | Financial Space + key |
| ClarificationTask | transaction + key |

This permits Personal and Business to use the same account-local import key, row number, category key, merchant slug, or rule key without sharing records.

## Replay Rule

- First execution creates immutable source records and deterministic source links.
- Exact replay reuses those records, links, checksums, and the original `importedAt`.
- Changed amount, currency, financial date, raw evidence, source row, or import under an existing identity returns `RAVEN_IMPORT_IMMUTABLE_CONFLICT` and rolls back the import. The composite identity cannot be rebound to another account; selecting another account creates a distinct import identity.
- Classification-only review uses the checksum-gated review function and cannot mutate source truth.
- A genuine corrected source uses a new replacement/correction identity; lineage is a later explicit workflow.

## Existing Records

`auditImportIdentityCompatibility` is intentionally aggregate-only. It reports counts by model for canonical identities, legacy identities, missing identity inputs, and expected collisions. It has no apply mode and returns no descriptions, amounts, account names, raw rows, or other financial content.

Existing local records may require a later explicit migration to composite IDs. That migration must be separately reviewed, begin with the aggregate audit, preserve references and provenance, and remain reversible. This Workline did not inspect private records, run the aggregate audit against private data, or apply any private-data ID migration.
