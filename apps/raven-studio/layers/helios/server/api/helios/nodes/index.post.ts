import { createError, defineEventHandler, readBody } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'
import type { HeliosNodeCreateInput } from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async (event) => {
  const body = await readBody<Partial<HeliosNodeCreateInput>>(event)
  const documentId = String(body?.documentId || '').trim()
  const zoneId = String(body?.zoneId || '').trim()

  if (!documentId || !zoneId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'documentId and zoneId are required',
    })
  }

  const storage = createHeliosStorageAdapter()
  const node = await storage.createNode({
    documentId,
    zoneId,
    kind: body.kind || 'frame',
    parent: body.parent || null,
    parentId: body.parentId || null,
    order: Number.isFinite(Number(body.order)) ? Number(body.order) : 0,
    label: body.label,
    content: body.content,
    qualities: body.qualities || {},
    meta: body.meta || {},
  })

  return {
    ok: true,
    node,
  }
})
