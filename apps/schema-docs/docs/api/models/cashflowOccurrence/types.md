# CashflowOccurrence — Types
_Concrete accepted due item materialized from a cashflow schedule_
**Table:** `cashflowOccurrence`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `schedule` | `record<cashflowSchedule>` | yes | `""` |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | no | `""` |
| `category` | `record<category>` | no | `""` |
| `scheduledDueOn` | `string` | yes | `""` |
| `dueOn` | `string` | yes | `""` |
| `scheduleRevision` | `int` | yes | `1` |
| `revision` | `int` | yes | `1` |
| `title` | `string` | yes | `""` |
| `direction` | `enum<"outflow" | "inflow">` | yes | `"outflow"` |
| `certainty` | `enum<"committed" | "confirmed" | "expected" | "possible">` | yes | `"committed"` |
| `cadence` | `enum<"once" | "weekly" | "monthly" | "quarterly" | "yearly">` | yes | `"once"` |
| `scheduledAmountMinor` | `int` | yes | `0` |
| `amountMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `status` | `enum<"due" | "settled" | "skipped" | "waived" | "cancelled">` | yes | `"due"` |
| `settledAt` | `string` | no | `""` |
| `transaction` | `record<transaction>` | no | `""` |
| `overrideReason` | `string` | no | `""` |
| `statusReason` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
| `lastOperation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
| `updatedAt` | `string` | yes | `""` |
## ID
- Export name: `CashflowOccurrenceId`
- Exported: yes
- Structure: `"stringID<schedule, scheduledDueOn>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.