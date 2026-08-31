# CashflowSchedule — Types
_Accepted one-off or recurring future money rule_
**Table:** `cashflowSchedule`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | no | `""` |
| `category` | `record<category>` | no | `""` |
| `key` | `string` | yes | `""` |
| `title` | `string` | yes | `""` |
| `direction` | `enum<"outflow" | "inflow">` | yes | `"outflow"` |
| `certainty` | `enum<"committed" | "confirmed" | "expected" | "possible">` | yes | `"committed"` |
| `amountMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `timezone` | `string` | yes | `"Africa/Johannesburg"` |
| `cadence` | `enum<"once" | "weekly" | "monthly" | "quarterly" | "yearly">` | yes | `"once"` |
| `interval` | `int` | yes | `1` |
| `startDate` | `string` | yes | `""` |
| `endDate` | `string` | no | `""` |
| `onceDueOn` | `string` | no | `""` |
| `dayOfWeek` | `int` | no | `0` |
| `dayOfMonth` | `int` | no | `0` |
| `monthOfYear` | `int` | no | `0` |
| `status` | `enum<"active" | "paused" | "ended" | "cancelled">` | yes | `"active"` |
| `revision` | `int` | yes | `1` |
| `materializedThrough` | `string` | no | `""` |
| `termsEffectiveFrom` | `string` | yes | `""` |
| `pausedOn` | `string` | no | `""` |
| `resumedOn` | `string` | no | `""` |
| `endedOn` | `string` | no | `""` |
| `cancelledOn` | `string` | no | `""` |
| `createdOperation` | `record<financialOperation>` | yes | `""` |
| `lastOperation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
| `updatedAt` | `string` | yes | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `CashflowScheduleId`
- Exported: yes
- Structure: `"stringID<space, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.