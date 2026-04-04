# Raven — Vision v1

## Core idea
Raven is not a budgeting app.

Raven is a personal **financial operating system**: a calm, private, rules-driven place where every rand can be understood, every obligation can be anticipated, and every decision can move life toward stability, dignity, and freedom.

It exists to do three things at once:
1. tell the truth about the past,
2. create clarity in the present,
3. engineer the future on purpose.

## Naming
**Raven** is the right product name.
It carries intelligence, pattern recognition, craft, foresight, and emotional meaning.

A useful creative move is to keep **Elgiz** alive as the name of the internal rules/projection engine.
- **Raven** = the product and daily companion
- **Elgiz** = the flow engine that routes money through buckets, gates, and projections

## One-sentence product vision
**Raven gives me total financial truth, daily grounded control, and a rules-driven path to recovery and prosperity.**

## The user promise
When I open Raven, I should feel:
- less fog,
- less shame,
- less panic,
- more orientation,
- more control,
- more momentum.

Raven should not merely report numbers.
It should reduce chaos.

## The three horizons

### 1) Past — Truth
Raven records what has actually happened.

This horizon answers:
- Where did the money actually go?
- What am I really spending on?
- Which costs recur?
- Which things are rising silently?
- What patterns are damaging me?
- What can be reclassified, optimized, stopped, or negotiated?

Primary capabilities:
- Accounts
- Statement imports
- Transaction normalization
- Categorization
- Merchant recognition
- Clarification queue
- Recurring spend detection
- Historical monthly views
- Tax-related annotations

### 2) Present — Command
Raven shows what is true right now and what matters next.

This horizon answers:
- What have I got today?
- What is safe to spend?
- What still needs to be covered this month?
- What is due soon?
- What is my runway?
- What is my per-day and per-hour target?
- What single action would improve my position fastest today?

Primary capabilities:
- Dashboard
- Cash position
- Runway
- Monthly obligations
- Budget status
- Daily target / hourly target
- Debt pressure and upcoming due dates
- Daily grounding notifications
- Opportunity prompts
- Micro-habit rituals

### 3) Future — Design
Raven models the future before life happens.

This horizon answers:
- If money comes in, where must it go first?
- Which buckets must fill before others?
- How long until debts are cleared?
- What changes if I reduce one expense?
- What happens if income improves?
- Which obligations can surprise me later if I ignore them now?

Primary capabilities:
- Buckets tree
- Bucket rules and gates
- Allocation engine
- Scenario projections
- Debt payoff strategies
- Goal funding timelines
- Emergency and reserve planning
- “What if” calculators

## The four internal layers
The best architecture for Raven is not just “budgeting”. It is four layers.

### Layer A — Facts
Immutable financial facts.
- raw statement files
- imported rows
- normalized transactions
- account balances
- transfers
- timestamps
- source provenance

### Layer B — Meaning
Interpretation of facts.
- merchants
- categories
- tags
- business/personal space
- tax treatment
- recurring pattern detection
- clarification state
- confidence scores

### Layer C — Control
Planned money behavior.
- budgets
- obligations
- buckets
- rules
- debt strategy
- saving targets
- reserve floors

### Layer D — Guidance
The coaching surface.
- notifications
- warnings
- opportunities
- insights
- rituals
- projections
- “next best move” suggestions

This separation matters.
Facts must stay true even when plans change.

## The most important architectural rule
**Never mix observed money with planned money.**

Keep these separate:
- **Observed ledger**: what actually happened
- **Planning ledger**: how money should be allocated
- **Scenario engine**: simulations that never overwrite reality

That single decision will keep Raven sane as it grows.

## The second architectural rule
**Raw imports are immutable.**

Every statement import should preserve:
- original file
- import batch
- original rows / parsed rows
- normalized transaction candidates
- confidence
- final reviewed result

This gives Raven accountant-like trust.

## The third architectural rule
**Every automation must be explainable.**

If Raven or an AI says:
- this transaction is groceries,
- this belongs to business,
- this overflow went to Emergency,
- this debt should be paid next,

then Raven must be able to show:
- why,
- based on which rule,
- with what confidence,
- and who or what made the decision.

## Product principles
1. **Clarity before cleverness**  
   A calm answer now is worth more than a powerful feature nobody trusts.

2. **Truth before advice**  
   Raven earns the right to advise only after it can represent reality accurately.

3. **Rules before willpower**  
   Good behavior should be encoded, not re-negotiated emotionally every month.

4. **Small moves compound**  
   Raven should honour tiny wins and show their future value.

5. **No shame in the interface**  
   The app can be honest without being punishing.

6. **Private by default**  
   Start local-first; sync later.

7. **Fast feedback**  
   Projections should feel immediate and alive.

8. **Every feature must answer “so what?”**  
   If a number does not change a decision, it is secondary.

## Anti-goals
Raven should not become:
- a generic bank-style analytics dashboard,
- a noisy productivity app,
- a bookkeeping clone for accountants,
- a trading terminal,
- a giant admin system that takes more time than it saves.

It can touch those worlds, but only in service of clarity and action.

## The emotional design stance
You described feeling disempowered, overwhelmed, and tired of vagueness.
That means Raven should not only show a raw net worth number.

A better daily grounding card is:
- net position,
- change over 30 days,
- cash available today,
- runway,
- debt reduced this month,
- one next action,
- one longer-term reason.

That keeps the app honest but strengthening.

## The primary job to be done
“When money comes in or goes out, I want Raven to tell me exactly what it means, what it affects, and what I should do next.”

## Secondary jobs to be done
- “Help me clean up the past.”
- “Help me stop surprises.”
- “Help me create a system that survives emotion.”
- “Help me model recovery.”
- “Help me protect my girls and future obligations.”
- “Help me make better decisions with limited resources.”

## Spaces / entities
Raven should support multiple financial spaces from early on.

Recommended:
- Personal
- Business
- Trading / Investing
- Child / Family obligations

Every account, transaction, budget, bucket, debt, and goal should belong to a space.
Cross-space transfers should be explicit.

That will matter enormously for tax, clarity, and future reporting.

## Core domain objects

### Phase 1 essentials
- FinancialSpace
- Account
- StatementImport
- StatementRow
- Transaction
- Merchant
- Category
- ClassificationRule
- ClarificationTask
- MonthlySnapshot

### Phase 2 planning
- Budget
- BudgetLine
- Obligation
- Subscription
- DebtAccount
- DebtPaymentRule
- Bucket
- BucketRule
- AllocationRun
- AllocationEntry

### Phase 3 future engine
- Scenario
- ScenarioAssumption
- ScenarioRun
- ScenarioSnapshot
- Goal
- ReserveTarget
- ProjectionInsight

### Phase 4 guidance
- Ritual
- NotificationRule
- Opportunity
- WorthSnapshot
- DailyFocus

## Suggested information architecture

### Main navigation
- **Past**
  - Imports
  - Transactions
  - Clarify
  - History
  - Recurring
- **Present**
  - Dashboard
  - This Month
  - Obligations
  - Budgets
  - Debts
- **Future**
  - Buckets
  - Projections
  - Goals
  - Scenarios
- **Review**
  - Opportunities
  - Cost Cutting
  - Weekly Review
- **Settings**
  - Accounts
  - Spaces
  - Rules
  - Notifications
  - Tax / Defaults

## The first truly useful version
The first version should not try to do everything.

It only needs to do five things well:
1. import statements,
2. normalize and categorize transactions,
3. surface a clarification queue,
4. show a truthful month view,
5. give a basic present-day dashboard.

That gives Raven a real spine.
Buckets and projections become much stronger once truth exists.

## Recommended MVP sequence

### MVP 1 — Financial Truth Engine
Goal: know where the money went.

Ship:
- spaces
- accounts
- statement import batches
- row parsing
- normalized transactions
- categories
- merchant memory
- clarification queue
- monthly spend views
- recurring/subscription detection

### MVP 2 — Present Dashboard
Goal: know where I stand right now.

Ship:
- current cash position
- obligations due this month
- monthly burn rate
- runway
- debt minimums
- daily target / hourly target
- net position card
- grounding notifications

### MVP 3 — Buckets & Rules
Goal: decide where money must go.

Ship:
- bucket tree
- bucket types
- target amounts
- priority
- overflow behavior
- simple gate rules
- manual allocation preview

### MVP 4 — Projections
Goal: see the future before it happens.

Ship:
- scenarios
- monthly simulation
- debt clearance ETA
- reserve fill ETA
- one-off inflows/outflows
- compare scenarios

### MVP 5 — Assistant Layer
Goal: make Raven feel accountant-like.

Ship:
- AI import assistant
- category suggestions
- clarification suggestions
- savings opportunities
- monthly review summary
- rule recommendations

## AI / MCP command surface
Do not let AI mutate your world through vague free-form access.
Create a small, explicit command surface.

Recommended verbs:
- `createStatementImport`
- `appendStatementRows`
- `normalizeImportBatch`
- `suggestTransactionMatches`
- `applyTransactionClassification`
- `queueClarification`
- `resolveClarification`
- `linkTransferCandidates`
- `rebuildMonthlySnapshot`
- `simulateScenario`
- `explainAllocation`
- `suggestSavingsActions`

Each command should be:
- auditable,
- idempotent where possible,
- confidence-aware,
- explainable.

## Notifications and rituals
Raven’s notifications should be grounding, not noisy.

Recommended rituals:
- **Morning**: where do I stand, what matters today, what’s one move?
- **Weekly**: reconcile, trim one cost, push one opportunity
- **Month-end**: review, sweep, project, reset play budget

## The “days until 80” idea
Keep it, but use it carefully.
It should inspire intention, not pressure.

A good implementation is a compact card:
- days lived
- days to 80
- today’s financial focus
- what a small action today becomes over time

## Success criteria
Raven is working when:
- 95%+ of recent transactions are classified,
- unclear items steadily trend down,
- you can explain any recent month simply,
- surprises reduce,
- debts become schedulable,
- bucket targets feel real and reachable,
- the app makes you calmer and more decisive.

## The north-star statement
**Raven turns money from a source of fog into a system of signals, decisions, and steady compounding progress.**
