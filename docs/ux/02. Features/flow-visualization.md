# Flow Visualization - Interactive Money Flow Canvas

## Overview
The Flow Canvas provides a visual, node-based view of your bucket structure, showing top-down money flow from income through pre-cuts, essentials, reserves, goals, and play. This complements the tree view by becoming your primary strategy and brainstorming workspace.

## Core Concept
Make the flow obvious - see where every Rand goes at a glance. Think in systems with gates, priorities, and overflow feeling natural when drawn as a graph. Design what-ifs fast by tweaking nodes and watching edges rebalance instantly.

## Canvas Modes

### 1. **Build Mode** 🔨
Edit structure and rules freely
- Add/remove nodes
- Create/modify edges  
- Set rules and gates
- Adjust distributions
- Auto-layout available

### 2. **Simulate Mode** 🎬
See money flow in action
- Layout locked
- Animated particle flow
- Time scrubber (1-24 months)
- Real-time projections
- What-if adjustments

### 3. **Reconcile Mode** 📊
Month-end envelope reconciliation
- Compare planned vs actual
- Resolve overspends
- Sweep underspends
- Adjust next month
- Generate reports

## Swimlane Organization

The canvas organizes buckets into horizontal swimlanes for visual clarity:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INCOME          │ 💰 Monthly Income: R50,000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRE-CUTS        │ ✂️ Tax  │  ✂️ LTF  │  ✂️ Other
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ESSENTIALS      │ 🏠 Rent │ 🍽️ Food │ ⚡ Utils
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROTECTION      │ 🛡️ Emergency │ 🏥 Medical │ 🔧 Maint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEBTS           │ 💳 Card 1 │ 💳 Card 2 │ 🏦 Loan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GOALS           │ 🎯 Vacation │ 💻 Laptop │ 🚗 Car
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PLAY            │ 🎮 Entertainment │ 🍺 Social
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Visual Elements

### Enhanced Node Design
```
┌─────────────────────────┐
│ 🏠 Essentials           │  ← Icon + Name
│ ━━━━━━━━━━━━━━━━━━━━━ │
│ R10,125 (30%)          │  ← Amount + Percentage
│ ████████░░ 80%         │  ← Progress Bar
│ Target: R12,500        │  ← Target/Limit
│ [📌] [🔒] [⚡] [▶]     │  ← Pills: Pinned, Locked, Rules, Active
└─────────────────────────┘

Withdrawal Glyphs: ▢ Open | ◐ Restricted | ⚠️ Last Resort | 🔒 Locked
```

### Node States
- **Default**: Clean, minimal
- **Hovering**: Subtle scale + glow
- **Selected**: Bold border + shadow
- **Warning**: Yellow highlight
- **Error**: Red highlight
- **Inactive**: Grayed out

### Edge Styles

#### Enhanced Edge Visualization
```
Source Node
    ║
    ║ 30% | R10,125    ← Percentage & Amount Label
    ║━━━━━━━━━━━━━━    ← Thickness = Amount
    ║ ● ● ● ● ●        ← Particles (when active)
    ▼
Target Node
```

#### Edge Types
1. **Primary Flow**: Solid line, thickness proportional to amount
2. **Rule-based Flow**: Dashed line with rule pill
3. **Overflow**: Dotted line, thinner, shows excess routing
4. **Gate Redirect**: Colored line showing conditional flow

#### Edge States
- **Active**: Animated particles flowing
- **Inactive**: Static, dimmed
- **Hovering**: Highlight path + show tooltip
- **Warning**: Yellow glow (approaching limit)
- **Error**: Red glow (blocked or invalid)

## Interactions

### 1. **Node Interactions**
- **Click**: Select and show in inspector
- **Double-click**: Drill down into sub-buckets
- **Right-click**: Context menu (duplicate, delete, convert type)
- **Drag**: Reposition (respects swimlanes in Build mode)
- **Hover**: Highlight upstream/downstream paths
- **N key**: Create new node at cursor

### 2. **Edge Interactions**
- **Click label**: Edit percentage/weight inline
- **Hover**: Show flow calculation tooltip
- **Tab**: Cycle through edge labels
- **Enter**: Commit percentage change
- **Drag from port**: Create new edge

### 3. **Canvas Interactions**
- **Pan**: Space+drag or middle-mouse drag
- **Zoom**: Scroll or pinch (0.2x to 4x)
- **Fit all**: F key or double-click background
- **Auto-layout**: A key (respects pinned nodes)
- **Cmd/Ctrl+F**: Search and focus bucket
- **Mini-map**: Toggle with M key

### 4. **Rule Pills**
Small indicators on nodes showing active rules:
- **Hover**: See rule in human language
- **Click**: Open rule editor in inspector
- **Glow**: Indicates currently active
- **Gray**: Rule exists but conditions not met

## Layout Algorithms

### 1. **Hierarchical Flow** (Default)
```
         Income
           │
       Pre-cuts
           │
    Distribution Hub
    ╱   ╱  │  ╲   ╲
   B1  B2  B3  B4  B5
   │   │   │   │   │
  Sub Sub Sub Sub Sub
```

### 2. **Circular Flow**
```
       Income
         ↓
    Pre-cuts ←─┐
         ↓     │
    Buckets ───┘
```

### 3. **Force-Directed**
- Buckets arrange by relationships
- Similar buckets cluster
- Rules create attractions

## Animation System

### 1. **Money Flow Animation**
```typescript
interface FlowAnimation {
  particles: {
    size: 'small' | 'medium' | 'large' // Based on amount
    speed: number // Based on priority
    color: string // Based on bucket type
    path: Edge[] // Route to follow
  }
  
  timing: {
    delay: number // Stagger for visual clarity
    duration: number // Total animation time
    easing: 'linear' | 'ease-in-out'
  }
}
```

### 2. **State Transitions**
- Smooth morphing between layouts
- Amount changes animate over 300ms
- New nodes fade in
- Deleted nodes fade out

### 3. **Interactive Feedback**
- Hover effects (scale + glow)
- Click ripples
- Drag ghosts
- Success celebrations

## Real-time Updates

### 1. **What-If Mode**
Toggle to experiment without saving:
- Adjust income amount via slider
- Drag distribution percentages
- Add/remove buckets
- See immediate impact

### 2. **Projection Mode**
Show future state:
- Timeline scrubber (1-24 months)
- Filling animations
- Completion indicators
- Goal achievement previews

### 3. **Comparison Mode**
- Current vs. Proposed
- This month vs. Last month
- Actual vs. Budget
- Split-screen synchronized

## Monthly Reconciliation Flow

### Overview
At month-end, reconcile planned vs actual spending for envelope budgets:

### Reconciliation Process
```typescript
function reconcileMonth(state: BucketState) {
  for (const bucket of envelopeBuckets) {
    const variance = bucket.actual - bucket.planned
    
    if (variance > 0) {
      // Overspend: Draw from sources
      resolveDeficit(bucket, variance)
    } else {
      // Underspend: Sweep surplus
      sweepSurplus(bucket, Math.abs(variance))
    }
  }
  
  generateReconciliationReport()
  adjustNextMonthBudgets()
}
```

### Visual Reconciliation Mode
1. **Canvas locks** to prevent structural changes
2. **Envelopes highlight** with variance indicators
3. **Deficit resolution** shows animated flows from sources
4. **Surplus sweeping** animates to target buckets
5. **One-click approve** or manual adjustments

### Deficit Resolution Order
```
1. Own reserves (if any)
2. Play bucket (up to 50%)
3. Buffer bucket (if available)
4. Emergency (with warning)
5. Manual selection required
```

### Smart Budget Adjustments
- Track 3-month rolling average
- Suggest increases for consistent overspend
- Recommend decreases for consistent underspend
- Respect volatility bands (±10% typical)

## Budget Envelope System

### Variable Expense Handling
```typescript
interface EnvelopeBucket extends Bucket {
  budgetType: 'envelope'
  
  envelope: {
    planned: number // Monthly budget
    spent: number // Actual spent
    committed: number // Pending transactions
    available: number // Can still spend
  }
  
  variance: {
    amount: number // Over/under
    percentage: number
    trend: 'improving' | 'worsening' | 'stable'
  }
  
  overdraftRules: {
    source: 'emergency' | 'play' | 'proportional' | 'deny'
    warningAt: number // Percentage (e.g., 0.8 = 80%)
    lockAt: number // Percentage (e.g., 1.0 = 100%)
  }
}
```

### Visual States
1. **Under Budget** (Green): Plenty remaining
2. **On Track** (Blue): Normal spending pace
3. **Warning** (Yellow): Approaching limit
4. **Over Budget** (Red): Exceeded allocation
5. **Locked** (Gray): Spending blocked

## Performance Optimizations

### 1. **Viewport Culling**
- Only render visible nodes
- Level-of-detail for zoomed out
- Simplify animations when many nodes

### 2. **Lazy Loading**
- Load deep hierarchies on demand
- Progressive detail enhancement
- Cache calculated layouts

### 3. **GPU Acceleration**
- Use CSS transforms for movement
- WebGL for particle effects
- RequestAnimationFrame for smoothness

## Keyboard Shortcuts

- **Space**: Play/pause animations
- **F**: Fit all nodes in view
- **Tab**: Cycle through nodes
- **Enter**: Drill into selected
- **Escape**: Back to parent level
- **1-5**: Switch layout modes
- **Cmd/Ctrl+D**: Duplicate scenario
- **Cmd/Ctrl+Z**: Undo changes

## Mobile/Touch Adaptations

### Gestures
- **Pinch**: Zoom in/out
- **Two-finger drag**: Pan canvas
- **Long press**: Context menu
- **Swipe up**: Show details
- **Swipe down**: Collapse details

### Responsive Design
- Simplify on small screens
- Vertical layout option
- Collapsible sidebar
- Full-screen mode

## Export Options

### 1. **Image Export**
- PNG with transparency
- SVG for scalability
- PDF for printing

### 2. **Data Export**
- Flow structure as JSON
- Calculations as CSV
- Full report as PDF

### 3. **Sharing**
- Public link (read-only)
- Embed code for blogs
- Social media cards

## Integration with Tree View

### Synchronized State
- Selection syncs between views
- Changes reflect immediately
- Shared data model
- Consistent animations

### View Switching
- Smooth transition animation
- Maintain selection context
- Remember zoom/pan state
- Keyboard shortcut (Cmd/Ctrl+Tab)

## Future Enhancements

### 1. **AI-Powered Layout**
- Optimize for clarity
- Suggest better structures
- Identify inefficiencies

### 2. **3D Mode**
- Depth for time dimension
- VR exploration
- Better hierarchy visualization

### 3. **Collaborative Features**
- Multi-user planning
- Comments on nodes
- Version history
- Change proposals