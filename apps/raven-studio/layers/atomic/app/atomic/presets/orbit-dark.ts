export type OrbitDarkTokenGroupId =
  | 'surface'
  | 'content'
  | 'border'
  | 'accent'
  | 'status'
  | 'interactive'
  | 'radius'
  | 'shadow'
  | 'motion'
  | 'field'
  | 'button'

export type OrbitDarkToken = {
  group: OrbitDarkTokenGroupId
  name: `--ds-${string}`
  value: string
  description: string
}

export type OrbitDarkShortcut = {
  name: `ds-${string}`
  description: string
}

export const orbitDarkTokenGroups: Array<{
  id: OrbitDarkTokenGroupId
  label: string
  description: string
}> = [
  { id: 'surface', label: 'Surface', description: 'Application background and elevated surfaces.' },
  { id: 'content', label: 'Content', description: 'Readable foreground colors.' },
  { id: 'border', label: 'Border', description: 'Subtle, default, and strong separators.' },
  { id: 'accent', label: 'Accent', description: 'Primary action and selected-state color.' },
  { id: 'status', label: 'Status', description: 'Compact semantic status colors.' },
  { id: 'interactive', label: 'Interactive', description: 'Control backgrounds, borders, and rings.' },
  { id: 'radius', label: 'Radius', description: 'Shared corner radius scale.' },
  { id: 'shadow', label: 'Shadow', description: 'Small dark-surface elevation shadows.' },
  { id: 'motion', label: 'Motion', description: 'Default transition timing.' },
  { id: 'field', label: 'Field', description: 'Field/Input v0 defaults.' },
  { id: 'button', label: 'Button', description: 'Button v0 defaults.' },
]

export const orbitDarkTokens: OrbitDarkToken[] = [
  { group: 'surface', name: '--ds-bg-root', value: '#212121', description: 'App root background.' },
  { group: 'surface', name: '--ds-bg-surface', value: '#303030', description: 'Default component surface.' },
  { group: 'surface', name: '--ds-bg-elevated', value: '#1b1b1b', description: 'Elevated panels and cards.' },
  { group: 'surface', name: '--ds-bg-muted', value: '#414141', description: 'Muted secondary surface.' },
  { group: 'surface', name: '--ds-bg-inverted', value: '#ffffff', description: 'Inverted light surface.' },

  { group: 'content', name: '--ds-text-primary', value: '#ffffff', description: 'Primary foreground.' },
  { group: 'content', name: '--ds-text-secondary', value: '#f3f3f3', description: 'Secondary foreground.' },
  { group: 'content', name: '--ds-text-muted', value: '#afafaf', description: 'Subdued foreground.' },
  { group: 'content', name: '--ds-text-inverted', value: '#0d0d0d', description: 'Text on inverted/light controls.' },

  { group: 'border', name: '--ds-border-subtle', value: '#ffffff0d', description: 'Hairline divider.' },
  { group: 'border', name: '--ds-border-default', value: '#ffffff26', description: 'Default component border.' },
  { group: 'border', name: '--ds-border-strong', value: '#ffffff40', description: 'Emphasized component border.' },

  { group: 'accent', name: '--ds-accent', value: '#48aaff', description: 'Primary accent.' },
  { group: 'accent', name: '--ds-accent-strong', value: '#0285ff', description: 'Strong accent fill.' },
  { group: 'accent', name: '--ds-accent-soft', value: '#0285ff21', description: 'Soft accent background.' },
  { group: 'accent', name: '--ds-accent-text', value: '#99ceff', description: 'Accent foreground.' },
  { group: 'accent', name: '--ds-accent-border', value: '#0285ff66', description: 'Accent border.' },

  { group: 'status', name: '--ds-danger', value: '#e02e2a', description: 'Danger state.' },
  { group: 'status', name: '--ds-warning', value: '#ff9e6c', description: 'Warning state.' },
  { group: 'status', name: '--ds-success', value: '#04b84c', description: 'Success state.' },
  { group: 'status', name: '--ds-info', value: '#48aaff', description: 'Info state.' },

  { group: 'interactive', name: '--ds-control-bg', value: '#ffffff00', description: 'Transparent control background.' },
  { group: 'interactive', name: '--ds-control-bg-hover', value: '#ffffff1a', description: 'Hovered control background.' },
  { group: 'interactive', name: '--ds-control-bg-active', value: '#ffffff26', description: 'Pressed/selected control background.' },
  { group: 'interactive', name: '--ds-control-border', value: '#ffffff26', description: 'Control border.' },
  { group: 'interactive', name: '--ds-control-ring', value: '#ffffff40', description: 'Focus ring.' },

  { group: 'radius', name: '--ds-radius-xs', value: '.125rem', description: 'Extra-small radius.' },
  { group: 'radius', name: '--ds-radius-sm', value: '.25rem', description: 'Small radius.' },
  { group: 'radius', name: '--ds-radius-md', value: '.375rem', description: 'Medium radius.' },
  { group: 'radius', name: '--ds-radius-lg', value: '.5rem', description: 'Large radius.' },
  { group: 'radius', name: '--ds-radius-xl', value: '.75rem', description: 'Extra-large radius.' },

  { group: 'shadow', name: '--ds-shadow-sm', value: '0 1px 3px 0 #0000001a, 0 1px 2px -1px #0000001a', description: 'Small elevation shadow.' },
  { group: 'shadow', name: '--ds-shadow-md', value: '0 4px 6px -1px #0000001a, 0 2px 4px -2px #0000001a', description: 'Medium elevation shadow.' },
  { group: 'shadow', name: '--ds-shadow-lg', value: '0 10px 15px -3px #0000001a, 0 4px 6px -4px #0000001a', description: 'Large elevation shadow.' },

  { group: 'motion', name: '--ds-duration-fast', value: '.15s', description: 'Fast transition duration.' },
  { group: 'motion', name: '--ds-duration-normal', value: '.2s', description: 'Default transition duration.' },
  { group: 'motion', name: '--ds-ease-standard', value: 'cubic-bezier(.4, 0, .2, 1)', description: 'Standard easing.' },

  { group: 'field', name: '--ds-field-height', value: 'calc(var(--h-gu, 1.4rem) * 1.75)', description: 'Default field height.' },
  { group: 'field', name: '--ds-field-padding-x', value: 'calc(var(--h-gu, 1.4rem) * .5)', description: 'Default field horizontal padding.' },
  { group: 'field', name: '--ds-field-radius', value: 'var(--ds-radius-lg)', description: 'Default field radius.' },
  { group: 'field', name: '--ds-field-bg', value: 'var(--ds-bg-surface)', description: 'Default field background.' },
  { group: 'field', name: '--ds-field-border', value: 'var(--ds-border-default)', description: 'Default field border.' },
  { group: 'field', name: '--ds-field-text', value: 'var(--ds-text-primary)', description: 'Field text.' },
  { group: 'field', name: '--ds-field-placeholder', value: '#fffc', description: 'Placeholder text.' },
  { group: 'field', name: '--ds-field-focus-ring', value: 'var(--ds-control-ring)', description: 'Field focus ring.' },
  { group: 'field', name: '--ds-field-label-text', value: 'var(--ds-text-secondary)', description: 'Field label text.' },
  { group: 'field', name: '--ds-field-help-text', value: 'var(--ds-text-muted)', description: 'Field help text.' },
  { group: 'field', name: '--ds-field-error-text', value: '#ff8583', description: 'Field error text.' },

  { group: 'button', name: '--ds-button-height', value: 'calc(var(--h-gu, 1.4rem) * 1.75)', description: 'Default button height.' },
  { group: 'button', name: '--ds-button-padding-x', value: 'calc(var(--h-gu, 1.4rem) * .625)', description: 'Default button horizontal padding.' },
  { group: 'button', name: '--ds-button-radius', value: 'var(--ds-radius-lg)', description: 'Default button radius.' },
  { group: 'button', name: '--ds-button-font-weight', value: '600', description: 'Default button font weight.' },
]

export const orbitDarkShortcuts: OrbitDarkShortcut[] = [
  { name: 'ds-app', description: 'Application root using Orbit Dark semantic tokens.' },
  { name: 'ds-surface', description: 'Plain token-backed surface.' },
  { name: 'ds-panel', description: 'Elevated panel surface.' },
  { name: 'ds-card', description: 'Card surface.' },
  { name: 'ds-control', description: 'Generic interactive control shell.' },
  { name: 'ds-field', description: 'Base input/textarea/select control.' },
  { name: 'ds-button', description: 'Base button primitive.' },
  { name: 'ds-button-primary', description: 'Primary button variant.' },
  { name: 'ds-button-secondary', description: 'Secondary button variant.' },
  { name: 'ds-text-muted', description: 'Subdued text helper.' },
  { name: 'ds-chip', description: 'Compact status chip base.' },
  { name: 'ds-chip-success', description: 'Success chip variant.' },
  { name: 'ds-chip-warning', description: 'Warning chip variant.' },
  { name: 'ds-chip-danger', description: 'Danger chip variant.' },
]

export const orbitDarkPreset = {
  id: 'orbit-dark',
  label: 'Orbit Dark',
  version: '0.1.0',
  status: 'v0 proposed Design System Studio preset',
  sourceReference: 'Distilled from the supplied clean/minimal dark UI token reference; not a verbatim token dump.',
  tokenGroups: orbitDarkTokenGroups,
  tokens: orbitDarkTokens,
  shortcuts: orbitDarkShortcuts,
  featureFamilies: [
    'colors',
    'surfaces',
    'shadows',
    'radii',
    'motion',
    'fields',
    'buttons',
    'status',
  ],
} as const

export function renderOrbitDarkCssVariables(
  selector = ":root,\n.dark,\n.dark-mode,\n[data-theme='orbit-dark']",
): string {
  const declarations = orbitDarkTokens
    .map((token) => `  ${token.name}: ${token.value};`)
    .join('\n')

  return `${selector} {\n${declarations}\n}`
}

export const orbitDarkCssVariableText = renderOrbitDarkCssVariables()
