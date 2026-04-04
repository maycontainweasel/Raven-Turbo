import { defineNuxtPlugin } from '#imports'

export const normalizePayloadValue = (
  value: unknown,
  seen = new WeakMap<object, any>(),
): any => {
  if (!value || typeof value !== 'object') return value

  if (Array.isArray(value)) {
    if (seen.has(value)) return seen.get(value)
    const next: any[] = []
    seen.set(value, next)
    for (const item of value) {
      next.push(normalizePayloadValue(item, seen))
    }
    return next
  }

  if (Object.prototype.toString.call(value) !== '[object Object]') return value

  if (seen.has(value as object)) return seen.get(value as object)
  const next: Record<string, any> = {}
  seen.set(value as object, next)
  for (const [key, nested] of Object.entries(value as Record<string, any>)) {
    next[key] = normalizePayloadValue(nested, seen)
  }
  return next
}

const normalizeNuxtPayload = (payload: Record<string, any>) => {
  const normalized = normalizePayloadValue(payload)
  if (!normalized || typeof normalized !== 'object') return payload

  for (const key of Object.keys(payload)) {
    delete payload[key]
  }

  for (const [key, value] of Object.entries(normalized)) {
    payload[key] = value
  }

  return payload
}

export default defineNuxtPlugin({
  name: 'payload-normalize',
  order: -50,
  setup(nuxtApp) {
    if (import.meta.server) {
      nuxtApp.hook('app:rendered', ({ ssrContext }) => {
        const payload = ssrContext?.payload as Record<string, any> | undefined
        if (!payload || typeof payload !== 'object') return
        normalizeNuxtPayload(payload)
      })
    }

    if (import.meta.client) {
      const payload = nuxtApp.payload as Record<string, any>
      if (payload && typeof payload === 'object') {
        normalizeNuxtPayload(payload)
      }
    }
  },
})
