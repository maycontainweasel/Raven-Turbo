# AccountFacilitySnapshot — Types
_Immutable dated evidence of a credit, overdraft, loan, or revolving facility and its exact observed or contractual terms_
**Table:** `accountFacilitySnapshot`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `facilityKind` | `enum<"credit_card" | "overdraft" | "revolving_credit" | "loan" | "other">` | yes | `"credit_card"` |
| `currency` | `string` | yes | `"ZAR"` |
| `asOf` | `string` | yes | `""` |
| `effectiveFrom` | `string` | no | `""` |
| `recordedAt` | `string` | yes | `""` |
| `evidenceLevel` | `enum<"confirmed" | "observed">` | yes | `"confirmed"` |
| `sourceKind` | `enum<"statement" | "contract" | "manual_confirmation" | "provider_sync">` | yes | `"statement"` |
| `sourceRef` | `string` | no | `""` |
| `statementImport` | `record<statementImport>` | no | `""` |
| `hasFacilityLimit` | `boolean` | yes | `false` |
| `facilityLimitMinor` | `int` | no | `0` |
| `hasAvailableCredit` | `boolean` | yes | `false` |
| `availableCreditMinor` | `int` | no | `0` |
| `hasMinimumPayment` | `boolean` | yes | `false` |
| `minimumPaymentMinor` | `int` | no | `0` |
| `paymentDueOn` | `string` | no | `""` |
| `interestRates` | `object` | no |  |
| `feeTerms` | `object` | no |  |
| `terms` | `object` | no |  |
| `operation` | `record<financialOperation>` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `AccountFacilitySnapshotId`
- Exported: yes
- Structure: `"stringID<account, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.