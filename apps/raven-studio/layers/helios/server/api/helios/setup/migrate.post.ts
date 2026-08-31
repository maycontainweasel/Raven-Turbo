import { defineEventHandler } from 'h3'
import { createHeliosStorageAdapter } from '../../../utils/helios-storage/index.ts'

export default defineEventHandler(async () => {
  const storage = createHeliosStorageAdapter()
  return storage.migrate()
})
