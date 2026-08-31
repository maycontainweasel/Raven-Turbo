# StatementRow — Types
_Raw statement row preserved from imported source material_
**Table:** `statementRow`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `rowNumber` | `number` | yes | `0` |
| `rowKind` | `enum<"movement" | "informational" | "composite" | "unresolved">` | no | `"unresolved"` |
| `transactionDate` | `string` | no | `""` |
| `postingDate` | `string` | no | `""` |
| `valueDate` | `string` | no | `""` |
| `sourceReference` | `string` | no | `""` |
| `sourceLocator` | `object` | no |  |
| `reportedBalanceMinor` | `int` | no | `0` |
| `componentCount` | `int` | no | `0` |
| `extractionConfidence` | `number` | no | `0` |
| `rowHash` | `string` | no | `""` |
| `commitOperation` | `record<financialOperation>` | no | `""` |
| `postedAt` | `string` | no | `""` |
| `description` | `string` | yes | `""` |
| `normalizedDescription` | `string` | no | `""` |
| `amount` | `number` | yes | `0` |
| `balance` | `number` | no | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `direction` | `enum<"debit" | "credit" | "transfer" | "unknown">` | yes | `"unknown"` |
| `status` | `enum<"raw" | "normalized" | "matched" | "clarified" | "ignored">` | yes | `"raw"` |
| `confidence` | `number` | no | `0` |
| `rawData` | `object` | no |  |
| `sourceChecksum` | `string` | no | `""` |
| `transaction` | `record<transaction>` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementRowId`
- Exported: yes
- Structure: `"stringID<statementImport, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.