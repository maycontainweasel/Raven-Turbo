# Flow Canvas — UX & Tech Plan v0

> A visual, node‑based view of the same Buckets structure: top‑down **money flow** from inflow → precuts → essentials → reserves → goals → play. This complements the Tree view and becomes the primary **strategy/brainstorming** workspace.

---

## 1) Why a Flow Canvas

* Make the flow **obvious**: see where R10,000 goes in a single glance.
* Think in **systems**: gates, priorities, and overflow feel natural when drawn as a graph.
* Design **what‑ifs** fast: tweak a node and watch edges re‑balance instantly.

---

## 2) Concept — Topology & Semantics

* **Orientation**: Top → bottom (DAG). Left‑right variants optional.
* **Lanes** (swimlanes): Precuts • Essentials • Reserves • Debts • Goals • Play.
* **Nodes = Buckets**. Header shows **name**, **type badge**, **current/target** (and **ETA** if set).
* **Edges = Distribution paths** with **% labels**; **thickness** proportional to amount this period.
* **Gates** render as small rule pills on nodes; active gates glow; tooltips explain *why*.
* **Overflow** shows as secondary thin edge with a dotted style to the target bucket.
* **Withdrawal policy** glyphs: open ▢, restricted ◐, last‑resort !, locked 🔒.
* **Mini‑map** + **zoom/pan** (trackpad‑friendly), grid snapping optional.

---

## 3) Core interactions

* **Create** nodes (N), drag to position; drag from node port to create **edge**; inline **% weights** editor on edge label.
* **Reparent** by dropping a node inside another in the Tree (source of truth). Canvas reflects instantly.
* **Auto‑layout** (ELK layered) with **pinning**: you can fix positions; layout respects pins.
* **Inspector dock** on right: Details • Rules • Preview • Ledger (same as Tree).
* **Mode switch**: **Build** (edit rules/edges) vs **Simulate** (locked layout, animated flow for current scenario).
* **Time scrubber** (Simulate): 1–24 months, plays a ghost animation showing balances filling.
* **Compare overlay**: Scenario A vs B draws faint second set of edges to show diffs.

---

## 4) Visual math (live)

* Header chip per node: **R received this period** (and % of parent), **R current**, **R to target**.
* Edge label auto‑computes **effective %** after gates and caps.
* Hover a node: highlight its **upstream** and **downstream** paths; dim rest.
* **Explain** on click: small ledger card: *“R742.15 from Goals (24% weighted) → Bike. Gate ‘Emergency < R30k’ inactive.”*

---

## 5) Variable budgets & reconciliation (monthly envelopes)

* **Envelope attributes** for `expense_variable` buckets:

  * `budget`: guideline per month (R)
  * `volatility_band`: e.g., ±10% (advisory)
  * `rollover_policy`: `none` | `cap_at_budget` | `carry_all`
  * `overspend_policy` (order): e.g., `own_reserve → discretionary → buffer → last_resort`
* **During month**: Actual spend debits envelope; canvas shows **deficit/surplus meter**.
* **Month end (“Reconcile”)**:

  1. Compute delta = actual − budget.
  2. If **surplus**: sweep per rollover policy (e.g., to Reserves or Debts).
  3. If **overspend**: resolve by policy order: draw from Play → Buffer → named buckets (with respect to withdrawal policies).
  4. Persist a **Reconciliation ledger** and adjust projections if persistent drift detected.
* **Budgets learning**: optional “smart suggest” raises/lowers next month’s budget within the volatility band based on rolling average.

---

## 6) Parallel/alternative processes

* **Scenario layers**: design alt flows without changing the base (e.g., “Lean Essentials” vs “Normal”).
* **Per‑node “Profile”**: quick preset of rules/weights per scenario (e.g., Goals weight shift when Emergency < target).
* **Overlay toggle** to compare scenario edges on the same canvas.

---

## 7) Tech options (Nuxt 4 / Vue 3)

### Recommended stack

* **Vue Flow** (`@vue-flow/core`) — modern Vue 3 graph editor: nodes/edges, zoom/pan, minimap, selection, edge labels; great DX.
* **ELK.js** for **layered DAG autolayout** (top‑down). Integrate via worker to keep the UI snappy.
* **ECharts** (Sankey/Waterfall/Bullets) for analytic charts in Projections Studio.

### Alternatives & when to pick them

* **Cytoscape.js (+ Vue wrapper)** — Canvas/WebGL renderer; excellent performance on very large graphs; rich layouts (dagre/elk extensions). Use if we anticipate **hundreds** of nodes.
* **AntV X6** — powerful graph editor with Vue integration; great for diagramming apps. Slightly heavier; superb for custom ports/handles and group nodes.
* **vis-network** — simple and light; fewer editing affordances.
* **D3 custom** — ultimate control, highest effort; only if we want a fully bespoke renderer.

**Note**: Tree remains the **source of truth**. Canvas is a projection/editing surface. All mutating actions call core commands which update the tree, then the canvas re‑derives nodes/edges.

---

## 8) Data mapping

* **Nodes**: `id`, `label`, `type`, `coords`, `metrics: { received, current, target, eta }`, `badges: { lock, gateActive, overflow }`.
* **Edges**: `sourceId`, `targetId`, `weightMode: equal|weights|fixed|percent`, `weight`, `effectivePercent`.
* **Derivation**: edges generated from **parent→child** relationships plus rule outcomes. We prohibit cycles; validation runs in core.

---

## 9) Performance

* Layout in a **Web Worker** (ELK). Debounce while dragging.
* Progressive detail: render edge labels only at zoom ≥ X; collapse quiet subtrees.
* Use **requestAnimationFrame** for flow animations; avoid layout reflow on minor metric updates.
* Large trees: virtualised node list + minimap for fast navigation.

---

## 10) Micro‑UX details

* **Edge editor**: click label to edit %/weight; Tab cycles labels; Enter commits.
* **Snap lines** to align nodes; **Guides** for swimlanes.
* **Rule pills**: hover shows human sentence; click opens rule in Inspector.
* **Conflict hints**: “Sum of child weights > 100%” with one‑click normalise.
* **Pin/Unpin** node; **Auto‑arrange** respects pins.
* **Mini‑tour**: 90‑second walkthrough the first time you open Canvas.

---

## 11) Budgeting examples (overspend/underspend)

* **Food** budget R10k, spend R11k → deficit R1k.

  * Policy: own\_reserve (0) → **Play** (R500) → **Buffer** (R500) → done.
  * Canvas paints the Food node amber with a deficit badge; a dotted edge animates from Play/Buffer to indicate the transfer.
* **Groceries** underspend R800 with `carry_all` → sweep to **Reserves: Health**.

---

## 12) End‑of‑month algorithm (pseudocode)

```ts
function reconcileMonth(state) {
  for (const b of variableExpenseBuckets(state)) {
    const delta = b.actual - b.budget;
    if (delta > 0) reduceByPolicy(b, delta, state); // overspend
    if (delta < 0) sweepSurplus(b, -delta, state);  // underspend
  }
  recordReconciliationEntries();
  maybeAdjustBudgets();
}
```

---

## 13) Implementation plan (2 sprints)

**Sprint 1 — Canvas MVP**

* Add `flow` route: Canvas shell with Vue Flow + ELK worker.
* Render nodes/edges from bucket tree; basic autolayout + pinning.
* Edge % editor; Inspector dock wired to core.
* Simulate **current month** allocation and animate edge thickness.

**Sprint 2 — Budgets & Reconcile**

* Envelope attributes & UI on `expense_variable` nodes.
* Deficit/surplus meters; month‑end Reconcile flow.
* Scenario overlay + compare view.
* Explainability tooltips and ledger link.

---

## 14) Open questions

* Do we allow **cross‑tree edges** (e.g., overflow to a distant sibling) visually, or keep overflow implicit except on hover?
* Should swimlanes be **auto‑derived** from type, or user‑customisable lanes?
* Do we show **actuals** on the Canvas during the month (from Past) or keep it purely projected and leave actuals to Present?

---

**Outcome**: A snappy, modern, visual canvas that keeps the mental model unified but gives you a wide, tactile surface to think and plan. Ready to scaffold in `apps/money/pages/future/flow.vue` with Vue Flow + ELK.js and the shared Inspector.
