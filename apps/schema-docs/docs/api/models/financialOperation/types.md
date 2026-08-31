# FinancialOperation — Types
_Immutable receipt for an idempotent semantic Raven command_
**Table:** `financialOperation`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `command` | `string` | yes | `""` |
| `idempotencyKey` | `string` | yes | `""` |
| `requestHash` | `string` | yes | `""` |
| `channel` | `enum<"ui" | "mcp" | "system">` | yes | `"ui"` |
| `actorId` | `string` | no | `""` |
| `status` | `enum<"applied" | "replayed" | "failed">` | yes | `"applied"` |
| `resultRefs` | `array<string>` | no | `[]` |
| `warningCodes` | `array<string>` | no | `[]` |
| `auditMeta` | `object` | no |  |
| `recordedAt` | `string` | yes | `""` |
| `completedAt` | `string` | no | `""` |
| `failureCode` | `string` | no | `""` |
## ID
- Export name: `FinancialOperationId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.