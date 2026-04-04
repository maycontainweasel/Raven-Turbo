Notes from a previous exploration

Money Mastery — Vision v0.1 (Skateboard)

Working title: Money Mastery
Form factor: Electron desktop app running a Nuxt 4 frontend with tRPC backend
Style: iterative (skateboard → scooter → bike → motorbike …), test‑driven where possible

⸻

1) One‑sentence purpose

Give me total clarity, control, and confidence over money by visualising the past, acting wisely in the present, and engineering the future via a rules‑driven Buckets system and fast “what‑if” projections.

2) Problems to solve
	•	Hard to stay connected to why today matters → need a Today view with targets, nudges, and wins.
	•	Money decisions are opaque → need to model flow of every rand into buckets with rules, priorities, and gates.
	•	Admin fatigue → import and classify statements; highlight recurring costs; expose savings opportunities.
	•	Planning feels abstract → simulate months ahead with sliders, assumptions, and immediate visual feedback.

3) Outcomes (definition of useful)
	•	I can say exactly where each R1 goes, now and in projection.
	•	I can see completion dates for goals/buckets at current (and stretched) income.
	•	I have a per‑day and per‑hour target that ladders to weekly/monthly goals.
	•	I get gentle reminders to do tiny, valuable behaviours (micro‑DMO) that compound wealth.

4) Product principles
	1.	Clarity first: simple, legible, opinionated defaults; power features unfold progressively.
	2.	Plan → Act → Learn: always close the loop from projections to reality and back.
	3.	Everything is a bucket: one mental model for expenses, savings, debts, goals, taxes, play.
	4.	Rules, not willpower: encode priorities and gates so good behaviour is the default path.
	5.	Fast what‑ifs: sliders should feel like a synth—immediate feedback encourages exploration.
	6.	Offline‑first, private‑by‑default: local data, optional sync.

⸻

5) Pillars & key experiences

Past (Truth)
	•	Add accounts; import statements (CSV first; PDF later).
	•	Categorise + auto‑rules; detect recurring spend; show past months, trends, and cost clarity.
	•	Outputs fuel Present targets and Future projections.

Present (Today → Week → Month)
	•	“Now” panel: runway, today’s number, per‑hour anchor, micro‑DMO checklist.
	•	Goals: weekly/monthly checkpoints sourced from projections.
	•	Reminders: Electron native notifications for rituals (visualise, review, reconcile, sell an hour, trim a cost).

Future (Buckets & Projections)
	•	Buckets view: left = sortable tree; right = inspector for rules and status.
	•	Flow engine: priorities, caps/targets, conditional gates, withdrawal policies.
	•	Projection: simulate N months with income sliders and one‑offs; see completion dates per bucket and debt‑free dates.

⸻

6) Buckets — domain model v0

Everything is a bucket.

Bucket attributes
	•	id, name, description
	•	type: expense_fixed | expense_variable | reserve | savings_goal | long_term_freedom | debt | tax | play | income_route | other
	•	parent_id (nullable) → hierarchical tree
	•	priority (integer; lower = earlier in flow)
	•	target (cap/goal amount; optional)
	•	min_level (for reserves; e.g., keep ≥ R2,000)
	•	distribution_mode: equal | weights | fixed_amount | percent
	•	weights: map of child_id → weight (if mode = weights)
	•	withdrawal_policy: open | restricted | last_resort | locked
	•	overflow_behaviour: to_parent | to_sibling_by_order | to_named_bucket
	•	interest_model (for debt/investment): simple | compound with rate/period
	•	active (bool)

Rules (DSL v0)
	•	Gate: IF bucket("A").progress < target THEN reroute 50% HERE → bucket("A")
	•	Skip when full: IF self.full THEN pass_downstream
	•	Tax first: precut 27.5% → bucket("Tax")
	•	Pay-yourself-first: precut 5% → bucket("LTF")
	•	Replenish reserves: until reserve("Emergency").level ≥ R30,000 reroute 30%

Flow order (default)
	1.	Pre‑cuts: Pay‑yourself‑first + Tax.
	2.	Fixed essentials (rent, utilities, debt mins) by priority.
	3.	Variable living envelopes (food, fuel).
	4.	Reserves & savings (emergency, future obligations).
	5.	Goals (bike, drum kit, holidays).
	6.	Play and discretionary.

Projection semantics
	•	In each period: apply income → precuts → walk buckets by priority → distribute to children per mode → respect gates/targets/overflow → accrue interest on debts → snapshot.
	•	Mark completion dates when target hit.

⸻

7) Projections engine v0

Inputs: baseline monthly income, variability band ±%, optional income schedule, one‑off inflows/outflows, inflation toggle.
Controls: timeline (1–36 months), scenario presets, “stretch goal” slider (+R per month), debt snowball toggle.
Outputs: per‑bucket balances by month; date a target is reached; runway; % to plan; suggested actions (e.g., “Trim subscriptions by R300 → Emergency hits target 2 months sooner”).

⸻

8) Data model (initial)
	•	User (id, locale, currency, tz)
	•	Account (id, user_id, name, institution, kind, balance)
	•	Transaction (id, account_id, posted_at, amount, payee, memo, category_id, bucket_id?)
	•	Category (simple taxonomy for past spend)
	•	Bucket (see above)
	•	BucketRule (serialised DSL JSON)
	•	Allocation (periodic ledger of how inflow was routed)
	•	Scenario (projection settings snapshot)
	•	Snapshot (per month per bucket state for charting)

Storage choice: SQLite locally (via Prisma) for speed/offline; optional sync adapter later to PostgreSQL.

⸻

9) MVP scope — Skateboard

Goal: Build a delightful Buckets + Projections prototype that’s useful on day one, with a minimal Today view.
	1.	Buckets view
	•	Create/edit/delete buckets in a tree (drag to reorder).
	•	Inspector: type, priority, target, distribution (equal/weights), withdrawal policy.
	•	Simple gates: “until Bucket X hits target, divert N%”.
	•	Visuals: progress bars; parent aggregates children.
	2.	Projections
	•	Input: baseline monthly income; fixed expenses buckets; optional one‑offs.
	•	Simulate 1–24 months; show per‑bucket balances and completion dates.
	•	Save/load scenarios.
	3.	Present (minimal)
	•	Today card with: per‑day and per‑hour target, week goal, 3 micro‑DMO actions.
	•	Electron notifications for 1–2 rituals per day (configurable).
	4.	Local persistence
	•	Prisma + SQLite; seed with example buckets.
	•	Domain services in a separate package (@money/core).
	5.	Packaging
	•	Electron wrapper that launches Nuxt app; auto‑launch on login toggle.

Out of scope (MVP): bank linking, PDF parsing, complex tax, multi‑currency.

⸻

10) Next iterations

Scooter (v0.2)
	•	CSV statement import; category rules; recurring‑spend detection.
	•	Debt snowball/avalanche with interest; tax envelope heuristics.
	•	Play budget enforcement (spend it monthly rule).
	•	Multi‑income sources & variability modelling.

Bike (v0.3)
	•	Personal + Business spaces; inter‑account transfers & tax planning helpers.
	•	Envelope rollover; “underspend → sweep to reserves”.
	•	Goal marketplaces (e.g., vendor quotes attached to buckets).
	•	Optional cloud sync and mobile companion.

⸻

11) UX deliverables to draft now
	•	Information architecture: Past / Present / Future nav, plus Settings.
	•	Wireframes: Buckets (tree+inspector), Projections panel, Today view.
	•	Glossary: bucket types, gates, priorities, withdrawal policies.
	•	Empty states: playful but clear; seed 5 default buckets (Emergency, Essentials, Taxes, Play, LTF).
	•	Rituals: Morning 3‑minute vision; Weekly review; Monthly reconcile.

⸻

12) Engineering approach
	•	Monorepo (Turborepo)
	•	apps/money → Nuxt 4 + tRPC UI
	•	packages/core → domain entities, Zod types, simulation engine
	•	packages/db → Prisma schema + SQLite client
	•	apps/shell → Electron wrapper
	•	Tech choices
	•	Nuxt 4, tRPC, Zod, Prisma(+SQLite), Pinia.
	•	Charting: lightweight Recharts or Apache ECharts (TBD).
	•	Testing: Vitest for unit; Playwright for flows.
	•	TDD focus: simulation engine pure functions + rule evaluation; bucket ordering; completion date maths.

⸻

13) Initial Prisma sketch (non‑binding)

model Bucket {
  id               String   @id @default(cuid())
  parentId         String?  @index
  name             String
  description      String?
  type             String   // enum in app code
  priority         Int      @default(100)
  target           Decimal? @precision(18,2)
  minLevel         Decimal? @precision(18,2)
  distributionMode String   // equal | weights | fixed_amount | percent
  withdrawalPolicy String   // open | restricted | last_resort | locked
  overflowBehaviour String  // to_parent | to_sibling_by_order | to_named_bucket
  weights          Json?
  interestModel    Json?
  active           Boolean  @default(true)
  rules            Json?    // DSL serialised
  children         Bucket[] @relation("BucketToBucket")
}

model Scenario {
  id        String  @id @default(cuid())
  name      String
  settings  Json
  createdAt DateTime @default(now())
}


⸻

14) Visual language (vibe)
	•	Calm, focused UI; 1–2 accent colours; whitespace and hierarchy for clarity.
	•	Motif: flow and completion (pipes, gauges, progress arcs).
	•	Copy tone: encouraging, matter‑of‑fact, British English.

⸻

15) Risks & mitigations
	•	Complexity creep → stage gates (MVP must ship with Buckets + Projections only).
	•	Rules DSL brittleness → start simple; expose only 3–4 rule types; version rules.
	•	Performance in projections → pure functions + memoisation; cap timeline to 36 months initially.

⸻

16) Immediate plan (this week)
	1.	Core domain: define Zod types for Bucket, Rule, Scenario in @money/core.
	2.	Sim engine: implement simulateMonth(state, inflow); add tests for gates/targets/overflow.
	3.	Nuxt UI: Buckets tree + Inspector; Projection panel with monthly slider; seed data.
	4.	Electron shell: minimal wrapper; notifications POC for daily ritual.
	5.	Docs (UX folder): IA, glossary, and wireframe sketches next.

⸻

17) Backlog (Skateboard)
	•	Create default buckets: Taxes, Essentials, Emergency, LTF, Play.
	•	Drag‑and‑drop ordering with parent aggregates.
	•	Rule: simple gate to reroute % to a target bucket until full.
	•	Projection chart with completion date chips.
	•	Today card: per‑day/‑hour targets + 3 micro‑DMO actions.
	•	Electron notification at 08:00 and 16:00 (configurable).
	•	Save/load scenarios.

⸻

18) Open questions (to refine later)
	•	Tax heuristics for SA (personal vs business) and when to model precisely.
	•	How to represent business vs personal spaces and transfers between them.
	•	When to introduce CSV import and mapping UI.
	•	Which chart lib suits Electron best (bundle size vs features).

⸻

This is v0.1 of the vision (Skateboard). Next doc to draft: “Buckets — Detailed UX Spec v0” with rule patterns, inspector fields, and example presets.



