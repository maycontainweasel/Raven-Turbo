# StatementSourceClaim — Types
_Deterministic active claim preventing one exact statement source from being committed twice for an account_
**Table:** `statementSourceClaim`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `originalFileSha256` | `string` | yes | `""` |
| `periodStart` | `string` | yes | `""` |
| `periodEnd` | `string` | yes | `""` |
| `state` | `enum<"active" | "released">` | yes | `"active"` |
| `claimedAt` | `string` | yes | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
## ID
- Export name: `StatementSourceClaimId`
- Exported: yes
- Structure: `"stringID<account, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.