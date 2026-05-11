# Account — Types
_Real-world bank, card, savings, loan, debt, investment, cash, or other account inside a financial space_
**Table:** `account`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `bankName` | `string` | yes | `""` |
| `accountType` | `enum<"current" | "credit_card" | "savings" | "loan" | "debt" | "investment" | "cash" | "other">` | yes | `"current"` |
| `currency` | `string` | yes | `"ZAR"` |
| `accountNumberLast4` | `string` | no | `""` |
| `openingBalance` | `number` | no | `0` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `AccountId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.