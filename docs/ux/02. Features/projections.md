# Projections - Future Financial Modeling

## Overview
The Projections module transforms the static bucket system into a dynamic crystal ball, allowing users to see exactly when goals will be achieved, how changes impact their financial future, and what actions can accelerate their journey to financial freedom.

## Core Purpose
Enable confident financial decision-making by:
- Visualizing future financial states
- Modeling different scenarios
- Understanding impact of changes
- Setting realistic timelines
- Optimizing financial strategies

## Projection Types

### 1. Linear Projections
Simple straight-line projections based on current patterns:
- Constant monthly income
- Fixed expense amounts
- Regular distribution patterns
- No variability consideration

### 2. Historical Projections
Based on past patterns and seasonality:
- Income fluctuations from history
- Seasonal expense variations
- Cyclical patterns recognition
- Weighted recent trends

### 3. Scenario-Based Projections
Multiple parallel projections:
- Best case scenario
- Worst case scenario
- Most likely scenario
- Custom scenarios

### 4. Monte Carlo Simulations
(Advanced feature) Statistical modeling:
- Probability distributions
- Confidence intervals
- Risk assessment
- Outcome likelihood

## Key Components

### 1. Income Projection Engine

```typescript
interface IncomeProjection {
  // Base Inputs
  monthlyBase: number
  growthRate: number // Annual percentage
  volatility: number // Income stability 0-1
  
  // Modifiers
  bonuses: BonusSchedule[]
  raises: RaiseSchedule[]
  additionalStreams: IncomeStream[]
  
  // Outputs
  projectedMonthly: MonthlyProjection[]
  confidenceLevel: number
  assumptions: string[]
}
```

#### Income Modeling Options
- **Fixed Income**: Stable salary
- **Variable Income**: Freelance/commission
- **Stepped Income**: Planned raises
- **Multiple Streams**: Various sources
- **Seasonal Income**: Cyclical patterns

### 2. Expense Projection System

#### Expense Categories
1. **Fixed Expenses**: Rent, insurance, loans
2. **Variable Expenses**: Food, entertainment
3. **Periodic Expenses**: Annual fees, maintenance
4. **Growing Expenses**: Inflation-adjusted
5. **Declining Expenses**: Loans being paid off

#### Inflation Modeling
```typescript
interface InflationModel {
  generalRate: number // Overall inflation
  categoryRates: {
    category: string
    rate: number
  }[]
  compoundMethod: 'simple' | 'compound'
}
```

### 3. Bucket Fill Projections

#### Fill Rate Calculations
```typescript
interface BucketProjection {
  bucket: Bucket
  currentBalance: number
  monthlyInflow: number
  monthlyOutflow: number
  
  // Projections
  fillDate: Date | null // When target reached
  monthsToTarget: number
  fillProbability: number // Based on volatility
  
  // Milestones
  milestones: {
    amount: number
    date: Date
    percentage: number
  }[]
}
```

#### Visual Timeline
- Horizontal timeline showing bucket completion
- Milestone markers (25%, 50%, 75%, 100%)
- Hover for exact dates and amounts
- Drag to adjust targets and see impact

### 4. Goal Achievement Tracking

#### Goal Types
1. **Target Amount**: Save specific sum
2. **Target Date**: Achieve by deadline
3. **Target Rate**: Maintain savings rate
4. **Debt Freedom**: Pay off all debt
5. **Financial Independence**: Passive income > expenses

#### Achievement Probability
- Green: >80% likely to achieve
- Yellow: 50-80% probability
- Red: <50% probability
- Factors: Income stability, expense volatility, track record

## Interactive Projection Tools

### 1. What-If Scenario Builder

#### Adjustment Sliders
```
Monthly Income:    [--------|----] R50,000
Expense Reduction: [---|----------] -10%
Savings Rate:      [---------|----] 30%
Time Horizon:      [--------|-----] 24 months
```

#### Real-time Updates
- Instant recalculation
- Visual feedback on changes
- Compare before/after
- Save scenarios

### 2. Life Event Modeler

#### Major Life Events
- **Job Change**: New income level
- **Major Purchase**: Large expense
- **Debt**: New loan or payoff
- **Investment**: Expected returns
- **Family**: New dependents

#### Event Timeline
```
2025 Jan: Salary increase +15%
2025 Jun: Car purchase -R150,000
2025 Dec: Bonus income +R50,000
2026 Mar: Investment maturity +R100,000
```

### 3. Optimization Suggester

#### AI-Powered Recommendations
- "Delay car purchase 6 months to maintain emergency fund"
- "Increase savings rate 5% to retire 2 years earlier"
- "Pay extra R500/month on loan to save R45,000 interest"
- "Redirect entertainment budget for 3 months to hit goal"

#### Trade-off Visualizer
Show impact of choices:
- Time vs. Money
- Security vs. Growth
- Present vs. Future
- Needs vs. Wants

## Visualization Methods

### 1. Projection Charts

#### Line Charts
- Multiple buckets over time
- Income/expense trends
- Net worth growth
- Savings rate evolution

#### Area Charts
- Stacked bucket balances
- Income distribution
- Expense categories
- Cash flow visualization

#### Gantt Charts
- Goal timelines
- Bucket fill schedules
- Debt payoff timeline
- Milestone tracking

### 2. Interactive Dashboards

#### Bucket Flow Animation
- Animated money flow
- Speed represents rate
- Size represents amount
- Color represents priority

#### Progress Meters
- Circular progress rings
- Linear progress bars
- Milestone markers
- Completion celebrations

### 3. Comparison Views

#### Side-by-Side Scenarios
```
Current Path          Optimized Path
--------------       ---------------
Emergency Fund:      Emergency Fund:
Full in 18 months    Full in 12 months

Debt Freedom:        Debt Freedom:
36 months           24 months

Vacation Fund:       Vacation Fund:
24 months           18 months
```

## Advanced Features

### 1. Sensitivity Analysis

#### Key Variables
- Income volatility impact
- Expense variance effect
- Interest rate changes
- Inflation scenarios

#### Tornado Diagrams
Show which variables have biggest impact on outcomes

### 2. Milestone Planning

#### Automatic Milestone Detection
- First R10,000 saved
- One month expenses covered
- Debt below 50%
- First goal achieved

#### Custom Milestones
- Set personal targets
- Track progress
- Celebrate achievements
- Share success

### 3. Stress Testing

#### Scenario Stress Tests
- Job loss simulation
- Medical emergency
- Market crash
- High inflation

#### Resilience Scoring
- How long can you survive?
- Which buckets are vulnerable?
- What's your safety margin?
- Recovery time estimates

## Reporting & Export

### 1. Projection Reports

#### Standard Reports
- **5-Year Financial Plan**: Comprehensive outlook
- **Goal Achievement Timeline**: All goals mapped
- **Cash Flow Forecast**: Monthly projections
- **Scenario Comparison**: Multiple paths analyzed

#### Custom Reports
- Select time range
- Choose specific buckets
- Include/exclude scenarios
- Add personal notes

### 2. Visual Exports

#### Image Formats
- PNG charts for presentations
- PDF reports for printing
- SVG for high quality
- GIF for animations

#### Data Exports
- Excel with formulas
- CSV for analysis
- JSON for backup
- API for integration

## Behavioral Nudges

### 1. Goal Proximity Alerts
"You're 3 months away from emergency fund goal!"
"Extra R1,000 this month cuts 2 months off debt"

### 2. Momentum Indicators
"You're ahead of schedule by 2 weeks"
"Current pace achieves goal 1 month early"

### 3. Course Corrections
"Spending trending 10% over budget"
"Need extra R500 this month to stay on track"

## Machine Learning Enhancements

### 1. Pattern Learning
- Improve projections based on actual vs. predicted
- Identify user-specific patterns
- Adjust for behavioral biases
- Personalized accuracy

### 2. Predictive Alerts
- "Based on patterns, expect high expenses next month"
- "Income typically drops in February - plan ahead"
- "You usually overspend after payday - be careful"

## Success Metrics

### Accuracy Metrics
- Projection accuracy: ±10% over 3 months
- Goal date accuracy: ±2 weeks
- User trust score: >8/10
- Adjustment frequency: <2 per month

### Usage Metrics
- Weekly projection views
- Scenario creation rate
- What-if usage
- Report generation

## Future Enhancements

### Advanced Modeling
- Tax optimization projections
- Investment return modeling
- Real estate calculations
- Business cash flow integration

### External Integration
- Market data feeds
- Economic indicators
- Bank rate updates
- Inflation data

### Collaboration Features
- Family projections
- Advisor sharing
- Goal accountability
- Community benchmarks