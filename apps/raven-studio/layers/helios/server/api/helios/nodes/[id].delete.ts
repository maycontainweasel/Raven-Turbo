import { createError, defineEventHandler, getRouterParam } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async (event) => {
  const id = getRouterParam(event, 'id')
  if (!id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Helios node id is required',
    })
  }

  const storage = createHeliosStorageAdapter()
  return storage.deleteNode(id)
})
