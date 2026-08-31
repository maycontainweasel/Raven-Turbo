import { RecordId, Surreal } from 'surrealdb'
import type {
  HeliosMigrateResult,
  HeliosNodeCreateInput,
  HeliosNodePatch,
  HeliosNodeRecord,
  HeliosStorageAdapter,
  HeliosStorageConfig,
} from './types.ts'
import {
  assertHeliosRecordTable,
  toHeliosRecordTarget,
} from './record-id.ts'
import { normalizeHeliosRecordRef, normalizeTextContentInput } from '@helios/protocol'

type CachedClient = {
  key: string
  client: Surreal
}

declare global {
  // eslint-disable-next-line no-var
  var __heliosLayerSurreal: CachedClient | undefined
  // eslint-disable-next-line no-var
  var __heliosLayerMigrations: Map<string, Promise<void>> | undefined
}

const nowIso = () => new Date().toISOString()

const lastResult = <T>(response: unknown): T => {
  if (Array.isArray(response) && response.length > 0) {
    const last = response[response.length - 1]
    if (last && typeof last === 'object' && Array.isArray((last as any).result)) {
      return (last as any).result as T
    }
    return last as T
  }
  return null as T
}

const normalizeNodeRecord = (
  value: unknown,
  table: string,
): HeliosNodeRecord => {
  const record = value && typeof value === 'object' ? value as Record<string, any> : {}
  const idRef = normalizeHeliosRecordRef(record.id, table)
  if (!idRef) throw new Error('SurrealDB returned a Helios node without a record id')
  const parentRef = normalizeHeliosRecordRef(record.parentId, table)
  return {
    id: idRef.key,
    record: idRef,
    parent: parentRef,
    documentId: String(record.documentId ?? ''),
    zoneId: String(record.zoneId ?? ''),
    kind: record.kind === 'text' || record.kind === 'widget' ? record.kind : 'frame',
    parentId: parentRef?.key ?? null,
    order: Number.isFinite(Number(record.order)) ? Number(record.order) : 0,
    label: typeof record.label === 'string' ? record.label : record.label === null ? null : undefined,
    content: record.kind === 'text' ? normalizeTextContentInput(record.content) : undefined,
    qualities: record.qualities && typeof record.qualities === 'object' ? record.qualities : undefined,
    meta: record.meta && typeof record.meta === 'object' ? record.meta : undefined,
  }
}

export const toSurrealHeliosRecordId = (
  value: unknown,
  table: string,
) => {
  const target = normalizeHeliosRecordRef(value, table)
  if (!target) return null
  assertHeliosRecordTable(target, table)
  return new RecordId(target.table, target.id as any)
}

const normalizeNodePayload = (
  input: HeliosNodeCreateInput | HeliosNodePatch,
  table: string,
) => {
  const payload: Record<string, any> = {}
  if ('documentId' in input && input.documentId !== undefined) payload.documentId = String(input.documentId)
  if ('zoneId' in input && input.zoneId !== undefined) payload.zoneId = String(input.zoneId)
  if ('kind' in input && input.kind !== undefined) payload.kind = input.kind
  if ('parent' in input && input.parent !== undefined) payload.parentId = input.parent ? toSurrealHeliosRecordId(input.parent, table) : null
  if ('parentId' in input && input.parentId !== undefined) payload.parentId = input.parentId ? toSurrealHeliosRecordId(input.parentId, table) : null
  if ('order' in input && input.order !== undefined) payload.order = Number.isFinite(Number(input.order)) ? Number(input.order) : 0
  if ('label' in input && input.label !== undefined) payload.label = input.label === null ? null : String(input.label)
  if ('content' in input && input.content !== undefined) payload.content = input.content === null ? null : normalizeTextContentInput(input.content)
  if ('qualities' in input && input.qualities !== undefined) payload.qualities = input.qualities
  if ('meta' in input && input.meta !== undefined) payload.meta = input.meta
  payload.updatedAt = nowIso()
  return payload
}

const assertConfigured = (config: HeliosStorageConfig) => {
  if (!config.url) throw new Error('Helios storage is missing NUXT_HELIOS_SURREALDB_URL or NUXT_SURREALDB_URL')
  if (!config.namespace) throw new Error('Helios storage is missing NUXT_HELIOS_SURREALDB_NAMESPACE or NUXT_SURREALDB_NAMESPACE')
  if (!config.database) throw new Error('Helios storage is missing NUXT_HELIOS_SURREALDB_DATABASE or NUXT_SURREALDB_DATABASE')
  if (!config.user || !config.pass) throw new Error('Helios storage is missing SurrealDB credentials')
}

const withTransactionRetry = async <T>(
  operation: () => Promise<T>,
  attempts = 3,
): Promise<T> => {
  let lastError: unknown
  for (let attempt = 1; attempt <= attempts; attempt += 1) {
    try {
      return await operation()
    } catch (error: any) {
      lastError = error
      const message = String(error?.message || error).toLowerCase()
      const retryable = message.includes('transaction conflict') || message.includes('resource busy')
      if (!retryable || attempt === attempts) break
      await new Promise((resolve) => setTimeout(resolve, attempt * 120))
    }
  }
  throw lastError
}

const getClient = async (config: HeliosStorageConfig) => {
  assertConfigured(config)

  const key = [
    config.url,
    config.namespace,
    config.database,
    config.user,
  ].join('|')

  if (globalThis.__heliosLayerSurreal?.key === key) {
    return globalThis.__heliosLayerSurreal.client
  }

  const client = new Surreal()
  const url = config.url.endsWith('/rpc') ? config.url : `${config.url}/rpc`
  await client.connect(url)
  await client.signin({ username: config.user, password: config.pass })
  await client.use({ namespace: config.namespace, database: config.database })
  globalThis.__heliosLayerSurreal = { key, client }
  return client
}

export const createSurrealHeliosStorageAdapter = (
  config: HeliosStorageConfig,
): HeliosStorageAdapter => {
  const table = config.table
  const ensureMigrated = async (db: Surreal) => {
    const key = `${config.url}|${config.namespace}|${config.database}|${table}`
    globalThis.__heliosLayerMigrations ??= new Map()
    const existing = globalThis.__heliosLayerMigrations.get(key)
    if (existing) return existing

    const migration = withTransactionRetry(() => db.query(`
      DEFINE TABLE IF NOT EXISTS ${table} SCHEMALESS;
      DEFINE FIELD OVERWRITE documentId ON TABLE ${table};
      DEFINE FIELD OVERWRITE zoneId ON TABLE ${table};
      DEFINE FIELD OVERWRITE kind ON TABLE ${table};
      DEFINE FIELD OVERWRITE parentId ON TABLE ${table};
      DEFINE FIELD OVERWRITE order ON TABLE ${table};
      DEFINE FIELD OVERWRITE label ON TABLE ${table};
      DEFINE FIELD OVERWRITE content ON TABLE ${table};
      DEFINE FIELD OVERWRITE qualities ON TABLE ${table};
      DEFINE FIELD OVERWRITE meta ON TABLE ${table};
      DEFINE FIELD OVERWRITE createdAt ON TABLE ${table};
      DEFINE FIELD OVERWRITE updatedAt ON TABLE ${table};
      DEFINE INDEX IF NOT EXISTS idx_${table}_document_zone ON TABLE ${table} COLUMNS documentId, zoneId;
    `).then(() => undefined))

    globalThis.__heliosLayerMigrations.set(key, migration)
    try {
      await migration
    } catch (error) {
      globalThis.__heliosLayerMigrations.delete(key)
      throw error
    }
  }

  return {
    async migrate(): Promise<HeliosMigrateResult> {
      const db = await getClient(config)
      await ensureMigrated(db)

      return {
        ok: true,
        notes: [`Ensured ${table} table, fields, and document/zone index.`],
      }
    },

    async listNodes(input) {
      const documentId = String(input.documentId || '').trim()
      if (!documentId) return []
      const db = await getClient(config)
      await ensureMigrated(db)
      const zoneId = String(input.zoneId || '').trim()
      const query = zoneId
        ? `SELECT * FROM ${table} WHERE documentId = $documentId AND zoneId = $zoneId ORDER BY order ASC, id ASC;`
        : `SELECT * FROM ${table} WHERE documentId = $documentId ORDER BY order ASC, id ASC;`
      const rows = lastResult<any[]>(await db.query(query, { documentId, zoneId })) ?? []
      return rows.map((row) => normalizeNodeRecord(row, table))
    },

    async createNode(input) {
      const db = await getClient(config)
      await ensureMigrated(db)
      const parentId = input.parent
        ? toSurrealHeliosRecordId(input.parent, table)
        : input.parentId
          ? toSurrealHeliosRecordId(input.parentId, table)
          : null
      const payload = {
        documentId: String(input.documentId || ''),
        zoneId: String(input.zoneId || ''),
        kind: input.kind || 'frame',
        parentId,
        order: Number.isFinite(Number(input.order)) ? Number(input.order) : 0,
        label: input.label === undefined ? undefined : input.label,
        content: input.content === undefined
          ? undefined
          : input.content === null
            ? null
            : normalizeTextContentInput(input.content),
        qualities: input.qualities || {},
        meta: input.meta || {},
        createdAt: nowIso(),
        updatedAt: nowIso(),
      }
      if (!payload.documentId || !payload.zoneId) {
        throw new Error('Helios node requires documentId and zoneId')
      }
      const rows = lastResult<any[]>(await db.query(`CREATE ${table} CONTENT $payload;`, { payload })) ?? []
      const created = rows[0]
      if (!created) throw new Error('SurrealDB did not return created Helios node')
      return normalizeNodeRecord(created, table)
    },

    async updateNode(id, patch) {
      const db = await getClient(config)
      await ensureMigrated(db)
      const target = toHeliosRecordTarget(id, table)
      assertHeliosRecordTable(target, table)
      const payload = normalizeNodePayload(patch, table)
      const rows = lastResult<any[]>(await db.query(
        'UPDATE type::record($table, $id) MERGE $payload RETURN AFTER;',
        { table: target.table, id: target.id, payload },
      )) ?? []
      const updated = rows[0]
      if (!updated) throw new Error(`Helios node not found: ${id}`)
      return normalizeNodeRecord(updated, table)
    },

    async deleteNode(id) {
      const db = await getClient(config)
      await ensureMigrated(db)
      const target = toHeliosRecordTarget(id, table)
      assertHeliosRecordTable(target, table)
      await db.query('DELETE type::record($table, $id);', { table: target.table, id: target.id })
      return { ok: true }
    },
  }
}
