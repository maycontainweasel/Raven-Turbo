import type {
  HeliosNodeCreateInput,
  HeliosNodePatch,
  HeliosNodeRecord,
  HeliosRecordRef,
} from '@helios/protocol'

export const HELIOS_NODE_TABLE = 'helios_node'

export type HeliosStorageDriver = 'surreal'

export type HeliosStorageConfig = {
  driver: HeliosStorageDriver
  table: string
  url: string
  namespace: string
  database: string
  user: string
  pass: string
}

export type HeliosStorageSafeConfig = {
  driver: HeliosStorageDriver
  table: string
  configured: boolean
  urlConfigured: boolean
  namespaceConfigured: boolean
  databaseConfigured: boolean
  userConfigured: boolean
}

export type HeliosMigrateResult = {
  ok: boolean
  notes: string[]
}

export type HeliosStorageAdapter = {
  migrate(): Promise<HeliosMigrateResult>
  listNodes(input: { documentId: string; zoneId?: string }): Promise<HeliosNodeRecord[]>
  createNode(input: HeliosNodeCreateInput): Promise<HeliosNodeRecord>
  updateNode(id: string | HeliosRecordRef, patch: HeliosNodePatch): Promise<HeliosNodeRecord>
  deleteNode(id: string | HeliosRecordRef): Promise<{ ok: boolean }>
}

export type {
  HeliosNodeCreateInput,
  HeliosNodePatch,
  HeliosNodeRecord,
}
