import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { TransactionPurpose, TransactionPurposeId, TransactionPurposeIdSubId } from '@schema/types'
type TransactionPurposeDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type TransactionPurposeCreateInput = Pick<TransactionPurpose, 'space' | 'key' | 'name' | 'purposeKind' | 'occurrencePattern' | 'active'> & Partial<Omit<TransactionPurpose, 'id'>>

export type TransactionPurposeUpdateInput = Partial<Omit<TransactionPurpose, 'id'>>
export type TransactionPurposeRecordId = NonNullable<TransactionPurpose['id']> | TransactionPurposeId
export type TransactionPurposeIdInput = ControllerIdInput<TransactionPurposeIdSubId, TransactionPurposeRecordId, TransactionPurpose>

export interface TransactionPurposeController {
  // Create a new transactionPurpose record.
  create: (payload: TransactionPurposeCreateInput, options?: ApiOptions) => Promise<TransactionPurpose | null>
  // Create multiple transactionPurpose records in sequence.
  createMany: (payloads: TransactionPurposeCreateInput[], options?: ApiOptions) => Promise<(TransactionPurpose | null)[]>
  // Update a transactionPurpose by id (record object or sub-id).
  update: (id: TransactionPurposeIdInput, payload: TransactionPurposeUpdateInput, options?: ApiOptions) => Promise<TransactionPurpose | null>
  // Update multiple transactionPurpose records in sequence.
  updateMany: (
    items: Array<{ id: TransactionPurposeIdInput; payload: TransactionPurposeUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(TransactionPurpose | null)[]>
  // Delete a transactionPurpose by id (record object or sub-id).
  delete: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<TransactionPurpose | null>
  // Delete multiple transactionPurpose records in sequence.
  deleteMany: (ids: TransactionPurposeIdInput[], options?: ApiOptions) => Promise<(TransactionPurpose | null)[]>
  // Fetch a resource view/function for the transactionPurpose.
  get: (id: TransactionPurposeIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: TransactionPurposeIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionPurposeIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: TransactionPurposeIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: TransactionPurposeIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<any>
  get: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: TransactionPurposeIdInput,
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
  attach: (id: TransactionPurposeIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionPurposeIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: TransactionPurposeIdInput, options?: ApiOptions) => Promise<TransactionPurposeDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionPurposeDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionPurposeDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type TransactionPurposeControllerOverride = ControllerOverride<TransactionPurposeController>

export function createGeneratedTransactionPurposeController(): TransactionPurposeController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: TransactionPurposeIdInput) => crud.resolveRecordSubId<TransactionPurposeIdSubId>(value)

  // Create a transactionPurpose via the TRPC endpoint.
  const create: TransactionPurposeController['create'] = async (payload, options) => {
    return await $process<TransactionPurposeCreateInput, TransactionPurpose>('transactionPurpose.create', payload, options)
  }

  // Create multiple transactionPurpose records in sequence.
  const createMany: TransactionPurposeController['createMany'] = async (payloads, options) => {
    const results: Array<TransactionPurpose | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a transactionPurpose via the TRPC endpoint.
  const update: TransactionPurposeController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurpose update requires a valid id')
    return await $process<{ id: TransactionPurposeIdSubId; payload: TransactionPurposeUpdateInput }, TransactionPurpose>(
      'transactionPurpose.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple transactionPurpose records in sequence.
  const updateMany: TransactionPurposeController['updateMany'] = async (items, options) => {
    const results: Array<TransactionPurpose | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a transactionPurpose via the TRPC endpoint.
  const del: TransactionPurposeController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurpose delete requires a valid id')
    return await $process<{ id: TransactionPurposeIdSubId }, TransactionPurpose>('transactionPurpose.delete', { id: resolvedId }, options)
  }

  // Delete multiple transactionPurpose records in sequence.
  const deleteMany: TransactionPurposeController['deleteMany'] = async (ids, options) => {
    const results: Array<TransactionPurpose | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a transactionPurpose.
  const get: TransactionPurposeController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurpose get requires a valid id')
    if (!resourceKey) throw new Error('TransactionPurpose get requires a resource key')
    return await $process('transactionPurpose.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: TransactionPurposeController['taxonomy'] = (key: string) => {
    const prefix = `transactionPurpose.${key}`
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

  const subtable: TransactionPurposeController['subtable'] = (key: string) => {
    const prefix = `transactionPurpose.subtables.${key}`
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

  const relation: TransactionPurposeController['relation'] = (key: string) => {
    const prefix = `transactionPurpose.relations.${key}`
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
  const typesense: TransactionPurposeController['typesense'] = () => {
    const prefix = `transactionPurpose.typesense`
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
  const refreshTypesenseFor: TransactionPurposeController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'transactionPurpose',
      id: resolvedId,
      endpoint: 'transactionPurpose.typesense.resource',
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
