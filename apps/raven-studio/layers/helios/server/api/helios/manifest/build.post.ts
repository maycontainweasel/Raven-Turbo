import { defineEventHandler, readBody } from 'h3'
import {
  createHeliosPageManifest,
  HELIOS_CANVAS_MAX_COLS,
  HELIOS_CANVAS_MAX_ROWS,
} from '@helios/protocol'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const documentId = String(body?.documentId || 'page:home')
  const zoneId = String(body?.zoneId || 'home-main')
  const cols = Math.max(1, Math.min(HELIOS_CANVAS_MAX_COLS, Math.round(Number(body?.cols || 24))))
  const rows = Math.max(1, Math.min(HELIOS_CANVAS_MAX_ROWS, Math.round(Number(body?.rows || 24))))
  const canvasHeight = Math.max(1, Math.round(Number(body?.canvasHeight || 720)))
  const nodes = await createHeliosStorageAdapter().listNodes({ documentId, zoneId })

  return createHeliosPageManifest({
    pageId: documentId,
    nodes,
    cols,
    rows,
    canvasHeight,
  })
})
