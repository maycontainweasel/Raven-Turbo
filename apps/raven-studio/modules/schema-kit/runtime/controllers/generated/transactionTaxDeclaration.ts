import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { TransactionTaxDeclaration, TransactionTaxDeclarationId, TransactionTaxDeclarationIdSubId } from '@schema/types'
type TransactionTaxDeclarationDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type TransactionTaxDeclarationCreateInput = Pick<TransactionTaxDeclaration, 'space' | 'transaction' | 'revision' | 'state' | 'isCurrent' | 'declarationSource' | 'evidenceStatus' | 'recordedAt'> & Partial<Omit<TransactionTaxDeclaration, 'id'>>

export type TransactionTaxDeclarationUpdateInput = Partial<Omit<TransactionTaxDeclaration, 'id'>>
export type TransactionTaxDeclarationRecordId = NonNullable<TransactionTaxDeclaration['id']> | TransactionTaxDeclarationId
export type TransactionTaxDeclarationIdInput = ControllerIdInput<TransactionTaxDeclarationIdSubId, TransactionTaxDeclarationRecordId, TransactionTaxDeclaration>

export interface TransactionTaxDeclarationController {
  // Create a new transactionTaxDeclaration record.
  create: (payload: TransactionTaxDeclarationCreateInput, options?: ApiOptions) => Promise<TransactionTaxDeclaration | null>
  // Create multiple transactionTaxDeclaration records in sequence.
  createMany: (payloads: TransactionTaxDeclarationCreateInput[], options?: ApiOptions) => Promise<(TransactionTaxDeclaration | null)[]>
  // Update a transactionTaxDeclaration by id (record object or sub-id).
  update: (id: TransactionTaxDeclarationIdInput, payload: TransactionTaxDeclarationUpdateInput, options?: ApiOptions) => Promise<TransactionTaxDeclaration | null>
  // Update multiple transactionTaxDeclaration records in sequence.
  updateMany: (
    items: Array<{ id: TransactionTaxDeclarationIdInput; payload: TransactionTaxDeclarationUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(TransactionTaxDeclaration | null)[]>
  // Delete a transactionTaxDeclaration by id (record object or sub-id).
  delete: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<TransactionTaxDeclaration | null>
  // Delete multiple transactionTaxDeclaration records in sequence.
  deleteMany: (ids: TransactionTaxDeclarationIdInput[], options?: ApiOptions) => Promise<(TransactionTaxDeclaration | null)[]>
  // Fetch a resource view/function for the transactionTaxDeclaration.
  get: (id: TransactionTaxDeclarationIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: TransactionTaxDeclarationIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionTaxDeclarationIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: TransactionTaxDeclarationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: TransactionTaxDeclarationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<any>
  get: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: TransactionTaxDeclarationIdInput,
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
  attach: (id: TransactionTaxDeclarationIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: TransactionTaxDeclarationIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: TransactionTaxDeclarationIdInput, options?: ApiOptions) => Promise<TransactionTaxDeclarationDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionTaxDeclarationDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TransactionTaxDeclarationDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type TransactionTaxDeclarationControllerOverride = ControllerOverride<TransactionTaxDeclarationController>

export function createGeneratedTransactionTaxDeclarationController(): TransactionTaxDeclarationController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: TransactionTaxDeclarationIdInput) => crud.resolveRecordSubId<TransactionTaxDeclarationIdSubId>(value)

  // Create a transactionTaxDeclaration via the TRPC endpoint.
  const create: TransactionTaxDeclarationController['create'] = async (payload, options) => {
    return await $process<TransactionTaxDeclarationCreateInput, TransactionTaxDeclaration>('transactionTaxDeclaration.create', payload, options)
  }

  // Create multiple transactionTaxDeclaration records in sequence.
  const createMany: TransactionTaxDeclarationController['createMany'] = async (payloads, options) => {
    const results: Array<TransactionTaxDeclaration | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a transactionTaxDeclaration via the TRPC endpoint.
  const update: TransactionTaxDeclarationController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionTaxDeclaration update requires a valid id')
    return await $process<{ id: TransactionTaxDeclarationIdSubId; payload: TransactionTaxDeclarationUpdateInput }, TransactionTaxDeclaration>(
      'transactionTaxDeclaration.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple transactionTaxDeclaration records in sequence.
  const updateMany: TransactionTaxDeclarationController['updateMany'] = async (items, options) => {
    const results: Array<TransactionTaxDeclaration | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a transactionTaxDeclaration via the TRPC endpoint.
  const del: TransactionTaxDeclarationController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionTaxDeclaration delete requires a valid id')
    return await $process<{ id: TransactionTaxDeclarationIdSubId }, TransactionTaxDeclaration>('transactionTaxDeclaration.delete', { id: resolvedId }, options)
  }

  // Delete multiple transactionTaxDeclaration records in sequence.
  const deleteMany: TransactionTaxDeclarationController['deleteMany'] = async (ids, options) => {
    const results: Array<TransactionTaxDeclaration | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a transactionTaxDeclaration.
  const get: TransactionTaxDeclarationController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TransactionTaxDeclaration get requires a valid id')
    if (!resourceKey) throw new Error('TransactionTaxDeclaration get requires a resource key')
    return await $process('transactionTaxDeclaration.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: TransactionTaxDeclarationController['taxonomy'] = (key: string) => {
    const prefix = `transactionTaxDeclaration.${key}`
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

  const subtable: TransactionTaxDeclarationController['subtable'] = (key: string) => {
    const prefix = `transactionTaxDeclaration.subtables.${key}`
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

  const relation: TransactionTaxDeclarationController['relation'] = (key: string) => {
    const prefix = `transactionTaxDeclaration.relations.${key}`
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
  const typesense: TransactionTaxDeclarationController['typesense'] = () => {
    const prefix = `transactionTaxDeclaration.typesense`
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
  const refreshTypesenseFor: TransactionTaxDeclarationController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'transactionTaxDeclaration',
      id: resolvedId,
      endpoint: 'transactionTaxDeclaration.typesense.resource',
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
