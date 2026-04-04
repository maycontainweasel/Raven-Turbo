# Data Models - Technical Specification

## Overview
Complete data model definitions for Money Mastery using TypeScript/Zod for type safety and Prisma for database schema.

## Core Domain Models

### User
```typescript
// Zod Schema
const UserSchema = z.object({
  id: z.string().cuid(),
  email: z.string().email(),
  name: z.string(),
  currency: z.literal('ZAR'), // South African Rand only for MVP
  timezone: z.string().default('Africa/Johannesburg'),
  settings: SettingsSchema,
  createdAt: z.date(),
  updatedAt: z.date()
})

// Prisma Model
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String
  currency  String   @default("ZAR")
  timezone  String   @default("Africa/Johannesburg")
  settings  Json
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  accounts     Account[]
  buckets      Bucket[]
  transactions Transaction[]
  scenarios    Scenario[]
}
```

### Bucket
```typescript
// Zod Schema
const BucketTypeSchema = z.enum([
  'expense_fixed',
  'expense_variable', 
  'reserve',
  'savings_goal',
  'debt',
  'tax',
  'long_term_freedom',
  'play',
  'investment',
  'buffer'
])

const DistributionModeSchema = z.enum([
  'equal',
  'weighted',
  'percentage',
  'fixed_amount',
  'priority_fill',
  'rule_based'
])

const WithdrawalPolicySchema = z.enum([
  'open',
  'restricted',
  'last_resort',
  'locked'
])

const BucketSchema = z.object({
  id: z.string().cuid(),
  userId: z.string(),
  parentId: z.string().nullable(),
  name: z.string().min(1).max(100),
  description: z.string().optional(),
  type: BucketTypeSchema,
  priority: z.number().int().min(0).max(999),
  order: z.number().int(), // Position among siblings
  
  // Visual
  icon: z.string().default('folder'),
  color: z.string().regex(/^#[0-9A-F]{6}$/i),
  
  // Financial
  currentBalance: z.number().min(0),
  target: z.number().min(0).nullable(),
  minimumLevel: z.number().min(0).nullable(),
  
  // Behavior
  distributionMode: DistributionModeSchema,
  distributionConfig: z.record(z.number()).optional(), // child weights/amounts
  withdrawalPolicy: WithdrawalPolicySchema,
  overflowBehavior: z.enum(['to_parent', 'to_sibling', 'to_named', 'cascade']),
  overflowTarget: z.string().nullable(),
  
  // Rules & Interest
  rules: z.array(RuleSchema),
  interestRate: z.number().nullable(),
  interestType: z.enum(['none', 'simple', 'compound']).default('none'),
  
  // State
  isActive: z.boolean().default(true),
  resetPeriod: z.enum(['never', 'monthly', 'yearly']).default('never'),
  lastReset: z.date().nullable(),
  
  // Metadata
  createdAt: z.date(),
  updatedAt: z.date()
})

// Prisma Model
model Bucket {
  id               String   @id @default(cuid())
  userId           String
  parentId         String?
  name             String
  description      String?
  type             String
  priority         Int      @default(100)
  order            Int      @default(0)
  icon             String   @default("folder")
  color            String   @default("#6B7280")
  
  currentBalance   Decimal  @precision(18, 2) @default(0)
  target           Decimal? @precision(18, 2)
  minimumLevel     Decimal? @precision(18, 2)
  
  distributionMode String   @default("equal")
  distributionConfig Json?
  withdrawalPolicy String   @default("open")
  overflowBehavior String   @default("to_parent")
  overflowTarget   String?
  
  rules            Json     @default("[]")
  interestRate     Decimal? @precision(5, 2)
  interestType     String   @default("none")
  
  isActive         Boolean  @default(true)
  resetPeriod      String   @default("never")
  lastReset        DateTime?
  
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
  
  user             User     @relation(fields: [userId], references: [id])
  parent           Bucket?  @relation("BucketHierarchy", fields: [parentId], references: [id])
  children         Bucket[] @relation("BucketHierarchy")
  allocations      Allocation[]
  
  @@index([userId, priority])
  @@index([parentId])
}
```

### Transaction
```typescript
// Zod Schema
const TransactionSchema = z.object({
  id: z.string().cuid(),
  userId: z.string(),
  accountId: z.string(),
  bucketId: z.string().nullable(),
  
  date: z.date(),
  amount: z.number(), // Negative for expenses
  description: z.string(),
  merchant: z.string().nullable(),
  
  category: z.string(),
  subcategory: z.string().nullable(),
  
  isRecurring: z.boolean().default(false),
  recurringGroupId: z.string().nullable(),
  
  metadata: z.record(z.any()).optional(),
  importId: z.string().nullable(), // For deduplication
  
  createdAt: z.date(),
  updatedAt: z.date()
})

// Prisma Model  
model Transaction {
  id               String   @id @default(cuid())
  userId           String
  accountId        String
  bucketId         String?
  
  date             DateTime
  amount           Decimal  @precision(18, 2)
  description      String
  merchant         String?
  
  category         String
  subcategory      String?
  
  isRecurring      Boolean  @default(false)
  recurringGroupId String?
  
  metadata         Json?
  importId         String?  @unique
  
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
  
  user             User     @relation(fields: [userId], references: [id])
  account          Account  @relation(fields: [accountId], references: [id])
  bucket           Bucket?  @relation(fields: [bucketId], references: [id])
  
  @@index([userId, date])
  @@index([accountId])
  @@index([category])
}
```

### Allocation
```typescript
// Zod Schema
const AllocationSchema = z.object({
  id: z.string().cuid(),
  userId: z.string(),
  scenarioId: z.string().nullable(),
  
  period: z.date(), // Month start date
  source: z.enum(['income', 'rule', 'overflow', 'manual', 'rebalance']),
  
  fromBucketId: z.string().nullable(),
  toBucketId: z.string(),
  amount: z.number().positive(),
  
  ruleId: z.string().nullable(),
  ruleName: z.string().nullable(),
  
  calculation: z.object({
    steps: z.array(z.string()),
    formula: z.string().optional(),
    variables: z.record(z.number()).optional()
  }),
  
  createdAt: z.date()
})

// Prisma Model
model Allocation {
  id           String   @id @default(cuid())
  userId       String
  scenarioId   String?
  
  period       DateTime
  source       String
  
  fromBucketId String?
  toBucketId   String
  amount       Decimal  @precision(18, 2)
  
  ruleId       String?
  ruleName     String?
  
  calculation  Json
  
  createdAt    DateTime @default(now())
  
  user         User     @relation(fields: [userId], references: [id])
  toBucket     Bucket   @relation(fields: [toBucketId], references: [id])
  scenario     Scenario? @relation(fields: [scenarioId], references: [id])
  
  @@index([userId, period])
  @@index([toBucketId])
}
```

### Scenario
```typescript
// Zod Schema
const ScenarioSchema = z.object({
  id: z.string().cuid(),
  userId: z.string(),
  name: z.string(),
  description: z.string().optional(),
  
  type: z.enum(['projection', 'stress_test', 'goal_planning']),
  
  parameters: z.object({
    monthlyIncome: z.number(),
    incomeGrowthRate: z.number().default(0),
    inflationRate: z.number().default(6),
    projectionMonths: z.number().min(1).max(360),
    
    oneTimeEvents: z.array(z.object({
      date: z.date(),
      amount: z.number(),
      description: z.string(),
      bucketId: z.string().optional()
    })).optional(),
    
    assumptions: z.record(z.any()).optional()
  }),
  
  results: z.object({
    bucketProjections: z.record(z.array(z.number())),
    completionDates: z.record(z.date().nullable()),
    warnings: z.array(z.string()).optional()
  }).optional(),
  
  isActive: z.boolean().default(true),
  createdAt: z.date(),
  updatedAt: z.date()
})

// Prisma Model
model Scenario {
  id          String   @id @default(cuid())
  userId      String
  name        String
  description String?
  
  type        String
  parameters  Json
  results     Json?
  
  isActive    Boolean  @default(true)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  
  user        User     @relation(fields: [userId], references: [id])
  allocations Allocation[]
  
  @@index([userId])
}
```

### Account
```typescript
// Zod Schema
const AccountSchema = z.object({
  id: z.string().cuid(),
  userId: z.string(),
  name: z.string(),
  type: z.enum(['checking', 'savings', 'credit', 'investment', 'cash']),
  institution: z.string().optional(),
  
  currentBalance: z.number(),
  currency: z.string().default('ZAR'),
  
  isActive: z.boolean().default(true),
  isPrimary: z.boolean().default(false),
  
  metadata: z.record(z.any()).optional(),
  
  createdAt: z.date(),
  updatedAt: z.date()
})

// Prisma Model
model Account {
  id             String   @id @default(cuid())
  userId         String
  name           String
  type           String
  institution    String?
  
  currentBalance Decimal  @precision(18, 2) @default(0)
  currency       String   @default("ZAR")
  
  isActive       Boolean  @default(true)
  isPrimary      Boolean  @default(false)
  
  metadata       Json?
  
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  user           User     @relation(fields: [userId], references: [id])
  transactions   Transaction[]
  
  @@index([userId])
}
```

## Supporting Types

### Rule Schema
```typescript
const RuleConditionSchema = z.object({
  bucket: z.string(),
  metric: z.enum(['balance', 'progress', 'full']),
  operator: z.enum(['<', '>', '=', '<=', '>=']),
  value: z.number()
})

const RuleActionSchema = z.object({
  type: z.enum(['redirect_percent', 'redirect_amount', 'alert', 'lock']),
  value: z.number().optional(),
  target: z.string().optional(),
  message: z.string().optional()
})

const RuleSchema = z.object({
  id: z.string().cuid(),
  name: z.string(),
  priority: z.number().int().min(1).max(100),
  condition: RuleConditionSchema,
  action: RuleActionSchema,
  isActive: z.boolean().default(true)
})
```

### Settings Schema
```typescript
const SettingsSchema = z.object({
  theme: z.enum(['light', 'dark', 'system']).default('system'),
  
  notifications: z.object({
    dailyCheckIn: z.boolean().default(true),
    dailyCheckInTime: z.string().default('08:00'),
    goalAchieved: z.boolean().default(true),
    overspendWarning: z.boolean().default(true),
    monthEndReview: z.boolean().default(true)
  }),
  
  display: z.object({
    compactMode: z.boolean().default(false),
    showCents: z.boolean().default(true),
    dateFormat: z.string().default('DD/MM/YYYY'),
    firstDayOfWeek: z.enum(['sunday', 'monday']).default('monday')
  }),
  
  privacy: z.object({
    blurAmounts: z.boolean().default(false),
    requirePinForSensitive: z.boolean().default(false)
  }),
  
  automation: z.object({
    autoStartWithSystem: z.boolean().default(true),
    backupFrequency: z.enum(['daily', 'weekly', 'monthly']).default('weekly'),
    exportFormat: z.enum(['json', 'csv', 'excel']).default('json')
  })
})
```

## Database Indexes

```sql
-- Performance indexes
CREATE INDEX idx_bucket_user_priority ON Bucket(userId, priority);
CREATE INDEX idx_transaction_user_date ON Transaction(userId, date);
CREATE INDEX idx_allocation_period ON Allocation(userId, period);

-- Unique constraints
CREATE UNIQUE INDEX idx_transaction_import ON Transaction(importId) WHERE importId IS NOT NULL;
CREATE UNIQUE INDEX idx_user_email ON User(email);

-- Full-text search (future)
CREATE INDEX idx_transaction_search ON Transaction USING gin(to_tsvector('english', description || ' ' || COALESCE(merchant, '')));
```

## Migration Strategy

### Initial Schema (MVP)
1. User table with basic settings
2. Bucket table with core fields
3. Allocation table for tracking
4. Scenario table for projections

### Phase 2 Additions
1. Transaction table for historical data
2. Account table for multi-account support
3. RecurringTransaction table
4. Category management tables

### Phase 3 Enhancements
1. BucketSnapshot for historical tracking
2. Notification queue table
3. AuditLog for compliance
4. UserPreferences expansion