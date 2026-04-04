# User — Types
_Minimal user profile_
**Table:** `u`
## Fields
| Field | Type | Required | Default |
| --- | --- | --- | --- |
| `email` | `string` | yes | `""` |
| `uniqueId` | `md5<$email>` | no |  |
| `firstName` | `string` | yes | `""` |
| `surname` | `string` | yes | `""` |
| `role` | `record<t_u_role>` | yes |  |
## ID
- Export name: `UserId`
- Exported: yes
- Structure: `"email"`
## Notes
- Types are inferred from the graph + generated specs.
- Record ids returned by SurrealDB are objects; pass the record sub-id (`record.id`) to routers.