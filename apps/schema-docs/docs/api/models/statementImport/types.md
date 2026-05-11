# StatementImport — Types
_Source statement import batch for an account cycle_
**Table:** `statementImport`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `sourceFileName` | `string` | yes | `""` |
| `sourceFormat` | `enum<"csv" | "ofx" | "qif" | "pdf" | "manual">` | yes | `"pdf"` |
| `importedAt` | `string` | yes | `""` |
| `statementDate` | `string` | no | `""` |
| `status` | `enum<"raw" | "parsed" | "matched" | "reviewed" | "error">` | yes | `"raw"` |
| `rowCount` | `number` | no | `0` |
| `normalizedCount` | `number` | no | `0` |
| `clarificationCount` | `number` | no | `0` |
| `sourceChecksum` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `StatementImportId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.