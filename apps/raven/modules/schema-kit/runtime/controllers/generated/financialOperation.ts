import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { FinancialOperation, FinancialOperationId, FinancialOperationIdSubId } from '@schema/types'
type FinancialOperationDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type FinancialOperationCreateInput = Pick<FinancialOperation, 'key' | 'command' | 'idempotencyKey' | 'requestHash' | 'channel' | 'status' | 'recordedAt'> & Partial<Omit<FinancialOperation, 'id'>>

export type FinancialOperationUpdateInput = Partial<Omit<FinancialOperation, 'id'>>
export type FinancialOperationRecordId = NonNullable<FinancialOperation['id']> | FinancialOperationId
export type FinancialOperationIdInput = ControllerIdInput<FinancialOperationIdSubId, FinancialOperationRecordId, FinancialOperation>

export interface FinancialOperationController {
  // Create a new financialOperation record.
  create: (payload: FinancialOperationCreateInput, options?: ApiOptions) => Promise<FinancialOperation | null>
  // Create multiple financialOperation records in sequence.
  createMany: (payloads: FinancialOperationCreateInput[], options?: ApiOptions) => Promise<(FinancialOperation | null)[]>
  // Update a financialOperation by id (record object or sub-id).
  update: (id: FinancialOperationIdInput, payload: FinancialOperationUpdateInput, options?: ApiOptions) => Promise<FinancialOperation | null>
  // Update multiple financialOperation records in sequence.
  updateMany: (
    items: Array<{ id: FinancialOperationIdInput; payload: FinancialOperationUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(FinancialOperation | null)[]>
  // Delete a financialOperation by id (record object or sub-id).
  delete: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<FinancialOperation | null>
  // Delete multiple financialOperation records in sequence.
  deleteMany: (ids: FinancialOperationIdInput[], options?: ApiOptions) => Promise<(FinancialOperation | null)[]>
  // Fetch a resource view/function for the financialOperation.
  get: (id: FinancialOperationIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: FinancialOperationIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: FinancialOperationIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: FinancialOperationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: FinancialOperationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<any>
  get: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: FinancialOperationIdInput,
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
  attach: (id: FinancialOperationIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: FinancialOperationIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: FinancialOperationIdInput, options?: ApiOptions) => Promise<FinancialOperationDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<FinancialOperationDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<FinancialOperationDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type FinancialOperationControllerOverride = ControllerOverride<FinancialOperationController>

export function createGeneratedFinancialOperationController(): FinancialOperationController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: FinancialOperationIdInput) => crud.resolveRecordSubId<FinancialOperationIdSubId>(value)

  // Create a financialOperation via the TRPC endpoint.
  const create: FinancialOperationController['create'] = async (payload, options) => {
    return await $process<FinancialOperationCreateInput, FinancialOperation>('financialOperation.create', payload, options)
  }

  // Create multiple financialOperation records in sequence.
  const createMany: FinancialOperationController['createMany'] = async (payloads, options) => {
    const results: Array<FinancialOperation | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a financialOperation via the TRPC endpoint.
  const update: FinancialOperationController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('FinancialOperation update requires a valid id')
    return await $process<{ id: FinancialOperationIdSubId; payload: FinancialOperationUpdateInput }, FinancialOperation>(
      'financialOperation.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple financialOperation records in sequence.
  const updateMany: FinancialOperationController['updateMany'] = async (items, options) => {
    const results: Array<FinancialOperation | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a financialOperation via the TRPC endpoint.
  const del: FinancialOperationController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('FinancialOperation delete requires a valid id')
    return await $process<{ id: FinancialOperationIdSubId }, FinancialOperation>('financialOperation.delete', { id: resolvedId }, options)
  }

  // Delete multiple financialOperation records in sequence.
  const deleteMany: FinancialOperationController['deleteMany'] = async (ids, options) => {
    const results: Array<FinancialOperation | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a financialOperation.
  const get: FinancialOperationController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('FinancialOperation get requires a valid id')
    if (!resourceKey) throw new Error('FinancialOperation get requires a resource key')
    return await $process('financialOperation.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: FinancialOperationController['taxonomy'] = (key: string) => {
    const prefix = `financialOperation.${key}`
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

  const subtable: FinancialOperationController['subtable'] = (key: string) => {
    const prefix = `financialOperation.subtables.${key}`
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

  const relation: FinancialOperationController['relation'] = (key: string) => {
    const prefix = `financialOperation.relations.${key}`
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
  const typesense: FinancialOperationController['typesense'] = () => {
    const prefix = `financialOperation.typesense`
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
  const refreshTypesenseFor: FinancialOperationController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'financialOperation',
      id: resolvedId,
      endpoint: 'financialOperation.typesense.resource',
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
