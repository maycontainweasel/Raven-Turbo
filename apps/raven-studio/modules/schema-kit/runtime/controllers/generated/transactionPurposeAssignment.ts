import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { TransactionPurposeAssignment, TransactionPurposeAssignmentId, TransactionPurposeAssignmentIdSubId } from '@schema/types'
type TransactionPurposeAssignmentDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type TransactionPurposeAssignmentCreateInput = Pick<TransactionPurposeAssignment, 'space' | 'transaction' | 'purpose' | 'revision' | 'state' | 'isCurrent' | 'assignmentSource' | 'recordedAt'> & Partial<Omit<TransactionPurposeAssignment, 'id'>>

export type TransactionPurposeAssignmentUpdateInput = Partial<Omit<TransactionPurposeAssignment, 'id'>>
export type TransactionPurposeAssignmentRecordId = NonNullable<TransactionPurposeAssignment['id']> | TransactionPurposeAssignmentId
export type TransactionPurposeAssignmentIdInput = ControllerIdInput<TransactionPurposeAssignmentIdSubId, TransactionPurposeAssignmentRecordId, TransactionPurposeAssignment>

export interface TransactionPurposeAssignmentController {
  // Create a new transactionPurposeAssignment record.
  create: (payload: TransactionPurposeAssignmentCreateInput, options?: ApiOptions) => Promise<TransactionPurposeAssignment | null>
  // Create multiple transactionPurposeAssignment records in sequence.
  createMany: (payloads: TransactionPurposeAssignmentCreateInput[], options?: ApiOptions) => Promise<(TransactionPurposeAssignment | null)[]>
  // Update a transactionPurposeAssignment by id (record object or sub-id).
  update: (id: TransactionPurposeAssignmentIdInput, payload: TransactionPurposeAssignmentUpdateInput, options?: ApiOptions) => Promise<TransactionPurposeAssignment | null>
  // Update multiple transactionPurposeAssignment records in sequence.
  updateMany: (
    items: Array<{ id: TransactionPurposeAssignmentIdInput; payload: TransactionPurposeAssignmentUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(TransactionPurposeAssignment | null)[]>
  // Delete a transactionPurposeAssignment by id (record object or sub-id).
  delete: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<TransactionPurposeAssignment | null>
  // Delete multiple transactionPurposeAssignment records in sequence.
  deleteMany: (ids: TransactionPurposeAssignmentIdInput[], options?: ApiOptions) => Promise<(TransactionPurposeAssignment | null)[]>
  // Fetch a resource view/function for the transactionPurposeAssignment.
  get: (id: TransactionPurposeAssignmentIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: TransactionPurposeAssignmentIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionPurposeAssignmentIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: TransactionPurposeAssignmentIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: TransactionPurposeAssignmentIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<any>
  get: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: TransactionPurposeAssignmentIdInput,
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
  attach: (id: TransactionPurposeAssignmentIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionPurposeAssignmentIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: TransactionPurposeAssignmentIdInput, options?: ApiOptions) => Promise<TransactionPurposeAssignmentDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionPurposeAssignmentDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionPurposeAssignmentDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type TransactionPurposeAssignmentControllerOverride = ControllerOverride<TransactionPurposeAssignmentController>

export function createGeneratedTransactionPurposeAssignmentController(): TransactionPurposeAssignmentController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: TransactionPurposeAssignmentIdInput) => crud.resolveRecordSubId<TransactionPurposeAssignmentIdSubId>(value)

  // Create a transactionPurposeAssignment via the TRPC endpoint.
  const create: TransactionPurposeAssignmentController['create'] = async (payload, options) => {
    return await $process<TransactionPurposeAssignmentCreateInput, TransactionPurposeAssignment>('transactionPurposeAssignment.create', payload, options)
  }

  // Create multiple transactionPurposeAssignment records in sequence.
  const createMany: TransactionPurposeAssignmentController['createMany'] = async (payloads, options) => {
    const results: Array<TransactionPurposeAssignment | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a transactionPurposeAssignment via the TRPC endpoint.
  const update: TransactionPurposeAssignmentController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurposeAssignment update requires a valid id')
    return await $process<{ id: TransactionPurposeAssignmentIdSubId; payload: TransactionPurposeAssignmentUpdateInput }, TransactionPurposeAssignment>(
      'transactionPurposeAssignment.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple transactionPurposeAssignment records in sequence.
  const updateMany: TransactionPurposeAssignmentController['updateMany'] = async (items, options) => {
    const results: Array<TransactionPurposeAssignment | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a transactionPurposeAssignment via the TRPC endpoint.
  const del: TransactionPurposeAssignmentController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurposeAssignment delete requires a valid id')
    return await $process<{ id: TransactionPurposeAssignmentIdSubId }, TransactionPurposeAssignment>('transactionPurposeAssignment.delete', { id: resolvedId }, options)
  }

  // Delete multiple transactionPurposeAssignment records in sequence.
  const deleteMany: TransactionPurposeAssignmentController['deleteMany'] = async (ids, options) => {
    const results: Array<TransactionPurposeAssignment | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a transactionPurposeAssignment.
  const get: TransactionPurposeAssignmentController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionPurposeAssignment get requires a valid id')
    if (!resourceKey) throw new Error('TransactionPurposeAssignment get requires a resource key')
    return await $process('transactionPurposeAssignment.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: TransactionPurposeAssignmentController['taxonomy'] = (key: string) => {
    const prefix = `transactionPurposeAssignment.${key}`
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

  const subtable: TransactionPurposeAssignmentController['subtable'] = (key: string) => {
    const prefix = `transactionPurposeAssignment.subtables.${key}`
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

  const relation: TransactionPurposeAssignmentController['relation'] = (key: string) => {
    const prefix = `transactionPurposeAssignment.relations.${key}`
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
  const typesense: TransactionPurposeAssignmentController['typesense'] = () => {
    const prefix = `transactionPurposeAssignment.typesense`
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
  const refreshTypesenseFor: TransactionPurposeAssignmentController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'transactionPurposeAssignment',
      id: resolvedId,
      endpoint: 'transactionPurposeAssignment.typesense.resource',
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
