# TransactionTaxDeclaration — Types
_Append-only sparse tax-lens category and description override for one observed transaction_
**Table:** `transactionTaxDeclaration`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `transaction` | `record<transaction>` | yes | `""` |
| `taxCategory` | `record<taxCategory>` | no | `""` |
| `revision` | `int` | yes | `1` |
| `state` | `enum<"proposed" | "user_confirmed" | "superseded" | "rejected">` | yes | `"proposed"` |
| `isCurrent` | `boolean` | yes | `true` |
| `declarationSource` | `enum<"manual" | "agent" | "rule" | "import">` | yes | `"manual"` |
| `taxDescription` | `string` | no | `""` |
| `evidenceStatus` | `enum<"not_assessed" | "missing" | "partial" | "available" | "not_required">` | yes | `"not_assessed"` |
| `context` | `object` | no |  |
| `supersedes` | `record<transactionTaxDeclaration>` | no | `""` |
| `operation` | `record<financialOperation>` | no | `""` |
| `recordedAt` | `string` | yes | `""` |
| `reviewedAt` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `TransactionTaxDeclarationId`
- Exported: yes
- Structure: `"stringID<transaction, revision>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.