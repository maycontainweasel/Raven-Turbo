<script setup lang="ts">
import { Dialog } from '@ark-ui/vue/dialog'

const open = useState('raven-command-palette-open', () => false)
const query = ref('')
const activeIndex = ref(0)
const { paletteActions } = useRavenActions()

const filteredActions = computed(() => {
  const needle = query.value.trim().toLowerCase()
  if (!needle) return paletteActions.value
  return paletteActions.value.filter((action) =>
    `${action.label} ${action.description} ${action.group}`.toLowerCase().includes(needle),
  )
})
const groupedActions = computed(() => {
  const order = ['Navigate', 'Create', 'Account'] as const
  return order
    .map((group) => ({
      group,
      actions: filteredActions.value.filter((action) => action.group === group),
    }))
    .filter((section) => section.actions.length)
})

const run = async (action: (typeof paletteActions.value)[number]) => {
  open.value = false
  query.value = ''
  await action.run()
}
const actionIndex = (action: (typeof paletteActions.value)[number]) => filteredActions.value.indexOf(action)
const handlePaletteKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') {
    open.value = false
    return
  }
  if (event.key === 'ArrowDown') {
    event.preventDefault()
    activeIndex.value = Math.min(activeIndex.value + 1, filteredActions.value.length - 1)
  }
  if (event.key === 'ArrowUp') {
    event.preventDefault()
    activeIndex.value = Math.max(activeIndex.value - 1, 0)
  }
  if (event.key === 'Enter') {
    event.preventDefault()
    const action = filteredActions.value[activeIndex.value]
    if (action) void run(action)
  }
}

const handleKeydown = (event: KeyboardEvent) => {
  if (!(event.metaKey || event.ctrlKey)) return
  if (event.key.toLowerCase() !== 'p' && event.key.toLowerCase() !== 'k') return
  event.preventDefault()
  open.value = !open.value
}

onMounted(() => window.addEventListener('keydown', handleKeydown))
onBeforeUnmount(() => window.removeEventListener('keydown', handleKeydown))
watch(query, () => {
  activeIndex.value = 0
})
watch(open, (nextOpen) => {
  if (nextOpen) activeIndex.value = 0
})
</script>

<template>
  <Dialog.Root :open="open" @open-change="({ open: nextOpen }) => (open = nextOpen)">
    <Teleport to="body">
      <Dialog.Backdrop class="raven-dialog-backdrop" />
      <Dialog.Positioner class="raven-dialog-positioner raven-palette-positioner">
        <Dialog.Content class="raven-dialog raven-palette">
          <Dialog.Title class="sr-only">Raven command palette</Dialog.Title>
          <div class="raven-palette__search">
            <span class="i-lucide-search" aria-hidden="true" />
            <input
              v-model="query"
              class="raven-palette__input"
              type="search"
              placeholder="Search routes and actions"
              autofocus
              @keydown="handlePaletteKeydown"
            />
            <kbd>Esc</kbd>
          </div>
          <p class="raven-palette__hint">Type to navigate Raven or create a financial record.</p>
          <div class="raven-palette__list">
            <section v-for="section in groupedActions" :key="section.group" class="raven-palette__section">
              <h2>{{ section.group }}</h2>
              <button
                v-for="action in section.actions"
                :key="action.id"
                type="button"
                class="raven-palette__action"
                :class="{ 'is-active': actionIndex(action) === activeIndex }"
                @mouseenter="activeIndex = actionIndex(action)"
                @click="run(action)"
              >
                <span :class="action.icon" aria-hidden="true" />
                <span>
                  <strong>{{ action.label }}</strong>
                  <small>{{ action.description }}</small>
                </span>
                <span class="raven-palette__group">{{ action.group }}</span>
              </button>
            </section>
            <p v-if="filteredActions.length === 0" class="raven-palette__empty">No matching action.</p>
          </div>
          <footer class="raven-palette__footer">
            <span>↑↓ Move</span>
            <span>↵ Select</span>
            <span>⌘K Open anywhere</span>
          </footer>
        </Dialog.Content>
      </Dialog.Positioner>
    </Teleport>
  </Dialog.Root>
</template>

<style scoped>
.raven-palette-positioner {
  place-items: start center;
  padding-top: max(11vh, 72px);
}

.raven-palette {
  width: min(100%, 700px);
  max-height: min(78vh, 780px);
  overflow: hidden;
  border-color: #343434;
  border-radius: 12px;
}

.raven-palette__search {
  display: grid;
  grid-template-columns: 20px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  border-bottom: 1px solid var(--raven-border);
  margin: 18px 18px 0;
  border: 1px solid var(--raven-border);
  border-radius: 8px;
  padding: 10px 13px;
  background: var(--raven-panel-raised);
}

.raven-palette__input {
  min-height: 34px;
  border: 0;
  padding: 0;
  background: transparent;
  font-size: 16px;
}

.raven-palette__input:focus {
  outline: 0;
}

kbd {
  border: 1px solid var(--raven-border);
  border-radius: 4px;
  padding: 2px 5px;
  color: var(--raven-muted);
  font-size: 11px;
}

.raven-palette__hint {
  margin: 14px 18px 8px;
  color: var(--raven-faint);
  font-size: 11px;
}

.raven-palette__list {
  max-height: min(58vh, 570px);
  overflow-y: auto;
  padding: 0 12px 12px;
}

.raven-palette__section h2 {
  margin: 14px 8px 6px;
  color: var(--raven-faint);
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.045em;
  text-transform: uppercase;
}

.raven-palette__action {
  width: 100%;
  min-height: 62px;
  display: grid;
  grid-template-columns: 22px minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  border: 0;
  border-radius: 7px;
  padding: 9px 12px;
  background: transparent;
  color: var(--raven-text);
  text-align: left;
  cursor: pointer;
}

.raven-palette__action:hover,
.raven-palette__action.is-active {
  background: #111713;
}

.raven-palette__action strong,
.raven-palette__action small {
  display: block;
}

.raven-palette__action strong {
  font-size: 14px;
}

.raven-palette__action small,
.raven-palette__group,
.raven-palette__empty {
  color: var(--raven-muted);
  font-size: 12px;
}

.raven-palette__empty {
  margin: 0;
  padding: 24px;
  text-align: center;
}

.raven-palette__footer {
  display: flex;
  align-items: center;
  gap: 18px;
  border-top: 1px solid var(--raven-border);
  padding: 10px 18px 12px;
  color: var(--raven-faint);
  font-size: 10px;
}

.raven-palette__footer span:last-child {
  margin-left: auto;
}
</style>
