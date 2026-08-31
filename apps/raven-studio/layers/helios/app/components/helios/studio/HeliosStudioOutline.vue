<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import type { HeliosStudioOutlineItem } from '../../../config/heliosStudioNavigation'

const props = defineProps<{
  items: HeliosStudioOutlineItem[]
}>()

const route = useRoute()
const activeHash = ref(route.hash || props.items[0]?.hash || '')
let observer: IntersectionObserver | undefined

const observeSections = async () => {
  observer?.disconnect()
  await nextTick()

  if (!props.items.length) return

  observer = new IntersectionObserver((entries) => {
    const visible = entries
      .filter((entry) => entry.isIntersecting)
      .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top)

    if (visible[0]?.target.id) activeHash.value = `#${visible[0].target.id}`
  }, {
    rootMargin: '-96px 0px -65% 0px',
    threshold: [0, 1],
  })

  props.items.forEach((item) => {
    const target = document.getElementById(item.hash.slice(1))
    if (target) observer?.observe(target)
  })
}

watch(() => [route.path, props.items], observeSections, { deep: true })
watch(() => route.hash, (hash) => {
  if (hash) activeHash.value = hash
})

onMounted(observeSections)
onBeforeUnmount(() => observer?.disconnect())
</script>

<template>
  <aside v-if="items.length" class="studio-outline" aria-label="On this page">
    <div class="studio-outline__sticky">
      <h2>
        <span class="i-lucide-list" aria-hidden="true" />
        On this page
      </h2>
      <nav aria-label="Page outline">
        <a
          v-for="item in items"
          :key="item.hash"
          :class="{ 'studio-outline__link--active': activeHash === item.hash }"
          :href="item.hash"
        >
          {{ item.label }}
        </a>
      </nav>
    </div>
  </aside>
</template>
