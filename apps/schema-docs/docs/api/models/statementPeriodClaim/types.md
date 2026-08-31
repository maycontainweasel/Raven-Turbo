# StatementPeriodClaim — Types
_Deterministic active claim allowing one committed statement source for an exact account period_
**Table:** `statementPeriodClaim`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `periodStart` | `string` | yes | `""` |
| `periodEnd` | `string` | yes | `""` |
| `originalFileSha256` | `string` | yes | `""` |
| `state` | `enum<"active" | "released">` | yes | `"active"` |
| `claimedAt` | `string` | yes | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
## ID
- Export name: `StatementPeriodClaimId`
- Exported: yes
- Structure: `"stringID<account, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.