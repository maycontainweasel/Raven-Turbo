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
| `facilityKind` | `enum<"none" | "credit_card" | "overdraft" | "revolving_credit" | "loan" | "other">` | yes | `"none"` |
| `currency` | `string` | yes | `"ZAR"` |
| `accountNumberLast4` | `string` | no | `""` |
| `openingBalance` | `number` | no | `0` |
| `openingBalanceMinor` | `int` | no | `0` |
| `normalNature` | `enum<"asset" | "liability">` | yes | `"asset"` |
| `liquidityClass` | `enum<"liquid" | "non_liquid">` | yes | `"liquid"` |
| `freshnessWindowHours` | `int` | yes | `72` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `AccountId`
- Exported: yes
- Structure: `"stringID<space, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.