# Raven — Build Plan v1

## What I’d do first
Do **not** start with the full Buckets engine.
Start with the data spine that everything else will rely on.

The right order is:
1. truth,
2. clarity,
3. control,
4. projection,
5. assistance.

That means:
- import and understand statements first,
- then present-day dashboard,
- then buckets,
- then scenarios,
- then AI helpers.

## Technical shape for this repo

### Current fit
You already have a good starting shape for this:
- `apps/raven` for the Nuxt 4 app
- `apps/schema` for model authoring / generation
- SurrealDB as the backend
- schema-kit runtime for generated CRUD/runtime contracts
- UnoCSS for the design system

### Recommended addition
Add one shared package for pure business logic:
- `packages/raven-core`

Use it for:
- money math
- transaction normalization helpers
- rule evaluation
- projection simulation
- debt payoff calculators
- shared Zod/TS domain types if helpful

That package becomes the portable brain you can later reuse in desktop/mobile surfaces.

## Core engineering principles
- Keep raw financial facts immutable.
- Keep planning separate from observation.
- Keep all AI decisions explainable.
- Keep simulation logic pure and testable.
- Keep UI components dumb where possible.
- Keep server-side orchestration where database topology or secrets matter.

## Suggested repo plan

### PR 1 — Vision, IA, and route skeleton
Goal: lock the product shape before deeper code.

Deliver:
- docs for product vision
- app shell nav for Past / Present / Future / Review / Settings
- placeholder pages with clean layout
- design tokens / UI rhythm decisions

Suggested routes:
- `/past/imports`
- `/past/transactions`
- `/past/clarify`
- `/present`
- `/present/month`
- `/present/debts`
- `/future/buckets`
- `/future/projections`
- `/review/opportunities`
- `/settings/accounts`
- `/settings/spaces`

### PR 2 — Schema for truth layer
Goal: establish the minimum data spine.

Models to define first:
- `financialSpace`
- `account`
- `statementImport`
- `statementRow`
- `transaction`
- `merchant`
- `category`
- `classificationRule`
- `clarificationTask`
- `monthlySnapshot`

Critical fields to include early:
- source identifiers
- imported timestamps
- original description text
- normalized description text
- amount and sign
- currency
- confidence
- status (`raw`, `normalized`, `classified`, `clarified`)
- space id
- manual override metadata

### PR 3 — Import pipeline and clarification queue
Goal: make Raven useful with real statement data.

Deliver:
- statement upload/import record
- parser for CSV first
- manual paste input for copied statement lines
- normalization pipeline
- duplicate detection heuristics
- transfer candidate matching
- clarification queue UI
- “apply rule to similar items” action

### PR 4 — Monthly truth dashboard
Goal: understand the current month and recent history.

Deliver:
- income vs outflow totals
- category breakdown
- recurring costs section
- subscription candidates
- banking fees visibility
- “largest avoidable costs” section
- business vs personal split visibility

### PR 5 — Present-day command center
Goal: give daily grounding and decision support.

Deliver:
- cash available
- upcoming obligations
- debt minimums
- runway
- daily target
- hourly target
- one action card
- daily worth / trajectory card

### PR 6 — Buckets engine v1
Goal: build the intentional money-routing system.

Deliver:
- bucket tree CRUD
- bucket types
- target, priority, withdrawal rules
- overflow behavior
- simple gates
- manual inflow allocation preview
- explanation ledger for allocations

### PR 7 — Projections studio
Goal: show realistic futures.

Deliver:
- scenario CRUD
- monthly simulation engine
- debt payoff ETA
- reserve target ETA
- compare scenarios
- one-off inflow/outflow adjustments
- “R200 less here = X sooner there” insights

### PR 8 — AI assistant surface
Goal: make Raven feel like a careful junior accountant.

Deliver:
- import assistant commands
- classification suggestions
- similar transaction suggestions
- cost-cutting suggestions
- explanation traces
- MCP-safe verbs only

## The most important domain workflow

### Statement-to-truth pipeline
1. Create import batch
2. Store raw file metadata
3. Parse rows into `statementRow`
4. Normalize to candidate `transaction` records
5. Match likely transfers
6. Suggest merchant/category/space
7. Queue low-confidence items for clarification
8. Apply learned rules to similar items
9. Rebuild month snapshots
10. Surface insights

That workflow is the backbone of Raven.

## Suggested status model
For transactions, use explicit lifecycle states:
- `imported`
- `normalized`
- `matched`
- `classified`
- `clarified`
- `ignored`

For clarifications:
- `open`
- `suggested`
- `resolved`
- `dismissed`

## Suggested first metrics to compute
- total income this month
- total spend this month
- fixed vs variable spend
- business vs personal spend
- recurring charges
- debt minimum due total
- average daily burn
- remaining runway days
- category drift vs last month
- top 5 optimization opportunities

## A good first dashboard layout

### Top row
- Cash today
- Runway
- Month remaining
- Debt pressure

### Middle row
- Income vs outflow this month
- Category spend
- Upcoming obligations

### Bottom row
- Clarifications waiting
- Recurring costs to review
- One next move
- Opportunities

## Codex prompt 1 — lock the shell and IA
```text
You are working in the Raven monorepo.

Read and follow these first:
- apps/raven/AGENTS.md
- apps/raven/app/pages/AGENTS.md
- apps/raven/server/AGENTS.md
- apps/raven/docs/ai/architecture.md

Task:
Create the first product shell for Raven as a Nuxt 4 application focused on a financial operating system with sections for Past, Present, Future, Review, and Settings.

Requirements:
- Add an app-level layout and navigation
- Create route pages for:
  - /past/imports
  - /past/transactions
  - /past/clarify
  - /present
  - /present/month
  - /present/debts
  - /future/buckets
  - /future/projections
  - /review/opportunities
  - /settings/accounts
  - /settings/spaces
- Use calm, minimal placeholder screens with clear headings and one-sentence purpose text for each page
- Keep styling simple and readable with UnoCSS-compatible classes
- Do not invent schema-driven CRUD pages yet
- Keep components presentational and light
- Add a small home/dashboard landing page that explains Raven as “financial truth, daily control, and future design”

Deliverables:
- New layout and route files
- Any small shared UI components needed for the shell
- A short README note describing the route structure
```

## Codex prompt 2 — define the truth-layer schema
```text
You are working in the Raven monorepo.

Read and follow these first:
- apps/schema/AGENTS.md
- apps/schema/config/AGENTS.md
- apps/raven/AGENTS.md
- apps/raven/docs/ai/architecture.md

Task:
Design the first Raven schema for the financial truth layer.

Goal:
Model the minimum entities needed to import statements, normalize transactions, categorize them, and manage a clarification queue.

Please define or scaffold the MPDG/schema approach for these models:
- financialSpace
- account
- statementImport
- statementRow
- transaction
- merchant
- category
- classificationRule
- clarificationTask
- monthlySnapshot

Requirements:
- Keep the design simple and extensible
- Preserve raw import provenance
- Include confidence and manual override support where relevant
- Include status fields for import/classification workflows
- Make room for personal/business separation via space/entity ownership
- Do not try to model the full bucket/projection system yet
- Produce a short design note explaining each model and the relationships

Output:
- Proposed schema/model definitions
- Notes on likely indexes
- Questions or risks surfaced as comments in the design note
```

## Codex prompt 3 — build import + clarification workflow
```text
You are working in the Raven monorepo.

Read and follow these first:
- apps/raven/AGENTS.md
- apps/raven/app/pages/AGENTS.md
- apps/raven/server/AGENTS.md
- any generated schema runtime contracts relevant to the new models

Task:
Implement the first end-to-end Raven import workflow for statement truth.

Scope:
- upload or create a statement import batch
- ingest CSV rows (CSV only for now)
- store rows and normalize them into candidate transactions
- add a clarification queue for low-confidence items
- allow the user to assign category, merchant, and financial space
- allow “apply to similar transactions” when resolving an item
- rebuild a monthly snapshot after changes

Requirements:
- keep raw import rows immutable
- preserve provenance from row -> normalized transaction
- add basic duplicate and transfer heuristics where practical
- do not add PDF parsing yet
- do not add bank APIs yet
- do not hide uncertainty: expose confidence clearly
- keep business logic out of presentational components

Deliverables:
- server/runtime orchestration needed for the workflow
- pages/components for import and clarification
- a simple seed/demo path if real import is not yet available
- tests for normalization helpers if there is a pure utility layer
```

## Codex prompt 4 — build present dashboard
```text
You are working in the Raven monorepo.

Read and follow the relevant AGENTS instructions first.

Task:
Build Raven’s first Present dashboard using the imported truth-layer data.

Show:
- cash position
- income this month
- spend this month
- fixed vs variable spend
- upcoming obligations placeholder section
- recurring costs
- clarifications waiting
- runway estimate
- a daily target card
- an hourly target card
- one “next best move” insight placeholder derived from available data

Requirements:
- prefer calm, high-signal UI
- make empty states thoughtful
- keep the language supportive, not shaming
- keep calculations transparent
```

## Codex prompt 5 — scaffold buckets engine
```text
You are working in the Raven monorepo.

Read and follow the relevant AGENTS instructions first.

Task:
Scaffold Raven’s first Buckets engine as a planning layer separate from observed transactions.

Scope:
- bucket CRUD
- hierarchical bucket tree
- bucket type
- target amount
- priority
- withdrawal policy
- overflow target
- simple gate rules
- manual preview of how a hypothetical inflow is allocated
- explanation panel showing why money flowed where it did

Requirements:
- keep observed transactions separate from planned allocations
- keep the rule engine simple and deterministic
- design the data structures so a later projection engine can reuse them
- do not build a full visual flow canvas yet unless the basics are already solid
```

## A simple product rule for deciding what to build next
Only build the next feature if it does one of these:
- increases truth,
- reduces ambiguity,
- improves decision quality,
- shortens time-to-clarity,
- makes future planning more realistic.

If it does not do one of those, it is probably not core yet.

## Immediate recommendation
This week, I would do only these three things:
1. lock the shell and route structure,
2. define the truth-layer schema,
3. build CSV import + clarification queue.

Once those exist, Raven becomes real.
