<script setup lang="ts">
type BucketType = 'source' | 'long_term' | 'tax' | 'expense' | 'reserve' | 'debt' | 'goal' | 'play' | 'buffer'
type AllocationKind = 'percent' | 'fixed' | 'remainder'
type WithdrawalPolicy = 'open' | 'restricted' | 'last_resort' | 'locked'

type BucketGate = {
  percent: number
  toBucketId: string
  untilBucketId: string
  untilAmount: number
}

type BucketNode = {
  id: string
  name: string
  type: BucketType
  parentId?: string
  x: number
  y: number
  priority: number
  allocation: AllocationKind
  value: number
  current: number
  target?: number
  withdrawal: WithdrawalPolicy
  overflowTargetId?: string
  gate?: BucketGate
  notes?: string
}

type LedgerEntry = {
  id: string
  from: string
  to: string
  amount: number
  reason: string
}

type AllocationResult = {
  received: Record<string, number>
  retained: Record<string, number>
  rerouted: Record<string, number>
  links: Record<string, number>
  ledger: LedgerEntry[]
}

type FlowEdge = {
  id: string
  sourceId: string
  targetId: string
  amount: number
  kind: 'normal' | 'gate'
}

const storageKey = 'raven:buckets-lab:v1'
const nodeWidth = 220
const nodeHeight = 132

const seedBuckets = (): BucketNode[] => [
  {
    id: 'income',
    name: 'Monthly Inflow',
    type: 'source',
    x: 640,
    y: 40,
    priority: 0,
    allocation: 'remainder',
    value: 0,
    current: 0,
    withdrawal: 'open',
    notes: 'Scenario source. Change the monthly inflow and the plan rebalances.',
  },
  {
    id: 'ltf',
    name: 'Pay Yourself First',
    type: 'long_term',
    parentId: 'income',
    x: 90,
    y: 235,
    priority: 1,
    allocation: 'percent',
    value: 10,
    current: 12500,
    target: 250000,
    withdrawal: 'locked',
    overflowTargetId: 'buffer',
    notes: 'A future-self slice before the rest of the plan starts negotiating.',
  },
  {
    id: 'tax',
    name: 'Tax Envelope',
    type: 'tax',
    parentId: 'income',
    x: 350,
    y: 235,
    priority: 2,
    allocation: 'percent',
    value: 20,
    current: 0,
    withdrawal: 'restricted',
    notes: 'Planning envelope for tax. Later this can become smarter by income source.',
  },
  {
    id: 'essentials',
    name: 'Essentials Circuit',
    type: 'expense',
    parentId: 'income',
    x: 610,
    y: 235,
    priority: 10,
    allocation: 'fixed',
    value: 30000,
    current: 0,
    withdrawal: 'open',
    notes: 'Fixed and semi-fixed living costs.',
  },
  {
    id: 'debts',
    name: 'Debt Pressure',
    type: 'debt',
    parentId: 'income',
    x: 870,
    y: 235,
    priority: 15,
    allocation: 'fixed',
    value: 6500,
    current: 0,
    target: 70000,
    withdrawal: 'restricted',
    notes: 'Minimum debt servicing first; snowball and avalanche rules can come later.',
  },
  {
    id: 'reserves',
    name: 'Security Reserves',
    type: 'reserve',
    parentId: 'income',
    x: 1130,
    y: 235,
    priority: 20,
    allocation: 'percent',
    value: 10,
    current: 0,
    withdrawal: 'restricted',
    notes: 'Safety, maintenance, health, and other stability reserves.',
  },
  {
    id: 'goals',
    name: 'Purpose Goals',
    type: 'goal',
    parentId: 'income',
    x: 1390,
    y: 235,
    priority: 60,
    allocation: 'percent',
    value: 5,
    current: 0,
    withdrawal: 'restricted',
    notes: 'Finite goals that should feel visible and earned instead of vague.',
  },
  {
    id: 'play',
    name: 'Play / Oxygen',
    type: 'play',
    parentId: 'income',
    x: 1650,
    y: 235,
    priority: 70,
    allocation: 'percent',
    value: 3,
    current: 1000,
    target: 6000,
    withdrawal: 'open',
    overflowTargetId: 'buffer',
    gate: {
      percent: 50,
      toBucketId: 'emergency',
      untilBucketId: 'emergency',
      untilAmount: 90000,
    },
    notes: 'A must-live slice. The starter gate sends half to Emergency until the safety net is full.',
  },
  {
    id: 'buffer',
    name: 'Flex Buffer',
    type: 'buffer',
    parentId: 'income',
    x: 1910,
    y: 235,
    priority: 99,
    allocation: 'remainder',
    value: 0,
    current: 2500,
    target: 30000,
    withdrawal: 'last_resort',
    notes: 'Whatever remains after the planned circuit.',
  },
  {
    id: 'rent',
    name: 'Rent / Bond',
    type: 'expense',
    parentId: 'essentials',
    x: 410,
    y: 450,
    priority: 1,
    allocation: 'fixed',
    value: 15000,
    current: 0,
    withdrawal: 'open',
  },
  {
    id: 'groceries',
    name: 'Groceries',
    type: 'expense',
    parentId: 'essentials',
    x: 650,
    y: 450,
    priority: 2,
    allocation: 'fixed',
    value: 8000,
    current: 0,
    withdrawal: 'open',
  },
  {
    id: 'utilities',
    name: 'Utilities + Data',
    type: 'expense',
    parentId: 'essentials',
    x: 890,
    y: 450,
    priority: 3,
    allocation: 'fixed',
    value: 4500,
    current: 0,
    withdrawal: 'open',
  },
  {
    id: 'kids',
    name: 'Kids Essentials',
    type: 'expense',
    parentId: 'essentials',
    x: 1130,
    y: 450,
    priority: 4,
    allocation: 'fixed',
    value: 2500,
    current: 0,
    withdrawal: 'open',
  },
  {
    id: 'visa',
    name: 'Credit Card A',
    type: 'debt',
    parentId: 'debts',
    x: 790,
    y: 665,
    priority: 1,
    allocation: 'fixed',
    value: 3000,
    current: 0,
    target: 40000,
    withdrawal: 'restricted',
  },
  {
    id: 'loan',
    name: 'Loan / Arrears',
    type: 'debt',
    parentId: 'debts',
    x: 1030,
    y: 665,
    priority: 2,
    allocation: 'fixed',
    value: 2500,
    current: 0,
    target: 30000,
    withdrawal: 'restricted',
  },
  {
    id: 'snowball',
    name: 'Snowball Extra',
    type: 'debt',
    parentId: 'debts',
    x: 1270,
    y: 665,
    priority: 3,
    allocation: 'remainder',
    value: 0,
    current: 0,
    withdrawal: 'restricted',
  },
  {
    id: 'emergency',
    name: 'Emergency 3-Month Net',
    type: 'reserve',
    parentId: 'reserves',
    x: 1090,
    y: 450,
    priority: 1,
    allocation: 'percent',
    value: 60,
    current: 11000,
    target: 90000,
    withdrawal: 'locked',
    overflowTargetId: 'buffer',
    notes: 'The key stability target. The Play gate boosts this until it reaches R90k.',
  },
  {
    id: 'health',
    name: 'Health Reserve',
    type: 'reserve',
    parentId: 'reserves',
    x: 1330,
    y: 450,
    priority: 2,
    allocation: 'percent',
    value: 20,
    current: 1300,
    target: 8000,
    withdrawal: 'restricted',
    overflowTargetId: 'buffer',
  },
  {
    id: 'car',
    name: 'Car Maintenance',
    type: 'reserve',
    parentId: 'reserves',
    x: 1570,
    y: 450,
    priority: 3,
    allocation: 'percent',
    value: 20,
    current: 900,
    target: 15000,
    withdrawal: 'restricted',
    overflowTargetId: 'buffer',
  },
  {
    id: 'tyres',
    name: 'Tyres',
    type: 'goal',
    parentId: 'goals',
    x: 1390,
    y: 665,
    priority: 1,
    allocation: 'percent',
    value: 45,
    current: 0,
    target: 12000,
    withdrawal: 'restricted',
    overflowTargetId: 'buffer',
  },
  {
    id: 'holiday',
    name: 'Holiday / Memory',
    type: 'goal',
    parentId: 'goals',
    x: 1630,
    y: 665,
    priority: 2,
    allocation: 'percent',
    value: 35,
    current: 0,
    target: 25000,
    withdrawal: 'restricted',
    overflowTargetId: 'buffer',
  },
  {
    id: 'learning',
    name: 'Learning Tools',
    type: 'goal',
    parentId: 'goals',
    x: 1870,
    y: 665,
    priority: 3,
    allocation: 'remainder',
    value: 0,
    current: 0,
    target: 10000,
    withdrawal: 'restricted',
    overflowTargetId: 'buffer',
  },
]

useHead({
  title: 'Raven - Buckets Lab',
  meta: [
    {
      name: 'description',
      content: 'Raven buckets planning surface for rules-driven money flow and projections.',
    },
  ],
})

const buckets = ref<BucketNode[]>(seedBuckets())
const selectedBucketId = ref('emergency')
const monthlyInflow = ref(80000)
const projectionMonths = ref(12)
const canvasMode = ref<'build' | 'simulate'>('build')
const copyState = ref('')
const dragState = ref<{
  id: string
  startX: number
  startY: number
  originX: number
  originY: number
} | null>(null)

const moneyFormatter = new Intl.NumberFormat('en-ZA', {
  style: 'currency',
  currency: 'ZAR',
  minimumFractionDigits: 0,
  maximumFractionDigits: 0,
})

const preciseMoneyFormatter = new Intl.NumberFormat('en-ZA', {
  style: 'currency',
  currency: 'ZAR',
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
})

const percentFormatter = new Intl.NumberFormat('en-ZA', {
  minimumFractionDigits: 0,
  maximumFractionDigits: 1,
})

const clampMoney = (value: number) => Math.max(0, Math.round((Number.isFinite(value) ? value : 0) * 100) / 100)
const formatMoney = (value: number | null | undefined, precise = false) =>
  (precise ? preciseMoneyFormatter : moneyFormatter).format(value ?? 0)
const formatPercent = (value: number | null | undefined) => `${percentFormatter.format(value ?? 0)}%`

const bucketMap = computed(() => new Map(buckets.value.map(bucket => [bucket.id, bucket])))
const rootBucket = computed(() => buckets.value.find(bucket => bucket.type === 'source') || buckets.value[0])
const selectedBucket = computed(() => bucketMap.value.get(selectedBucketId.value) || rootBucket.value)

const childrenOf = (parentId: string) =>
  buckets.value
    .filter(bucket => bucket.parentId === parentId)
    .sort((a, b) => a.priority - b.priority || a.name.localeCompare(b.name))

const hasChildren = (bucketId: string) => buckets.value.some(bucket => bucket.parentId === bucketId)
const isBalanceBucket = (bucket: BucketNode) => !['source', 'tax', 'expense'].includes(bucket.type)

const activeGate = (bucket: BucketNode, balances: Record<string, number>) => {
  if (!bucket.gate) return false
  return (balances[bucket.gate.untilBucketId] ?? 0) < bucket.gate.untilAmount
}

const addLedger = (ledger: LedgerEntry[], from: string, to: string, amount: number, reason: string) => {
  if (amount <= 0.009) return
  ledger.push({
    id: `${ledger.length + 1}-${from}-${to}`,
    from,
    to,
    amount: clampMoney(amount),
    reason,
  })
}

const runAllocation = (sourceAmount: number, balances: Record<string, number>): AllocationResult => {
  const received: Record<string, number> = {}
  const retained: Record<string, number> = {}
  const rerouted: Record<string, number> = {}
  const links: Record<string, number> = {}
  const ledger: LedgerEntry[] = []
  const root = rootBucket.value

  if (!root) return { received, retained, rerouted, links, ledger }

  const receiveIntoBucket = (bucketId: string, amount: number, fromId: string, reason: string) => {
    const bucket = bucketMap.value.get(bucketId)
    if (!bucket || amount <= 0) return 0

    let accepted = clampMoney(amount)
    let overflow = 0

    if (bucket.target && isBalanceBucket(bucket)) {
      const alreadyAccepted = received[bucket.id] ?? 0
      const room = Math.max(0, bucket.target - (balances[bucket.id] ?? bucket.current ?? 0) - alreadyAccepted)
      accepted = clampMoney(Math.min(accepted, room))
      overflow = clampMoney(amount - accepted)
    }

    if (accepted > 0) {
      received[bucket.id] = clampMoney((received[bucket.id] ?? 0) + accepted)
      links[`${fromId}->${bucket.id}`] = clampMoney((links[`${fromId}->${bucket.id}`] ?? 0) + accepted)
      addLedger(ledger, fromId, bucket.id, accepted, reason)
      distributeChildren(bucket.id, accepted)
    }

    if (overflow > 0) {
      const overflowTarget = bucket.overflowTargetId && bucket.overflowTargetId !== bucket.id ? bucket.overflowTargetId : undefined
      if (overflowTarget && bucketMap.value.has(overflowTarget)) {
        receiveIntoBucket(overflowTarget, overflow, bucket.id, `Overflow from ${bucket.name} after target cap`)
      } else {
        retained[bucket.id] = clampMoney((retained[bucket.id] ?? 0) + overflow)
        addLedger(ledger, bucket.id, bucket.id, overflow, 'Overflow retained because no overflow target is set')
      }
    }

    return accepted
  }

  const routeToChild = (parentId: string, child: BucketNode, amount: number, reason: string) => {
    if (amount <= 0) return

    if (child.gate && activeGate(child, balances) && child.gate.toBucketId !== child.id) {
      const gateAmount = clampMoney(amount * (child.gate.percent / 100))
      const remaining = clampMoney(amount - gateAmount)
      const gateKey = `${child.id}->${child.gate.toBucketId}`
      rerouted[gateKey] = clampMoney((rerouted[gateKey] ?? 0) + gateAmount)

      if (remaining > 0) {
        receiveIntoBucket(child.id, remaining, parentId, `${reason}; ${formatPercent(child.gate.percent)} gate left in ${child.name}`)
      }

      if (gateAmount > 0) {
        const targetName = bucketMap.value.get(child.gate.untilBucketId)?.name || 'target'
        receiveIntoBucket(child.gate.toBucketId, gateAmount, child.id, `${child.name} gate active until ${targetName} reaches ${formatMoney(child.gate.untilAmount)}`)
      }

      return
    }

    receiveIntoBucket(child.id, amount, parentId, reason)
  }

  function distributeChildren(parentId: string, amount: number) {
    const children = childrenOf(parentId)
    if (!children.length || amount <= 0) {
      retained[parentId] = clampMoney((retained[parentId] ?? 0) + amount)
      return
    }

    let remaining = clampMoney(amount)
    const remainderChildren: BucketNode[] = []
    const parentName = bucketMap.value.get(parentId)?.name || 'parent'

    for (const child of children) {
      if (child.allocation === 'remainder') {
        remainderChildren.push(child)
        continue
      }

      const requested = child.allocation === 'percent'
        ? clampMoney(amount * (child.value / 100))
        : clampMoney(child.value)
      const allocated = clampMoney(Math.min(requested, remaining))
      remaining = clampMoney(remaining - allocated)

      routeToChild(
        parentId,
        child,
        allocated,
        child.allocation === 'percent'
          ? `${formatPercent(child.value)} of ${parentName}`
          : `Fixed allocation from ${parentName}`,
      )
    }

    if (remainderChildren.length) {
      const each = clampMoney(remaining / remainderChildren.length)
      let remainderLeft = remaining
      remainderChildren.forEach((child, index) => {
        const allocated = index === remainderChildren.length - 1 ? remainderLeft : each
        remainderLeft = clampMoney(remainderLeft - allocated)
        routeToChild(parentId, child, allocated, `Remainder from ${parentName}`)
      })
      remaining = 0
    }

    if (remaining > 0) {
      retained[parentId] = clampMoney((retained[parentId] ?? 0) + remaining)
      addLedger(ledger, parentId, parentId, remaining, 'Unallocated parent remainder')
    }
  }

  received[root.id] = clampMoney(sourceAmount)
  distributeChildren(root.id, clampMoney(sourceAmount))

  return { received, retained, rerouted, links, ledger }
}

const startingBalances = computed(() =>
  Object.fromEntries(buckets.value.map(bucket => [bucket.id, bucket.current || 0])),
)

const monthlyPreview = computed(() => runAllocation(monthlyInflow.value, startingBalances.value))

const projection = computed(() => {
  const balances = { ...startingBalances.value }
  const cumulative: Record<string, number> = {}
  const firstCompletionMonth: Record<string, number> = {}
  let lastLedger: LedgerEntry[] = []

  for (let month = 1; month <= projectionMonths.value; month += 1) {
    const result = runAllocation(monthlyInflow.value, balances)
    lastLedger = result.ledger

    for (const bucket of buckets.value) {
      const amount = result.received[bucket.id] ?? 0
      cumulative[bucket.id] = clampMoney((cumulative[bucket.id] ?? 0) + amount)

      if (isBalanceBucket(bucket)) {
        balances[bucket.id] = clampMoney((balances[bucket.id] ?? 0) + amount)
        if (bucket.target && !firstCompletionMonth[bucket.id] && balances[bucket.id] >= bucket.target) {
          firstCompletionMonth[bucket.id] = month
        }
      }
    }
  }

  return {
    balances,
    cumulative,
    firstCompletionMonth,
    lastLedger,
  }
})

const rootRemainder = computed(() => monthlyPreview.value.retained[rootBucket.value?.id || ''] ?? 0)
const totalAllocatedMonthly = computed(() => Math.max(0, monthlyInflow.value - rootRemainder.value))

const flowEdges = computed<FlowEdge[]>(() => {
  const normalEdges = buckets.value
    .filter(bucket => bucket.parentId)
    .map(bucket => ({
      id: `${bucket.parentId}->${bucket.id}`,
      sourceId: bucket.parentId || '',
      targetId: bucket.id,
      amount: monthlyPreview.value.links[`${bucket.parentId}->${bucket.id}`] ?? 0,
      kind: 'normal' as const,
    }))

  const balances = startingBalances.value
  const gateEdges = buckets.value
    .filter(bucket => bucket.gate && activeGate(bucket, balances))
    .map(bucket => {
      const toBucketId = bucket.gate?.toBucketId || ''
      return {
        id: `gate:${bucket.id}->${toBucketId}`,
        sourceId: bucket.id,
        targetId: toBucketId,
        amount: monthlyPreview.value.rerouted[`${bucket.id}->${toBucketId}`] ?? 0,
        kind: 'gate' as const,
      }
    })

  return [...normalEdges, ...gateEdges]
})

const treeRows = computed(() => {
  const rows: Array<{ bucket: BucketNode, depth: number }> = []
  const walk = (parentId: string | undefined, depth: number) => {
    buckets.value
      .filter(bucket => bucket.parentId === parentId)
      .sort((a, b) => a.priority - b.priority || a.name.localeCompare(b.name))
      .forEach(bucket => {
        rows.push({ bucket, depth })
        walk(bucket.id, depth + 1)
      })
  }
  walk(undefined, 0)
  return rows
})

const topStats = computed(() => {
  const emergency = bucketMap.value.get('emergency')
  const emergencyBalance = emergency ? projection.value.balances[emergency.id] ?? emergency.current : 0
  const emergencyTarget = emergency?.target ?? 0

  return [
    {
      label: 'Monthly routed',
      value: formatMoney(totalAllocatedMonthly.value),
      helper: `${formatMoney(rootRemainder.value)} unallocated at source`,
    },
    {
      label: `${projectionMonths.value}-month scenario`,
      value: formatMoney(monthlyInflow.value * projectionMonths.value),
      helper: 'Before actuals reconciliation',
    },
    {
      label: 'Emergency projection',
      value: formatMoney(emergencyBalance),
      helper: emergencyTarget ? `${formatPercent(Math.min(100, (emergencyBalance / emergencyTarget) * 100))} of target` : 'No target set',
    },
  ]
})

const descendantsOf = (bucketId: string) => {
  const descendants = new Set<string>()
  const visit = (id: string) => {
    childrenOf(id).forEach(child => {
      descendants.add(child.id)
      visit(child.id)
    })
  }
  visit(bucketId)
  return descendants
}

const parentOptions = computed(() => {
  const selected = selectedBucket.value
  if (!selected) return buckets.value
  const blocked = descendantsOf(selected.id)
  blocked.add(selected.id)
  return buckets.value.filter(bucket => !blocked.has(bucket.id))
})

const bucketTypes: Array<{ value: BucketType, label: string }> = [
  { value: 'source', label: 'Source' },
  { value: 'long_term', label: 'Long-term freedom' },
  { value: 'tax', label: 'Tax' },
  { value: 'expense', label: 'Expense' },
  { value: 'reserve', label: 'Reserve' },
  { value: 'debt', label: 'Debt' },
  { value: 'goal', label: 'Goal' },
  { value: 'play', label: 'Play' },
  { value: 'buffer', label: 'Buffer' },
]

const allocationKinds: Array<{ value: AllocationKind, label: string }> = [
  { value: 'percent', label: 'Percent of parent' },
  { value: 'fixed', label: 'Fixed amount' },
  { value: 'remainder', label: 'Remainder' },
]

const withdrawalPolicies: Array<{ value: WithdrawalPolicy, label: string }> = [
  { value: 'open', label: 'Open' },
  { value: 'restricted', label: 'Restricted' },
  { value: 'last_resort', label: 'Last resort' },
  { value: 'locked', label: 'Locked' },
]

const typeLabel = (type: BucketType) => bucketTypes.find(item => item.value === type)?.label || type
const allocationLabel = (bucket: BucketNode) => {
  if (!bucket.parentId) return 'Scenario source'
  if (bucket.allocation === 'percent') return `${formatPercent(bucket.value)} of parent`
  if (bucket.allocation === 'fixed') return `${formatMoney(bucket.value)} fixed`
  return 'Remainder'
}

const progressPercent = (bucket: BucketNode) => {
  if (!bucket.target) return 0
  const balance = projection.value.balances[bucket.id] ?? bucket.current ?? 0
  return Math.max(0, Math.min(100, (balance / bucket.target) * 100))
}

const etaLabel = (bucket: BucketNode) => {
  if (!bucket.target || !isBalanceBucket(bucket)) return 'No target'
  const projectedBalance = projection.value.balances[bucket.id] ?? bucket.current ?? 0
  if (projectedBalance >= bucket.target) {
    const completionMonth = projection.value.firstCompletionMonth[bucket.id]
    return completionMonth ? `fills in month ${completionMonth}` : 'target filled'
  }

  const monthlyAmount = monthlyPreview.value.received[bucket.id] ?? 0
  if (monthlyAmount <= 0) return 'no inflow yet'
  const remaining = bucket.target - (bucket.current ?? 0)
  return `approx ${Math.ceil(remaining / monthlyAmount)} months`
}

const nodeStyle = (bucket: BucketNode) => ({
  transform: `translate3d(${bucket.x}px, ${bucket.y}px, 0)`,
  zIndex: selectedBucketId.value === bucket.id ? 5 : 2,
})

const edgePath = (edge: FlowEdge) => {
  const source = bucketMap.value.get(edge.sourceId)
  const target = bucketMap.value.get(edge.targetId)
  if (!source || !target) return ''

  if (edge.kind === 'gate') {
    const sx = source.x + nodeWidth
    const sy = source.y + nodeHeight / 2
    const tx = target.x
    const ty = target.y + nodeHeight / 2
    const midX = sx + (tx - sx) / 2
    return `M ${sx} ${sy} C ${midX} ${sy}, ${midX} ${ty}, ${tx} ${ty}`
  }

  const sx = source.x + nodeWidth / 2
  const sy = source.y + nodeHeight
  const tx = target.x + nodeWidth / 2
  const ty = target.y
  const midY = sy + (ty - sy) / 2
  return `M ${sx} ${sy} C ${sx} ${midY}, ${tx} ${midY}, ${tx} ${ty}`
}

const edgeStrokeWidth = (amount: number) => Math.max(1.25, Math.min(8, (amount / Math.max(1, monthlyInflow.value)) * 46))

const onNodePointerDown = (event: PointerEvent, bucket: BucketNode) => {
  if (canvasMode.value === 'simulate') {
    selectedBucketId.value = bucket.id
    return
  }

  selectedBucketId.value = bucket.id
  dragState.value = {
    id: bucket.id,
    startX: event.clientX,
    startY: event.clientY,
    originX: bucket.x,
    originY: bucket.y,
  }

  window.addEventListener('pointermove', onPointerMove)
  window.addEventListener('pointerup', onPointerUp, { once: true })
}

const onPointerMove = (event: PointerEvent) => {
  const state = dragState.value
  if (!state) return
  const bucket = bucketMap.value.get(state.id)
  if (!bucket) return

  const dx = event.clientX - state.startX
  const dy = event.clientY - state.startY
  bucket.x = Math.max(16, state.originX + dx)
  bucket.y = Math.max(16, state.originY + dy)
}

const onPointerUp = () => {
  window.removeEventListener('pointermove', onPointerMove)
  dragState.value = null
}

const addBucket = () => {
  const parent = selectedBucket.value || rootBucket.value
  const id = `bucket-${Date.now().toString(36)}`
  buckets.value.push({
    id,
    name: 'New Bucket',
    type: 'goal',
    parentId: parent?.id,
    x: (parent?.x ?? 280) + 260,
    y: (parent?.y ?? 120) + 170,
    priority: childrenOf(parent?.id || '').length + 1,
    allocation: 'percent',
    value: 5,
    current: 0,
    target: 10000,
    withdrawal: 'restricted',
    overflowTargetId: bucketMap.value.has('buffer') ? 'buffer' : undefined,
    notes: 'Purpose for this bucket.',
  })
  selectedBucketId.value = id
}

const deleteSelectedBucket = () => {
  const selected = selectedBucket.value
  if (!selected || selected.type === 'source') return
  const deleteIds = descendantsOf(selected.id)
  deleteIds.add(selected.id)
  buckets.value = buckets.value.filter(bucket => !deleteIds.has(bucket.id))
  selectedBucketId.value = selected.parentId || rootBucket.value?.id || ''
}

const autoArrange = () => {
  const root = rootBucket.value
  if (!root) return

  const levels: BucketNode[][] = []
  const visit = (bucket: BucketNode, depth: number) => {
    if (!levels[depth]) levels[depth] = []
    levels[depth].push(bucket)
    childrenOf(bucket.id).forEach(child => visit(child, depth + 1))
  }
  visit(root, 0)

  levels.forEach((level, depth) => {
    const spacing = 248
    const totalWidth = (level.length - 1) * spacing
    const startX = Math.max(60, 820 - totalWidth / 2)
    level.forEach((bucket, index) => {
      bucket.x = Math.round(startX + index * spacing)
      bucket.y = 40 + depth * 205
    })
  })
}

const resetDemo = () => {
  buckets.value = seedBuckets()
  monthlyInflow.value = 80000
  projectionMonths.value = 12
  selectedBucketId.value = 'emergency'
  copyState.value = ''
}

const copyScenarioJson = async () => {
  const payload = JSON.stringify({
    monthlyInflow: monthlyInflow.value,
    projectionMonths: projectionMonths.value,
    buckets: buckets.value,
  }, null, 2)

  try {
    await navigator.clipboard.writeText(payload)
    copyState.value = 'Copied JSON'
  } catch {
    copyState.value = 'Copy failed'
  }

  window.setTimeout(() => {
    copyState.value = ''
  }, 2200)
}

watch([buckets, monthlyInflow, projectionMonths], () => {
  if (typeof window === 'undefined') return
  localStorage.setItem(storageKey, JSON.stringify({
    buckets: buckets.value,
    monthlyInflow: monthlyInflow.value,
    projectionMonths: projectionMonths.value,
  }))
}, { deep: true })

onMounted(() => {
  const raw = localStorage.getItem(storageKey)
  if (!raw) return

  try {
    const parsed = JSON.parse(raw) as {
      buckets?: BucketNode[]
      monthlyInflow?: number
      projectionMonths?: number
    }
    if (Array.isArray(parsed.buckets) && parsed.buckets.length) buckets.value = parsed.buckets
    if (typeof parsed.monthlyInflow === 'number') monthlyInflow.value = parsed.monthlyInflow
    if (typeof parsed.projectionMonths === 'number') projectionMonths.value = parsed.projectionMonths
  } catch {
    localStorage.removeItem(storageKey)
  }
})

onBeforeUnmount(() => {
  if (typeof window === 'undefined') return
  window.removeEventListener('pointermove', onPointerMove)
})
</script>

<template>
  <section class="buckets-page space-y-8 py-6">
    <header class="grid gap-6 xl:grid-cols-[1.1fr_0.9fr] xl:items-end">
      <div class="space-y-5">
        <NuxtLink to="/" class="inline-flex items-center gap-2 text-sm text-slate-300 transition hover:text-white">
          <span aria-hidden="true">&lt;-</span>
          Raven home
        </NuxtLink>

        <div class="inline-flex items-center gap-2 rounded-full border border-cyan-400/20 bg-cyan-400/10 px-3 py-1 text-[11px] font-medium uppercase tracking-[0.32em] text-cyan-100/80">
          <span class="h-1.5 w-1.5 rounded-full bg-cyan-300 shadow-[0_0_18px_rgba(34,211,238,0.8)]" />
          Future / Buckets Lab
        </div>

        <div class="space-y-3">
          <p class="text-xs uppercase tracking-[0.34em] text-slate-400">
            Money flow planner
          </p>
          <h1 class="max-w-5xl text-5xl font-semibold tracking-[-0.06em] text-white sm:text-6xl">
            Route every rand before the month begins.
          </h1>
          <p class="max-w-4xl text-base leading-7 text-slate-300 sm:text-lg">
            Shape a monthly inflow into buckets, gates, reserves, debt pressure, and goals. The canvas,
            table, and ledger all recalculate from the same draft plan.
          </p>
        </div>
      </div>

      <aside class="raven-card space-y-4 p-5 sm:p-6">
        <div class="grid gap-3 sm:grid-cols-2">
          <label class="space-y-2">
            <span class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Monthly inflow</span>
            <input
              v-model.number="monthlyInflow"
              class="buckets-input text-lg"
              type="number"
              min="0"
              step="500"
            >
          </label>

          <label class="space-y-2">
            <span class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Projection months</span>
            <input
              v-model.number="projectionMonths"
              class="buckets-input text-lg"
              type="number"
              min="1"
              max="60"
              step="1"
            >
          </label>
        </div>

        <input
          v-model.number="projectionMonths"
          class="w-full accent-cyan-300"
          type="range"
          min="1"
          max="36"
        >

        <div class="grid gap-3 sm:grid-cols-3">
          <article v-for="stat in topStats" :key="stat.label" class="rounded-3xl border border-white/8 bg-slate-950/45 p-4">
            <p class="text-[10px] uppercase tracking-[0.24em] text-slate-400">{{ stat.label }}</p>
            <p class="mt-2 text-xl font-semibold text-white">{{ stat.value }}</p>
            <p class="mt-1 text-xs leading-5 text-slate-400">{{ stat.helper }}</p>
          </article>
        </div>
      </aside>
    </header>

    <section class="grid gap-4 xl:grid-cols-[minmax(0,1fr)_23rem]">
      <div class="raven-card overflow-hidden">
        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-white/8 px-5 py-4">
          <div>
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Money canvas</p>
            <h2 class="mt-1 text-xl font-semibold text-white">Buckets as a living circuit</h2>
          </div>

          <div class="flex flex-wrap items-center gap-2">
            <button
              class="buckets-pill"
              :class="canvasMode === 'build' ? 'buckets-pill--active' : ''"
              type="button"
              @click="canvasMode = 'build'"
            >
              Build
            </button>
            <button
              class="buckets-pill"
              :class="canvasMode === 'simulate' ? 'buckets-pill--active' : ''"
              type="button"
              @click="canvasMode = 'simulate'"
            >
              Simulate
            </button>
            <button class="buckets-pill" type="button" @click="addBucket()">+ Bucket</button>
            <button class="buckets-pill" type="button" @click="autoArrange()">Auto-arrange</button>
            <button class="buckets-pill" type="button" @click="resetDemo()">Reset</button>
          </div>
        </div>

        <div class="buckets-canvas-shell">
          <div class="buckets-canvas-grid" aria-hidden="true" />
          <svg class="buckets-edges" viewBox="0 0 2300 980" aria-hidden="true">
            <defs>
              <marker id="buckets-arrow" markerHeight="8" markerWidth="8" orient="auto" refX="7" refY="4">
                <path d="M 0 0 L 8 4 L 0 8 z" fill="rgba(125, 211, 252, 0.75)" />
              </marker>
            </defs>

            <g v-for="edge in flowEdges" :key="edge.id">
              <path
                class="buckets-edge"
                :class="edge.kind === 'gate' ? 'buckets-edge--gate' : ''"
                :d="edgePath(edge)"
                :stroke-width="edgeStrokeWidth(edge.amount)"
                marker-end="url(#buckets-arrow)"
              />
            </g>
          </svg>

          <button
            v-for="bucket in buckets"
            :key="bucket.id"
            class="buckets-node"
            :class="selectedBucketId === bucket.id ? 'buckets-node--selected' : ''"
            :data-type="bucket.type"
            :style="nodeStyle(bucket)"
            type="button"
            @pointerdown="onNodePointerDown($event, bucket)"
          >
            <span class="buckets-node__glow" aria-hidden="true" />
            <span class="buckets-node__topline">
              <span class="buckets-node__type">{{ typeLabel(bucket.type) }}</span>
              <span class="buckets-node__policy">{{ bucket.withdrawal.replace('_', ' ') }}</span>
            </span>
            <span class="buckets-node__name">{{ bucket.name }}</span>
            <span class="buckets-node__amount">{{ formatMoney(monthlyPreview.received[bucket.id] ?? 0) }} / month</span>
            <span class="buckets-node__meta">
              <span>{{ allocationLabel(bucket) }}</span>
              <span v-if="hasChildren(bucket.id)">{{ childrenOf(bucket.id).length }} children</span>
              <span v-else>{{ etaLabel(bucket) }}</span>
            </span>
            <span v-if="bucket.target" class="buckets-progress" aria-hidden="true">
              <span :style="{ width: `${progressPercent(bucket)}%` }" />
            </span>
            <span v-if="bucket.gate" class="buckets-gate-pill">
              Gate {{ formatPercent(bucket.gate.percent) }} -&gt; {{ bucketMap.get(bucket.gate.toBucketId)?.name || 'target' }}
            </span>
          </button>
        </div>
      </div>

      <aside class="raven-card buckets-inspector p-5 sm:p-6">
        <div v-if="selectedBucket" class="space-y-5">
          <div class="flex items-start justify-between gap-3">
            <div>
              <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Inspector</p>
              <h2 class="mt-2 text-2xl font-semibold tracking-[-0.04em] text-white">{{ selectedBucket.name }}</h2>
            </div>
            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs text-slate-300">
              {{ typeLabel(selectedBucket.type) }}
            </span>
          </div>

          <div class="grid gap-3">
            <label class="space-y-2">
              <span class="buckets-label">Name</span>
              <input v-model="selectedBucket.name" class="buckets-input" type="text">
            </label>

            <div class="grid gap-3 sm:grid-cols-2">
              <label class="space-y-2">
                <span class="buckets-label">Type</span>
                <select v-model="selectedBucket.type" class="buckets-input">
                  <option v-for="type in bucketTypes" :key="type.value" :value="type.value">{{ type.label }}</option>
                </select>
              </label>

              <label class="space-y-2">
                <span class="buckets-label">Parent</span>
                <select v-model="selectedBucket.parentId" class="buckets-input" :disabled="selectedBucket.type === 'source'">
                  <option :value="undefined">None</option>
                  <option v-for="bucket in parentOptions" :key="bucket.id" :value="bucket.id">{{ bucket.name }}</option>
                </select>
              </label>
            </div>

            <div class="grid gap-3 sm:grid-cols-3">
              <label class="space-y-2">
                <span class="buckets-label">Rule</span>
                <select v-model="selectedBucket.allocation" class="buckets-input" :disabled="selectedBucket.type === 'source'">
                  <option v-for="kind in allocationKinds" :key="kind.value" :value="kind.value">{{ kind.label }}</option>
                </select>
              </label>

              <label class="space-y-2">
                <span class="buckets-label">Value</span>
                <input v-model.number="selectedBucket.value" class="buckets-input" type="number" min="0" step="0.5" :disabled="selectedBucket.allocation === 'remainder' || selectedBucket.type === 'source'">
              </label>

              <label class="space-y-2">
                <span class="buckets-label">Priority</span>
                <input v-model.number="selectedBucket.priority" class="buckets-input" type="number" min="0" step="1">
              </label>
            </div>

            <div class="grid gap-3 sm:grid-cols-3">
              <label class="space-y-2">
                <span class="buckets-label">Current</span>
                <input v-model.number="selectedBucket.current" class="buckets-input" type="number" min="0" step="100">
              </label>

              <label class="space-y-2">
                <span class="buckets-label">Target</span>
                <input v-model.number="selectedBucket.target" class="buckets-input" type="number" min="0" step="100">
              </label>

              <label class="space-y-2">
                <span class="buckets-label">Withdrawal</span>
                <select v-model="selectedBucket.withdrawal" class="buckets-input">
                  <option v-for="policy in withdrawalPolicies" :key="policy.value" :value="policy.value">{{ policy.label }}</option>
                </select>
              </label>
            </div>

            <label class="space-y-2">
              <span class="buckets-label">Overflow target</span>
              <select v-model="selectedBucket.overflowTargetId" class="buckets-input">
                <option :value="undefined">None</option>
                <option v-for="bucket in buckets.filter(item => item.id !== selectedBucket?.id)" :key="bucket.id" :value="bucket.id">{{ bucket.name }}</option>
              </select>
            </label>

            <div class="rounded-3xl border border-white/8 bg-slate-950/35 p-4">
              <div class="flex items-center justify-between gap-3">
                <div>
                  <p class="buckets-label">Gate</p>
                  <p class="mt-1 text-xs leading-5 text-slate-400">Optional reroute while another bucket is below target.</p>
                </div>
                <button
                  class="buckets-pill"
                  type="button"
                  @click="selectedBucket.gate = selectedBucket.gate ? undefined : { percent: 25, toBucketId: bucketMap.has('emergency') ? 'emergency' : rootBucket?.id || selectedBucket.id, untilBucketId: bucketMap.has('emergency') ? 'emergency' : rootBucket?.id || selectedBucket.id, untilAmount: 90000 }"
                >
                  {{ selectedBucket.gate ? 'Remove' : 'Add' }}
                </button>
              </div>

              <div v-if="selectedBucket.gate" class="mt-4 grid gap-3">
                <div class="grid gap-3 sm:grid-cols-2">
                  <label class="space-y-2">
                    <span class="buckets-label">Reroute %</span>
                    <input v-model.number="selectedBucket.gate.percent" class="buckets-input" type="number" min="0" max="100" step="1">
                  </label>
                  <label class="space-y-2">
                    <span class="buckets-label">To bucket</span>
                    <select v-model="selectedBucket.gate.toBucketId" class="buckets-input">
                      <option v-for="bucket in buckets.filter(item => item.id !== selectedBucket?.id)" :key="bucket.id" :value="bucket.id">{{ bucket.name }}</option>
                    </select>
                  </label>
                </div>
                <div class="grid gap-3 sm:grid-cols-2">
                  <label class="space-y-2">
                    <span class="buckets-label">Until bucket</span>
                    <select v-model="selectedBucket.gate.untilBucketId" class="buckets-input">
                      <option v-for="bucket in buckets" :key="bucket.id" :value="bucket.id">{{ bucket.name }}</option>
                    </select>
                  </label>
                  <label class="space-y-2">
                    <span class="buckets-label">Reaches</span>
                    <input v-model.number="selectedBucket.gate.untilAmount" class="buckets-input" type="number" min="0" step="100">
                  </label>
                </div>
              </div>
            </div>

            <label class="space-y-2">
              <span class="buckets-label">Notes</span>
              <textarea v-model="selectedBucket.notes" class="buckets-input min-h-24 resize-y" />
            </label>
          </div>

          <div class="grid gap-3 rounded-3xl border border-cyan-300/15 bg-cyan-400/8 p-4">
            <div class="flex items-center justify-between gap-3 text-sm">
              <span class="text-slate-300">Monthly receives</span>
              <strong class="text-cyan-50">{{ formatMoney(monthlyPreview.received[selectedBucket.id] ?? 0, true) }}</strong>
            </div>
            <div class="flex items-center justify-between gap-3 text-sm">
              <span class="text-slate-300">Projected receives</span>
              <strong class="text-cyan-50">{{ formatMoney(projection.cumulative[selectedBucket.id] ?? 0, true) }}</strong>
            </div>
            <div class="flex items-center justify-between gap-3 text-sm">
              <span class="text-slate-300">Projected balance</span>
              <strong class="text-cyan-50">{{ formatMoney(projection.balances[selectedBucket.id] ?? selectedBucket.current, true) }}</strong>
            </div>
            <div class="flex items-center justify-between gap-3 text-sm">
              <span class="text-slate-300">ETA</span>
              <strong class="text-cyan-50">{{ etaLabel(selectedBucket) }}</strong>
            </div>
          </div>

          <div class="flex flex-wrap gap-2">
            <button class="buckets-action" type="button" @click="addBucket()">Add child bucket</button>
            <button class="buckets-action" type="button" @click="copyScenarioJson()">{{ copyState || 'Copy JSON' }}</button>
            <button
              class="buckets-action buckets-action--danger"
              type="button"
              :disabled="selectedBucket.type === 'source'"
              @click="deleteSelectedBucket()"
            >
              Delete subtree
            </button>
          </div>
        </div>
      </aside>
    </section>

    <section class="grid gap-4 xl:grid-cols-[minmax(0,1fr)_26rem]">
      <article class="raven-card overflow-hidden">
        <div class="flex flex-wrap items-center justify-between gap-3 border-b border-white/8 px-5 py-4">
          <div>
            <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Table view</p>
            <h2 class="mt-1 text-xl font-semibold text-white">Same flow, spreadsheet calm</h2>
          </div>
          <p class="max-w-xl text-sm leading-6 text-slate-400">
            The nested table shares the same bucket graph as the canvas.
          </p>
        </div>

        <div class="overflow-x-auto">
          <table class="buckets-table">
            <thead>
              <tr>
                <th>Bucket</th>
                <th>Rule</th>
                <th>Monthly</th>
                <th>{{ projectionMonths }} months</th>
                <th>Projected balance</th>
                <th>Target / ETA</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="row in treeRows"
                :key="row.bucket.id"
                :class="selectedBucketId === row.bucket.id ? 'is-selected' : ''"
                @click="selectedBucketId = row.bucket.id"
              >
                <td>
                  <div class="flex items-center gap-3" :style="{ paddingLeft: `${row.depth * 1.1}rem` }">
                    <span class="buckets-type-dot" :data-type="row.bucket.type" />
                    <div>
                      <p class="font-medium text-white">{{ row.bucket.name }}</p>
                      <p class="text-xs text-slate-400">{{ typeLabel(row.bucket.type) }} / {{ row.bucket.withdrawal.replace('_', ' ') }}</p>
                    </div>
                  </div>
                </td>
                <td>{{ allocationLabel(row.bucket) }}</td>
                <td>{{ formatMoney(monthlyPreview.received[row.bucket.id] ?? 0, true) }}</td>
                <td>{{ formatMoney(projection.cumulative[row.bucket.id] ?? 0, true) }}</td>
                <td>{{ formatMoney(projection.balances[row.bucket.id] ?? row.bucket.current, true) }}</td>
                <td>
                  <div class="min-w-44">
                    <div class="flex items-center justify-between gap-3 text-xs">
                      <span>{{ row.bucket.target ? formatMoney(row.bucket.target) : 'No target' }}</span>
                      <span>{{ etaLabel(row.bucket) }}</span>
                    </div>
                    <span v-if="row.bucket.target" class="buckets-progress buckets-progress--table" aria-hidden="true">
                      <span :style="{ width: `${progressPercent(row.bucket)}%` }" />
                    </span>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>

      <aside class="raven-card overflow-hidden">
        <div class="border-b border-white/8 px-5 py-4">
          <p class="text-[11px] uppercase tracking-[0.28em] text-slate-400">Explainability ledger</p>
          <h2 class="mt-1 text-xl font-semibold text-white">Why did money move?</h2>
        </div>

        <div class="max-h-[38rem] space-y-3 overflow-y-auto p-5">
          <article
            v-for="entry in monthlyPreview.ledger.slice(0, 28)"
            :key="entry.id"
            class="rounded-3xl border border-white/8 bg-slate-950/40 p-4"
          >
            <div class="flex items-start justify-between gap-3">
              <div>
                <p class="text-sm font-medium text-white">
                  {{ bucketMap.get(entry.from)?.name || entry.from }} -&gt; {{ bucketMap.get(entry.to)?.name || entry.to }}
                </p>
                <p class="mt-1 text-xs leading-5 text-slate-400">{{ entry.reason }}</p>
              </div>
              <strong class="text-sm text-cyan-50">{{ formatMoney(entry.amount, true) }}</strong>
            </div>
          </article>
        </div>
      </aside>
    </section>
  </section>
</template>

<style scoped>
.buckets-page :global(.raven-card) {
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1.5rem;
  background: linear-gradient(145deg, rgba(15, 23, 42, 0.82), rgba(2, 6, 23, 0.72));
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.22), inset 0 1px 0 rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(24px);
}

.buckets-input {
  width: 100%;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1rem;
  background: rgba(2, 6, 23, 0.62);
  color: white;
  outline: none;
  padding: 0.85rem 1rem;
  transition: border-color 160ms ease, box-shadow 160ms ease, background 160ms ease;
}

.buckets-input:focus {
  border-color: rgba(103, 232, 249, 0.45);
  background: rgba(2, 6, 23, 0.76);
  box-shadow: 0 0 0 4px rgba(34, 211, 238, 0.1);
}

.buckets-input:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.buckets-label {
  display: block;
  color: rgb(148, 163, 184);
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.24em;
  text-transform: uppercase;
}

.buckets-pill,
.buckets-action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.05);
  color: rgb(226, 232, 240);
  font-size: 0.78rem;
  font-weight: 600;
  gap: 0.4rem;
  padding: 0.62rem 0.9rem;
  transition: transform 160ms ease, border-color 160ms ease, background 160ms ease;
}

.buckets-pill:hover,
.buckets-action:hover {
  border-color: rgba(103, 232, 249, 0.32);
  background: rgba(34, 211, 238, 0.1);
  transform: translateY(-1px);
}

.buckets-pill--active,
.buckets-action {
  border-color: rgba(103, 232, 249, 0.32);
  background: rgba(34, 211, 238, 0.12);
  color: rgb(236, 254, 255);
}

.buckets-action--danger {
  border-color: rgba(251, 113, 133, 0.25);
  background: rgba(244, 63, 94, 0.08);
  color: rgb(254, 205, 211);
}

.buckets-action:disabled {
  cursor: not-allowed;
  opacity: 0.45;
  transform: none;
}

.buckets-canvas-shell {
  position: relative;
  height: 55rem;
  overflow: auto;
  background:
    radial-gradient(circle at 20% 15%, rgba(34, 211, 238, 0.13), transparent 28rem),
    radial-gradient(circle at 85% 30%, rgba(16, 185, 129, 0.11), transparent 26rem),
    rgba(2, 6, 23, 0.35);
}

.buckets-canvas-grid {
  position: absolute;
  inset: 0;
  width: 2300px;
  height: 980px;
  background-image:
    linear-gradient(rgba(148, 163, 184, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(148, 163, 184, 0.08) 1px, transparent 1px);
  background-size: 34px 34px;
  mask-image: linear-gradient(180deg, black, rgba(0, 0, 0, 0.78));
}

.buckets-edges {
  position: absolute;
  inset: 0;
  width: 2300px;
  height: 980px;
  pointer-events: none;
}

.buckets-edge {
  fill: none;
  filter: drop-shadow(0 0 12px rgba(34, 211, 238, 0.2));
  stroke: rgba(125, 211, 252, 0.58);
  stroke-linecap: round;
}

.buckets-edge--gate {
  filter: drop-shadow(0 0 12px rgba(251, 191, 36, 0.2));
  stroke: rgba(251, 191, 36, 0.72);
  stroke-dasharray: 8 8;
}

.buckets-node {
  position: absolute;
  width: 220px;
  min-height: 132px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 1.2rem;
  background: linear-gradient(145deg, rgba(15, 23, 42, 0.93), rgba(2, 6, 23, 0.9));
  box-shadow: 0 18px 44px rgba(0, 0, 0, 0.24), inset 0 1px 0 rgba(255, 255, 255, 0.06);
  color: white;
  cursor: grab;
  padding: 1rem;
  text-align: left;
  touch-action: none;
  transition: border-color 160ms ease, box-shadow 160ms ease, transform 80ms linear;
  user-select: none;
}

.buckets-node:active {
  cursor: grabbing;
}

.buckets-node--selected {
  border-color: rgba(103, 232, 249, 0.56);
  box-shadow: 0 20px 60px rgba(8, 145, 178, 0.18), 0 0 0 4px rgba(34, 211, 238, 0.1), inset 0 1px 0 rgba(255, 255, 255, 0.08);
}

.buckets-node__glow {
  position: absolute;
  inset: -4rem auto auto -4rem;
  width: 8rem;
  height: 8rem;
  border-radius: 999px;
  background: rgba(34, 211, 238, 0.16);
  filter: blur(28px);
}

.buckets-node[data-type='long_term'] .buckets-node__glow,
.buckets-type-dot[data-type='long_term'] {
  background: rgba(56, 189, 248, 0.34);
}

.buckets-node[data-type='tax'] .buckets-node__glow,
.buckets-type-dot[data-type='tax'] {
  background: rgba(168, 85, 247, 0.34);
}

.buckets-node[data-type='expense'] .buckets-node__glow,
.buckets-type-dot[data-type='expense'] {
  background: rgba(251, 113, 133, 0.3);
}

.buckets-node[data-type='reserve'] .buckets-node__glow,
.buckets-type-dot[data-type='reserve'] {
  background: rgba(16, 185, 129, 0.32);
}

.buckets-node[data-type='debt'] .buckets-node__glow,
.buckets-type-dot[data-type='debt'] {
  background: rgba(251, 146, 60, 0.33);
}

.buckets-node[data-type='goal'] .buckets-node__glow,
.buckets-type-dot[data-type='goal'] {
  background: rgba(129, 140, 248, 0.33);
}

.buckets-node[data-type='play'] .buckets-node__glow,
.buckets-type-dot[data-type='play'] {
  background: rgba(244, 114, 182, 0.33);
}

.buckets-node[data-type='buffer'] .buckets-node__glow,
.buckets-type-dot[data-type='buffer'] {
  background: rgba(250, 204, 21, 0.3);
}

.buckets-node__topline,
.buckets-node__meta {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
}

.buckets-node__type,
.buckets-node__policy {
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  color: rgb(203, 213, 225);
  font-size: 0.62rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  padding: 0.22rem 0.46rem;
  text-overflow: ellipsis;
  text-transform: uppercase;
  white-space: nowrap;
}

.buckets-node__policy {
  max-width: 6.5rem;
  color: rgb(186, 230, 253);
}

.buckets-node__name {
  position: relative;
  display: block;
  overflow: hidden;
  margin-top: 0.78rem;
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: -0.03em;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.buckets-node__amount {
  position: relative;
  display: block;
  margin-top: 0.34rem;
  color: rgb(207, 250, 254);
  font-size: 1.25rem;
  font-weight: 800;
  letter-spacing: -0.04em;
}

.buckets-node__meta {
  margin-top: 0.5rem;
  color: rgb(148, 163, 184);
  font-size: 0.72rem;
}

.buckets-progress {
  position: relative;
  display: block;
  height: 0.42rem;
  overflow: hidden;
  margin-top: 0.72rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
}

.buckets-progress span {
  display: block;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, rgba(34, 211, 238, 0.9), rgba(16, 185, 129, 0.9));
}

.buckets-progress--table {
  height: 0.36rem;
  margin-top: 0.42rem;
}

.buckets-gate-pill {
  position: relative;
  display: inline-flex;
  max-width: 100%;
  overflow: hidden;
  border: 1px solid rgba(251, 191, 36, 0.24);
  border-radius: 999px;
  margin-top: 0.66rem;
  background: rgba(251, 191, 36, 0.1);
  color: rgb(254, 243, 199);
  font-size: 0.68rem;
  padding: 0.32rem 0.52rem;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.buckets-inspector {
  position: sticky;
  top: 1rem;
  align-self: start;
}

.buckets-table {
  width: 100%;
  min-width: 980px;
  border-collapse: collapse;
}

.buckets-table th,
.buckets-table td {
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  padding: 1rem 1.1rem;
  text-align: left;
  vertical-align: middle;
}

.buckets-table th {
  color: rgb(148, 163, 184);
  font-size: 0.68rem;
  font-weight: 700;
  letter-spacing: 0.22em;
  text-transform: uppercase;
}

.buckets-table td {
  color: rgb(203, 213, 225);
  font-size: 0.86rem;
}

.buckets-table tbody tr {
  cursor: pointer;
  transition: background 160ms ease;
}

.buckets-table tbody tr:hover,
.buckets-table tbody tr.is-selected {
  background: rgba(34, 211, 238, 0.07);
}

.buckets-type-dot {
  display: inline-flex;
  width: 0.78rem;
  height: 0.78rem;
  flex: 0 0 auto;
  border-radius: 999px;
  box-shadow: 0 0 16px currentColor;
}

@media (max-width: 1024px) {
  .buckets-canvas-shell {
    height: 42rem;
  }

  .buckets-inspector {
    position: static;
  }
}
</style>
