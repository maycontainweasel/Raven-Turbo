import { mergeConfigs } from '@unocss/core'
import { existsSync } from 'node:fs'
import { defineConfig, presetAttributify, presetIcons, presetWind4 } from 'unocss'
import transformerVariantGroup from '@unocss/transformer-variant-group'
import lucideIcons from '@iconify-json/lucide/icons.json'

const overridesPath = new URL('./uno.overrides.config.ts', import.meta.url)
const heliosPath = new URL('./app/helios/generated/uno.generated.ts', import.meta.url)

const studioBase = defineConfig({
  presets: [
    presetWind4({
      preflights: {
        reset: true,
        theme: true,
      },
    }),
    presetIcons({
      collections: {
        lucide: lucideIcons,
      },
      extraProperties: {
        display: 'inline-block',
        'vertical-align': 'middle',
      },
    }),
    presetAttributify(),
  ],
  transformers: [transformerVariantGroup()],
})

function isObjectLike(value: unknown): value is Record<PropertyKey, unknown> {
  return value !== null && typeof value === 'object'
}

function toPlainConfig<T>(value: T, seen = new WeakMap<object, unknown>()): T {
  if (Array.isArray(value)) {
    return value.map((entry) => toPlainConfig(entry, seen)) as T
  }

  if (!isObjectLike(value)) {
    return value
  }

  if (seen.has(value)) {
    return seen.get(value) as T
  }

  const proto = Object.getPrototypeOf(value)
  if (proto !== null && proto !== Object.prototype) {
    return value
  }

  const out: Record<PropertyKey, unknown> = {}
  seen.set(value, out)
  for (const key of Reflect.ownKeys(value)) {
    out[key] = toPlainConfig(value[key], seen)
  }
  return out as T
}

function hasPresetEntries(value: unknown) {
  return isObjectLike(value) && Array.isArray(value.presets) && value.presets.length > 0
}

let base: any = {}
try {
  const mod = await import('./.nuxt/uno.config.mjs')
  base = (mod as any).default ?? mod
} catch {
  base = {}
}

let heliosGenerated: any = {}
if (existsSync(heliosPath)) {
  try {
    const mod = await import('./app/helios/generated/uno.generated.ts')
    heliosGenerated = mod.default ?? {}
  } catch {
    heliosGenerated = {}
  }
}

let overrides: any = {}
if (existsSync(overridesPath)) {
  try {
    const mod = await import('./uno.overrides.config.ts')
    overrides = mod.default ?? {}
  } catch {
    overrides = {}
  }
}

const configs = [
  base,
  hasPresetEntries(heliosGenerated) ? {} : studioBase,
  heliosGenerated,
  overrides,
].map((config) => toPlainConfig(config))

export default mergeConfigs(configs)
