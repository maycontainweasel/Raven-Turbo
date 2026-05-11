# ClarificationTask — Types
_Review task for uncertain transaction meaning_
**Table:** `clarificationTask`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `transaction` | `record<transaction>` | yes | `""` |
| `status` | `enum<"open" | "suggested" | "resolved" | "dismissed">` | yes | `"open"` |
| `question` | `string` | yes | `""` |
| `reason` | `string` | no | `""` |
| `suggestedSpace` | `record<financialSpace>` | no | `""` |
| `suggestedMerchant` | `record<merchant>` | no | `""` |
| `suggestedCategory` | `record<category>` | no | `""` |
| `resolvedAt` | `string` | no | `""` |
| `resolutionNotes` | `string` | no | `""` |
| `confidence` | `number` | no | `0` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `ClarificationTaskId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.