# StatementReconciliationEvent — Types
_Append-only attestation or reopening history for an exact statement reconciliation_
**Table:** `statementReconciliationEvent`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `statementReconciliation` | `record<statementReconciliation>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `eventType` | `enum<"attested" | "reopened">` | yes | `"attested"` |
| `reconciliationRevision` | `int` | yes | `1` |
| `calculationHash` | `string` | yes | `""` |
| `calculationSnapshot` | `object` | yes |  |
| `reason` | `string` | no | `""` |
| `actorId` | `string` | no | `""` |
| `channel` | `enum<"ui" | "mcp" | "system">` | yes | `"ui"` |
| `operation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
## ID
- Export name: `StatementReconciliationEventId`
- Exported: yes
- Structure: `"stringID<statementReconciliation, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.