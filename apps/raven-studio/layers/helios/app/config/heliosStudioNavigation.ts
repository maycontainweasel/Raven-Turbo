export type HeliosStudioStatusTone = 'neutral' | 'info' | 'success' | 'warning'

export type HeliosStudioArenaId = 'helios' | 'utilities' | 'design-system' | 'components' | 'output'

export type HeliosStudioNavItem = {
  label: string
  to: string
  icon?: string
  status?: string
  statusTone?: HeliosStudioStatusTone
}

export type HeliosStudioNavGroup = {
  label: string
  items: HeliosStudioNavItem[]
}

export type HeliosStudioArena = {
  id: HeliosStudioArenaId
  label: string
  to: string
  groups: HeliosStudioNavGroup[]
}

export type HeliosStudioOutlineItem = {
  label: string
  hash: string
}

export const heliosStudioArenas: HeliosStudioArena[] = [
  {
    id: 'helios',
    label: 'Helios',
    to: '/helios',
    groups: [
      {
        label: 'Studio',
        items: [
          { label: 'Overview', to: '/helios' },
          { label: 'Settings', to: '/helios/settings' },
        ],
      },
      {
        label: 'Migration',
        items: [
          { label: 'Legacy manager', to: '/helios/legacy', status: 'Active', statusTone: 'success' },
        ],
      },
    ],
  },
  {
    id: 'utilities',
    label: 'Utilities',
    to: '/helios/foundations',
    groups: [
      {
        label: 'Atomic',
        items: [
          { label: 'Foundations', to: '/helios/foundations' },
          { label: 'Working controls', to: '/helios/legacy', status: 'Legacy', statusTone: 'success' },
        ],
      },
      {
        label: 'Foundation families',
        items: [
          { label: 'Typography', to: '/helios/foundations#typography' },
          { label: 'Rhythm & space', to: '/helios/foundations#rhythm-space' },
          { label: 'Breakpoints', to: '/helios/foundations#breakpoints' },
          { label: 'Color utilities', to: '/helios/foundations#colors' },
        ],
      },
    ],
  },
  {
    id: 'design-system',
    label: 'Design System',
    to: '/helios/themes',
    groups: [
      {
        label: 'System',
        items: [
          { label: 'Themes', to: '/helios/themes', status: '1 preset', statusTone: 'success' },
          { label: 'Studio prototype', to: '/helios/design', status: 'Prototype', statusTone: 'info' },
        ],
      },
      {
        label: 'Current preset',
        items: [
          { label: 'Orbit Dark', to: '/helios/themes#orbit-dark' },
          { label: 'Showcase', to: '/helios/design#showcase' },
        ],
      },
    ],
  },
  {
    id: 'components',
    label: 'Components',
    to: '/helios/components',
    groups: [
      {
        label: 'Catalogue',
        items: [
          { label: 'Components', to: '/helios/components' },
          { label: 'Registry', to: '/helios/registry', status: 'Planned', statusTone: 'warning' },
        ],
      },
      {
        label: 'Families',
        items: [
          { label: 'Field', to: '/helios/components#field' },
          { label: 'Input', to: '/helios/components#input' },
          { label: 'Button', to: '/helios/components#button' },
          { label: 'Select', to: '/helios/components#select' },
        ],
      },
    ],
  },
  {
    id: 'output',
    label: 'Output',
    to: '/helios/build',
    groups: [
      {
        label: 'Delivery',
        items: [
          { label: 'Build & artifacts', to: '/helios/build', status: 'Planned', statusTone: 'warning' },
          { label: 'Output preview', to: '/helios-output' },
        ],
      },
      {
        label: 'Automation',
        items: [
          { label: 'Agents', to: '/helios/agents' },
          { label: 'Settings', to: '/helios/settings' },
        ],
      },
    ],
  },
]

const pageOutlines: Record<string, HeliosStudioOutlineItem[]> = {
  '/helios': [
    { label: 'Studio doctrine', hash: '#studio-doctrine' },
    { label: 'System status', hash: '#system-status' },
    { label: 'Accepted ownership', hash: '#accepted-ownership' },
  ],
  '/helios/foundations': [
    { label: 'Colors', hash: '#colors' },
    { label: 'Typography', hash: '#typography' },
    { label: 'Rhythm & space', hash: '#rhythm-space' },
    { label: 'Breakpoints', hash: '#breakpoints' },
    { label: 'Radius', hash: '#radius' },
    { label: 'Shadows', hash: '#shadows' },
    { label: 'Motion', hash: '#motion' },
  ],
  '/helios/themes': [
    { label: 'Orbit Dark', hash: '#orbit-dark' },
  ],
  '/helios/components': [
    { label: 'Field', hash: '#field' },
    { label: 'Input', hash: '#input' },
    { label: 'Button', hash: '#button' },
    { label: 'Select', hash: '#select' },
  ],
  '/helios/registry': [
    { label: 'Installed', hash: '#installed' },
    { label: 'Available', hash: '#available' },
    { label: 'Modified', hash: '#modified' },
    { label: 'Updates', hash: '#updates' },
    { label: 'Operations', hash: '#registry-operations' },
  ],
  '/helios/build': [
    { label: 'Manifest', hash: '#manifest' },
    { label: 'Registry lock', hash: '#registry-lock' },
    { label: 'Tokens', hash: '#tokens' },
    { label: 'Recipes', hash: '#recipes' },
    { label: 'Uno payload', hash: '#uno-payload' },
    { label: 'Component diff', hash: '#component-diff' },
  ],
  '/helios/agents': [
    { label: 'Cookbook', hash: '#cookbook' },
    { label: 'Capabilities', hash: '#capabilities' },
    { label: 'MCP status', hash: '#mcp-status' },
    { label: 'Agent doctrine', hash: '#agent-doctrine' },
  ],
  '/helios/settings': [
    { label: 'Removal doctrine', hash: '#removal-doctrine' },
    { label: 'Migration routes', hash: '#migration-routes' },
    { label: 'Transactions', hash: '#removal-transactions' },
  ],
}

const arenaByPath = (path: string): HeliosStudioArenaId => {
  if (path === '/helios/foundations' || path.startsWith('/helios/foundations/')) return 'utilities'
  if (path === '/helios/themes' || path.startsWith('/helios/themes/') || path === '/helios/design') return 'design-system'
  if (path === '/helios/components' || path.startsWith('/helios/components/') || path === '/helios/registry') return 'components'
  if (path === '/helios/build' || path === '/helios/agents' || path === '/helios-output') return 'output'
  return 'helios'
}

export const findHeliosStudioArena = (path: string) => {
  const arenaId = arenaByPath(path)
  return heliosStudioArenas.find((arena) => arena.id === arenaId) ?? heliosStudioArenas[0]
}

export const findHeliosStudioNavItem = (path: string) => {
  const arena = findHeliosStudioArena(path)
  return arena.groups
    .flatMap((group) => group.items)
    .find((item) => item.to.split('#')[0] === path)
}

export const getHeliosStudioPageOutline = (path: string) => pageOutlines[path] ?? []
