# Visualization Architecture - Technical Implementation

## Overview
Technical architecture for implementing the dual-view system (Tree + Flow) using Vue Flow as the primary visualization library, integrated with Nuxt 4 and synchronized state management.

## Technology Stack

### Core Visualization
```typescript
// Primary library
import { VueFlow, useVueFlow } from '@vue-flow/core'
import { Background } from '@vue-flow/background'
import { Controls } from '@vue-flow/controls'
import { MiniMap } from '@vue-flow/minimap'

// Layout engine
import ELK from 'elkjs/lib/elk.bundled.js'
```

### Supporting Libraries
- **@vue-flow/core**: Vue 3 flow graph editor
- **elkjs**: Layered graph layout (for DAG organization)
- **@vueuse/core**: Composables for interactions
- **animejs**: Smooth animations for particles
- **@formkit/auto-animate**: Automatic transitions

## Data Structure

### Unified Bucket Model
```typescript
// Enhanced for visualization
interface VisualBucket extends Bucket {
  // Position in flow diagram
  position: {
    x: number
    y: number
  }
  
  // Visual properties
  dimensions: {
    width: number
    height: number
  }
  
  // Node type for rendering
  nodeType: 'income' | 'precut' | 'hub' | 'bucket' | 'envelope'
  
  // Calculated flow data
  flowData: {
    incomingAmount: number
    outgoingFlows: {
      targetId: string
      amount: number
      percentage: number
    }[]
  }
}
```

### Flow Graph Structure
```typescript
interface FlowGraph {
  nodes: FlowNode[]
  edges: FlowEdge[]
  layout: LayoutConfig
}

interface FlowNode {
  id: string
  type: string
  position: { x: number; y: number }
  data: {
    bucket: VisualBucket
    amount: number
    percentage: number
    isExpanded: boolean
  }
  style: NodeStyle
}

interface FlowEdge {
  id: string
  source: string
  target: string
  type: 'flow' | 'rule' | 'overflow'
  data: {
    amount: number
    isActive: boolean
    rule?: Rule
  }
  animated: boolean
  style: EdgeStyle
}
```

## State Management

### Pinia Store Structure
```typescript
export const useVisualizationStore = defineStore('visualization', {
  state: () => ({
    // Current view mode
    viewMode: 'tree' | 'flow' | 'split',
    
    // Canvas mode
    canvasMode: 'build' | 'simulate' | 'reconcile',
    
    // Flow diagram state
    flowGraph: null as FlowGraph | null,
    zoom: 1,
    center: { x: 0, y: 0 },
    
    // Selection & interaction
    selectedNodeId: null as string | null,
    hoveredNodeId: null as string | null,
    draggedNode: null as FlowNode | null,
    pinnedNodes: new Set<string>(),
    
    // Animation state
    animationsEnabled: true,
    flowAnimationSpeed: 1,
    particleSystem: null as ParticleSystem | null,
    
    // Layout preferences
    layoutAlgorithm: 'hierarchical' | 'swimlane' | 'force',
    showMinimap: true,
    
    // What-if mode
    isWhatIfMode: false,
    whatIfChanges: new Map<string, any>(),
    
    // Reconciliation
    reconciliationActive: false,
    reconciliationSuggestions: []
  }),
  
  getters: {
    // Computed flow from buckets
    flowNodes: (state) => {
      return computeFlowNodes(state.buckets, state.layoutAlgorithm)
    },
    
    flowEdges: (state) => {
      return computeFlowEdges(state.buckets, state.rules)
    }
  },
  
  actions: {
    // Synchronize with bucket store
    syncFromBuckets() {
      this.flowGraph = buildFlowGraph(useBucketStore().buckets)
    },
    
    // Handle node updates
    updateNodePosition(nodeId: string, position: Position) {
      // Update position
      // Persist layout
      // Sync to bucket if needed
    }
  }
})
```

## Component Architecture

### Main Visualization Component
```vue
<template>
  <div class="visualization-container">
    <!-- View Mode Switcher -->
    <ViewModeSwitcher v-model="viewMode" />
    
    <!-- Tree View -->
    <Transition name="fade-slide">
      <TreeView 
        v-if="viewMode === 'tree' || viewMode === 'split'"
        :class="{ 'w-1/2': viewMode === 'split' }"
      />
    </Transition>
    
    <!-- Flow View -->
    <Transition name="fade-slide">
      <FlowView 
        v-if="viewMode === 'flow' || viewMode === 'split'"
        :class="{ 'w-1/2': viewMode === 'split' }"
      />
    </Transition>
  </div>
</template>
```

### Flow View Component
```vue
<template>
  <div class="flow-view">
    <VueFlow
      v-model="elements"
      :default-zoom="1"
      :min-zoom="0.2"
      :max-zoom="4"
      @node-drag-stop="handleNodeDragStop"
      @edge-click="handleEdgeClick"
    >
      <!-- Custom node types -->
      <template #node-income="props">
        <IncomeNode v-bind="props" />
      </template>
      
      <template #node-bucket="props">
        <BucketNode v-bind="props" />
      </template>
      
      <template #node-envelope="props">
        <EnvelopeNode v-bind="props" />
      </template>
      
      <!-- Background and controls -->
      <Background variant="dots" />
      <Controls />
      <MiniMap />
      
      <!-- Custom overlays -->
      <FlowAnimationLayer v-if="animationsEnabled" />
      <AllocationLedger v-if="selectedEdge" />
    </VueFlow>
  </div>
</template>
```

### Custom Node Components
```vue
<!-- BucketNode.vue -->
<template>
  <div 
    class="bucket-node"
    :class="[
      bucket.type,
      { 
        'is-selected': isSelected,
        'is-hovering': isHovering,
        'is-full': bucket.isFull
      }
    ]"
    @mouseenter="isHovering = true"
    @mouseleave="isHovering = false"
  >
    <!-- Header -->
    <div class="bucket-header">
      <Icon :name="bucket.icon" />
      <span class="bucket-name">{{ bucket.name }}</span>
      <span class="bucket-percentage">({{ percentage }}%)</span>
    </div>
    
    <!-- Amount Display -->
    <div class="bucket-amount">
      <AnimatedNumber :value="amount" format="currency" />
    </div>
    
    <!-- Progress Bar -->
    <div v-if="bucket.target" class="bucket-progress">
      <div 
        class="progress-fill" 
        :style="{ width: progressPercentage + '%' }"
      />
      <span class="progress-label">{{ progressPercentage }}%</span>
    </div>
    
    <!-- Overflow Indicator -->
    <div v-if="hasOverflow" class="overflow-indicator">
      <Icon name="arrow-down" />
      <span>Overflow</span>
    </div>
  </div>
</template>
```

## Layout Algorithms

### ELK.js Hierarchical Layout (Primary)
```typescript
// Web Worker for layout calculation
// layout.worker.ts
import ELK from 'elkjs/lib/elk.bundled.js'

const elk = new ELK()

self.addEventListener('message', async (event) => {
  const { nodes, edges, options } = event.data
  
  const elkGraph = {
    id: 'root',
    layoutOptions: {
      'elk.algorithm': 'layered',
      'elk.direction': 'DOWN',
      'elk.spacing.nodeNode': '50',
      'elk.layered.spacing.edgeNodeBetweenLayers': '50',
      'elk.layered.crossingMinimization.strategy': 'LAYER_SWEEP'
    },
    children: nodes.map(node => ({
      id: node.id,
      width: node.width || 200,
      height: node.height || 100,
      layoutOptions: node.pinned ? {
        'elk.position': `(${node.x},${node.y})`
      } : {}
    })),
    edges: edges.map(edge => ({
      id: edge.id,
      sources: [edge.source],
      targets: [edge.target]
    }))
  }
  
  const layout = await elk.layout(elkGraph)
  self.postMessage({ layout })
})
```

### Swimlane Layout
```typescript
function swimlaneLayout(nodes: FlowNode[], edges: FlowEdge[]): Layout {
  const lanes = {
    'income': 0,
    'precut': 100,
    'essentials': 200,
    'protection': 300,
    'debts': 400,
    'goals': 500,
    'play': 600
  }
  
  // Group nodes by type/category
  const grouped = groupBy(nodes, node => node.data.bucket.category)
  
  // Position within lanes
  Object.entries(grouped).forEach(([category, nodes]) => {
    const laneY = lanes[category] || 700
    const spacing = width / (nodes.length + 1)
    
    nodes.forEach((node, index) => {
      if (!node.data.pinned) {
        node.position = {
          x: spacing * (index + 1),
          y: laneY
        }
      }
    })
  })
  
  return { nodes, edges }
}
```

## Animation System

### Money Flow Animation
```typescript
class FlowAnimationController {
  private particles: Particle[] = []
  private animationFrame: number | null = null
  
  startFlow(edge: FlowEdge, amount: number) {
    const particleCount = Math.ceil(amount / 1000) // 1 particle per R1000
    const particles = this.createParticles(edge, particleCount)
    
    this.particles.push(...particles)
    this.animate()
  }
  
  private createParticles(edge: FlowEdge, count: number): Particle[] {
    return Array.from({ length: count }, (_, i) => ({
      id: `particle-${Date.now()}-${i}`,
      edge,
      progress: 0,
      delay: i * 100, // Stagger
      speed: 0.02,
      size: edge.data.amount > 10000 ? 'large' : 'small',
      color: this.getParticleColor(edge)
    }))
  }
  
  private getParticleColor(edge: FlowEdge): string {
    // Color based on flow type
    const colorMap = {
      'income': '#10b981',      // Green
      'precut': '#f59e0b',      // Amber
      'essential': '#3b82f6',   // Blue
      'debt': '#ef4444',        // Red
      'goal': '#8b5cf6',        // Purple
      'play': '#ec4899',        // Pink
      'overflow': '#6b7280'     // Gray
    }
    return colorMap[edge.data.flowType] || '#3b82f6'
  }
  
  private animate() {
    this.particles.forEach(particle => {
      particle.progress += particle.speed
      
      // Add physics for more natural movement
      const easedProgress = this.easeInOutQuad(particle.progress)
      particle.position = this.interpolatePosition(particle.edge, easedProgress)
      
      if (particle.progress >= 1) {
        // Trigger arrival effect
        this.createArrivalEffect(particle)
        // Remove completed particle
        this.particles = this.particles.filter(p => p.id !== particle.id)
      }
    })
    
    if (this.particles.length > 0) {
      this.animationFrame = requestAnimationFrame(() => this.animate())
    }
  }
  
  private easeInOutQuad(t: number): number {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
  }
  
  private createArrivalEffect(particle: Particle) {
    // Create ripple effect at destination
    const target = particle.edge.target
    this.emitEvent('particle-arrived', { 
      nodeId: target, 
      amount: particle.size === 'large' ? 1000 : 100 
    })
  }
}
```

### Transition Animations
```typescript
// Using @formkit/auto-animate
import { autoAnimate } from '@formkit/auto-animate'

// In component
onMounted(() => {
  if (containerRef.value) {
    autoAnimate(containerRef.value, {
      duration: 300,
      easing: 'ease-out'
    })
  }
})
```

## Performance Optimization

### Viewport Culling & Progressive Detail
```typescript
const useViewportOptimization = () => {
  const { viewport } = useVueFlow()
  const zoomLevel = computed(() => viewport.value.zoom)
  
  const visibleElements = computed(() => {
    const padding = 100 // Render slightly outside viewport
    const bounds = {
      left: viewport.value.x - padding,
      top: viewport.value.y - padding,
      right: viewport.value.x + viewport.value.width + padding,
      bottom: viewport.value.y + viewport.value.height + padding
    }
    
    // Filter nodes in viewport
    const visibleNodes = nodes.value.filter(node => {
      return isInBounds(node.position, node.dimensions, bounds)
    })
    
    // Filter edges with at least one visible endpoint
    const visibleNodeIds = new Set(visibleNodes.map(n => n.id))
    const visibleEdges = edges.value.filter(edge => {
      return visibleNodeIds.has(edge.source) || visibleNodeIds.has(edge.target)
    })
    
    return { nodes: visibleNodes, edges: visibleEdges }
  })
  
  // Level of detail based on zoom
  const detailLevel = computed(() => {
    if (zoomLevel.value < 0.5) return 'minimal'
    if (zoomLevel.value < 1) return 'reduced'
    return 'full'
  })
  
  return { visibleElements, detailLevel }
}
```

### Debounced Updates
```typescript
const useOptimizedSync = () => {
  // Debounce layout recalculation
  const debouncedLayout = useDebounceFn(() => {
    recalculateLayout()
  }, 300)
  
  // Batch state updates
  const pendingUpdates = ref<Map<string, any>>(new Map())
  const flushUpdates = useDebounceFn(() => {
    if (pendingUpdates.value.size > 0) {
      batchUpdate(pendingUpdates.value)
      pendingUpdates.value.clear()
    }
  }, 100)
  
  // Throttle expensive operations
  const throttledParticleUpdate = useThrottleFn(() => {
    updateParticleSystem()
  }, 16) // 60fps
  
  return { debouncedLayout, flushUpdates, throttledParticleUpdate }
}
```

### Web Worker Pool for Heavy Calculations
```typescript
// layout-worker-pool.ts
class LayoutWorkerPool {
  private workers: Worker[] = []
  private taskQueue: Task[] = []
  private busyWorkers = new Set<Worker>()
  
  constructor(size = navigator.hardwareConcurrency || 4) {
    for (let i = 0; i < size; i++) {
      const worker = new Worker('/workers/layout.worker.js')
      worker.onmessage = (e) => this.handleWorkerMessage(worker, e)
      this.workers.push(worker)
    }
  }
  
  async calculateLayout(nodes: FlowNode[], edges: FlowEdge[], options: LayoutOptions) {
    return new Promise((resolve, reject) => {
      const task = { nodes, edges, options, resolve, reject }
      this.taskQueue.push(task)
      this.processQueue()
    })
  }
  
  private processQueue() {
    while (this.taskQueue.length > 0) {
      const worker = this.getIdleWorker()
      if (!worker) break
      
      const task = this.taskQueue.shift()!
      this.busyWorkers.add(worker)
      worker.postMessage(task)
    }
  }
  
  private getIdleWorker(): Worker | null {
    return this.workers.find(w => !this.busyWorkers.has(w)) || null
  }
}

// Enhanced layout.worker.ts
import ELK from 'elkjs/lib/elk.bundled.js'

const elk = new ELK()
const layoutCache = new Map<string, any>()

self.addEventListener('message', async (event) => {
  const { nodes, edges, options } = event.data
  
  // Generate cache key
  const cacheKey = generateCacheKey(nodes, edges, options)
  
  // Check cache
  if (layoutCache.has(cacheKey)) {
    self.postMessage({ layout: layoutCache.get(cacheKey), cached: true })
    return
  }
  
  // Calculate layout
  const elkGraph = {
    id: 'root',
    layoutOptions: {
      'elk.algorithm': options.algorithm || 'layered',
      'elk.direction': options.direction || 'DOWN',
      'elk.spacing.nodeNode': options.nodeSpacing || '50',
      'elk.layered.spacing.edgeNodeBetweenLayers': '50',
      'elk.layered.crossingMinimization.strategy': 'LAYER_SWEEP',
      ...options.additionalOptions
    },
    children: nodes.map(node => ({
      id: node.id,
      width: node.dimensions?.width || 200,
      height: node.dimensions?.height || 100,
      layoutOptions: node.pinned ? {
        'elk.position': `(${node.position.x},${node.position.y})`,
        'elk.portConstraints': 'FIXED_POS'
      } : {}
    })),
    edges: edges.map(edge => ({
      id: edge.id,
      sources: [edge.source],
      targets: [edge.target],
      labels: edge.data.weight ? [{
        text: `${edge.data.weight}%`,
        width: 40,
        height: 20
      }] : []
    }))
  }
  
  try {
    const layout = await elk.layout(elkGraph)
    
    // Cache result
    layoutCache.set(cacheKey, layout)
    
    // Limit cache size
    if (layoutCache.size > 100) {
      const firstKey = layoutCache.keys().next().value
      layoutCache.delete(firstKey)
    }
    
    self.postMessage({ layout, cached: false })
  } catch (error) {
    self.postMessage({ error: error.message })
  }
})
```

### Memory Management
```typescript
const useMemoryOptimization = () => {
  // Cleanup unused resources
  const cleanup = () => {
    // Clear animation frames
    if (animationController.value) {
      animationController.value.destroy()
    }
    
    // Clear particle systems
    if (particleSystem.value) {
      particleSystem.value.clear()
    }
    
    // Clear large data structures
    flowCache.clear()
    nodeCache.clear()
  }
  
  // Monitor memory usage
  const memoryMonitor = useIntervalFn(() => {
    if (performance.memory) {
      const used = performance.memory.usedJSHeapSize
      const limit = performance.memory.jsHeapSizeLimit
      const usage = (used / limit) * 100
      
      if (usage > 80) {
        console.warn('High memory usage:', usage.toFixed(1) + '%')
        cleanup()
      }
    }
  }, 5000)
  
  onUnmounted(cleanup)
  
  return { cleanup, memoryMonitor }
}
```

## Integration Points

### Tree View Synchronization
```typescript
// Shared selection state
const { selectedBucketId } = storeToRefs(useBucketStore())

// Sync selection between views
watch(selectedBucketId, (id) => {
  if (id && viewMode === 'flow') {
    flowInstance.fitView({
      nodes: [id],
      duration: 800,
      padding: 0.2
    })
  }
})
```

### What-If Mode
```typescript
function enterWhatIfMode() {
  // Clone current state
  whatIfState.value = cloneDeep(currentState.value)
  
  // Enable interactive adjustments
  isWhatIfMode.value = true
  
  // Show comparison overlay
  showComparison.value = true
}

function applyWhatIfChanges() {
  // Apply changes to real state
  Object.entries(whatIfChanges.value).forEach(([bucketId, changes]) => {
    updateBucket(bucketId, changes)
  })
  
  exitWhatIfMode()
}
```

## Micro-UX Details

### Edge Label Editing
```typescript
const EdgeLabelEditor = {
  setup() {
    const isEditing = ref(false)
    const editValue = ref('')
    
    const handleLabelClick = (edge: FlowEdge) => {
      isEditing.value = true
      editValue.value = edge.data.weight.toString()
      nextTick(() => inputRef.value?.select())
    }
    
    const handleKeydown = (e: KeyboardEvent) => {
      if (e.key === 'Tab') {
        e.preventDefault()
        cycleToNextEdge()
      } else if (e.key === 'Enter') {
        commitEdit()
      } else if (e.key === 'Escape') {
        cancelEdit()
      }
    }
    
    return { isEditing, editValue, handleLabelClick, handleKeydown }
  }
}
```

### Snap Lines & Alignment
```typescript
const useSnapLines = () => {
  const snapThreshold = 10
  const guides = ref<Guide[]>([])
  
  const findSnapTargets = (node: FlowNode, nodes: FlowNode[]) => {
    const targets = []
    
    nodes.forEach(other => {
      if (other.id === node.id) return
      
      // Horizontal alignment
      if (Math.abs(node.position.x - other.position.x) < snapThreshold) {
        targets.push({ axis: 'x', value: other.position.x, nodes: [other] })
      }
      
      // Vertical alignment
      if (Math.abs(node.position.y - other.position.y) < snapThreshold) {
        targets.push({ axis: 'y', value: other.position.y, nodes: [other] })
      }
      
      // Center alignment
      const nodeCenterX = node.position.x + node.dimensions.width / 2
      const otherCenterX = other.position.x + other.dimensions.width / 2
      if (Math.abs(nodeCenterX - otherCenterX) < snapThreshold) {
        targets.push({ axis: 'centerX', value: otherCenterX, nodes: [other] })
      }
    })
    
    return targets
  }
  
  return { guides, findSnapTargets }
}
```

### Rule Pills
```typescript
interface RulePill {
  rule: Rule
  isActive: boolean
  tooltip: string
}

const RulePillComponent = {
  template: `
    <div 
      class="rule-pill"
      :class="{ 
        'is-active': pill.isActive,
        'is-hovering': isHovering 
      }"
      @mouseenter="showTooltip"
      @mouseleave="hideTooltip"
      @click="openRuleEditor"
    >
      <Icon name="lightning" size="sm" />
      <Tooltip v-if="isHovering">
        {{ humanReadableRule }}
      </Tooltip>
    </div>
  `,
  
  computed: {
    humanReadableRule() {
      // Convert rule to human language
      return this.rule.toHumanString()
      // e.g., "When Emergency Fund is below R30,000, allocate 50% here"
    }
  }
}
```

### Conflict Detection
```typescript
const useConflictDetection = () => {
  const conflicts = ref<Conflict[]>([])
  
  const detectConflicts = (nodes: FlowNode[]) => {
    conflicts.value = []
    
    // Check weight sum conflicts
    nodes.forEach(parent => {
      const children = nodes.filter(n => n.data.bucket.parentId === parent.id)
      const weightSum = children.reduce((sum, child) => {
        return sum + (child.data.bucket.distributionWeight || 0)
      }, 0)
      
      if (weightSum > 100) {
        conflicts.value.push({
          type: 'weight-overflow',
          nodeId: parent.id,
          message: `Child weights sum to ${weightSum}% (max 100%)`,
          severity: 'error',
          fix: () => normalizeWeights(parent, children)
        })
      }
    })
    
    // Check circular dependencies
    const cycles = detectCycles(nodes)
    cycles.forEach(cycle => {
      conflicts.value.push({
        type: 'circular-dependency',
        nodeIds: cycle,
        message: 'Circular flow detected',
        severity: 'critical',
        fix: () => breakCycle(cycle)
      })
    })
    
    return conflicts.value
  }
  
  const normalizeWeights = (parent: FlowNode, children: FlowNode[]) => {
    const total = children.reduce((sum, c) => sum + c.data.bucket.distributionWeight, 0)
    children.forEach(child => {
      child.data.bucket.distributionWeight = 
        Math.round((child.data.bucket.distributionWeight / total) * 100)
    })
  }
  
  return { conflicts, detectConflicts }
}
```

### Mini-Tour
```typescript
const FlowCanvasTour = {
  steps: [
    {
      target: '.vue-flow',
      title: 'Welcome to Flow Canvas',
      content: 'This is your visual money flow workspace. See how money flows from income through your bucket system.',
      position: 'center'
    },
    {
      target: '.income-node',
      title: 'Income Source',
      content: 'Your monthly income starts here and flows downward through your buckets.',
      position: 'bottom'
    },
    {
      target: '.bucket-node',
      title: 'Bucket Nodes',
      content: 'Each node represents a bucket. Click to select, drag to reposition.',
      position: 'right'
    },
    {
      target: '.flow-edge',
      title: 'Money Flow',
      content: 'Lines show money flow. Thickness represents amount. Click labels to edit percentages.',
      position: 'left'
    },
    {
      target: '.canvas-mode-switcher',
      title: 'Canvas Modes',
      content: 'Switch between Build (edit), Simulate (preview), and Reconcile (month-end) modes.',
      position: 'bottom'
    },
    {
      target: '.minimap',
      title: 'Navigation',
      content: 'Use the minimap to navigate large flows. Press F to fit all nodes in view.',
      position: 'left'
    }
  ],
  
  duration: 90, // seconds
  
  onComplete: () => {
    localStorage.setItem('flow-tour-completed', 'true')
  }
}
```

## Testing Strategy

### Visual Regression Tests
```typescript
import { test } from '@playwright/test'

test('flow visualization renders correctly', async ({ page }) => {
  await page.goto('/buckets/flow')
  await page.waitForSelector('.vue-flow')
  
  // Take screenshot
  await expect(page).toHaveScreenshot('flow-visualization.png')
})

test('swimlanes display correctly', async ({ page }) => {
  await page.goto('/buckets/flow')
  await page.waitForSelector('.swimlane-container')
  
  // Verify all swimlanes present
  const lanes = ['income', 'precuts', 'essentials', 'protection', 'debts', 'goals', 'play']
  for (const lane of lanes) {
    await expect(page.locator(`.swimlane-${lane}`)).toBeVisible()
  }
})
```

### Interaction Tests
```typescript
test('drag and drop updates bucket position', async ({ page }) => {
  const bucket = page.locator('.bucket-node').first()
  
  await bucket.dragTo({ x: 200, y: 300 })
  
  // Verify position updated
  const position = await bucket.getAttribute('transform')
  expect(position).toContain('translate(200, 300)')
})

test('edge label editing works', async ({ page }) => {
  const edgeLabel = page.locator('.edge-label').first()
  
  await edgeLabel.click()
  await page.keyboard.type('25')
  await page.keyboard.press('Enter')
  
  // Verify update
  await expect(edgeLabel).toContainText('25%')
})

test('reconciliation mode shows variances', async ({ page }) => {
  await page.goto('/buckets/flow')
  await page.click('[data-mode="reconcile"]')
  
  // Verify envelope nodes show variance
  const envelopeNode = page.locator('.envelope-node').first()
  await expect(envelopeNode.locator('.variance-indicator')).toBeVisible()
})
```