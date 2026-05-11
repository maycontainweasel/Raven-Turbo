# Category — Types
_Transaction category and category hierarchy node_
**Table:** `category`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `categoryKind` | `enum<"income" | "expense" | "transfer" | "tax" | "savings" | "other">` | yes | `"expense"` |
| `parentCategory` | `record<category>` | no | `""` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `CategoryId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.