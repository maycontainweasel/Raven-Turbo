# StatementImport — Types
_Source statement import batch for an account cycle_
**Table:** `statementImport`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `sourceFileName` | `string` | yes | `""` |
| `sourceFormat` | `enum<"csv" | "ofx" | "qif" | "pdf" | "image" | "normalized_json" | "manual">` | yes | `"pdf"` |
| `privateSourceRef` | `string` | no | `""` |
| `extractionAssistRef` | `string` | no | `""` |
| `originalFileSha256` | `string` | no | `""` |
| `extractionInputSha256` | `string` | no | `""` |
| `canonicalExtractionSha256` | `string` | no | `""` |
| `previewHash` | `string` | no | `""` |
| `sourceMimeType` | `string` | no | `""` |
| `sourceByteSize` | `int` | no | `0` |
| `profileId` | `string` | no | `""` |
| `profileVersion` | `string` | no | `""` |
| `extractorVersion` | `string` | no | `""` |
| `validationRulesetVersion` | `string` | no | `""` |
| `periodStart` | `string` | no | `""` |
| `periodEnd` | `string` | no | `""` |
| `currency` | `string` | no | `"ZAR"` |
| `balanceConvention` | `string` | no | `""` |
| `balanceConventionAuthority` | `enum<"profile" | "operator_unverified">` | no | `""` |
| `accountContextFingerprint` | `string` | no | `""` |
| `openingBalanceMinor` | `int` | no | `0` |
| `closingBalanceMinor` | `int` | no | `0` |
| `closingBalanceEconomicNature` | `enum<"asset" | "liability">` | no | `""` |
| `coverage` | `object` | no |  |
| `sourceState` | `enum<"legacy" | "committed" | "superseded">` | no | `"legacy"` |
| `commitOperation` | `record<financialOperation>` | no | `""` |
| `committedAt` | `string` | no | `""` |
| `replacementOf` | `record<statementImport>` | no | `""` |
| `importedAt` | `string` | yes | `""` |
| `statementDate` | `string` | no | `""` |
| `status` | `enum<"raw" | "parsed" | "matched" | "reviewed" | "error">` | yes | `"raw"` |
| `rowCount` | `number` | no | `0` |
| `componentCount` | `number` | no | `0` |
| `issueCount` | `number` | no | `0` |
| `revision` | `int` | yes | `1` |
| `normalizedCount` | `number` | no | `0` |
| `clarificationCount` | `number` | no | `0` |
| `sourceChecksum` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementImportId`
- Exported: yes
- Structure: `"stringID<account, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.