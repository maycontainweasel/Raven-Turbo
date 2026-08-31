import { createError, defineEventHandler, readBody } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'
import type { HeliosRecordRef } from '@helios/protocol'

export default defineEventHandler(async (event) => {
  const body = await readBody<{
    record?: HeliosRecordRef | string
  }>(event)

  if (!body?.record) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Helios node record is required',
    })
  }

  const storage = createHeliosStorageAdapter()
  return storage.deleteNode(body.record)
})
