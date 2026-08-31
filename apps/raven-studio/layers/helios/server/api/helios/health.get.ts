import { defineEventHandler } from 'h3'
import { getHeliosStorageSafeConfig } from '../../utils/helios-storage/index.ts'

export default defineEventHandler(() => {
  const storage = getHeliosStorageSafeConfig()
  return {
    ok: true,
    service: 'helios-layer',
    storage,
  }
})
