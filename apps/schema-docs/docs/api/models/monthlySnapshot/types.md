# MonthlySnapshot — Types
_Month-level financial truth snapshot for a financial space_
**Table:** `monthlySnapshot`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `month` | `string` | yes | `""` |
| `currency` | `string` | yes | `"ZAR"` |
| `incomeTotal` | `number` | yes | `0` |
| `outflowTotal` | `number` | yes | `0` |
| `netTotal` | `number` | yes | `0` |
| `transferTotal` | `number` | no | `0` |
| `cashAvailable` | `number` | no | `0` |
| `recurringTotal` | `number` | no | `0` |
| `businessSpendTotal` | `number` | no | `0` |
| `personalSpendTotal` | `number` | no | `0` |
| `generatedAt` | `string` | yes | `""` |
| `status` | `enum<"draft" | "final">` | yes | `"draft"` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `MonthlySnapshotId`
- Exported: yes
- Structure: `"stringID<space, month>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.