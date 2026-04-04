# Buckets — Detailed UX Spec v0

> Scope: Detailed UX + interaction specification for the **Buckets** system (creation, hierarchy, rules, distribution, withdrawal, projections integration) for **Money Mastery**.\
> Intent: Ship a delightful **Skateboard** that makes planning tangible on day one; evolve cleanly to Scooter/Bike.

---

## 1) Objectives (what “good” looks like)

- I can **model every rand** with a single mental model: *everything is a bucket*.
- I can create a **tree** of buckets, set rules and priorities, and immediately see **how inflows will be allocated**.
- I can run a **projection** and know **when** each target will be reached; I can try *what‑ifs* in seconds.
- The UI feels **calm, snappy, and legible**; defaults are helpful; power is progressive.

---

## 2) Information Architecture

- **Future** → **Buckets** (primary workspace)
  - Left: **Bucket Tree** (sortable, collapsible)
  - Right: **Inspector** (details, rules, preview)
  - Top bar: income per period (for preview), scenario switcher, Undo/Redo
- **Present** uses Buckets via projections for targets and reminders.
- **Past** maps statement categories to buckets (later).

---

## 3) Glossary & Mental Model

- **Bucket**: logical envelope for money (expense, saving, reserve, debt, tax, play, etc.).
- **Parent bucket** aggregates all descendants and can have its own rules.
- **Priority**: lower number means earlier in the flow (handled before others).
- **Distribution mode**: how a parent splits inflow among children.
- **Gate**: conditional reroute (e.g. “until Emergency hits R30k, divert 30% here”).
- **Withdrawal policy**: how spendable the bucket is (open → locked).
- **Target**: cap/goal; when hit, inflow overflows downstream according to rule.
- **Overflow**: where surplus goes when a target is met.

---

## 4) Bucket Types (presets; types drive sensible defaults)

- **expense\_fixed** — rent, insurance, loan minimums. Default: priority 10, target = monthly due, overflow → parent.
- **expense\_variable** — food, fuel. Priority 20, soft monthly guideline (no hard target by default).
- **reserve** — e.g., Emergency. Priority 30, min\_level/target, withdrawal `restricted`.
- **savings\_goal** — bike/holiday. Priority 60, target finite, withdrawal `restricted`.
- **debt** — credit card/loan. Priority 15, interest model, snowball rank.
- **tax** — tax envelope. Priority 5, precut percent.
- **long\_term\_freedom** — pay‑yourself‑first fund. Priority 0–2, precut percent, withdrawal `locked`.
- **play** — must‑spend monthly to avoid hoarding. Priority 70, monthly reset reminder.

> Note: Types are UX presets only; the engine reads explicit attributes.

---

## 5) Bucket Attributes (Inspector fields)

**Essentials**

- Name, Description
- Type (with tooltip explaining defaults)
- Parent (move bucket)
- Priority (integer; 0–999; lower = earlier)

**Targets & Levels**

- Target (R) — optional cap/goal
- Minimum level (R) — reserves floor
- Interest model (for *debt*/*investment*): none | simple | compound; rate; period

**Distribution** (applies when the bucket has children)

- Mode: **Equal** | **Weighted** | **Fixed amounts** | **Percent**
- Weights table (child → weight / amount / %)
- Remainder handling: to first child by order | round‑robin | to named child

**Withdrawal**

- Policy: **Open** | **Restricted** | **Last resort** | **Locked**
- Notes/policy hint shown in Present view (e.g., “Last‑resort only after reserves used”).

**Overflow**

- When full: **Return to parent** | **Send to sibling by order** | **Send to named bucket**

**Rules**

- Add one or more **Gates** (see §7):
  - Template library (common patterns)
  - Condition builder (IF … THEN …)
  - Active toggle

**Preview**

- With current Scenario income, show:
  - “If R10,000 enters parent → this bucket receives R… (…%) after rules.”
  - Progress meter and estimated completion date (if Target set).

---

## 6) Interactions & Micro‑UX

- **Create**: + New bucket (defaults to `expense_variable` under selected parent).
- **Reparent**: drag to new parent; confirm if rules/weights will be reset.
- **Reorder**: drag within a parent to change priority tie‑break and remainder target.
- **Duplicate**: clone a bucket (optionally include subtree).
- **Archive**: hides from active flow (keeps history).
- **Undo/Redo**: global stack for structural edits.
- **Keyboard**: `N` new sibling, `Shift+N` new child, `Cmd/Ctrl+↑/↓` reorder, `Cmd/Ctrl+E` edit.
- **Empty states**: seed template with 5 defaults; guided tour.

---

## 7) Rules (DSL v0 & UI)

**Goal**: powerful enough for 80% of scenarios; simple to read.

### 7.1 Rule templates (recommended)

- **Pay‑yourself‑first**: *Precut X% to Bucket LTF before anything else.*
- **Tax precut**: *Precut Y% to Tax bucket.*
- **Gate a goal**: *Until Emergency ≥ R30k, divert 30% of my share to Emergency.*
- **Skip when full**: *If this bucket is full, pass all allocation to overflow target.*
- **Debt snowball**: *When Debt A is paid, cascade its minimum to Debt B.*
- **Must‑spend Play**: *At month end, reset Play to 0; notify if unused.*

### 7.2 Condition builder (UI)

- IF **[bucket]** **[level/completion]** **[operator]** **[value/bucket]** THEN **[action]** **[percentage/amount]** **[destination]**.
- Examples:
  - IF `Emergency.level` < `R30,000` THEN `reroute 30%` TO `Emergency`.
  - IF `Debt:Visa.full` = `true` THEN `move min payment` TO `Debt:Mastercard`.

### 7.3 DSL (serialised JSON example)

```json
{
  "if": { "lhs": {"bucket":"Emergency","metric":"level"}, "op":"<", "rhs": 30000 },
  "then": { "action":"reroute_percent", "value": 30, "to":"Emergency" },
  "priority": 10,
  "active": true
}
```

Rules execute by **priority**, then declaration order. All rules are **pure** (no side‑effects outside allocation math).

---

## 8) Flow Semantics (deterministic order)

1. **Pre‑cuts** applied to inflow (e.g., LTF %, Tax %).
2. Walk buckets by **priority** ascending.
3. For a bucket with **children**, compute its distributable share:
   - Apply **Gates** (reroutes) to its share.
   - Distribute to children per **Mode**.
   - Handle rounding (see §9).
4. For a bucket with a **target**: cap at `target - current`; send **overflow** downstream.
5. Apply **interest** to debts at period end (projection mode).
6. Persist an **Allocation ledger** for explainability.

---

## 9) Rounding & Remainders

- Currency precision: 2 decimals.
- Distribute floor to 2 decimals; accumulate remainder at parent; apply to **first child by order** (default) for determinism.
- Option in Inspector to switch to **round‑robin** or **named remainder child**.

---

## 10) Visual Design

- **Tree**: left rail, collapsible; badges for type (icon + colour).
- **Progress**: inline bars with target chip (e.g., “R12,400 / R30,000 • ETA: Feb ‘26”).
- **Inspector**: two‑column form with sticky footer actions (Save, Revert).
- **Allocation Preview**: miniature Sankey/pill list showing current scenario split.
- **Errors**: human text (“Emergency target < current level; overflow will trigger”).

---

## 11) Projection Integration

- Mini **Scenario switcher** in Buckets header (e.g., Base, Stretch +R5k).
- **Time slider** (1–24 months) updates completion dates in preview.
- **Compare** mode: A/B two scenarios; show delta (months sooner/later).
- **Suggest**: small callouts, e.g., “Trim Subscriptions R300 → Emergency +1 month faster.”

---

## 12) Default Template (seed)

1. **Pay‑Yourself‑First (LTF)** — 5% precut, locked.
2. **Tax** — 27.5% precut (adjust later), restricted.
3. **Essentials** (parent) — priority 10; children: Rent (fixed), Utilities (fixed), Insurance (fixed), Groceries (variable).
4. **Reserves** (parent) — Emergency (target R30k, restricted), Health (min R2k), Maintenance (min R2k).
5. **Debts** (parent) — Visa, Loan (with interest).
6. **Goals** (parent) — Bike, Holiday.
7. **Play** — monthly reset reminder.

Gates:

- Until Emergency ≥ R30k, divert 30% of Reserves share to Emergency.
- Debt snowball on completion.

---

## 13) Creative Add‑ons (nice now, great later)

- **Windfall Wizard**: when a once‑off inflow arrives, propose optimal split respecting gates/targets.
- **Underspend Sweep**: at month end, sweep unspent variable envelopes → Reserves or Debts (toggle).
- **Drift Guard**: notify if a bucket’s actual spend deviates from plan by X% (when Past is wired up).
- **Bucket Notes & Docs**: attach quotes/receipts to goals; quick‑open from tree.
- **Templates Gallery**: “Starter”, “Family”, “Freelancer SA”, “Business Owner”.
- **Stress Tests**: simulate −20% income for 3 months; show which targets slip and by how much.
- **Lock‑to‑Unlock Ritual**: two‑step confirm to dip into `restricted` buckets (adds friction).
- **Badges**: Playfully celebrate milestones (first Emergency filled; first debt cleared).
- **Keyboard palette** (`Cmd/Ctrl+K`): jump to bucket; run “Add goal”, “Open Windfall Wizard”.

---

## 14) Explainability (trust)

- **Allocation ledger** panel: “Why did this bucket receive R742.15?” → show rule chain and math.
- **Rule inspector**: highlight currently active gates in green; inactive in grey with reason.

---

## 15) Data (initial shapes, Zod-ish)

```ts
Bucket = {
  id: string,
  parentId?: string,
  name: string,
  type: BucketType,
  priority: number,
  target?: Money,
  minLevel?: Money,
  distribution: { mode: 'equal'|'weights'|'fixed'|'percent', map?: Record<childId, number> },
  withdrawal: 'open'|'restricted'|'last_resort'|'locked',
  overflow: { mode: 'parent'|'sibling'|'named', toId?: string },
  interest?: { kind: 'none'|'simple'|'compound', rate?: number, period?: 'month'|'year' },
  rules: Rule[],
  active: boolean
}

Rule = { id: string, priority: number, active: boolean, if: Condition, then: Action }
Condition = { lhs: Metric, op: '<'|'≤'|'='|'≥'|'>' , rhs: number|Metric }
Metric = { bucketId: string, metric: 'level'|'progress'|'full' }
Action =
  | { kind: 'reroute_percent', value: number, toBucketId: string }
  | { kind: 'move_min_payment', fromDebtId: string, toDebtId: string }
  | { kind: 'skip_when_full' }
```

---

16. Algorithm (projection tick)

  1.  Start with inflow for the period.
  2.  Apply precut rules (LTF/Tax) → produce initial allocations.
  3.  For each priority band:
a. For each bucket: evaluate gates against current snapshot.
b. Determine distributable; apply target caps.
c. If the bucket has children: distribute by mode; push to children queues.
d. Route overflow.
  4.  End-of-period adjustments: accrue interest on debts; apply underspend sweep if enabled.
  5.  Record snapshot.

  17. Edge Cases

  • Parent target smaller than sum of child current levels → parent is “over-full”: flag and suggest fix.
  • Circular overflow/gates → detect and block with a helpful hint.
  • Locked bucket targeted by spend → require a two-step override.

  18. Acceptance Criteria (Skateboard)

  • Create, reorder, reparent, and archive buckets.
  • Set type, target, minimum level, distribution mode; set one or two gates.
  • Deterministic allocation preview works for a given inflow.
  • Projection (1–24 months) returns per-bucket series and completion dates.
  • Undo/Redo for structure edits.
  • Allocation ledger explains a bucket’s received amount.

  19. Test Matrix (unit)

  • Equal vs weighted distribution; remainder handling.
  • Gate ordering; multiple active gates.
  • Target cap then overflow.
  • Debt snowball cascade.
  • Locked/last-resort withdrawal attempts.
  • Scenario compare yields stable deltas.

  20. Next Design Artifacts

  • Wireframes: Tree + Inspector, Rule Builder modal, Allocation preview.
  • Micro-copy set for errors, hints, and celebratory states.
  • Icon set for bucket types.

  21. Implementation Notes

  • Domain in @money/core with Zod types and a pure simulation engine.
  • Nuxt UI uses a Pinia store to mirror the tree; Inspector writes through to core.
  • Electron: tray with two quick actions (Open Today, Add Windfall).
  • Data: SQLite locally; encryption at rest later.
  • Performance: memoise rule evaluation; update only affected subtrees to avoid reflow.