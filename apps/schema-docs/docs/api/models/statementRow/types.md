# StatementRow — Types
_Raw statement row preserved from imported source material_
**Table:** `statementRow`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `rowNumber` | `number` | yes | `0` |
| `postedAt` | `string` | no | `""` |
| `description` | `string` | yes | `""` |
| `normalizedDescription` | `string` | no | `""` |
| `amount` | `number` | yes | `0` |
| `balance` | `number` | no | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `direction` | `enum<"debit" | "credit" | "transfer">` | yes | `"debit"` |
| `status` | `enum<"raw" | "normalized" | "matched" | "clarified" | "ignored">` | yes | `"raw"` |
| `confidence` | `number` | no | `0` |
| `rawData` | `object` | no |  |
| `transaction` | `record<transaction>` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementRowId`
- Exported: yes
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.