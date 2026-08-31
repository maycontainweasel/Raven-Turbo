# ClassificationRule — Types
_Rule for automatic transaction matching and future classification suggestions_
**Table:** `classificationRule`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `matcher` | `string` | yes | `""` |
| `scope` | `enum<"description" | "merchant" | "reference" | "amount">` | yes | `"description"` |
| `targetMerchant` | `record<merchant>` | no | `""` |
| `targetCategory` | `record<category>` | no | `""` |
| `targetPurpose` | `record<transactionPurpose>` | no | `""` |
| `priority` | `number` | no | `0` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `ClassificationRuleId`
- Exported: yes
- Structure: `"stringID<space, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.