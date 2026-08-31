<script setup lang="ts">
import { Menu } from '@ark-ui/vue/menu'

const { actions } = useRavenActions()

const run = async (action: (typeof actions.value)[number]) => {
  await action.run()
}
</script>

<template>
  <Menu.Root>
    <Menu.Trigger as-child>
      <button class="raven-icon-button" type="button" aria-label="Open Raven menu" title="Menu">
        <span class="i-lucide-ellipsis" aria-hidden="true" />
      </button>
    </Menu.Trigger>
    <Teleport to="body">
      <Menu.Positioner class="raven-menu-positioner">
        <Menu.Content class="raven-menu">
          <Menu.Item
            v-for="action in actions"
            :key="action.id"
            :value="action.id"
            class="raven-menu__item"
            @click="run(action)"
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
.raven-menu-positioner {
  z-index: 75;
}

.raven-menu {
  min-width: 190px;
  border: 1px solid var(--raven-border);
  border-radius: 7px;
  padding: 5px;
  background: var(--raven-panel);
  box-shadow: 0 12px 36px rgb(0 0 0 / 0.2);
}

.raven-menu__item {
  min-height: 36px;
  display: flex;
  align-items: center;
  gap: 9px;
  border-radius: 4px;
  padding: 7px 9px;
  cursor: pointer;
  outline: none;
}

.raven-menu__item[data-highlighted] {
  background: var(--raven-panel-subtle);
}
</style>
