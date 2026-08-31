# Retainer — Types
_Client retainer, hosting agreement, support arrangement, or recurring maintenance commitment_
**Table:** `retainer`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `client` | `record<client>` | yes | `""` |
| `title` | `string` | yes | `""` |
| `type` | `enum<"hosting" | "email_hosting" | "maintenance" | "support" | "seo" | "mixed" | "other">` | yes | `"hosting"` |
| `status` | `enum<"active" | "paused" | "overdue" | "cancelled" | "closed">` | yes | `"active"` |
| `startDate` | `string` | no | `""` |
| `billingCadence` | `enum<"monthly" | "quarterly" | "annual" | "ad_hoc">` | yes | `"monthly"` |
| `amountCharged` | `number` | no | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `quotedAmount` | `number` | no | `0` |
| `quotedAt` | `string` | no | `""` |
| `quoteReference` | `string` | no | `""` |
| `nextBillingDate` | `string` | no | `""` |
| `lastBilledDate` | `string` | no | `""` |
| `invoiceCount` | `number` | no | `0` |
| `amountCollectedToDate` | `number` | no | `0` |
| `agreementSourceNotes` | `string` | no | `""` |
| `termsConditions` | `string` | no | `""` |
| `includedServices` | `string` | no | `""` |
| `excludedServices` | `string` | no | `""` |
| `supportLevel` | `string` | no | `""` |
| `hostingProvider` | `record<hostingProvider>` | no | `""` |
| `providerAccountName` | `string` | no | `""` |
| `coveredAssets` | `string` | no | `""` |
| `costToMe` | `number` | no | `0` |
| `costCadence` | `enum<"monthly" | "quarterly" | "annual" | "ad_hoc">` | yes | `"monthly"` |
| `renewalReviewDate` | `string` | no | `""` |
| `recommendedAction` | `enum<"none" | "review" | "increase" | "pause" | "cancel" | "new_quote" | "confirm_terms" | "bill_client">` | yes | `"none"` |
| `risksIssues` | `string` | no | `""` |
| `nextAction` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `RetainerId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.