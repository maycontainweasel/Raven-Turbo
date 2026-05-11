# Transaction — Types
_Normalized money movement derived from a statement row or manual entry_
**Table:** `transaction`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `sourceRow` | `record<statementRow>` | no | `""` |
| `postedAt` | `string` | yes | `""` |
| `effectiveAt` | `string` | no | `""` |
| `description` | `string` | yes | `""` |
| `normalizedDescription` | `string` | no | `""` |
| `amount` | `number` | yes | `0` |
| `balance` | `number` | no | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `direction` | `enum<"debit" | "credit" | "transfer">` | yes | `"debit"` |
| `status` | `enum<"imported" | "normalized" | "matched" | "classified" | "clarified" | "ignored">` | yes | `"imported"` |
| `confidence` | `number` | no | `0` |
| `merchantName` | `string` | no | `""` |
| `merchant` | `record<merchant>` | no | `""` |
| `category` | `record<category>` | no | `""` |
| `isTransfer` | `boolean` | no | `false` |
| `manualOverride` | `boolean` | no | `false` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `TransactionId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.