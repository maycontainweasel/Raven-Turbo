import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementReconciliationEvent, StatementReconciliationEventId, StatementReconciliationEventIdSubId } from '@schema/types'
type StatementReconciliationEventDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementReconciliationEventCreateInput = Pick<StatementReconciliationEvent, 'space' | 'account' | 'statementImport' | 'statementReconciliation' | 'key' | 'eventType' | 'reconciliationRevision' | 'calculationHash' | 'calculationSnapshot' | 'channel' | 'operation' | 'recordedAt'> & Partial<Omit<StatementReconciliationEvent, 'id'>>

export type StatementReconciliationEventUpdateInput = Partial<Omit<StatementReconciliationEvent, 'id'>>
export type StatementReconciliationEventRecordId = NonNullable<StatementReconciliationEvent['id']> | StatementReconciliationEventId
export type StatementReconciliationEventIdInput = ControllerIdInput<StatementReconciliationEventIdSubId, StatementReconciliationEventRecordId, StatementReconciliationEvent>

export interface StatementReconciliationEventController {
  // Create a new statementReconciliationEvent record.
  create: (payload: StatementReconciliationEventCreateInput, options?: ApiOptions) => Promise<StatementReconciliationEvent | null>
  // Create multiple statementReconciliationEvent records in sequence.
  createMany: (payloads: StatementReconciliationEventCreateInput[], options?: ApiOptions) => Promise<(StatementReconciliationEvent | null)[]>
  // Update a statementReconciliationEvent by id (record object or sub-id).
  update: (id: StatementReconciliationEventIdInput, payload: StatementReconciliationEventUpdateInput, options?: ApiOptions) => Promise<StatementReconciliationEvent | null>
  // Update multiple statementReconciliationEvent records in sequence.
  updateMany: (
    items: Array<{ id: StatementReconciliationEventIdInput; payload: StatementReconciliationEventUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementReconciliationEvent | null)[]>
  // Delete a statementReconciliationEvent by id (record object or sub-id).
  delete: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<StatementReconciliationEvent | null>
  // Delete multiple statementReconciliationEvent records in sequence.
  deleteMany: (ids: StatementReconciliationEventIdInput[], options?: ApiOptions) => Promise<(StatementReconciliationEvent | null)[]>
  // Fetch a resource view/function for the statementReconciliationEvent.
  get: (id: StatementReconciliationEventIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementReconciliationEventIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementReconciliationEventIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementReconciliationEventIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementReconciliationEventIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementReconciliationEventIdInput,
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
  attach: (id: StatementReconciliationEventIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementReconciliationEventIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementReconciliationEventIdInput, options?: ApiOptions) => Promise<StatementReconciliationEventDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementReconciliationEventDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementReconciliationEventDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementReconciliationEventControllerOverride = ControllerOverride<StatementReconciliationEventController>

export function createGeneratedStatementReconciliationEventController(): StatementReconciliationEventController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementReconciliationEventIdInput) => crud.resolveRecordSubId<StatementReconciliationEventIdSubId>(value)

  // Create a statementReconciliationEvent via the TRPC endpoint.
  const create: StatementReconciliationEventController['create'] = async (payload, options) => {
    return await $process<StatementReconciliationEventCreateInput, StatementReconciliationEvent>('statementReconciliationEvent.create', payload, options)
  }

  // Create multiple statementReconciliationEvent records in sequence.
  const createMany: StatementReconciliationEventController['createMany'] = async (payloads, options) => {
    const results: Array<StatementReconciliationEvent | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementReconciliationEvent via the TRPC endpoint.
  const update: StatementReconciliationEventController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliationEvent update requires a valid id')
    return await $process<{ id: StatementReconciliationEventIdSubId; payload: StatementReconciliationEventUpdateInput }, StatementReconciliationEvent>(
      'statementReconciliationEvent.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementReconciliationEvent records in sequence.
  const updateMany: StatementReconciliationEventController['updateMany'] = async (items, options) => {
    const results: Array<StatementReconciliationEvent | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementReconciliationEvent via the TRPC endpoint.
  const del: StatementReconciliationEventController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliationEvent delete requires a valid id')
    return await $process<{ id: StatementReconciliationEventIdSubId }, StatementReconciliationEvent>('statementReconciliationEvent.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementReconciliationEvent records in sequence.
  const deleteMany: StatementReconciliationEventController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementReconciliationEvent | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementReconciliationEvent.
  const get: StatementReconciliationEventController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliationEvent get requires a valid id')
    if (!resourceKey) throw new Error('StatementReconciliationEvent get requires a resource key')
    return await $process('statementReconciliationEvent.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementReconciliationEventController['taxonomy'] = (key: string) => {
    const prefix = `statementReconciliationEvent.${key}`
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

  const subtable: StatementReconciliationEventController['subtable'] = (key: string) => {
    const prefix = `statementReconciliationEvent.subtables.${key}`
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

  const relation: StatementReconciliationEventController['relation'] = (key: string) => {
    const prefix = `statementReconciliationEvent.relations.${key}`
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
  const typesense: StatementReconciliationEventController['typesense'] = () => {
    const prefix = `statementReconciliationEvent.typesense`
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
  const refreshTypesenseFor: StatementReconciliationEventController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementReconciliationEvent',
      id: resolvedId,
      endpoint: 'statementReconciliationEvent.typesense.resource',
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
