import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementLegacyResolution, StatementLegacyResolutionId, StatementLegacyResolutionIdSubId } from '@schema/types'
type StatementLegacyResolutionDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementLegacyResolutionCreateInput = Pick<StatementLegacyResolution, 'space' | 'account' | 'legacyStatementImport' | 'canonicalStatementImport' | 'key' | 'resolutionType' | 'strategy' | 'authorityEffect' | 'previousLegacySourceState' | 'previousSourceClaimState' | 'previousPeriodClaimState' | 'databaseFingerprint' | 'sourceIdentityHash' | 'canonicalPreviewHash' | 'legacyEvidenceHash' | 'accountContextFingerprint' | 'crosswalkHash' | 'expectedRevisionClaimHash' | 'resultAuthorityHash' | 'aggregateCounts' | 'idempotencyKey' | 'requestHash' | 'channel' | 'operation' | 'recordedAt'> & Partial<Omit<StatementLegacyResolution, 'id'>>

export type StatementLegacyResolutionUpdateInput = Partial<Omit<StatementLegacyResolution, 'id'>>
export type StatementLegacyResolutionRecordId = NonNullable<StatementLegacyResolution['id']> | StatementLegacyResolutionId
export type StatementLegacyResolutionIdInput = ControllerIdInput<StatementLegacyResolutionIdSubId, StatementLegacyResolutionRecordId, StatementLegacyResolution>

export interface StatementLegacyResolutionController {
  // Create a new statementLegacyResolution record.
  create: (payload: StatementLegacyResolutionCreateInput, options?: ApiOptions) => Promise<StatementLegacyResolution | null>
  // Create multiple statementLegacyResolution records in sequence.
  createMany: (payloads: StatementLegacyResolutionCreateInput[], options?: ApiOptions) => Promise<(StatementLegacyResolution | null)[]>
  // Update a statementLegacyResolution by id (record object or sub-id).
  update: (id: StatementLegacyResolutionIdInput, payload: StatementLegacyResolutionUpdateInput, options?: ApiOptions) => Promise<StatementLegacyResolution | null>
  // Update multiple statementLegacyResolution records in sequence.
  updateMany: (
    items: Array<{ id: StatementLegacyResolutionIdInput; payload: StatementLegacyResolutionUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementLegacyResolution | null)[]>
  // Delete a statementLegacyResolution by id (record object or sub-id).
  delete: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<StatementLegacyResolution | null>
  // Delete multiple statementLegacyResolution records in sequence.
  deleteMany: (ids: StatementLegacyResolutionIdInput[], options?: ApiOptions) => Promise<(StatementLegacyResolution | null)[]>
  // Fetch a resource view/function for the statementLegacyResolution.
  get: (id: StatementLegacyResolutionIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementLegacyResolutionIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementLegacyResolutionIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementLegacyResolutionIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementLegacyResolutionIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementLegacyResolutionIdInput,
    params?: {
      start?: number;
      limit?: number;
      sortBy?: string;
      sortDir?: 'asc' | 'desc';
      filters?: Record<string, any>;
    },
    options?: ApiOptions
  ) => Promise<any>
}

export interface RelationController {
  attach: (id: StatementLegacyResolutionIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementLegacyResolutionIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementLegacyResolutionIdInput, options?: ApiOptions) => Promise<StatementLegacyResolutionDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementLegacyResolutionDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementLegacyResolutionDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementLegacyResolutionControllerOverride = ControllerOverride<StatementLegacyResolutionController>

export function createGeneratedStatementLegacyResolutionController(): StatementLegacyResolutionController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementLegacyResolutionIdInput) => crud.resolveRecordSubId<StatementLegacyResolutionIdSubId>(value)

  // Create a statementLegacyResolution via the TRPC endpoint.
  const create: StatementLegacyResolutionController['create'] = async (payload, options) => {
    return await $process<StatementLegacyResolutionCreateInput, StatementLegacyResolution>('statementLegacyResolution.create', payload, options)
  }

  // Create multiple statementLegacyResolution records in sequence.
  const createMany: StatementLegacyResolutionController['createMany'] = async (payloads, options) => {
    const results: Array<StatementLegacyResolution | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementLegacyResolution via the TRPC endpoint.
  const update: StatementLegacyResolutionController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolution update requires a valid id')
    return await $process<{ id: StatementLegacyResolutionIdSubId; payload: StatementLegacyResolutionUpdateInput }, StatementLegacyResolution>(
      'statementLegacyResolution.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementLegacyResolution records in sequence.
  const updateMany: StatementLegacyResolutionController['updateMany'] = async (items, options) => {
    const results: Array<StatementLegacyResolution | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementLegacyResolution via the TRPC endpoint.
  const del: StatementLegacyResolutionController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolution delete requires a valid id')
    return await $process<{ id: StatementLegacyResolutionIdSubId }, StatementLegacyResolution>('statementLegacyResolution.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementLegacyResolution records in sequence.
  const deleteMany: StatementLegacyResolutionController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementLegacyResolution | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementLegacyResolution.
  const get: StatementLegacyResolutionController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolution get requires a valid id')
    if (!resourceKey) throw new Error('StatementLegacyResolution get requires a resource key')
    return await $process('statementLegacyResolution.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementLegacyResolutionController['taxonomy'] = (key: string) => {
    const prefix = `statementLegacyResolution.${key}`
    return {
      createTaxonomy: (payload, options) =>
        $process(`${prefix}.createTaxonomy`, payload, options),
      addTerm: (payload, options) =>
        $process(`${prefix}.addTerm`, payload, options),
      removeTerm: (term, options) =>
        $process(`${prefix}.removeTerm`, term, options),
      attach: (id, term, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('taxonomy.attach requires a valid id')
        return $process(`${prefix}.attach`, { id: resolvedId, term }, options)
      },
      detach: (id, term, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('taxonomy.detach requires a valid id')
        return $process(`${prefix}.detach`, { id: resolvedId, term }, options)
      },
      getTerms: (options) =>
        $process(`${prefix}.getTerms`, {}, options),
      getRecordTerms: (id, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('taxonomy.getRecordTerms requires a valid id')
        return $process(`${prefix}.getRecordTerms`, { id: resolvedId }, options)
      },
    }
  }

  const subtable: StatementLegacyResolutionController['subtable'] = (key: string) => {
    const prefix = `statementLegacyResolution.subtables.${key}`
    return {
      create: (id, payload, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('subtable.create requires a valid id')
        return $process(`${prefix}.create`, { id: resolvedId, payload }, options)
      },
      update: (id, payload, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('subtable.update requires a valid id')
        return $process(`${prefix}.update`, { id: resolvedId, payload }, options)
      },
      delete: (id, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('subtable.delete requires a valid id')
        return $process(`${prefix}.delete`, { id: resolvedId }, options)
      },
      get: (id, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('subtable.get requires a valid id')
        return $process(`${prefix}.get`, { id: resolvedId }, options)
      },
      list: (id, params, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('subtable.list requires a valid id')
        return $process(`${prefix}.list`, { id: resolvedId, ...(params ?? {}) }, options)
      },
    }
  }

  const relation: StatementLegacyResolutionController['relation'] = (key: string) => {
    const prefix = `statementLegacyResolution.relations.${key}`
    return {
      attach: (id, target, options) => {
        const resolvedId = resolveSubId(id)
        const resolvedTarget = resolveSubId(target)
        if (!resolvedId || !resolvedTarget) throw new Error('relation.attach requires id and target')
        return $process(`${prefix}.attach`, { id: resolvedId, target: resolvedTarget }, options)
      },
      detach: (id, target, options) => {
        const resolvedId = resolveSubId(id)
        const resolvedTarget = resolveSubId(target)
        if (!resolvedId || !resolvedTarget) throw new Error('relation.detach requires id and target')
        return $process(`${prefix}.detach`, { id: resolvedId, target: resolvedTarget }, options)
      },
      list: (id, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('relation.list requires a valid id')
        return $process(`${prefix}.list`, { id: resolvedId }, options)
      },
    }
  }

  // Typesense helper wrapper for this model.
  const typesense: StatementLegacyResolutionController['typesense'] = () => {
    const prefix = `statementLegacyResolution.typesense`
    return {
      get: (id, options) => {
        const resolvedId = resolveSubId(id)
        if (!resolvedId) throw new Error('typesense.get requires a valid id')
        return $process(`${prefix}.resource`, { id: resolvedId }, options)
      },
      list: (params, options) =>
        $process(`${prefix}.list`, { ...(params ?? {}) }, options),
      refresh: (params, options) =>
        $process(`${prefix}.refresh`, { ...(params ?? {}) }, options),
      count: (options) =>
        $process(`${prefix}.count`, {}, options),
      collection: (options) =>
        $process(`${prefix}.collection`, {}, options),
    }
  }

  // Refresh Typesense for a single record id.
  const refreshTypesenseFor: StatementLegacyResolutionController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementLegacyResolution',
      id: resolvedId,
      endpoint: 'statementLegacyResolution.typesense.resource',
      instance: options?.instance,
      instances: options?.instances,
      bypassMothership: options?.bypassMothership,
    })
  }

  return {
    create,
    createMany,
    update,
    updateMany,
    delete: del,
    deleteMany,
    get,
    taxonomy,
    subtable,
    relation,
    typesense,
    refreshTypesenseFor,
  }
}
