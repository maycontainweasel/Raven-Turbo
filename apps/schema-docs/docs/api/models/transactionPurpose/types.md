# TransactionPurpose — Types
_Reusable reviewed management meaning for what an observed transaction represents_
**Table:** `transactionPurpose`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `description` | `string` | no | `""` |
| `purposeKind` | `enum<"subscription" | "service" | "bank_fee" | "family_support" | "housing" | "education" | "trading_funding" | "transfer_purpose" | "income_source" | "purchase" | "other">` | yes | `"other"` |
| `occurrencePattern` | `enum<"one_off" | "recurring" | "irregular" | "unknown">` | yes | `"unknown"` |
| `defaultMerchant` | `record<merchant>` | no | `""` |
| `defaultCategory` | `record<category>` | no | `""` |
| `aliases` | `array<string>` | no | `[]` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `TransactionPurposeId`
- Exported: yes
- Structure: `"stringID<space, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.