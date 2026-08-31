import type {
  BucketPrototypeConnectionMode,
  BucketPrototypeCreateDirection,
  BucketPrototypeCreateKind,
  BucketPrototypeDisplayMode,
  BucketPrototypeExpenseLifecycle,
  BucketPrototypeExpenseMode,
  BucketPrototypeNode,
} from '~/types/buckets'

export type BucketPrototypeView = 'nodes' | 'table'

export type BucketCanvasPosition = {
  x: number
  y: number
}

export type BucketGroupFrame = {
  paddingX: number
  paddingTop: number
  paddingBottom: number
  minWidth: number
  minHeight: number
}

export type BucketAllocationMetric = {
  grossReceivedMinor: number
  receivedMinor: number
  remainingAfterMinor: number
  unallocatedMinor: number
  redirectedInMinor: number
  redirectedOutMinor: number
}

export type BucketPrototypeEdge = {
  id: string
  sourceId: string
  targetId: string
  amountMinor: number
  kind: 'branch' | 'series' | 'rule'
}

export type BucketFlowReportEntry = {
  id: string
  step: number
  subject: string
  detail: string
  openingMinor: number
  movementMinor: number
  closingMinor: number
  kind: 'source' | 'allocation' | 'expense' | 'budget' | 'group' | 'remainder' | 'rule'
}

const seedBuckets = (): BucketPrototypeNode[] => [
  {
    id: 'plan',
    name: 'Monthly plan',
    kind: 'source',
    description: 'A blank planning canvas. Add only values and allocation rules you intend to model.',
    method: 'Scenario input',
    allocationKind: 'source',
    currentMinor: 0,
    state: 'Empty',
    tone: 'accent',
    displayMode: 'inline',
    connectionMode: 'branch',
    rules: [],
    children: [],
  },
]

const seedPositions = (): Record<string, BucketCanvasPosition> => ({
  plan: { x: 370, y: 48 },
})

const seedGroupFrames = (): Record<string, BucketGroupFrame> => ({})

export const useBucketsPrototypeStore = defineStore('raven-buckets-prototype', () => {
  const buckets = ref<BucketPrototypeNode[]>(seedBuckets())
  const scenarioMinor = ref(0)
  const viewMode = ref<BucketPrototypeView>('nodes')
  const selectedId = ref('plan')
  const inspectorOpen = ref(true)
  const collapsedIds = ref<string[]>([])
  const positions = ref<Record<string, BucketCanvasPosition>>(seedPositions())
  const groupFrames = ref<Record<string, BucketGroupFrame>>(seedGroupFrames())

  const walk = (
    nodes: BucketPrototypeNode[],
    visit: (node: BucketPrototypeNode, depth: number, parentId: string | null) => void,
    depth = 0,
    parentId: string | null = null,
  ) => {
    for (const node of nodes) {
      visit(node, depth, parentId)
      if (node.children?.length) walk(node.children, visit, depth + 1, node.id)
    }
  }

  const findNode = (id: string) => {
    let result: BucketPrototypeNode | null = null
    walk(buckets.value, (node) => {
      if (node.id === id) result = node
    })
    return result
  }

  type BucketNodeLocation = {
    node: BucketPrototypeNode
    parent: BucketPrototypeNode | null
    container: BucketPrototypeNode[]
    index: number
  }

  const findLocation = (
    id: string,
    nodes: BucketPrototypeNode[] = buckets.value,
    parent: BucketPrototypeNode | null = null,
  ): BucketNodeLocation | null => {
    const index = nodes.findIndex(node => node.id === id)
    if (index >= 0) return { node: nodes[index]!, parent, container: nodes, index }

    for (const node of nodes) {
      if (!node.children?.length) continue
      const result = findLocation(id, node.children, node)
      if (result) return result
    }
    return null
  }

  const flatNodes = computed(() => {
    const result: Array<{ node: BucketPrototypeNode; depth: number; parentId: string | null }> = []
    walk(buckets.value, (node, depth, parentId) => result.push({ node, depth, parentId }))
    return result
  })

  const selectedBucket = computed(() => findNode(selectedId.value) ?? buckets.value[0]!)
  const selectedParent = computed(() => findLocation(selectedId.value)?.parent ?? null)

  const parentOptionsFor = (id: string) => {
    const node = findNode(id)
    if (!node) return []
    return flatNodes.value
      .filter(({ node: candidate }) =>
        candidate.id !== id
        && !containsNode(node, candidate.id),
      )
      .map(({ node: candidate, depth }) => ({
        id: candidate.id,
        name: candidate.name,
        kind: candidate.presentation === 'group' ? 'group' : candidate.kind,
        depth,
      }))
  }

  const groupFrameFor = (id: string): BucketGroupFrame => groupFrames.value[id] ?? {
    paddingX: 36,
    paddingTop: 42,
    paddingBottom: 28,
    minWidth: 320,
    minHeight: 120,
  }

  const metrics = computed(() => {
    const result = new Map<string, BucketAllocationMetric>()

    const distribute = (node: BucketPrototypeNode, receivedMinor: number, remainingAfterMinor = receivedMinor) => {
      const metric: BucketAllocationMetric = {
        grossReceivedMinor: receivedMinor,
        receivedMinor,
        remainingAfterMinor,
        unallocatedMinor: receivedMinor,
        redirectedInMinor: 0,
        redirectedOutMinor: 0,
      }
      result.set(node.id, metric)

      if (!node.children?.length) return

      let remaining = receivedMinor
      for (const child of node.children) {
        const splitOffer = node.connectionMode === 'branch' && child.distributionPercentage !== undefined
          ? Math.round(receivedMinor * child.distributionPercentage / 100)
          : null
        const requested = splitOffer !== null
          ? child.allocationKind === 'fixed'
            ? Math.min(splitOffer, child.allocationValue ?? splitOffer)
            : splitOffer
          : child.allocationKind === 'percentage'
            ? Math.round(receivedMinor * (child.allocationValue ?? 0) / 100)
            : child.allocationKind === 'remainder'
              ? remaining
              : child.allocationValue ?? 0
        const allocation = Math.max(0, Math.min(remaining, requested))
        remaining -= allocation
        distribute(child, allocation, node.connectionMode === 'series' ? remaining : allocation)
      }
      metric.unallocatedMinor = remaining
    }

    const root = buckets.value[0]
    if (root) distribute(root, scenarioMinor.value, 0)

    for (const { node } of flatNodes.value) {
      const rule = node.conditionalRedirect
      const nodeMetric = result.get(node.id)
      const targetNode = rule ? findNode(rule.targetId) : null
      const targetMetric = targetNode ? result.get(targetNode.id) : null
      if (!rule || !nodeMetric || !targetNode || !targetMetric) continue

      const targetPositionMinor = targetNode.currentMinor + targetMetric.receivedMinor
      const targetShortfallMinor = Math.max(0, rule.thresholdMinor - targetPositionMinor)
      const requestedRedirectMinor = Math.round(nodeMetric.grossReceivedMinor * rule.percentage / 100)
      const redirectedMinor = Math.min(nodeMetric.receivedMinor, targetShortfallMinor, requestedRedirectMinor)
      if (redirectedMinor <= 0) continue

      nodeMetric.receivedMinor -= redirectedMinor
      nodeMetric.unallocatedMinor = Math.max(0, nodeMetric.unallocatedMinor - redirectedMinor)
      nodeMetric.redirectedOutMinor += redirectedMinor
      targetMetric.receivedMinor += redirectedMinor
      targetMetric.unallocatedMinor += redirectedMinor
      targetMetric.redirectedInMinor += redirectedMinor
    }

    return result
  })

  const metricFor = (nodeOrId: BucketPrototypeNode | string) => {
    const id = typeof nodeOrId === 'string' ? nodeOrId : nodeOrId.id
    return metrics.value.get(id) ?? {
      grossReceivedMinor: 0,
      receivedMinor: 0,
      remainingAfterMinor: 0,
      unallocatedMinor: 0,
      redirectedInMinor: 0,
      redirectedOutMinor: 0,
    }
  }

  const edges = computed<BucketPrototypeEdge[]>(() => {
    const result: BucketPrototypeEdge[] = []

    const collect = (node: BucketPrototypeNode) => {
      const children = node.children ?? []
      if (children.length) {
        if (node.connectionMode === 'series') {
          result.push({
            id: `${node.id}-${children[0]!.id}`,
            sourceId: node.id,
            targetId: children[0]!.id,
            amountMinor: metricFor(node).grossReceivedMinor,
            kind: 'series',
          })
          for (let index = 1; index < children.length; index += 1) {
            const source = children[index - 1]!
            const target = children[index]!
            result.push({
              id: `${source.id}-${target.id}`,
              sourceId: source.id,
              targetId: target.id,
              amountMinor: metricFor(source).remainingAfterMinor,
              kind: 'series',
            })
          }
        } else {
          for (const child of children) {
            result.push({
              id: `${node.id}-${child.id}`,
              sourceId: node.id,
              targetId: child.id,
              amountMinor: metricFor(child).grossReceivedMinor,
              kind: 'branch',
            })
          }
        }
      }
      for (const child of children) collect(child)

      if (node.conditionalRedirect) {
        const redirectedMinor = metricFor(node).redirectedOutMinor
        if (redirectedMinor > 0) {
          result.push({
            id: `rule-${node.id}-${node.conditionalRedirect.targetId}`,
            sourceId: node.id,
            targetId: node.conditionalRedirect.targetId,
            amountMinor: redirectedMinor,
            kind: 'rule',
          })
        }
      }
    }

    for (const root of buckets.value) collect(root)
    return result
  })

  const flowReport = computed<BucketFlowReportEntry[]>(() => {
    const entries: BucketFlowReportEntry[] = []
    let step = 0
    const push = (entry: Omit<BucketFlowReportEntry, 'step'>) => {
      step += 1
      entries.push({ ...entry, step })
    }

    const visit = (
      node: BucketPrototypeNode,
      parent: BucketPrototypeNode | null,
    ) => {
      const metric = metricFor(node)

      if (!parent) {
        push({
          id: `${node.id}-source`,
          subject: node.name,
          detail: 'Scenario source enters the model',
          openingMinor: node.currentMinor,
          movementMinor: metric.grossReceivedMinor,
          closingMinor: node.currentMinor + metric.grossReceivedMinor,
          kind: 'source',
        })
      } else if (parent.connectionMode === 'series' && node.kind === 'expense') {
        push({
          id: `${node.id}-expense`,
          subject: node.name,
          detail: node.expenseMode === 'budget' ? 'Expense budget reserved in sequence' : 'Fixed expense deducted in sequence',
          openingMinor: metric.grossReceivedMinor + metric.remainingAfterMinor,
          movementMinor: -metric.grossReceivedMinor,
          closingMinor: metric.remainingAfterMinor,
          kind: node.expenseMode === 'budget' ? 'budget' : 'expense',
        })
      } else {
        const baseReceivedMinor = metric.grossReceivedMinor
        push({
          id: `${node.id}-allocation`,
          subject: node.name,
          detail: node.presentation === 'group'
            ? 'Named group receives the flow entering its contained nodes'
            : node.allocationKind === 'remainder'
              ? 'Receives the available remainder'
              : node.distributionPercentage !== undefined
                ? `Receives a ${node.distributionPercentage}% sibling share`
                : node.method,
          openingMinor: node.currentMinor,
          movementMinor: baseReceivedMinor,
          closingMinor: node.currentMinor + baseReceivedMinor,
          kind: node.presentation === 'group'
            ? 'group'
            : node.allocationKind === 'remainder'
              ? 'remainder'
              : node.expenseMode === 'budget'
                ? 'budget'
                : node.kind === 'expense'
                  ? 'expense'
                  : 'allocation',
        })
      }

      for (const child of node.children ?? []) visit(child, node)

      if (node.conditionalRedirect && metric.redirectedOutMinor > 0) {
        const target = findNode(node.conditionalRedirect.targetId)
        const targetMetric = target ? metricFor(target) : null
        push({
          id: `${node.id}-rule-out`,
          subject: node.name,
          detail: `${node.conditionalRedirect.percentage}% protection rule routes to ${target?.name ?? 'target bucket'}`,
          openingMinor: node.currentMinor + metric.grossReceivedMinor,
          movementMinor: -metric.redirectedOutMinor,
          closingMinor: node.currentMinor + metric.receivedMinor,
          kind: 'rule',
        })
        if (target && targetMetric) {
          push({
            id: `${node.id}-rule-in-${target.id}`,
            subject: target.name,
            detail: `Receives conditional allocation from ${node.name}`,
            openingMinor: target.currentMinor + targetMetric.grossReceivedMinor,
            movementMinor: metric.redirectedOutMinor,
            closingMinor: target.currentMinor + targetMetric.receivedMinor,
            kind: 'rule',
          })
        }
      }
    }

    for (const root of buckets.value) visit(root, null)
    return entries
  })

  const setScenarioRands = (value: number) => {
    const safeValue = Number.isFinite(value) ? Math.max(0, Math.min(100_000_000, value)) : 0
    scenarioMinor.value = Math.round(safeValue * 100)
  }

  const selectNode = (id: string) => {
    if (!findNode(id)) return
    selectedId.value = id
    inspectorOpen.value = true
  }

  const moveNode = (id: string, x: number, y: number) => {
    if (!positions.value[id]) return
    positions.value[id] = {
      x: Math.max(20, Math.round(x / 20) * 20),
      y: Math.max(20, Math.round(y / 20) * 20),
    }
  }

  const moveGroup = (id: string, x: number, y: number) => {
    const node = findNode(id)
    const current = positions.value[id]
    if (!node || node.presentation !== 'group' || !current) return

    const next = {
      x: Math.max(20, Math.round(x / 20) * 20),
      y: Math.max(20, Math.round(y / 20) * 20),
    }
    const delta = {
      x: next.x - current.x,
      y: next.y - current.y,
    }
    positions.value[id] = next

    const shiftDescendants = (descendants: BucketPrototypeNode[]) => {
      for (const descendant of descendants) {
        const position = positions.value[descendant.id]
        if (position) {
          positions.value[descendant.id] = {
            x: Math.max(20, position.x + delta.x),
            y: Math.max(20, position.y + delta.y),
          }
        }
        if (descendant.children?.length) shiftDescendants(descendant.children)
      }
    }
    shiftDescendants(node.children ?? [])
  }

  const renameNode = (id: string, name: string) => {
    const node = findNode(id)
    if (node && name.trim()) node.name = name.trim()
  }

  const setAllocationValue = (id: string, value: number) => {
    const node = findNode(id)
    if (!node || node.allocationKind === 'source' || node.allocationKind === 'remainder') return
    node.allocationValue = Math.max(0, Math.round(value))
    if (node.allocationKind === 'fixed') {
      node.method = node.expenseMode === 'budget'
        ? `Monthly budget ${formatPrototypeMinor(node.allocationValue)}`
        : `Fixed ${formatPrototypeMinor(node.allocationValue)}`
    }
  }

  const setDisplayMode = (id: string, displayMode: BucketPrototypeDisplayMode) => {
    const node = findNode(id)
    if (node) node.displayMode = displayMode
  }

  const setExpenseMode = (id: string, expenseMode: BucketPrototypeExpenseMode) => {
    const node = findNode(id)
    if (!node || node.kind !== 'expense') return
    node.expenseMode = expenseMode
    node.tone = expenseMode === 'budget' ? 'warning' : 'default'
    node.state = expenseMode === 'budget' ? 'Budgeted' : 'Draft'
    node.method = expenseMode === 'budget'
      ? `Monthly budget ${formatPrototypeMinor(node.allocationValue ?? 0)}`
      : `Fixed ${formatPrototypeMinor(node.allocationValue ?? 0)}`
  }

  const setExpenseLifecycle = (id: string, expenseLifecycle: BucketPrototypeExpenseLifecycle) => {
    const node = findNode(id)
    if (!node || node.kind !== 'expense') return
    node.expenseLifecycle = expenseLifecycle
    if (expenseLifecycle === 'recurring') {
      node.recurrenceDay ??= 1
      node.state = node.expenseMode === 'budget' ? 'Budgeted monthly' : 'Recurring'
    } else if (expenseLifecycle === 'payoff') {
      node.targetMinor ??= node.allocationValue ?? 0
      node.state = 'Payoff'
    } else {
      node.state = node.expenseMode === 'budget' ? 'Budgeted' : 'One-off'
    }
  }

  const setRecurrenceDay = (id: string, day: number) => {
    const node = findNode(id)
    if (!node || node.kind !== 'expense') return
    node.recurrenceDay = Math.max(1, Math.min(31, Math.round(day)))
  }

  const setExpenseTarget = (id: string, valueMinor: number) => {
    const node = findNode(id)
    if (!node || node.kind !== 'expense') return
    node.targetMinor = Math.max(0, Math.round(valueMinor))
  }

  const layoutGroupChildren = (node: BucketPrototypeNode) => {
    const anchor = positions.value[node.id] ?? { x: 490, y: 170 }
    const children = node.children ?? []
    const regularChildren = children.filter(child => child.allocationKind !== 'remainder')
    const remainderChildren = children.filter(child => child.allocationKind === 'remainder')
    const placeChild = (child: BucketPrototypeNode, target: BucketCanvasPosition) => {
      const current = positions.value[child.id] ?? target
      const delta = { x: target.x - current.x, y: target.y - current.y }
      const shift = (item: BucketPrototypeNode) => {
        const position = positions.value[item.id]
        if (position) {
          positions.value[item.id] = {
            x: Math.max(20, position.x + delta.x),
            y: Math.max(20, position.y + delta.y),
          }
        }
        for (const descendant of item.children ?? []) shift(descendant)
      }
      shift(child)
    }

    if (node.connectionMode === 'branch') {
      regularChildren.forEach((child, index) => {
        placeChild(child, {
          x: anchor.x - 70 + (index % 2) * 300,
          y: anchor.y + 100 + Math.floor(index / 2) * 100,
        })
      })
      remainderChildren.forEach((child, index) => {
        placeChild(child, {
          x: anchor.x + 80,
          y: anchor.y + 100 + Math.ceil(regularChildren.length / 2) * 100 + index * 100,
        })
      })
    } else {
      children.forEach((child, index) => {
        placeChild(child, {
          x: anchor.x + 40,
          y: anchor.y + 80 + index * 90,
        })
      })
    }
  }

  const setConnectionMode = (id: string, connectionMode: BucketPrototypeConnectionMode) => {
    const node = findNode(id)
    if (!node?.children?.length) return
    node.connectionMode = connectionMode
    if (node.presentation !== 'group') {
      node.state = connectionMode === 'branch' ? 'Split flow' : 'In sequence'
      node.method = connectionMode === 'branch' ? 'Sibling distribution' : 'Sequential remainder'
    }
    const executionRule = node.rules.find(rule => rule.id === 'expenses-series')
    if (executionRule) {
      executionRule.title = connectionMode === 'branch'
        ? 'Distribute input across sibling allocations'
        : 'Process expenses from top to bottom'
      executionRule.detail = connectionMode === 'branch'
        ? 'Each sibling receives its configured share; fixed amounts and budgets cap the allocation'
        : 'Each step sees the remaining value'
    }

    if (connectionMode === 'branch') {
      const children = node.children.filter(child => child.allocationKind !== 'remainder')
      const base = Math.floor(100 / Math.max(1, children.length))
      let assigned = 0
      children.forEach((child, index) => {
        const percentage = index === children.length - 1 ? 100 - assigned : base
        child.distributionPercentage = percentage
        assigned += percentage
      })
    }
    layoutGroupChildren(node)
  }

  const rebalanceChildren = (parent: BucketPrototypeNode) => {
    const children = (parent.children ?? []).filter(child => child.allocationKind !== 'remainder')
    if (!children.length) return
    const base = Math.floor(100 / children.length)
    let assigned = 0
    children.forEach((child, index) => {
      const percentage = index === children.length - 1 ? 100 - assigned : base
      child.distributionPercentage = percentage
      assigned += percentage
    })
  }

  const setChildDistribution = (parentId: string, childId: string, value: number) => {
    const parent = findNode(parentId)
    if (!parent?.children?.length || parent.connectionMode !== 'branch') return
    const siblings = parent.children.filter(child => child.allocationKind !== 'remainder')
    const child = siblings.find(node => node.id === childId)
    if (!child) return

    const nextValue = Math.max(0, Math.min(100, Math.round(value)))
    child.distributionPercentage = nextValue
    const others = siblings.filter(node => node.id !== childId)
    if (!others.length) {
      child.distributionPercentage = 100
      return
    }

    const remainder = 100 - nextValue
    const existingTotal = others.reduce((total, node) => total + (node.distributionPercentage ?? 0), 0)
    let assigned = 0
    others.forEach((node, index) => {
      const percentage = index === others.length - 1
        ? remainder - assigned
        : existingTotal > 0
          ? Math.round(remainder * (node.distributionPercentage ?? 0) / existingTotal)
          : Math.floor(remainder / others.length)
      node.distributionPercentage = Math.max(0, percentage)
      assigned += node.distributionPercentage
    })
  }

  const toggleNode = (id: string) => {
    collapsedIds.value = collapsedIds.value.includes(id)
      ? collapsedIds.value.filter(value => value !== id)
      : [...collapsedIds.value, id]
  }

  const containsNode = (node: BucketPrototypeNode, id: string): boolean =>
    node.id === id || Boolean(node.children?.some(child => containsNode(child, id)))

  const detachNode = (nodes: BucketPrototypeNode[], id: string): BucketPrototypeNode | null => {
    const index = nodes.findIndex(node => node.id === id)
    if (index >= 0) return nodes.splice(index, 1)[0] ?? null
    for (const node of nodes) {
      if (!node.children) continue
      const detached = detachNode(node.children, id)
      if (detached) return detached
    }
    return null
  }

  const findContainer = (nodes: BucketPrototypeNode[], id: string): BucketPrototypeNode[] | null => {
    if (nodes.some(node => node.id === id)) return nodes
    for (const node of nodes) {
      if (!node.children) continue
      const container = findContainer(node.children, id)
      if (container) return container
    }
    return null
  }

  const moveBefore = (sourceId: string, targetId: string) => {
    if (sourceId === targetId || sourceId === 'plan') return
    const source = findNode(sourceId)
    if (!source || containsNode(source, targetId)) return
    const sourceContainer = findContainer(buckets.value, sourceId)
    const targetContainer = findContainer(buckets.value, targetId)
    if (!sourceContainer || !targetContainer) return
    const detached = detachNode(buckets.value, sourceId)
    if (!detached) return
    const targetIndex = targetContainer.findIndex(node => node.id === targetId)
    if (targetIndex < 0) {
      sourceContainer.push(detached)
      return
    }
    targetContainer.splice(targetIndex, 0, detached)
  }

  const setParent = (nodeId: string, parentId: string) => {
    if (nodeId === 'plan' || nodeId === parentId) return
    const location = findLocation(nodeId)
    const parent = findNode(parentId)
    if (!location || !parent || containsNode(location.node, parentId)) return
    if (location.parent?.id === parentId) return

    const oldParent = location.parent
    const detached = detachNode(buckets.value, nodeId)
    if (!detached) return
    parent.children ??= []
    parent.children.push(detached)

    if ((oldParent?.children?.length ?? 0) > 1 && oldParent?.connectionMode === 'branch') {
      rebalanceChildren(oldParent)
    }
    if (parent.children.length > 1) {
      parent.connectionMode = 'branch'
      rebalanceChildren(parent)
    } else {
      parent.connectionMode ??= 'series'
      detached.distributionPercentage = undefined
    }

    const parentPosition = positions.value[parent.id] ?? { x: 420, y: 120 }
    const currentPosition = positions.value[nodeId] ?? parentPosition
    const siblingIndex = parent.children.findIndex(child => child.id === nodeId)
    const targetPosition = {
      x: parentPosition.x + Math.max(-280, Math.min(280, (siblingIndex - (parent.children.length - 1) / 2) * 280)),
      y: parentPosition.y + 110,
    }
    const delta = {
      x: targetPosition.x - currentPosition.x,
      y: targetPosition.y - currentPosition.y,
    }
    const shift = (node: BucketPrototypeNode) => {
      const position = positions.value[node.id]
      if (position) {
        positions.value[node.id] = {
          x: Math.max(20, Math.round((position.x + delta.x) / 20) * 20),
          y: Math.max(20, Math.round((position.y + delta.y) / 20) * 20),
        }
      }
      for (const child of node.children ?? []) shift(child)
    }
    shift(detached)
  }

  const setGroupPadding = (id: string, axis: 'horizontal' | 'vertical', value: number) => {
    const node = findNode(id)
    if (node?.presentation !== 'group') return
    const frame = { ...groupFrameFor(id) }
    const safeValue = Math.max(12, Math.min(160, Math.round(value)))
    if (axis === 'horizontal') frame.paddingX = safeValue
    else {
      frame.paddingTop = safeValue
      frame.paddingBottom = safeValue
    }
    groupFrames.value[id] = frame
  }

  const resizeGroup = (id: string, width: number, height: number) => {
    const node = findNode(id)
    if (node?.presentation !== 'group') return
    const frame = { ...groupFrameFor(id) }
    frame.minWidth = Math.max(260, Math.round(width / 20) * 20)
    frame.minHeight = Math.max(84, Math.round(height / 20) * 20)
    groupFrames.value[id] = frame
  }

  let draftSequence = 0

  function formatPrototypeMinor(value: number) {
    return new Intl.NumberFormat('en-ZA', {
      style: 'currency',
      currency: 'ZAR',
      currencyDisplay: 'narrowSymbol',
      maximumFractionDigits: 0,
    }).format(value / 100)
  }

  const createDraftNode = (kind: BucketPrototypeCreateKind): BucketPrototypeNode => {
    draftSequence += 1
    const id = `draft-${kind}-${Date.now()}-${draftSequence}`
    const isExpense = kind === 'expense' || kind === 'budget'
    const isBudget = kind === 'budget'
    return {
      id,
      name: isBudget ? 'New expense budget' : isExpense ? 'New expense' : 'New bucket',
      kind: isExpense ? 'expense' : 'accumulator',
      description: isBudget
        ? 'A monthly spending boundary in this app-local model.'
        : isExpense
          ? 'A fixed monthly expense in this app-local model.'
          : 'A new retained allocation in this app-local model.',
      method: isBudget ? 'Monthly budget R0' : isExpense ? 'Fixed R0' : 'Fixed allocation R0',
      allocationKind: 'fixed',
      allocationValue: 0,
      currentMinor: 0,
      state: 'Draft',
      tone: isBudget ? 'warning' : isExpense ? 'default' : 'accent',
      displayMode: 'inline',
      expenseMode: isExpense ? (isBudget ? 'budget' : 'fixed') : undefined,
      expenseLifecycle: isExpense ? 'one-off' : undefined,
      rules: [{
        id: `${id}-allocation`,
        title: isBudget ? 'Reserve a monthly budget' : isExpense ? 'Allocate a fixed expense' : 'Retain an allocation',
        detail: 'Set the amount in the inspector; this remains planning state and is not observed money.',
      }],
    }
  }

  const addNodeFrom = (
    sourceId: string,
    direction: BucketPrototypeCreateDirection,
    kind: BucketPrototypeCreateKind,
  ) => {
    const sourceLocation = findLocation(sourceId)
    const sourcePosition = positions.value[sourceId]
    if (!sourceLocation || !sourcePosition) return

    const node = createDraftNode(kind)
    const sideSibling = direction === 'left' || direction === 'right'
    const verticalSibling = direction === 'top'
    const shouldNest = direction === 'bottom' || (!sourceLocation.parent && !sideSibling && !verticalSibling)

    if (shouldNest) {
      sourceLocation.node.children ??= []
      sourceLocation.node.connectionMode ??= 'branch'
      sourceLocation.node.children.push(node)
    } else if (!sourceLocation.parent && sourceLocation.node.id === 'plan') {
      sourceLocation.node.children ??= []
      const insertionIndex = direction === 'left' || direction === 'top' ? 0 : sourceLocation.node.children.length
      sourceLocation.node.children.splice(insertionIndex, 0, node)
    } else {
      const insertionIndex = direction === 'left' || direction === 'top'
        ? sourceLocation.index
        : sourceLocation.index + 1
      sourceLocation.container.splice(insertionIndex, 0, node)
    }

    const offsets: Record<BucketPrototypeCreateDirection, BucketCanvasPosition> = {
      top: { x: 0, y: -90 },
      right: { x: 280, y: 0 },
      bottom: { x: 0, y: 100 },
      left: { x: -280, y: 0 },
    }
    const offset = offsets[direction]
    positions.value[node.id] = {
      x: Math.max(20, sourcePosition.x + offset.x),
      y: Math.max(20, sourcePosition.y + offset.y),
    }
    selectNode(node.id)
  }

  const addExpenseNode = () => {
    const parent = findNode('expenses') ?? findNode('plan')
    if (!parent) return
    parent.children ??= []
    const bufferIndex = parent.children.findIndex(node => node.id === 'buffer')
    const id = `expense-${Date.now()}`
    const node: BucketPrototypeNode = {
      id,
      name: 'New expense',
      kind: 'expense',
      description: 'A new local planning expense step.',
      method: 'Fixed R0',
      allocationKind: 'fixed',
      allocationValue: 0,
      currentMinor: 0,
      state: 'Draft',
      tone: 'muted',
      displayMode: 'inline',
      expenseMode: 'fixed',
      expenseLifecycle: 'one-off',
      rules: [{ id: `${id}-fixed`, title: 'Allocate R0', detail: 'Edit the amount in the inspector later' }],
    }
    const insertAt = bufferIndex >= 0 ? bufferIndex : parent.children.length
    parent.children.splice(insertAt, 0, node)

    const parentPosition = positions.value[parent.id] ?? { x: 370, y: 48 }
    const bufferPosition = positions.value.buffer ?? {
      x: parentPosition.x,
      y: parentPosition.y + 120 + parent.children.length * 90,
    }
    positions.value[id] = { x: bufferPosition.x, y: bufferPosition.y }
    if (positions.value.buffer) {
      positions.value.buffer = { x: bufferPosition.x, y: bufferPosition.y + 90 }
    }
    const playPosition = positions.value.play
    if (playPosition) positions.value.play = { x: playPosition.x, y: playPosition.y + 90 }
    selectNode(id)
  }

  const resetPrototype = () => {
    buckets.value = seedBuckets()
    positions.value = seedPositions()
    groupFrames.value = seedGroupFrames()
    scenarioMinor.value = 0
    selectedId.value = 'plan'
    inspectorOpen.value = true
    collapsedIds.value = []
    viewMode.value = 'nodes'
  }

  return {
    buckets,
    scenarioMinor,
    viewMode,
    selectedId,
    inspectorOpen,
    collapsedIds,
    positions,
    groupFrames,
    flatNodes,
    selectedBucket,
    selectedParent,
    metrics,
    edges,
    flowReport,
    findNode,
    parentOptionsFor,
    groupFrameFor,
    metricFor,
    setScenarioRands,
    selectNode,
    moveNode,
    moveGroup,
    renameNode,
    setAllocationValue,
    setDisplayMode,
    setExpenseMode,
    setExpenseLifecycle,
    setRecurrenceDay,
    setExpenseTarget,
    setConnectionMode,
    setChildDistribution,
    toggleNode,
    setParent,
    setGroupPadding,
    resizeGroup,
    moveBefore,
    addNodeFrom,
    addExpenseNode,
    resetPrototype,
  }
})
