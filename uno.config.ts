import { mergeConfigs } from '@unocss/core'
import { existsSync } from 'node:fs'

const overridesPath = new URL('./uno.overrides.config.ts', globalThis._importMeta_.url)
const heliosPath = new URL('./app/helios/generated/uno.generated.ts', globalThis._importMeta_.url)

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
    heliosGenerated = (mod as any).default ?? {}
  } catch {
    heliosGenerated = {}
  }
}

let overrides: any = {}
if (existsSync(overridesPath)) {
  try {
    const mod = await import('./uno.overrides.config.ts')
    overrides = (mod as any).default ?? {}
  } catch {
    overrides = {}
  }
}

export default mergeConfigs([base, heliosGenerated, overrides])
