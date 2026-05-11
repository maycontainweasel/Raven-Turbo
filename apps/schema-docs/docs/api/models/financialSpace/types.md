# FinancialSpace — Types
_Personal, business, trading, family, or other money context_
**Table:** `financialSpace`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `spaceType` | `enum<"personal" | "business" | "trading" | "family" | "other">` | yes | `"personal"` |
| `currency` | `string` | yes | `"ZAR"` |
| `description` | `string` | no | `""` |
| `active` | `boolean` | yes | `true` |
| `archivedAt` | `string` | no | `""` |
## ID
- Export name: `FinancialSpaceId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.