export type BucketPrototypeTone = 'accent' | 'warning' | 'muted' | 'default'
export type BucketPrototypeConnectionMode = 'branch' | 'series'
export type BucketPrototypeDisplayMode = 'compact' | 'inline'
export type BucketPrototypePresentation = 'node' | 'group'
export type BucketPrototypeExpenseMode = 'fixed' | 'budget'
export type BucketPrototypeExpenseLifecycle = 'one-off' | 'recurring' | 'payoff'
export type BucketPrototypeCreateKind = 'expense' | 'budget' | 'bucket'
export type BucketPrototypeCreateDirection = 'top' | 'right' | 'bottom' | 'left'

export type BucketPrototypeRule = {
  id: string
  title: string
  detail: string
}

export type BucketPrototypeConditionalRedirect = {
  targetId: string
  thresholdMinor: number
  percentage: number
}

/**
 * App-local planning state for the Buckets workspace.
 *
 * This is deliberately not a persistence or domain contract. The canonical
 * Elgiz model remains subject to its schema/domain approval workline.
 */
export type BucketPrototypeNode = {
  id: string
  name: string
  kind: string
  description: string
  method: string
  allocationKind: 'source' | 'fixed' | 'percentage' | 'priority' | 'remainder'
  allocationValue?: number
  distributionPercentage?: number
  currentMinor: number
  targetMinor?: number
  state: string
  tone: BucketPrototypeTone
  rules: BucketPrototypeRule[]
  displayMode?: BucketPrototypeDisplayMode
  presentation?: BucketPrototypePresentation
  expenseMode?: BucketPrototypeExpenseMode
  expenseLifecycle?: BucketPrototypeExpenseLifecycle
  recurrenceDay?: number
  conditionalRedirect?: BucketPrototypeConditionalRedirect
  connectionMode?: BucketPrototypeConnectionMode
  children?: BucketPrototypeNode[]
}
