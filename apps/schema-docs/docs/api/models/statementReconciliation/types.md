# StatementReconciliation — Types
_Current exact reconciliation state for one Account and committed statement import_
**Table:** `statementReconciliation`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `"current"` |
| `periodStart` | `string` | yes | `""` |
| `periodEnd` | `string` | yes | `""` |
| `currency` | `string` | yes | `"ZAR"` |
| `openingBalanceMinor` | `int` | no | `0` |
| `signedMovementEffectMinor` | `int` | yes | `0` |
| `expectedClosingBalanceMinor` | `int` | no | `0` |
| `reportedClosingBalanceMinor` | `int` | no | `0` |
| `differenceMinor` | `int` | no | `0` |
| `printedRowCount` | `int` | yes | `0` |
| `extractedRowCount` | `int` | yes | `0` |
| `movementComponentCount` | `int` | yes | `0` |
| `informationalComponentCount` | `int` | yes | `0` |
| `pendingCount` | `int` | yes | `0` |
| `proposedCount` | `int` | yes | `0` |
| `confirmedExistingCount` | `int` | yes | `0` |
| `newlyMaterializedCount` | `int` | yes | `0` |
| `unresolvedCount` | `int` | yes | `0` |
| `transferCandidateCount` | `int` | yes | `0` |
| `activeIssueCount` | `int` | yes | `0` |
| `blockingIssueCount` | `int` | yes | `0` |
| `calculationState` | `enum<"unavailable" | "difference" | "balanced">` | yes | `"unavailable"` |
| `coverageState` | `enum<"incomplete" | "complete">` | yes | `"incomplete"` |
| `attestationState` | `enum<"open" | "ready" | "reconciled" | "reopened">` | yes | `"open"` |
| `calculationHash` | `string` | yes | `""` |
| `revision` | `int` | yes | `1` |
| `calculatedAt` | `string` | yes | `""` |
| `calculationOperation` | `record<financialOperation>` | yes | `""` |
| `latestAttestationOperation` | `record<financialOperation>` | no | `""` |
| `latestReopeningOperation` | `record<financialOperation>` | no | `""` |
| `attestedAt` | `string` | no | `""` |
| `reopenedAt` | `string` | no | `""` |
| `provenance` | `object` | no |  |
## ID
- Export name: `StatementReconciliationId`
- Exported: yes
- Structure: `"stringID<statementImport, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.