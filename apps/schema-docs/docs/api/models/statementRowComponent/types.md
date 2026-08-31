# StatementRowComponent — Types
_Exact neutral source component extracted from one printed statement row_
**Table:** `statementRowComponent`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `statementRow` | `record<statementRow>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `componentKind` | `enum<"principal" | "bank_fee" | "vat" | "interest" | "adjustment" | "unknown">` | yes | `"unknown"` |
| `componentRole` | `enum<"movement" | "informational_breakdown">` | yes | `"movement"` |
| `transactionDate` | `string` | no | `""` |
| `postingDate` | `string` | no | `""` |
| `valueDate` | `string` | no | `""` |
| `description` | `string` | yes | `""` |
| `sourceReference` | `string` | no | `""` |
| `amountMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `sourceDirection` | `enum<"debit" | "credit" | "unknown">` | yes | `"unknown"` |
| `sourceFlow` | `enum<"inflow" | "outflow" | "unknown">` | yes | `"unknown"` |
| `balanceEffectMinor` | `int` | yes | `0` |
| `sourceLocator` | `object` | no |  |
| `confidence` | `number` | no | `0` |
| `sourceChecksum` | `string` | yes | `""` |
| `sourceState` | `enum<"committed" | "superseded">` | yes | `"committed"` |
| `commitOperation` | `record<financialOperation>` | yes | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementRowComponentId`
- Exported: yes
- Structure: `"stringID<statementRow, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.