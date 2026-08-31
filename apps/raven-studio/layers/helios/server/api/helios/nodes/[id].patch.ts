import { createError, defineEventHandler, getRouterParam, readBody } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'
import type { HeliosNodePatch } from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  if (!id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Helios node id is required',
    })
  }

  const patch = await readBody<HeliosNodePatch>(event)
  const storage = createHeliosStorageAdapter()
  const node = await storage.updateNode(id, patch || {})

  return {
    ok: true,
    node,
  }
})
