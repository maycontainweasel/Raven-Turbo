# StatementLegacyResolutionItem — Types
_Immutable compatibility disposition item belonging to one selected-source resolution event_
**Table:** `statementLegacyResolutionItem`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `space` | `record<financialSpace>` | yes | `""` |
| `account` | `record<account>` | yes | `""` |
| `statementLegacyResolution` | `record<statementLegacyResolution>` | yes | `""` |
| `canonicalStatementImport` | `record<statementImport>` | yes | `""` |
| `legacyStatementImport` | `record<statementImport>` | yes | `""` |
| `key` | `string` | yes | `""` |
| `compatibilityClass` | `enum<"exact_existing_transaction_adoption" | "exact_grouped_component_adoption" | "canonical_component_requires_materialization" | "legacy_transaction_historical_only" | "transfer_review_required" | "informational_non_movement" | "ambiguous_or_conflicting">` | yes | `"exact_existing_transaction_adoption"` |
| `activeLedgerOutcome` | `enum<"adopted_existing" | "adopted_grouped" | "materialized" | "historical_only" | "confirmed_transfer" | "informational_only" | "authority_released">` | yes | `"adopted_existing"` |
| `canonicalComponent` | `record<statementRowComponent>` | no | `""` |
| `canonicalComponentIds` | `array<string>` | yes | `[]` |
| `legacyStatementRow` | `record<statementRow>` | no | `""` |
| `legacyTransaction` | `record<transaction>` | no | `""` |
| `legacyTransactionIds` | `array<string>` | yes | `[]` |
| `accountTransfer` | `record<accountTransfer>` | no | `""` |
| `itemEvidenceHash` | `string` | yes | `""` |
| `expectedClaimHash` | `string` | yes | `""` |
| `operation` | `record<financialOperation>` | yes | `""` |
| `recordedAt` | `string` | yes | `""` |
## ID
- Export name: `StatementLegacyResolutionItemId`
- Exported: yes
- Structure: `"stringID<statementLegacyResolution, key>"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.