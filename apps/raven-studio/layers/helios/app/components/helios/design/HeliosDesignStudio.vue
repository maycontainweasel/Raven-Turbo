<script setup lang="ts">
import {
  orbitDarkCssVariableText,
  orbitDarkPreset,
  orbitDarkTokenGroups,
  orbitDarkTokens,
} from '../../../../../atomic/app/atomic/presets/orbit-dark'

type StudioSectionId =
  | 'overview'
  | 'tokens'
  | 'typography'
  | 'fields'
  | 'input'
  | 'orbit'
  | 'showcase'
  | 'agent'

type FieldSize = 'sm' | 'md' | 'lg'

const sections: Array<{
  id: StudioSectionId
  label: string
  eyebrow: string
}> = [
  { id: 'overview', label: 'Overview', eyebrow: 'Branch C' },
  { id: 'tokens', label: 'Tokens', eyebrow: 'Proposed' },
  { id: 'typography', label: 'Typography', eyebrow: 'Branch B' },
  { id: 'fields', label: 'Fields', eyebrow: 'Primitive' },
  { id: 'input', label: 'Input v0', eyebrow: 'Playground' },
  { id: 'orbit', label: 'Orbit Dark', eyebrow: 'Preset v0' },
  { id: 'showcase', label: 'Showcase', eyebrow: 'States' },
  { id: 'agent', label: 'Agent Cookbook', eyebrow: 'Rules' },
]

const activeSection = ref<StudioSectionId>('orbit')

const fieldConfig = reactive({
  size: 'md' as FieldSize,
  radius: 10,
  controlHeight: 44,
  borderColor: '#cbd5e1',
  focusColor: '#2563eb',
  invalid: false,
  disabled: false,
  readonly: false,
  helperText: true,
  errorText: false,
  leadingIcon: true,
  trailingAction: false,
})

const sizeMeta: Record<FieldSize, {
  label: string
  labelSize: string
  inputSize: string
  helperSize: string
  paddingX: string
  gap: string
}> = {
  sm: {
    label: 'Small / dense controls',
    labelSize: '0.75rem',
    inputSize: '0.875rem',
    helperSize: '0.75rem',
    paddingX: '0.75rem',
    gap: '0.375rem',
  },
  md: {
    label: 'Medium / default forms',
    labelSize: '0.8125rem',
    inputSize: '0.9375rem',
    helperSize: '0.8125rem',
    paddingX: '0.875rem',
    gap: '0.5rem',
  },
  lg: {
    label: 'Large / prominent fields',
    labelSize: '0.875rem',
    inputSize: '1rem',
    helperSize: '0.875rem',
    paddingX: '1rem',
    gap: '0.625rem',
  },
}

const activeSectionMeta = computed(() => {
  return sections.find((section) => section.id === activeSection.value) ?? sections[0]
})

const currentSize = computed(() => sizeMeta[fieldConfig.size])

const isInvalid = computed(() => fieldConfig.invalid || fieldConfig.errorText)

const describedBy = computed(() => {
  const ids = []
  if (fieldConfig.helperText) ids.push('studio-input-helper')
  if (fieldConfig.errorText) ids.push('studio-input-error')
  return ids.length > 0 ? ids.join(' ') : undefined
})

const previewStyle = computed<Record<string, string>>(() => ({
  '--ds-field-control-height-proposed': `${fieldConfig.controlHeight}px`,
  '--ds-field-control-radius-proposed': `${fieldConfig.radius}px`,
  '--ds-field-control-border-proposed': isInvalid.value ? '#dc2626' : fieldConfig.borderColor,
  '--ds-field-focus-ring-proposed': fieldConfig.focusColor,
  '--ds-field-label-size-proposed': currentSize.value.labelSize,
  '--ds-field-input-size-proposed': currentSize.value.inputSize,
  '--ds-field-helper-size-proposed': currentSize.value.helperSize,
  '--ds-field-control-px-proposed': currentSize.value.paddingX,
  '--ds-field-gap-proposed': currentSize.value.gap,
}))

const proposedClasses = computed(() => {
  const classes = [
    'ds-field',
    'ds-field--input',
    `ds-field--size-${fieldConfig.size}`,
    'ds-field__control',
    'ds-input',
  ]

  if (fieldConfig.leadingIcon) classes.push('ds-field__leading-icon')
  if (fieldConfig.trailingAction) classes.push('ds-field__trailing-action')
  if (fieldConfig.helperText) classes.push('ds-field__helper')
  if (fieldConfig.errorText) classes.push('ds-field__error')

  return classes
})

const stateSummary = computed(() => [
  `size=${fieldConfig.size}`,
  `invalid=${isInvalid.value}`,
  `disabled=${fieldConfig.disabled}`,
  `readonly=${fieldConfig.readonly}`,
  `helper=${fieldConfig.helperText}`,
  `error=${fieldConfig.errorText}`,
])

const proposedHtml = computed(() => {
  const described = describedBy.value
  const disabled = fieldConfig.disabled ? '\n      disabled' : ''
  const readonly = fieldConfig.readonly ? '\n      readonly' : ''
  const invalid = isInvalid.value ? '\n      aria-invalid="true"' : ''
  const describedAttr = described ? `\n      aria-describedby="${described}"` : ''
  const leading = fieldConfig.leadingIcon
    ? '    <span class="ds-field__leading-icon" aria-hidden="true">@</span>\n'
    : ''
  const trailing = fieldConfig.trailingAction
    ? '    <button class="ds-field__trailing-action" type="button" aria-label="Clear email">Clear</button>\n'
    : ''
  const helper = fieldConfig.helperText
    ? '\n  <p id="studio-input-helper" class="ds-field__helper">Use the email address connected to your account.</p>'
    : ''
  const error = fieldConfig.errorText
    ? '\n  <p id="studio-input-error" class="ds-field__error">Enter a valid email address.</p>'
    : ''

  return `<div
  class="ds-field ds-field--input"
  data-size="${fieldConfig.size}"
  data-invalid="${String(isInvalid.value)}"
  data-disabled="${String(fieldConfig.disabled)}"
  data-readonly="${String(fieldConfig.readonly)}"
>
  <label class="ds-field__label" for="studio-input-email">Email</label>

  <div class="ds-field__control">
${leading}    <input
      id="studio-input-email"
      class="ds-input"
      type="email"
      name="email"
      autocomplete="email"${disabled}${readonly}${invalid}${describedAttr}
    >
${trailing}  </div>${helper}${error}
</div>`
})

const proposedCssTokens = computed(() => {
  return `/* Proposed only. Branch B / Atomic must review names and values. */
.ds-field {
  --field-control-height: ${fieldConfig.controlHeight}px;
  --field-control-radius: ${fieldConfig.radius}px;
  --field-control-border: ${fieldConfig.borderColor};
  --field-control-border-focus: ${fieldConfig.focusColor};
  --field-control-px: ${currentSize.value.paddingX};
  --field-control-gap: ${currentSize.value.gap};
}

.ds-field[data-invalid="true"] {
  --field-control-border: #dc2626;
  --field-error-color: #b91c1c;
}`
})

const proposedAgentSnippet = computed(() => {
  return `Use Input v0 when a single-line text-like control needs a visible label, helper/error text, or state styling.

Required steps:
1. Render a ds-field root with data-size="${fieldConfig.size}".
2. Render a real label connected to the input.
3. Put the native input inside ds-field__control.
4. Use native disabled/readonly/required attributes where possible.
5. Mark every ds-* class and --field-* token as proposed until Branch B approves it.

Do not invent Atomic utilities or change @helios/protocol for Field/Input v0.`
})

const orbitTokenRows = computed(() => {
  return orbitDarkTokens.map((token) => ({
    ...token,
    groupLabel: orbitDarkTokenGroups.find((group) => group.id === token.group)?.label ?? token.group,
  }))
})

const orbitShortcutNames = computed(() => orbitDarkPreset.shortcuts.map((shortcut) => shortcut.name))

const orbitCssPreview = computed(() => {
  return `${orbitDarkCssVariableText}

/* Minimal v0 classes are also registered by Atomic:
${orbitShortcutNames.value.map((name) => `   ${name}`).join('\n')}
*/`
})

const orbitCookbookSnippet = computed(() => {
  return `Use ds-app for app roots and workspace shells.
Use ds-panel for elevated panes and ds-card for repeated content cards.
Use ds-field for simple input, textarea, and select controls.
Use ds-button-primary for primary actions and ds-button-secondary for secondary actions.
Use ds-chip-success/warning/danger for compact status labels.
Do not hardcode dark UI colors when orbit-dark --ds-* tokens exist.`
})

const orbitEvents = [
  { label: 'Agent planner', detail: 'Sequenced Branch C preset review', status: 'Running' },
  { label: 'Task mirror', detail: '5 artifacts ready for inspection', status: 'Synced' },
  { label: 'Output gate', detail: 'Awaiting Branch B token review', status: 'Review' },
]

const orbitTasks = [
  { title: 'Field/Input v0', meta: 'Prototype contract', state: 'Accepted' },
  { title: 'Orbit Dark preset', meta: 'Semantic token baseline', state: 'Active' },
  { title: 'Atomic review', meta: 'Token and shortcut doctrine', state: 'Queued' },
]

function orbitTokenSwatchStyle(value: string): Record<string, string> {
  if (value.startsWith('#') || value.startsWith('rgb') || value.startsWith('color(')) {
    return { background: value }
  }

  if (value.startsWith('var(')) {
    return { background: value }
  }

  return {
    background: 'var(--ds-bg-muted)',
    boxShadow: value.startsWith('0 ') ? value : 'none',
  }
}
</script>

<template>
  <div class="helios-design-studio">
    <aside class="studio-sidebar" aria-label="Design System Studio sections">
      <div class="studio-brand">
        <span class="studio-brand__mark">DS</span>
        <div>
          <p class="studio-brand__eyebrow">Branch C</p>
          <h1>Design Studio</h1>
        </div>
      </div>

      <nav class="studio-nav">
        <button
          v-for="section in sections"
          :key="section.id"
          class="studio-nav__item"
          :class="{ 'studio-nav__item--active': activeSection === section.id }"
          type="button"
          @click="activeSection = section.id"
        >
          <span>{{ section.label }}</span>
          <small>{{ section.eyebrow }}</small>
        </button>
      </nav>
    </aside>

    <main class="studio-main">
      <header class="studio-header">
        <div>
          <p class="studio-header__eyebrow">{{ activeSectionMeta.eyebrow }}</p>
          <h2>{{ activeSectionMeta.label }}</h2>
        </div>
        <div class="studio-status">
          <span>Prototype only</span>
          <span>Proposed tokens/classes</span>
        </div>
      </header>

      <section v-if="activeSection === 'overview'" class="studio-panel">
        <div class="studio-copy">
          <h3>Design System Studio packages Atomic language.</h3>
          <p>
            Atomic defines the utility and token language. Design System Studio turns that
            language into inspectable UI conventions for humans and agents. This route is
            visual management only: no generated artifacts are written in this sprint.
          </p>
        </div>

        <div class="studio-card-grid">
          <article class="studio-card">
            <h4>Protect the spine</h4>
            <p>Visual Management -> Commit Canonical Artifacts -> Output Preview / Build / Bake.</p>
          </article>
          <article class="studio-card">
            <h4>Branch C boundary</h4>
            <p>Package field/input patterns without redefining Atomic utilities or protocol contracts.</p>
          </article>
          <article class="studio-card">
            <h4>First slice</h4>
            <p>Field Primitive and Input v0, using local mock state and proposed `ds-*` hooks.</p>
          </article>
        </div>
      </section>

      <section v-else-if="activeSection === 'tokens'" class="studio-panel">
        <div class="studio-copy">
          <h3>Proposed token map</h3>
          <p>
            These names are review candidates only. Branch B / Atomic must approve names,
            values, primitive mappings, and generated recipe behavior before any of this
            becomes doctrine.
          </p>
        </div>

        <div class="token-table">
          <div><strong>--field-control-height-*</strong><span>Size-specific control heights</span></div>
          <div><strong>--field-control-radius</strong><span>Input shell radius</span></div>
          <div><strong>--field-control-border</strong><span>Default border color</span></div>
          <div><strong>--field-control-border-focus</strong><span>Focus border/ring color</span></div>
          <div><strong>--field-helper-color</strong><span>Neutral support text</span></div>
          <div><strong>--field-error-color</strong><span>Validation text and invalid affordances</span></div>
        </div>
      </section>

      <section v-else-if="activeSection === 'typography'" class="studio-panel">
        <div class="studio-copy studio-copy--narrow">
          <h3>Typography is Branch B owned.</h3>
          <p>
            Field labels, input text, helper text, and error text will eventually map to
            Atomic type/rhythm primitives. This Studio may propose needs, but it must not
            finalize `f-*`, `v-*`, or rhythm semantics.
          </p>
        </div>
      </section>

      <section v-else-if="activeSection === 'fields'" class="studio-panel">
        <div class="studio-copy">
          <h3>Field Primitive anatomy</h3>
          <p>
            A field is a small interaction system: root, label, control, input, helper,
            error, optional leading icon, optional trailing icon or action, and required or
            optional indicators.
          </p>
        </div>

        <div class="studio-card-grid">
          <article class="studio-card">
            <h4>States</h4>
            <p>Default, hover, focus, disabled, readonly, and invalid.</p>
          </article>
          <article class="studio-card">
            <h4>Sizes</h4>
            <p>`sm`, `md`, and `lg` are the current draft sizes. `xs` and `xl` are reserved.</p>
          </article>
          <article class="studio-card">
            <h4>Accessibility</h4>
            <p>Use real labels, native state attributes, and connected helper/error text.</p>
          </article>
        </div>
      </section>

      <section v-else-if="activeSection === 'input'" class="studio-playground">
        <div class="studio-playground__left">
          <section class="studio-panel">
            <div class="studio-copy">
              <h3>Input v0 Playground</h3>
              <p>
                Local mock state only. The preview follows the Field Primitive anatomy and
                proposed Input v0 class strategy.
              </p>
            </div>

            <div class="control-grid">
              <label class="studio-control">
                <span>Size</span>
                <select v-model="fieldConfig.size">
                  <option value="sm">sm</option>
                  <option value="md">md</option>
                  <option value="lg">lg</option>
                </select>
              </label>

              <label class="studio-control">
                <span>Radius</span>
                <input v-model.number="fieldConfig.radius" type="range" min="0" max="24">
                <strong>{{ fieldConfig.radius }}px</strong>
              </label>

              <label class="studio-control">
                <span>Control height</span>
                <input v-model.number="fieldConfig.controlHeight" type="range" min="32" max="64">
                <strong>{{ fieldConfig.controlHeight }}px</strong>
              </label>

              <label class="studio-control">
                <span>Border color</span>
                <input v-model="fieldConfig.borderColor" type="color">
              </label>

              <label class="studio-control">
                <span>Focus color</span>
                <input v-model="fieldConfig.focusColor" type="color">
              </label>
            </div>

            <div class="toggle-grid">
              <label><input v-model="fieldConfig.invalid" type="checkbox"> Invalid state</label>
              <label><input v-model="fieldConfig.disabled" type="checkbox"> Disabled</label>
              <label><input v-model="fieldConfig.readonly" type="checkbox"> Readonly</label>
              <label><input v-model="fieldConfig.helperText" type="checkbox"> Helper text</label>
              <label><input v-model="fieldConfig.errorText" type="checkbox"> Error text</label>
              <label><input v-model="fieldConfig.leadingIcon" type="checkbox"> Leading icon</label>
              <label><input v-model="fieldConfig.trailingAction" type="checkbox"> Trailing action</label>
            </div>
          </section>

          <section class="studio-panel">
            <div class="studio-preview-head">
              <div>
                <h3>Live Input v0 Preview</h3>
                <p>{{ currentSize.label }}</p>
              </div>
              <span>Proposed recipe</span>
            </div>

            <div class="studio-preview-surface">
              <div
                class="ds-field ds-field--input ds-field-preview"
                :data-size="fieldConfig.size"
                :data-invalid="String(isInvalid)"
                :data-disabled="String(fieldConfig.disabled)"
                :data-readonly="String(fieldConfig.readonly)"
                :style="previewStyle"
              >
                <div class="ds-field-preview__label-row">
                  <label class="ds-field__label" for="studio-input-email">
                    Email
                  </label>
                  <span class="ds-field-preview__indicator">required</span>
                </div>

                <div class="ds-field__control">
                  <span
                    v-if="fieldConfig.leadingIcon"
                    class="ds-field__leading-icon"
                    aria-hidden="true"
                  >
                    @
                  </span>
                  <input
                    id="studio-input-email"
                    class="ds-input"
                    type="email"
                    name="email"
                    autocomplete="email"
                    value="michael@example.com"
                    :disabled="fieldConfig.disabled"
                    :readonly="fieldConfig.readonly"
                    :aria-invalid="isInvalid ? 'true' : 'false'"
                    :aria-describedby="describedBy"
                  >
                  <button
                    v-if="fieldConfig.trailingAction"
                    class="ds-field__trailing-action"
                    type="button"
                    aria-label="Clear email"
                  >
                    Clear
                  </button>
                </div>

                <p
                  v-if="fieldConfig.helperText"
                  id="studio-input-helper"
                  class="ds-field__helper"
                >
                  Use the email address connected to your account.
                </p>
                <p
                  v-if="fieldConfig.errorText"
                  id="studio-input-error"
                  class="ds-field__error"
                >
                  Enter a valid email address.
                </p>
              </div>
            </div>

            <div class="state-pills" aria-label="Current playground state">
              <span v-for="item in stateSummary" :key="item">{{ item }}</span>
            </div>
          </section>
        </div>

        <aside class="studio-output">
          <section class="studio-panel">
            <h3>Generated Output Preview</h3>
            <p class="studio-note">Preview only. Nothing is written to app artifacts.</p>

            <div class="output-block">
              <h4>Proposed HTML anatomy</h4>
              <pre><code>{{ proposedHtml }}</code></pre>
            </div>

            <div class="output-block">
              <h4>Proposed ds-* classes</h4>
              <div class="class-list">
                <span v-for="className in proposedClasses" :key="className">{{ className }}</span>
              </div>
            </div>

            <div class="output-block">
              <h4>Proposed CSS token variables</h4>
              <pre><code>{{ proposedCssTokens }}</code></pre>
            </div>

            <div class="output-block">
              <h4>Proposed agent cookbook snippet</h4>
              <pre><code>{{ proposedAgentSnippet }}</code></pre>
            </div>
          </section>
        </aside>
      </section>

      <section v-else-if="activeSection === 'orbit'" class="orbit-section">
        <section class="studio-panel">
          <div class="studio-copy">
            <h3>Orbit Dark preset v0</h3>
            <p>
              `orbit-dark` is a semantic dark application preset owned by Atomic and
              previewed here by Design System Studio. It distills the supplied dark token
              reference into a smaller Helios-native `--ds-*` subset.
            </p>
          </div>

          <div class="orbit-status-row">
            <span>{{ orbitDarkPreset.label }}</span>
            <span>{{ orbitDarkPreset.version }}</span>
            <span>Proposed `--ds-*` tokens</span>
            <span>No protocol/runtime changes</span>
          </div>
        </section>

        <section class="orbit-demo ds-app" data-theme="orbit-dark">
          <aside class="orbit-demo__sidebar ds-panel">
            <div class="orbit-demo__brand">
              <span>O</span>
              <div>
                <strong>Orbit</strong>
                <small class="ds-text-muted">Agent workspace</small>
              </div>
            </div>

            <nav class="orbit-demo__nav" aria-label="Orbit demo navigation">
              <button class="ds-control" type="button">Runs</button>
              <button class="ds-control" type="button">Tasks</button>
              <button class="ds-control" type="button">Context</button>
              <button class="ds-control" type="button">Notebooks</button>
            </nav>
          </aside>

          <main class="orbit-demo__main">
            <header class="orbit-demo__topbar ds-panel">
              <div>
                <p class="orbit-demo__eyebrow ds-text-muted">Design System Studio</p>
                <h3>Dark dashboard baseline</h3>
              </div>
              <div class="orbit-demo__actions">
                <button class="ds-button ds-button-secondary" type="button">Inspect tokens</button>
                <button class="ds-button ds-button-primary" type="button">Start run</button>
              </div>
            </header>

            <div class="orbit-demo__grid">
              <section class="orbit-demo__panel ds-panel">
                <div class="orbit-demo__panel-head">
                  <div>
                    <h4>Agent queue</h4>
                    <p class="ds-text-muted">Compact status blocks for real-time work.</p>
                  </div>
                  <span class="ds-chip ds-chip-success">Online</span>
                </div>

                <div class="orbit-task-list">
                  <article v-for="task in orbitTasks" :key="task.title" class="orbit-task ds-card">
                    <div>
                      <strong>{{ task.title }}</strong>
                      <p class="ds-text-muted">{{ task.meta }}</p>
                    </div>
                    <span
                      class="ds-chip"
                      :class="{
                        'ds-chip-success': task.state === 'Accepted',
                        'ds-chip-warning': task.state === 'Active',
                      }"
                    >
                      {{ task.state }}
                    </span>
                  </article>
                </div>
              </section>

              <section class="orbit-demo__panel ds-panel">
                <div class="orbit-demo__panel-head">
                  <div>
                    <h4>Field and button baseline</h4>
                    <p class="ds-text-muted">Token-backed controls using v0 semantic hooks.</p>
                  </div>
                </div>

                <div class="orbit-form">
                  <label>
                    <span>Run title</span>
                    <input class="ds-field" type="text" value="Orbit Dark review">
                  </label>

                  <label>
                    <span>Notes</span>
                    <textarea class="ds-field" rows="4">Review semantic token subset before promoting to Atomic doctrine.</textarea>
                  </label>

                  <label>
                    <span>Priority</span>
                    <select class="ds-field">
                      <option>Normal</option>
                      <option>High</option>
                      <option>Review gate</option>
                    </select>
                  </label>
                </div>
              </section>

              <section class="orbit-demo__panel orbit-demo__panel--wide ds-panel">
                <div class="orbit-demo__panel-head">
                  <div>
                    <h4>Agent events</h4>
                    <p class="ds-text-muted">Console-like work log with status chips.</p>
                  </div>
                  <span class="ds-chip ds-chip-warning">Live</span>
                </div>

                <div class="orbit-console">
                  <div v-for="event in orbitEvents" :key="event.label" class="orbit-console__row">
                    <span class="orbit-console__dot" aria-hidden="true"></span>
                    <strong>{{ event.label }}</strong>
                    <span class="ds-text-muted">{{ event.detail }}</span>
                    <span class="ds-chip">{{ event.status }}</span>
                  </div>
                </div>
              </section>
            </div>
          </main>
        </section>

        <section class="orbit-output-grid">
          <article class="studio-panel">
            <div class="studio-preview-head">
              <div>
                <h3>Token output viewer</h3>
                <p>Semantic subset only. Source reference was not copied wholesale.</p>
              </div>
              <span>Proposed</span>
            </div>

            <div class="orbit-token-table">
              <div class="orbit-token-table__head">
                <span>Group</span>
                <span>Token</span>
                <span>Value</span>
              </div>
              <div v-for="token in orbitTokenRows" :key="token.name" class="orbit-token-row">
                <span>{{ token.groupLabel }}</span>
                <code>{{ token.name }}</code>
                <span class="orbit-token-value">
                  <i :style="orbitTokenSwatchStyle(token.value)" aria-hidden="true"></i>
                  <code>{{ token.value }}</code>
                </span>
              </div>
            </div>
          </article>

          <article class="studio-panel">
            <h3>Generated output preview</h3>
            <p class="studio-note">Inspectable preview only. Artifact writing is future work.</p>

            <div class="output-block">
              <h4>CSS variables</h4>
              <pre><code>{{ orbitCssPreview }}</code></pre>
            </div>

            <div class="output-block">
              <h4>Proposed ds-* classes</h4>
              <div class="class-list">
                <span v-for="className in orbitShortcutNames" :key="className">{{ className }}</span>
              </div>
            </div>

            <div class="output-block">
              <h4>Agent cookbook snippet</h4>
              <pre><code>{{ orbitCookbookSnippet }}</code></pre>
            </div>
          </article>
        </section>
      </section>

      <section v-else-if="activeSection === 'showcase'" class="studio-panel">
        <div class="studio-copy">
          <h3>State showcase</h3>
          <p>
            The current playground can represent the first state set. A future sprint can
            turn this into a persistent generated showcase once Branch B accepts the token
            names and recipe strategy.
          </p>
        </div>
      </section>

      <section v-else-if="activeSection === 'agent'" class="studio-panel">
        <div class="studio-copy">
          <h3>Agent cookbook rules</h3>
          <p>
            Agents may use Field/Input when a single-line control needs a label, helper,
            error, state, or icon slot. They must not invent Atomic utilities or treat
            these proposed names as finalized doctrine.
          </p>
        </div>

        <div class="output-block output-block--wide">
          <pre><code>{{ proposedAgentSnippet }}</code></pre>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.helios-design-studio {
  min-height: 100vh;
  display: grid;
  grid-template-columns: minmax(220px, 280px) minmax(0, 1fr);
  background: #eef2f7;
  color: #111827;
}

.studio-sidebar {
  border-right: 1px solid #d5dce8;
  background: #f8fafc;
  padding: 24px 18px;
}

.studio-brand {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 28px;
}

.studio-brand__mark {
  width: 44px;
  height: 44px;
  display: grid;
  place-items: center;
  border-radius: 8px;
  background: #111827;
  color: #f8fafc;
  font-weight: 800;
  font-size: 0.9rem;
}

.studio-brand__eyebrow,
.studio-header__eyebrow {
  margin: 0;
  color: #667085;
  text-transform: uppercase;
  font-size: 0.72rem;
  font-weight: 800;
}

.studio-brand h1,
.studio-header h2 {
  margin: 2px 0 0;
  font-size: 1.25rem;
  line-height: 1.1;
}

.studio-nav {
  display: grid;
  gap: 6px;
}

.studio-nav__item {
  width: 100%;
  border: 1px solid transparent;
  border-radius: 8px;
  background: transparent;
  color: #344054;
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding: 11px 12px;
  text-align: left;
  cursor: pointer;
}

.studio-nav__item:hover {
  background: #edf2f7;
}

.studio-nav__item--active {
  background: #2563eb;
  color: #ffffff;
  box-shadow: 0 10px 24px rgba(37, 99, 235, 0.24);
}

.studio-nav__item small {
  color: currentColor;
  opacity: 0.72;
  font-size: 0.68rem;
  font-weight: 800;
  text-transform: uppercase;
}

.studio-main {
  min-width: 0;
  padding: 24px;
}

.studio-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 18px;
}

.studio-status {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 8px;
}

.studio-status span,
.studio-preview-head span,
.state-pills span,
.class-list span {
  border: 1px solid #d7deeb;
  border-radius: 999px;
  background: #ffffff;
  color: #344054;
  padding: 6px 10px;
  font-size: 0.76rem;
  font-weight: 800;
}

.studio-panel {
  border: 1px solid #d7deeb;
  border-radius: 8px;
  background: #ffffff;
  box-shadow: 0 14px 36px rgba(15, 23, 42, 0.08);
  padding: 22px;
}

.studio-copy {
  max-width: 850px;
}

.studio-copy--narrow {
  max-width: 680px;
}

.studio-copy h3,
.studio-panel h3 {
  margin: 0 0 8px;
  font-size: 1.05rem;
}

.studio-copy p,
.studio-panel p {
  margin: 0;
  color: #596579;
  line-height: 1.55;
}

.studio-card-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.studio-card {
  border: 1px solid #dde4ef;
  border-radius: 8px;
  background: #f8fafc;
  padding: 16px;
}

.studio-card h4,
.output-block h4 {
  margin: 0 0 8px;
  font-size: 0.88rem;
  text-transform: uppercase;
  color: #344054;
}

.token-table {
  display: grid;
  gap: 8px;
  margin-top: 18px;
}

.token-table div {
  display: grid;
  grid-template-columns: minmax(220px, 320px) minmax(0, 1fr);
  gap: 18px;
  border: 1px solid #dde4ef;
  border-radius: 8px;
  padding: 12px;
}

.token-table span {
  color: #667085;
}

.studio-playground {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(360px, 520px);
  gap: 18px;
  align-items: start;
}

.studio-playground__left {
  display: grid;
  gap: 18px;
  min-width: 0;
}

.control-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 12px;
  margin-top: 18px;
}

.studio-control {
  display: grid;
  gap: 8px;
  color: #344054;
  font-size: 0.78rem;
  font-weight: 800;
}

.studio-control select,
.studio-control input[type='range'],
.studio-control input[type='color'] {
  width: 100%;
}

.studio-control select {
  border: 1px solid #cfd6e3;
  border-radius: 8px;
  background: #ffffff;
  padding: 9px 10px;
  color: #111827;
  font-weight: 700;
}

.studio-control input[type='color'] {
  height: 38px;
  border: 1px solid #cfd6e3;
  border-radius: 8px;
  background: #ffffff;
}

.studio-control strong {
  color: #667085;
  font-size: 0.76rem;
}

.toggle-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
  margin-top: 18px;
}

.toggle-grid label {
  display: flex;
  align-items: center;
  gap: 8px;
  border: 1px solid #dde4ef;
  border-radius: 8px;
  background: #f8fafc;
  padding: 10px;
  color: #344054;
  font-size: 0.82rem;
  font-weight: 750;
}

.studio-preview-head {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
  margin-bottom: 14px;
}

.studio-preview-surface {
  border: 1px solid #d7deeb;
  border-radius: 8px;
  background:
    linear-gradient(90deg, rgba(37, 99, 235, 0.07) 1px, transparent 1px),
    linear-gradient(0deg, rgba(37, 99, 235, 0.07) 1px, transparent 1px),
    #f8fafc;
  background-size: 28px 28px;
  padding: 28px;
}

.ds-field-preview {
  max-width: 520px;
  display: grid;
  gap: var(--ds-field-gap-proposed);
}

.ds-field-preview__label-row {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  align-items: baseline;
}

.ds-field__label {
  color: #344054;
  font-size: var(--ds-field-label-size-proposed);
  font-weight: 800;
}

.ds-field-preview__indicator {
  color: #667085;
  font-size: 0.72rem;
  font-weight: 750;
}

.ds-field__control {
  min-height: var(--ds-field-control-height-proposed);
  display: flex;
  align-items: center;
  gap: var(--ds-field-gap-proposed);
  border: 1px solid var(--ds-field-control-border-proposed);
  border-radius: var(--ds-field-control-radius-proposed);
  background: #ffffff;
  padding-inline: var(--ds-field-control-px-proposed);
  transition: border-color 140ms ease, box-shadow 140ms ease;
}

.ds-field__control:focus-within {
  border-color: var(--ds-field-focus-ring-proposed);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--ds-field-focus-ring-proposed) 18%, transparent);
}

.ds-field[data-invalid='true'] .ds-field__control {
  border-color: #dc2626;
}

.ds-field[data-disabled='true'] {
  opacity: 0.62;
}

.ds-field__leading-icon {
  color: #667085;
  font-weight: 900;
}

.ds-input {
  min-width: 0;
  flex: 1;
  border: 0;
  outline: 0;
  background: transparent;
  color: #111827;
  font-size: var(--ds-field-input-size-proposed);
  font-weight: 650;
}

.ds-input:disabled {
  cursor: not-allowed;
}

.ds-field__trailing-action {
  border: 1px solid #d7deeb;
  border-radius: 6px;
  background: #f8fafc;
  color: #344054;
  padding: 5px 8px;
  font-size: 0.75rem;
  font-weight: 800;
}

.ds-field__helper,
.ds-field__error {
  font-size: var(--ds-field-helper-size-proposed);
  line-height: 1.45;
}

.ds-field__helper {
  color: #667085;
}

.ds-field__error {
  color: #b91c1c;
  font-weight: 750;
}

.state-pills,
.class-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 14px;
}

.studio-output {
  min-width: 0;
}

.studio-note {
  margin-bottom: 14px;
  font-size: 0.86rem;
}

.output-block {
  border-top: 1px solid #e2e8f0;
  padding-top: 16px;
  margin-top: 16px;
}

.output-block--wide {
  max-width: 760px;
}

pre {
  max-height: 360px;
  overflow: auto;
  border-radius: 8px;
  background: #0f172a;
  color: #dbeafe;
  padding: 14px;
  font-size: 0.76rem;
  line-height: 1.45;
}

code {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', monospace;
}

.orbit-section {
  display: grid;
  gap: 18px;
}

.orbit-status-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 18px;
}

.orbit-status-row span {
  border: 1px solid #d7deeb;
  border-radius: 999px;
  background: #f8fafc;
  color: #344054;
  padding: 6px 10px;
  font-size: 0.76rem;
  font-weight: 800;
}

.orbit-demo {
  min-height: 640px;
  display: grid;
  grid-template-columns: minmax(190px, 240px) minmax(0, 1fr);
  gap: 18px;
  border-radius: 12px;
  padding: 18px;
  overflow: hidden;
}

.orbit-demo__sidebar,
.orbit-demo__topbar,
.orbit-demo__panel {
  padding: 18px;
}

.orbit-demo__brand {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 18px;
}

.orbit-demo__brand span {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border-radius: var(--ds-radius-lg);
  background: var(--ds-accent-soft);
  color: var(--ds-accent-text);
  font-weight: 900;
}

.orbit-demo__brand strong,
.orbit-demo__panel h4,
.orbit-demo__topbar h3 {
  display: block;
  margin: 0;
}

.orbit-demo__brand small {
  display: block;
  margin-top: 2px;
}

.orbit-demo__nav {
  display: grid;
  gap: 8px;
}

.orbit-demo__nav .ds-control {
  min-height: 38px;
  padding-inline: 12px;
  text-align: left;
  cursor: pointer;
}

.orbit-demo__main {
  min-width: 0;
  display: grid;
  gap: 18px;
}

.orbit-demo__topbar,
.orbit-demo__panel-head,
.orbit-task,
.orbit-console__row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}

.orbit-demo__eyebrow {
  margin: 0 0 4px;
  text-transform: uppercase;
  font-size: 0.72rem;
  font-weight: 800;
}

.orbit-demo__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.orbit-demo__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.orbit-demo__panel {
  display: grid;
  align-content: start;
  gap: 16px;
}

.orbit-demo__panel--wide {
  grid-column: 1 / -1;
}

.orbit-demo__panel p,
.orbit-task p {
  margin: 4px 0 0;
}

.orbit-task-list,
.orbit-form,
.orbit-console {
  display: grid;
  gap: 10px;
}

.orbit-task {
  padding: 14px;
}

.orbit-form label {
  display: grid;
  gap: 8px;
  color: var(--ds-field-label-text);
  font-size: 0.8rem;
  font-weight: 800;
}

.orbit-form textarea.ds-field {
  padding-block: 10px;
  resize: vertical;
}

.orbit-form select.ds-field {
  appearance: auto;
}

.orbit-console {
  border: 1px solid var(--ds-border-subtle);
  border-radius: var(--ds-radius-lg);
  background: color-mix(in srgb, var(--ds-bg-root) 72%, transparent);
  padding: 10px;
}

.orbit-console__row {
  justify-content: flex-start;
  min-height: 36px;
  font-size: 0.84rem;
}

.orbit-console__row strong {
  min-width: 140px;
}

.orbit-console__row .ds-chip {
  margin-left: auto;
}

.orbit-console__dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: var(--ds-accent);
  box-shadow: 0 0 0 4px var(--ds-accent-soft);
}

.orbit-output-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(360px, 0.85fr);
  gap: 18px;
  align-items: start;
}

.orbit-token-table {
  display: grid;
  gap: 6px;
  max-height: 560px;
  overflow: auto;
  margin-top: 14px;
}

.orbit-token-table__head,
.orbit-token-row {
  display: grid;
  grid-template-columns: minmax(110px, 150px) minmax(190px, 1fr) minmax(240px, 1.1fr);
  gap: 12px;
  align-items: center;
}

.orbit-token-table__head {
  position: sticky;
  top: 0;
  z-index: 1;
  border-radius: 8px;
  background: #f8fafc;
  color: #344054;
  padding: 10px 12px;
  font-size: 0.72rem;
  font-weight: 900;
  text-transform: uppercase;
}

.orbit-token-row {
  border: 1px solid #dde4ef;
  border-radius: 8px;
  padding: 10px 12px;
  background: #ffffff;
}

.orbit-token-row > span:first-child {
  color: #667085;
  font-size: 0.78rem;
  font-weight: 800;
}

.orbit-token-value {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}

.orbit-token-value i {
  width: 28px;
  height: 20px;
  flex: 0 0 auto;
  border: 1px solid #d7deeb;
  border-radius: 5px;
}

@media (max-width: 1180px) {
  .studio-playground {
    grid-template-columns: 1fr;
  }

  .orbit-output-grid {
    grid-template-columns: 1fr;
  }

  .control-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 820px) {
  .helios-design-studio {
    grid-template-columns: 1fr;
  }

  .studio-sidebar {
    position: sticky;
    top: 0;
    z-index: 10;
    border-right: 0;
    border-bottom: 1px solid #d5dce8;
    padding: 14px;
  }

  .studio-nav {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .studio-main {
    padding: 14px;
  }

  .studio-header,
  .studio-preview-head {
    display: grid;
  }

  .studio-status {
    justify-content: flex-start;
  }

  .studio-card-grid,
  .control-grid,
  .toggle-grid,
  .token-table div,
  .orbit-demo,
  .orbit-demo__grid,
  .orbit-token-table__head,
  .orbit-token-row {
    grid-template-columns: 1fr;
  }

  .orbit-demo__topbar,
  .orbit-demo__panel-head,
  .orbit-task,
  .orbit-console__row {
    align-items: flex-start;
  }

  .orbit-demo__topbar,
  .orbit-demo__panel-head,
  .orbit-task {
    display: grid;
  }

  .orbit-console__row {
    flex-wrap: wrap;
  }

  .orbit-console__row .ds-chip {
    margin-left: 0;
  }
}
</style>
