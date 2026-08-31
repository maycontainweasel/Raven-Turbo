import { HELIOS_NODE_TABLE, type HeliosStorageConfig, type HeliosStorageSafeConfig } from './types.ts'
import { createSurrealHeliosStorageAdapter } from './surreal.ts'

const readRuntime = () => (
  typeof useRuntimeConfig === 'function' ? useRuntimeConfig() as any : {}
)

const normalizeTableName = (value: unknown) => {
  const table = String(value || '').trim()
  return /^[a-zA-Z_][a-zA-Z0-9_]*$/.test(table) ? table : HELIOS_NODE_TABLE
}

export const getHeliosStorageConfig = (): HeliosStorageConfig => {
  const runtime = readRuntime()
  const heliosStorage = runtime?.helios?.storage || {}
  const legacySurreal = runtime?.surrealdb || {}

  return {
    driver: 'surreal',
    table: normalizeTableName(heliosStorage.table || process.env.NUXT_HELIOS_NODE_TABLE),
    url: heliosStorage.url || legacySurreal.url || process.env.NUXT_HELIOS_SURREALDB_URL || process.env.NUXT_SURREALDB_URL || '',
    namespace: heliosStorage.namespace || legacySurreal.namespace || process.env.NUXT_HELIOS_SURREALDB_NAMESPACE || process.env.NUXT_SURREALDB_NAMESPACE || '',
    database: heliosStorage.database || legacySurreal.database || process.env.NUXT_HELIOS_SURREALDB_DATABASE || process.env.NUXT_SURREALDB_DATABASE || '',
    user: heliosStorage.user || legacySurreal.user || process.env.NUXT_HELIOS_SURREALDB_USER || process.env.NUXT_SURREALDB_USER || '',
    pass: heliosStorage.pass || legacySurreal.pass || process.env.NUXT_HELIOS_SURREALDB_PASS || process.env.NUXT_SURREALDB_PASS || '',
  }
}

export const getHeliosStorageSafeConfig = (): HeliosStorageSafeConfig => {
  const config = getHeliosStorageConfig()
  return {
    driver: config.driver,
    table: config.table,
    configured: Boolean(config.url && config.namespace && config.database && config.user && config.pass),
    urlConfigured: Boolean(config.url),
    namespaceConfigured: Boolean(config.namespace),
    databaseConfigured: Boolean(config.database),
    userConfigured: Boolean(config.user),
  }
}

export const createHeliosStorageAdapter = () => {
  const config = getHeliosStorageConfig()
  return createSurrealHeliosStorageAdapter(config)
}

const storageErrorMessage = (error: unknown) => {
  const err = error as any
  return String(
    err?.statusMessage
    || err?.cause?.message
    || err?.message
    || err
    || 'Helios storage is unavailable',
  )
}

export const isHeliosStorageUnavailableError = (error: unknown) => {
  const message = storageErrorMessage(error).toLowerCase()
  return (
    message.includes('fetch failed')
    || message.includes('failed to fetch')
    || message.includes('econnrefused')
    || message.includes('connection refused')
    || message.includes('missing nuxt_helios_surrealdb')
    || message.includes('missing nuxt_surrealdb')
    || message.includes('missing surrealdb credentials')
  )
}

export const formatHeliosStorageUnavailableMessage = (error: unknown) => {
  const message = storageErrorMessage(error)
  if (message.toLowerCase().includes('fetch failed')) {
    return 'Helios storage is configured but SurrealDB is not reachable. Start the local Helios database and reload the canvas.'
  }
  return message
}

export * from './types.ts'
