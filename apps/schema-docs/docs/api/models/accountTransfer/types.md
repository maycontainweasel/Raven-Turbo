# AccountTransfer — Types
_Source-authority aggregate linking two exact observed transfer legs between tracked accounts_
**Table:** `accountTransfer`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `sourceSpace` | `record<financialSpace>` | yes | `""` |
| `sourceAccount` | `record<account>` | yes | `""` |
| `targetSpace` | `record<financialSpace>` | yes | `""` |
| `targetAccount` | `record<account>` | yes | `""` |
| `amountMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `postedAt` | `string` | yes | `""` |
| `description` | `string` | no | `""` |
| `sourceTransaction` | `record<transaction>` | yes | `""` |
| `targetTransaction` | `record<transaction>` | yes | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
## ID
- Export name: `AccountTransferId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.