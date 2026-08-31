# StatementTransactionResolutionClaim — Types
_Deterministic active claim preventing one transaction from being claimed by multiple statement imports_
**Table:** `statementTransactionResolutionClaim`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `statementTransactionMatch` | `record<statementTransactionMatch>` | yes | `""` |
| `transaction` | `record<transaction>` | yes | `""` |
| `key` | `string` | yes | `"active"` |
| `periodStart` | `string` | yes | `""` |
| `periodEnd` | `string` | yes | `""` |
| `state` | `enum<"active" | "released">` | yes | `"active"` |
| `claimedAt` | `string` | yes | `""` |
| `releasedAt` | `string` | no | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
## ID
- Export name: `StatementTransactionResolutionClaimId`
- Exported: yes
- Structure: `"stringID<transaction, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.