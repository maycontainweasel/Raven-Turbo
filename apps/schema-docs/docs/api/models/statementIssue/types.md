# StatementIssue — Types
_Source extraction or validation issue kept separate from management clarification_
**Table:** `statementIssue`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `statementRow` | `record<statementRow>` | no | `""` |
| `statementRowComponent` | `record<statementRowComponent>` | no | `""` |
| `key` | `string` | yes | `""` |
| `code` | `string` | yes | `""` |
| `severity` | `enum<"info" | "warning" | "blocking">` | yes | `"warning"` |
| `blocking` | `boolean` | yes | `false` |
| `state` | `enum<"open" | "acknowledged" | "resolved" | "superseded">` | yes | `"open"` |
| `message` | `string` | yes | `""` |
| `revision` | `int` | yes | `1` |
| `detectedOperation` | `record<financialOperation>` | yes | `""` |
| `dispositionOperation` | `record<financialOperation>` | no | `""` |
| `detectedAt` | `string` | yes | `""` |
| `acknowledgedAt` | `string` | no | `""` |
| `resolvedAt` | `string` | no | `""` |
| `reviewedBy` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementIssueId`
- Exported: yes
- Structure: `"stringID<statementImport, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.