# TransactionPurposeAssignment — Types
_Append-only reviewed assignment of one reusable management purpose to one observed transaction_
**Table:** `transactionPurposeAssignment`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `transaction` | `record<transaction>` | yes | `""` |
| `purpose` | `record<transactionPurpose>` | yes | `""` |
| `revision` | `int` | yes | `1` |
| `state` | `enum<"proposed" | "confirmed" | "superseded" | "rejected">` | yes | `"proposed"` |
| `isCurrent` | `boolean` | yes | `true` |
| `assignmentSource` | `enum<"manual" | "agent" | "rule" | "import">` | yes | `"manual"` |
| `confidence` | `number` | no | `0` |
| `occurrenceLabel` | `string` | no | `""` |
| `context` | `object` | no |  |
| `rule` | `record<classificationRule>` | no | `""` |
| `supersedes` | `record<transactionPurposeAssignment>` | no | `""` |
| `operation` | `record<financialOperation>` | no | `""` |
| `recordedAt` | `string` | yes | `""` |
| `reviewedAt` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `TransactionPurposeAssignmentId`
- Exported: yes
- Structure: `"stringID<transaction, revision>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.