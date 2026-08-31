<script setup lang="ts">
import { Menu } from '@ark-ui/vue/menu'

const { actions } = useRavenActions()
const createActions = computed(() => actions.value.filter((action) => action.group === 'Create'))
</script>

<template>
  <Menu.Root>
    <Menu.Trigger as-child>
      <button class="raven-button" type="button">
        <span class="i-lucide-plus" aria-hidden="true" />
        <span class="raven-topbar__add-label">Add</span>
        <span class="i-lucide-chevron-down" aria-hidden="true" />
      </button>
    </Menu.Trigger>
    <Teleport to="body">
      <Menu.Positioner class="raven-menu-positioner">
        <Menu.Content class="raven-menu">
          <Menu.Item
            v-for="action in createActions"
            :key="action.id"
            :value="action.id"
            class="raven-menu__item"
            @click="action.run"
          >
            <span :class="action.icon" aria-hidden="true" />
            <span>{{ action.label }}</span>
          </Menu.Item>
        </Menu.Content>
      </Menu.Positioner>
    </Teleport>
  </Menu.Root>
</template>

<style scoped>
.raven-menu-positioner { z-index: 75; }
.raven-menu { min-width: 210px; border: 1px solid var(--raven-border); border-radius: 7px; padding: 5px; background: var(--raven-panel); box-shadow: 0 12px 36px rgb(0 0 0 / 0.28); }
.raven-menu__item { min-height: 38px; display: flex; align-items: center; gap: 9px; border-radius: 4px; padding: 7px 9px; cursor: pointer; outline: none; }
.raven-menu__item[data-highlighted] { background: var(--raven-panel-subtle); }
</style>
