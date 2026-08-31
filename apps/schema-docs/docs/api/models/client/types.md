# Client — Types
_Global Raven client record for retainers, hosting, maintenance, and future billing relationships_
**Table:** `client`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `key` | `string` | yes | `""` |
| `name` | `string` | yes | `""` |
| `businessName` | `string` | no | `""` |
| `contactPerson` | `string` | no | `""` |
| `email` | `email` | no | `""` |
| `phoneWhatsapp` | `string` | no | `""` |
| `websiteDomain` | `string` | no | `""` |
| `status` | `enum<"active" | "paused" | "inactive" | "closed">` | yes | `"active"` |
| `relatedProjects` | `string` | no | `""` |
| `orbitClientId` | `string` | no | `""` |
| `notes` | `string` | no | `""` |
## ID
- Export name: `ClientId`
- Exported: yes
- Structure: `"key"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.