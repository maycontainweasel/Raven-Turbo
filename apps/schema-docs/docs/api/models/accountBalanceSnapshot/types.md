# AccountBalanceSnapshot — Types
_Immutable as-of account balance evidence with explicit freshness provenance_
**Table:** `accountBalanceSnapshot`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `balanceKind` | `enum<"available" | "ledger" | "statement" | "market_value" | "outstanding">` | yes | `"ledger"` |
| `amountMinor` | `int` | yes | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `economicNature` | `enum<"asset" | "liability" | "informational">` | yes | `"asset"` |
| `asOf` | `string` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
| `evidenceLevel` | `enum<"confirmed" | "observed">` | yes | `"confirmed"` |
| `sourceKind` | `enum<"manual_confirmation" | "statement_closing" | "transaction_observation" | "provider_sync" | "market_quote">` | yes | `"manual_confirmation"` |
| `sourceRef` | `string` | no | `""` |
| `operation` | `record<financialOperation>` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `AccountBalanceSnapshotId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.