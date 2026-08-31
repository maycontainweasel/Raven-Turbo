import type { H3Event } from 'h3'

type ContextBase = Record<string, unknown>

export async function createContextExt(_event: H3Event, _base: ContextBase) {
  return {}
}
