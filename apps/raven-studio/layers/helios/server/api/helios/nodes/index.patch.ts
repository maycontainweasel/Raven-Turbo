import { createError, defineEventHandler, readBody } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'
import type { HeliosNodePatch } from '../../../utils/helios-storage/index.ts'
import type { HeliosRecordRef } from '@helios/protocol'

export default defineEventHandler(async (event) => {
  const body = await readBody<{
    record?: HeliosRecordRef | string
    patch?: HeliosNodePatch
  }>(event)

  if (!body?.record) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Helios node record is required',
    })
  }

  const storage = createHeliosStorageAdapter()
  const node = await storage.updateNode(body.record, body.patch || {})

  return {
    ok: true,
    node,
  }
})
