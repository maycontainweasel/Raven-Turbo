# Raven Penpot Reference Pack

These PNGs are implementation references exported from the `Raven` page in the
shared `one` Penpot project on 28 July 2026.

They are visual intent, not runtime or schema authority. Raven’s generated
schema-kit contracts remain authoritative for persisted models, commands, and
queries. Prototype-only interactions may use local Pinia state until an
orchestrator accepts the corresponding schema integration.

## Boards

| File | Penpot board |
| --- | --- |
| `00-raven-starting-board.png` | Raven · Starting board |
| `01-raven-accounts-baseline.png` | Raven · Accounts · Baseline |
| `02-raven-account-management.png` | Raven · Account · Management |
| `03-raven-account-tax.png` | Raven · Account · Tax |
| `04-raven-upcoming-baseline.png` | Raven · Upcoming · Baseline |
| `05-raven-command-palette.png` | Raven · Command palette |
| `06-raven-transaction-meaning-evidence.png` | Raven · Transaction · Meaning & Evidence |
| `07-raven-buckets-projection.png` | Raven · Buckets · Projection |
| `08-money-circuit-flow-v0.png` | Money Circuit · Flow v0 |
| `09-raven-daily-dashboard.png` | Raven · Daily Dashboard |
| `10-raven-clients-directory.png` | Raven · Clients · Directory |
| `11-raven-client-retainers.png` | Raven · Client · Retainers |
| `12-raven-daily-dashboard-sections.png` | Raven · Daily Dashboard · Sections |

## Current implementation order

1. Today dashboard and section controls — implemented
2. Accounts directory — implemented against the existing account-control contract
3. Account workspace and management/tax lenses — implemented against the existing account-control contract
4. Upcoming cashflow — implemented against the existing account-control contract
5. Transaction meaning and evidence — implemented as the account transaction drawer
6. Clients and retainers — implemented as app-local Pinia prototype routes
7. Buckets and Money Circuit — implemented as synchronized Nodes/Table prototype surfaces over one app-local Pinia tree

## Prototype routes

- `/` — Today
- `/accounts` — Accounts
- `/accounts/:spaceKey/:accountKey` — Account workspace, management/tax lenses, and transaction evidence
- `/upcoming` — Upcoming cashflow
- `/clients` — Client directory
- `/clients/:clientKey` — Retainers, expected income, client note, and opportunity
- `/buckets` — one-month Buckets projection with synchronized Nodes/Table views, inline draggable cards, fixed and expense-budget modes, movable flow groups, sequential/split execution with sibling distribution controls, directional node creation, conditional routing, a companion line-by-line flow report, a shared inspector, and a fullscreen spatial editor with zoom and Space-drag panning

The current circuit deliberately remains an app-local Pinia prototype. Its first
conditional example routes 50% of `Play` back into `Savings` while Savings is
below R80,000; this demonstrates rule visualization without defining persistent
schema or runtime semantics. `Monthly expenses` is one shared execution group:
the canvas renders it as a movable fieldset around its expenses while the table
renders it as a programmatic row with the same children. The inspector can
switch the group between sequential execution and a sibling split; the flow
report explains the resulting movements without representing observed ledger
transactions.

Do not infer missing backend behavior from a picture. Resolve any persistent
feature against `apps/raven-studio/docs/controllers/**` and
`modules/schema-kit/runtime/generated/**` first.
