# Bucket System - Detailed Specification

## Overview
The Bucket System is the core innovation of Money Mastery, transforming traditional budgeting into a dynamic flow-based money management system. Each bucket represents a virtual allocation of funds with specific rules, priorities, and behaviors.

## Core Concepts

### What is a Bucket?
A bucket is a virtual container that represents an allocation of money for a specific purpose. Unlike traditional budget categories, buckets are active participants in money flow, with rules and behaviors that automate financial decisions.

### Bucket Hierarchy
Buckets form a tree structure where:
- **Root Level**: Primary allocation categories (Savings, Expenses, Goals)
- **Parent Buckets**: Container buckets that distribute to children
- **Child Buckets**: Specific allocations within a parent category
- **Leaf Buckets**: Final destinations with no children

## Bucket Properties

### Essential Properties
```typescript
interface Bucket {
  id: string
  name: string
  type: BucketType
  parentId: string | null
  order: number // Position among siblings
  icon: string // Visual identifier
  color: string // For charts and visualizations
}
```

### Financial Properties
```typescript
interface BucketFinancials {
  currentBalance: number
  targetAmount?: number // For goal-based buckets
  monthlyTarget?: number // For recurring buckets
  lastUpdated: Date
  currency: 'ZAR' // South African Rand
}
```

### Behavioral Properties
```typescript
interface BucketBehavior {
  distributionMethod: 'equal' | 'weighted' | 'priority' | 'rule-based'
  distributionWeight?: number // For weighted distribution
  fillPriority: number // Order for priority filling
  withdrawalProtection: ProtectionLevel
  resetPeriod?: 'monthly' | 'yearly' | 'never'
  isActive: boolean
}
```

## Bucket Types

### 1. Expense Fixed
- **Purpose**: Regular fixed expenses
- **Behavior**: Resets monthly, expects exact amount
- **Examples**: Rent, insurance, loan payments
- **Special Features**: Due date tracking, autopay indicators
- **Default Priority**: 10

### 2. Expense Variable
- **Purpose**: Flexible spending categories
- **Behavior**: Resets monthly, tracks against guideline
- **Examples**: Groceries, fuel, dining
- **Special Features**: Average tracking, overspend warnings
- **Default Priority**: 20

### 3. Reserve
- **Purpose**: Emergency and buffer funds
- **Behavior**: Maintains minimum level, restricted withdrawal
- **Examples**: Emergency fund, medical reserve, maintenance buffer
- **Special Features**: Minimum level alerts, protection rules
- **Default Priority**: 30

### 4. Savings Goal
- **Purpose**: Save for specific targets
- **Behavior**: Fills until target reached, then deactivates
- **Examples**: Vacation, new laptop, home deposit
- **Special Features**: Progress visualization, completion estimates
- **Default Priority**: 60

### 5. Debt
- **Purpose**: Track and pay off debts
- **Behavior**: Tracks principal, calculates interest
- **Examples**: Credit cards, loans, mortgages
- **Special Features**: Snowball/avalanche strategies, payoff projections
- **Default Priority**: 15

### 6. Tax
- **Purpose**: Set aside tax obligations
- **Behavior**: Pre-cut percentage, restricted access
- **Examples**: Income tax, VAT provisions
- **Special Features**: Quarterly reminders, rate calculations
- **Default Priority**: 5

### 7. Long Term Freedom (LTF)
- **Purpose**: Pay-yourself-first wealth building
- **Behavior**: Pre-cut percentage, locked withdrawal
- **Examples**: Retirement, financial independence
- **Special Features**: Compound interest projections
- **Default Priority**: 0-2

### 8. Play
- **Purpose**: Guilt-free spending money
- **Behavior**: Must be spent monthly (T. Harv Eker principle)
- **Examples**: Entertainment, hobbies, treats
- **Special Features**: Spending reminders, use-it-or-lose-it alerts
- **Default Priority**: 70

### 9. Investment
- **Purpose**: Active investment allocation
- **Behavior**: Tracks contributions, monitors performance
- **Examples**: Stock portfolio, business ventures
- **Special Features**: ROI tracking, rebalancing alerts
- **Default Priority**: 50

### 10. Buffer
- **Purpose**: Temporary holding for distribution
- **Behavior**: Holds funds pending allocation decisions
- **Examples**: Bonus income, windfalls, uncertain income
- **Special Features**: Smart distribution suggestions
- **Default Priority**: 90

### 11. Envelope (Variable Expense)
- **Purpose**: Budget for variable monthly expenses
- **Behavior**: Tracks planned vs actual spending
- **Examples**: Food, entertainment, clothing
- **Special Features**: Variance tracking, overspend handling
- **Default Priority**: Varies by necessity

## Distribution Methods

### 1. Equal Distribution
- Default method for new parent buckets
- Divides incoming funds equally among active children
- Remainder goes to first child in order

### 2. Weighted Distribution
- Each child has a weight value
- Funds distributed proportionally to weights
- Example: Child A (weight: 3), Child B (weight: 2), Child C (weight: 1)
  - From R600: A gets R300, B gets R200, C gets R100

### 3. Percentage Distribution
- Each child receives a fixed percentage
- Ensures predictable allocation ratios
- Example: Emergency 30%, Savings 20%, Goals 50%

### 4. Fixed Amount Distribution
- Specific amounts to each child first
- Remainder distributed by secondary method
- Example: Rent R8000, Insurance R1200, then distribute rest

### 5. Priority Fill Distribution
- Children filled in order until targets met
- Each bucket filled completely before next
- Useful for essential expenses and emergency funds

### 6. Rule-Based Distribution
- Complex conditions determine distribution
- Dynamic allocation based on bucket states
- Examples:
  - "If Emergency Fund < R50,000, allocate 50% here"
  - "If Debt > 0, minimum 30% to debt payment"
  - "If month = December, double entertainment budget"

## Envelope Budget System

### Overview
The Envelope Budget System handles variable expenses that need budgets but can fluctuate month-to-month. Unlike fixed expenses, envelopes track both planned and actual spending, providing real-time variance feedback.

### Envelope Properties
```typescript
interface EnvelopeBucket extends Bucket {
  type: 'envelope'
  
  envelope: {
    // Planning
    plannedMonthly: number      // Budget allocation
    rolloverAllowed: boolean    // Can unused funds carry over?
    
    // Tracking
    spent: number              // Actually spent this period
    committed: number          // Pending/authorized
    available: number          // Can still spend
    
    // History
    averageSpend: number       // Last 3 months average
    lastMonthSpend: number     // Previous month actual
  }
  
  variance: {
    amount: number            // Over/under budget
    percentage: number        // Variance as %
    trend: 'improving' | 'stable' | 'worsening'
    severity: 'ok' | 'warning' | 'critical'
  }
  
  overdraftRules: {
    mode: 'strict' | 'flexible' | 'elastic'
    source: 'emergency' | 'play' | 'buffer' | 'proportional'
    warningThreshold: number   // Default 0.8 (80%)
    lockThreshold: number      // Default 1.0 (100%)
    maxOverdraft: number       // Maximum allowed over
  }
}
```

### Envelope Modes

#### 1. **Strict Mode**
- Cannot exceed budget
- Transactions blocked at 100%
- No overdraft allowed
- Example: Fixed entertainment budget

#### 2. **Flexible Mode**
- Can exceed with warnings
- Draws from specified source
- Tracks overspend for adjustment
- Example: Groceries (essential but variable)

#### 3. **Elastic Mode**
- Expands based on need
- Proportionally reduces other envelopes
- Self-adjusts next month
- Example: Medical expenses

### Variance Handling

#### When Under Budget
```typescript
if (envelope.spent < envelope.plannedMonthly) {
  const surplus = envelope.plannedMonthly - envelope.spent
  
  if (envelope.rolloverAllowed) {
    // Carry forward to next month
    nextMonth.plannedMonthly += surplus
  } else {
    // Sweep to savings or specified bucket
    sweepToBucket(envelope.sweepTarget, surplus)
  }
}
```

#### When Over Budget
```typescript
if (envelope.spent > envelope.plannedMonthly) {
  const deficit = envelope.spent - envelope.plannedMonthly
  
  switch (envelope.overdraftRules.mode) {
    case 'strict':
      // Block transaction
      throw new Error('Budget exceeded')
      
    case 'flexible':
      // Draw from source
      transferFrom(envelope.overdraftRules.source, deficit)
      
    case 'elastic':
      // Reduce other envelopes proportionally
      distributeDeficit(deficit, otherEnvelopes)
  }
}
```

### Visual Indicators

#### Envelope States
1. **Healthy** (Green): 0-60% spent
2. **Normal** (Blue): 60-80% spent  
3. **Warning** (Yellow): 80-95% spent
4. **Critical** (Orange): 95-100% spent
5. **Overspent** (Red): >100% spent
6. **Locked** (Gray): Spending blocked

#### Real-time Feedback
```
Food Budget
│ Planned: R10,000
│ Spent:   R 8,432 (84.3%)
│ ████████████████░░░░
│ 
│ Available: R1,568
│ Daily avg: R281 (5 days left)
│ 
│ ⚠️ Spending faster than usual
│ Last month: R9,200
```

### Smart Features

#### 1. **Predictive Warnings**
- "At current rate, you'll exceed budget in 3 days"
- "Consider reducing daily spend to R200"
- "You typically overspend in month-end"

#### 2. **Auto-Adjustments**
- Learn from patterns
- Suggest budget changes
- Seasonal adjustments
- Event-based modifications

#### 3. **Envelope Groups**
Group related envelopes for better control:
```
Lifestyle Group (R15,000 total)
├── Food (R10,000)
├── Entertainment (R3,000)
└── Personal (R2,000)

If one overspends, others compensate
```

### Common Envelope Examples

#### Essential Envelopes
- **Groceries**: Flexible mode, emergency source
- **Fuel/Transport**: Flexible mode, proportional source
- **Utilities**: Strict mode (usually fixed)

#### Lifestyle Envelopes  
- **Dining Out**: Strict mode, no overdraft
- **Entertainment**: Strict mode, play source
- **Clothing**: Flexible mode, buffer source

#### Variable Envelopes
- **Home Maintenance**: Elastic mode
- **Medical**: Elastic mode, emergency source
- **Gifts**: Flexible mode, specific occasions

### Month-End Processing

```typescript
function processEnvelopeMonthEnd(envelope: EnvelopeBucket) {
  // Calculate variance
  const variance = envelope.spent - envelope.plannedMonthly
  
  // Update history
  envelope.history.push({
    month: currentMonth,
    planned: envelope.plannedMonthly,
    spent: envelope.spent,
    variance
  })
  
  // Adjust next month
  if (envelope.autoAdjust) {
    const avgSpend = calculateAverage(envelope.history, 3)
    envelope.plannedMonthly = Math.round(avgSpend * 1.1) // 10% buffer
  }
  
  // Handle surplus/deficit
  if (variance < 0 && !envelope.rolloverAllowed) {
    sweepSurplus(Math.abs(variance))
  } else if (variance > 0) {
    recordDeficit(variance)
  }
  
  // Reset for new month
  envelope.spent = 0
  envelope.committed = 0
  envelope.available = envelope.plannedMonthly
}
```

## Withdrawal Protection Levels

### Level 1: Locked 🔒
- **Cannot be withdrawn under any circumstances**
- Examples: Retirement, children's education
- UI: Red lock icon, requires multiple confirmations to modify

### Level 2: Protected 🛡️
- **Only for designated purpose**
- Examples: Medical emergency fund
- UI: Yellow shield, requires reason for withdrawal

### Level 3: Restricted ⚠️
- **24-hour cooling period before withdrawal**
- Examples: Long-term savings goals
- UI: Orange warning, shows countdown timer

### Level 4: Monitored 👁️
- **Alerts and tracks withdrawals**
- Examples: Investment funds
- UI: Blue eye icon, logs all transactions

### Level 5: Free ✅
- **Available for immediate use**
- Examples: Daily expenses, play money
- UI: Green checkmark, no restrictions

## Rules Engine

### Rule Structure
```typescript
interface BucketRule {
  id: string
  bucketId: string
  type: 'distribution' | 'withdrawal' | 'alert'
  condition: RuleCondition
  action: RuleAction
  priority: number // For conflicting rules
  isActive: boolean
}
```

### Overflow Behavior
When a bucket reaches its target, excess funds flow according to:
1. **Return to Parent**: Default - sends back up the tree
2. **Send to Sibling by Order**: Next sibling in priority order
3. **Send to Named Bucket**: Specific bucket destination
4. **Cascade to Children**: Distribute among child buckets

### Condition Types
1. **Balance Conditions**: Based on bucket balances
2. **Date Conditions**: Time-based rules
3. **Income Conditions**: Based on income levels
4. **Goal Conditions**: Based on goal progress
5. **External Conditions**: Based on other factors

### Action Types
1. **Redirect Funds**: Change distribution flow
2. **Lock/Unlock**: Modify protection levels
3. **Alert User**: Send notifications
4. **Auto-Transfer**: Move funds between buckets
5. **Adjust Targets**: Modify bucket targets

### Example Rules

#### Emergency Fund Priority
```
IF emergency_fund.balance < emergency_fund.target
THEN redirect 50% of entertainment bucket income to emergency_fund
```

#### Debt Avalanche
```
IF high_interest_debt.balance > 0
THEN allocate minimum_payment + all_surplus to high_interest_debt
```

#### Seasonal Adjustment
```
IF current_month IN ['December', 'January']
THEN increase gift_bucket.monthly_allocation by 100%
```

#### Windfall Distribution
```
IF income_this_month > average_monthly_income * 1.5
THEN distribute surplus according to windfall_rules
```

## Visual Representation

### Bucket Cards
- Display current balance prominently
- Show fill percentage for goal buckets
- Progress bars for visual feedback
- Sparkline for balance history
- Quick actions (add funds, view details)

### Flow Visualization
- Animated particles showing money flow
- Thicker lines for larger flows
- Color coding for different flow types
- Real-time updates during distribution

### Hierarchy View
- Tree structure with expand/collapse
- Drag-and-drop for reordering
- Visual parent-child relationships
- Aggregate statistics at parent levels

## User Interactions

### Creating Buckets
1. Choose bucket type
2. Set basic properties (name, icon, color)
3. Define financial targets
4. Set distribution method
5. Configure protection level
6. Add rules (optional)

### Managing Buckets
- **Drag & Drop**: Reorder and reorganize
- **Quick Edit**: Inline editing of key properties
- **Bulk Actions**: Apply changes to multiple buckets
- **Templates**: Save and reuse bucket configurations

### Bucket Operations
1. **Fund**: Add money manually
2. **Transfer**: Move between buckets
3. **Adjust**: Modify targets or rules
4. **Analyze**: View detailed statistics
5. **Project**: See future state
6. **Archive**: Deactivate completed buckets

## Analytics & Insights

### Bucket Metrics
- Fill rate (funds per month)
- Utilization (spending vs. allocation)
- Time to target (for goals)
- Historical performance
- Projection accuracy

### System Metrics
- Total allocated vs. unallocated
- Distribution efficiency
- Rule trigger frequency
- Protection effectiveness
- Goal achievement rate

## Implementation Considerations

### Performance
- Lazy load child buckets
- Cache calculated distributions
- Batch rule evaluations
- Optimize recursive calculations

### Data Integrity
- Validate all distributions sum correctly
- Ensure no money is lost in transfers
- Maintain audit trail
- Regular balance reconciliation

### User Experience
- Smooth animations for flow visualization
- Instant feedback on changes
- Clear error messages
- Undo/redo for bucket operations
- Keyboard shortcuts for power users

## Special Features

### Allocation Ledger
- **Purpose**: Build trust through transparency
- **Shows**: Exact calculation path for each allocation
- **Example**: "Why did Emergency Fund receive R742.15?"
  - Income: R10,000
  - After tax (27.5%): R7,250
  - After LTF (5%): R6,887.50
  - Emergency allocation (30% of remainder): R742.15
- **Access**: Click any bucket amount for breakdown

### Windfall Wizard
- **Purpose**: Optimal distribution of unexpected income
- **Process**:
  1. Enter windfall amount
  2. System analyzes current bucket states
  3. Suggests distribution respecting rules and priorities
  4. Preview impact on goal completion dates
  5. One-click apply or customize

### Templates Gallery
- **Starter**: Basic 5-bucket setup for beginners
- **Family**: Includes education and household buckets
- **Freelancer SA**: Tax provisions and variable income handling
- **Business Owner**: Separate business/personal flows
- **Debt Destroyer**: Aggressive debt payoff focus
- **FIRE Seeker**: Maximum savings rate optimization

### Stress Testing
- **Income Drop**: Simulate -20% income for X months
- **Emergency Scenarios**: Medical, job loss, car repair
- **Shows**: Which buckets deplete first, timeline impact
- **Recommendations**: Minimum reserves needed for resilience

## Default Seed Template

### Pre-configured Buckets
1. **Pay-Yourself-First (LTF)** - 5% precut, locked
2. **Tax** - 27.5% precut, restricted
3. **Essentials** (parent)
   - Rent (fixed): R8,000
   - Utilities (fixed): R1,500  
   - Insurance (fixed): R2,000
   - Groceries (variable): R4,000
4. **Reserves** (parent)
   - Emergency: R30,000 target, restricted
   - Medical: R5,000 minimum
   - Maintenance: R3,000 minimum
5. **Debts** (parent)
   - Example slots for cards/loans
6. **Goals** (parent)
   - Vacation: R15,000 target
   - New Laptop: R25,000 target
7. **Play** - 5% allocation, monthly reset

### Default Rules
- Until Emergency ≥ R30,000, redirect 30% of Reserves allocation
- When any Debt paid off, cascade payment to next debt
- Play bucket must be spent monthly (reminder on 25th)

## Future Enhancements

### AI-Powered Features
- Smart bucket suggestions based on spending patterns
- Anomaly detection in allocations
- Optimization recommendations
- Predictive rule creation
- Natural language rule builder

### Integration Options
- Bank account mapping
- Investment platform sync
- Bill pay integration
- Tax optimization
- Receipt scanning

### Advanced Visualizations
- 3D bucket flow
- Sankey diagram overlays
- AR overlay for shopping decisions
- Voice-controlled updates
- Real-time collaboration