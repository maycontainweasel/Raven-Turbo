import { existsSync } from 'node:fs'
import { mergeConfigs } from '@unocss/core'
import base from './.nuxt/uno.config.mjs'

const heliosPath = new URL('./app/helios/generated/uno.generated.ts', import.meta.url)
const overridesPath = new URL('./uno.overrides.config.ts', import.meta.url)

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

export default mergeConfigs([base, heliosGenerated, overrides])
