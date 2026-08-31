# HostingProvider — Types
_Hosting, reseller, domain, email, VPS, or infrastructure provider account used to deliver retainers_
**Table:** `hostingProvider`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `providerType` | `enum<"reseller" | "shared_hosting" | "vps" | "domain" | "email" | "cloud" | "other">` | yes | `"reseller"` |
| `accountName` | `string` | no | `""` |
| `accountReference` | `string` | no | `""` |
| `websiteUrl` | `string` | no | `""` |
| `billingCadence` | `enum<"monthly" | "quarterly" | "annual" | "ad_hoc">` | yes | `"monthly"` |
| `monthlyCost` | `number` | no | `0` |
| `currency` | `string` | yes | `"ZAR"` |
| `status` | `enum<"active" | "paused" | "inactive" | "closed">` | yes | `"active"` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `HostingProviderId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.