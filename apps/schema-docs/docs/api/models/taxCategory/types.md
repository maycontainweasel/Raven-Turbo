# TaxCategory — Types
_Separate hierarchical vocabulary for tax-facing transaction presentation without asserting deductibility or filing treatment_
**Table:** `taxCategory`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `parentTaxCategory` | `record<taxCategory>` | no | `""` |
| `active` | `boolean` | yes | `true` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `TaxCategoryId`
- Exported: yes
- Structure: `"stringID<space, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.