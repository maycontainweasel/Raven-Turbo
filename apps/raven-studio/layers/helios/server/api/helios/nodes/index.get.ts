import { createError, defineEventHandler, getQuery } from 'h3'
import {
  createHeliosStorageAdapter,
  formatHeliosStorageUnavailableMessage,
  isHeliosStorageUnavailableError,
} from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const documentId = String(query.documentId || '').trim()
  const zoneId = String(query.zoneId || '').trim()

  if (!documentId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'documentId is required',
    })
  }

  try {
    const storage = createHeliosStorageAdapter()
    const nodes = await storage.listNodes({
      documentId,
      zoneId: zoneId || undefined,
    })

    return {
      ok: true,
      nodes,
    }
  } catch (error) {
    if (isHeliosStorageUnavailableError(error)) {
      return {
        ok: false,
        nodes: [],
        storage: {
          available: false,
          message: formatHeliosStorageUnavailableMessage(error),
        },
      }
    }

    throw error
  }
})
