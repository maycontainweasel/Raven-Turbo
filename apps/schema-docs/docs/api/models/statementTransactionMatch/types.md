# StatementTransactionMatch — Types
_Audited interpretation linking exact statement movement components to one observed transaction_
**Table:** `statementTransactionMatch`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `primaryComponent` | `record<statementRowComponent>` | yes | `""` |
| `componentIds` | `array<string>` | yes | `[]` |
| `transaction` | `record<transaction>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `state` | `enum<"proposed" | "confirmed" | "rejected" | "superseded">` | yes | `"proposed"` |
| `method` | `enum<"explicit" | "exact_reference" | "exact_description" | "exact_date" | "bounded_date" | "grouped_exact" | "created_from_component" | "transfer_candidate" | "other">` | yes | `"explicit"` |
| `reasonCodes` | `array<string>` | yes | `[]` |
| `confidence` | `number` | yes | `0` |
| `signedComponentTotalMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `revision` | `int` | yes | `1` |
| `proposedOperation` | `record<financialOperation>` | yes | `""` |
| `confirmedOperation` | `record<financialOperation>` | no | `""` |
| `rejectedOperation` | `record<financialOperation>` | no | `""` |
| `supersededOperation` | `record<financialOperation>` | no | `""` |
| `proposedBy` | `string` | no | `""` |
| `reviewedBy` | `string` | no | `""` |
| `proposedAt` | `string` | yes | `""` |
| `confirmedAt` | `string` | no | `""` |
| `rejectedAt` | `string` | no | `""` |
| `supersededAt` | `string` | no | `""` |
| `rejectionReason` | `string` | no | `""` |
| `supersessionReason` | `string` | no | `""` |
| `supersedes` | `record<statementTransactionMatch>` | no | `""` |
| `supersededBy` | `record<statementTransactionMatch>` | no | `""` |
| `sourceState` | `enum<"committed" | "superseded">` | yes | `"committed"` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementTransactionMatchId`
- Exported: yes
- Structure: `"stringID<statementImport, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.