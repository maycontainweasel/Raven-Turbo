# StatementLegacyResolution — Types
_Append-only selected-source compatibility authority event for one legacy and canonical statement pair_
**Table:** `statementLegacyResolution`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `legacyStatementImport` | `record<statementImport>` | yes | `""` |
| `canonicalStatementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `resolutionType` | `enum<"apply" | "reversal">` | yes | `"apply"` |
| `strategy` | `enum<"A" | "B" | "C">` | yes | `"A"` |
| `authorityEffect` | `enum<"activate_canonical" | "restore_previous">` | yes | `"activate_canonical"` |
| `previousLegacySourceState` | `enum<"legacy" | "committed">` | yes | `"legacy"` |
| `previousSourceClaimState` | `enum<"absent" | "active" | "released">` | yes | `"absent"` |
| `previousPeriodClaimState` | `enum<"absent" | "active" | "released">` | yes | `"absent"` |
| `targetResolution` | `record<statementLegacyResolution>` | no | `""` |
| `predecessorResolution` | `record<statementLegacyResolution>` | no | `""` |
| `databaseFingerprint` | `string` | yes | `""` |
| `sourceIdentityHash` | `string` | yes | `""` |
| `canonicalPreviewHash` | `string` | yes | `""` |
| `legacyEvidenceHash` | `string` | yes | `""` |
| `accountContextFingerprint` | `string` | yes | `""` |
| `crosswalkHash` | `string` | yes | `""` |
| `expectedRevisionClaimHash` | `string` | yes | `""` |
| `resultAuthorityHash` | `string` | yes | `""` |
| `aggregateCounts` | `object` | yes |  |
| `idempotencyKey` | `string` | yes | `""` |
| `requestHash` | `string` | yes | `""` |
| `channel` | `enum<"ui" | "mcp" | "system">` | yes | `"ui"` |
| `actorId` | `string` | no | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
## ID
- Export name: `StatementLegacyResolutionId`
- Exported: yes
- Structure: `"stringID<canonicalStatementImport, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.