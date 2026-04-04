# Past Analysis - Financial Archaeology

## Overview
The Past Analysis module provides comprehensive historical financial analysis, helping users understand their spending patterns, identify money leaks, and build a foundation for better financial decisions. It's the "archaeology" layer that uncovers the truth about past financial behavior.

## Core Purpose
Transform raw transaction data into actionable insights by:
- Categorizing all historical transactions
- Identifying patterns and trends
- Calculating true costs of decisions
- Building baseline metrics for improvement

## Key Features

### 1. Transaction Import

#### Supported Formats
- **CSV**: Standard bank export format
- **PDF**: Bank statement parsing
- **OFX/QFX**: Financial data formats
- **Manual Entry**: For cash transactions

#### Import Workflow
1. **Upload**: Drag & drop or select files
2. **Preview**: Review detected transactions
3. **Map Fields**: Match bank columns to system fields
4. **Deduplicate**: Identify and merge duplicates
5. **Confirm**: Final review before import

### 2. Intelligent Categorization

#### Auto-Categorization Engine
- **Merchant Matching**: Known vendors to categories
- **Description Parsing**: Keywords and patterns
- **Amount Patterns**: Typical amounts for categories
- **Learning System**: Improves with user corrections

#### Category Hierarchy
```
Living Expenses
├── Housing
│   ├── Rent/Mortgage
│   ├── Utilities
│   └── Maintenance
├── Transportation
│   ├── Fuel
│   ├── Insurance
│   └── Maintenance
├── Food & Dining
│   ├── Groceries
│   ├── Restaurants
│   └── Delivery
└── [Custom Categories]
```

#### Manual Categorization
- **Bulk Actions**: Categorize multiple transactions
- **Rules Creation**: "Always categorize X as Y"
- **Split Transactions**: Divide single transactions
- **Quick Shortcuts**: Keyboard navigation

### 3. Pattern Recognition

#### Spending Patterns
- **Daily Averages**: Typical daily spend
- **Weekly Cycles**: Day-of-week patterns
- **Monthly Trends**: Beginning vs. end of month
- **Seasonal Variations**: Holiday spikes, etc.

#### Recurring Transactions
- **Subscription Detection**: Monthly/annual charges
- **Bill Identification**: Regular payments
- **Income Recognition**: Salary patterns
- **Subscription Audit**: Forgotten services

### 4. Financial Metrics

#### Key Performance Indicators
```typescript
interface FinancialMetrics {
  // Income Metrics
  averageMonthlyIncome: number
  incomeStability: number // 0-100 score
  incomeGrowthRate: number
  
  // Expense Metrics
  averageMonthlyExpenses: number
  fixedVsVariableRatio: number
  expenseGrowthRate: number
  
  // Efficiency Metrics
  savingsRate: number
  burnRate: number // Monthly cash consumption
  runwayMonths: number // Months until zero
  
  // Category Metrics
  categoryBreakdown: CategoryMetric[]
  topExpenseCategories: Category[]
  unusualExpenses: Transaction[]
}
```

#### Trend Analysis
- **Income Trends**: Growth or decline patterns
- **Expense Inflation**: Category-specific increases
- **Savings Trends**: Improvement or deterioration
- **Efficiency Scores**: Money management effectiveness

### 5. Visual Analytics

#### Charts & Graphs
1. **Sankey Diagram**: Money flow visualization
2. **Time Series**: Trends over time
3. **Category Pie Charts**: Spending distribution
4. **Heat Maps**: Daily/monthly spending intensity
5. **Comparison Charts**: Month-over-month, year-over-year

#### Interactive Dashboards
- **Drill-Down**: Click to explore details
- **Time Range Selection**: Focus on specific periods
- **Comparative Views**: Side-by-side periods
- **Export Options**: Charts and data

### 6. Insights Engine

#### Automated Insights
```typescript
interface Insight {
  type: 'warning' | 'opportunity' | 'achievement'
  category: string
  title: string
  description: string
  impact: number // Potential monthly savings
  action: string // Recommended action
  priority: 'high' | 'medium' | 'low'
}
```

#### Example Insights
- **Subscription Creep**: "You have 15 subscriptions totaling R2,400/month"
- **Coffee Habit**: "Daily coffee purchases cost R1,200/month"
- **Late Fees**: "R450 in late fees over last 3 months"
- **Unused Gym**: "Gym membership unused for 2 months"
- **Insurance Review**: "Car insurance 30% above market rate"

### 7. Benchmark Comparisons

#### Personal Benchmarks
- **Best Month**: Lowest expense month
- **Worst Month**: Highest expense month
- **Average Baseline**: Typical monthly pattern
- **Goal Tracking**: Progress vs. targets

#### Category Benchmarks
- **Food Budget**: Current vs. recommended
- **Housing Costs**: Percentage of income
- **Savings Rate**: Current vs. target
- **Debt Ratio**: Healthy vs. concerning

## User Interface

### Transaction List View
```
Date       Description          Category        Amount    Actions
--------------------------------------------------------------
2024-12-15 Pick n Pay          Groceries       -R458.32  [Edit]
2024-12-14 Netflix             Entertainment   -R199.00  [Edit]
2024-12-13 Salary Deposit      Income          R45,000   [Edit]
```

### Category Management
- **Drag & Drop**: Reorganize hierarchy
- **Color Coding**: Visual distinction
- **Icon Selection**: Quick recognition
- **Budget Setting**: Per-category limits

### Time Navigation
- **Month View**: Calendar with daily totals
- **Year View**: Monthly comparison grid
- **Custom Range**: Select specific dates
- **Quick Periods**: Last 30/60/90 days

## Data Processing

### Import Pipeline
1. **Parse**: Extract transaction data
2. **Clean**: Standardize formats
3. **Enrich**: Add categories, tags
4. **Validate**: Check for errors
5. **Store**: Save to database

### Privacy & Security
- **Local Processing**: No cloud requirements
- **Encryption**: Sensitive data protected
- **Anonymization**: Remove personal details
- **Audit Trail**: Track all changes

## Integration with Buckets

### Historical Mapping
- **Retroactive Allocation**: Map past spending to bucket structure
- **What-If Analysis**: "If I had used buckets..."
- **Learning Mode**: Use history to set bucket targets
- **Validation**: Compare actual vs. ideal allocation

### Baseline Creation
- **Average Calculation**: Typical bucket requirements
- **Variance Analysis**: Identify volatile categories
- **Recommendation Engine**: Suggest bucket amounts
- **Stress Testing**: Ensure buckets cover variations

## Reports & Exports

### Standard Reports
1. **Monthly Summary**: Income, expenses, savings
2. **Category Report**: Detailed breakdown
3. **Trend Report**: Changes over time
4. **Subscription Audit**: All recurring charges
5. **Tax Report**: Deductible expenses

### Export Formats
- **PDF**: Formatted reports
- **Excel**: Raw data with formulas
- **CSV**: Simple data export
- **JSON**: For backup/restore

## Machine Learning Features

### Pattern Detection
- **Anomaly Detection**: Unusual transactions
- **Prediction**: Future expense estimates
- **Categorization**: Improve accuracy over time
- **Personalization**: Learn user preferences

### Recommendations
- **Cost Savings**: Identify reduction opportunities
- **Optimization**: Suggest better providers
- **Timing**: Optimal purchase timing
- **Bundling**: Combine services for savings

## Success Metrics

### Analysis Quality
- **Categorization Accuracy**: >95% auto-categorized
- **Pattern Recognition**: Identify all subscriptions
- **Insight Relevance**: User acts on >50% of insights
- **Time to Insight**: <5 minutes for monthly analysis

### User Engagement
- **Regular Reviews**: Monthly analysis sessions
- **Action Taking**: Implement recommendations
- **Data Completeness**: All accounts imported
- **Historical Depth**: 12+ months analyzed

## Future Enhancements

### Advanced Analytics
- **Predictive Modeling**: Future state projections
- **Scenario Planning**: What-if simulations
- **Peer Comparison**: Anonymous benchmarks
- **AI Coach**: Personalized advice

### Automation
- **Bank Connections**: Direct import
- **Receipt Scanning**: OCR for cash
- **Email Parsing**: Extract e-receipts
- **Voice Entry**: Speak transactions