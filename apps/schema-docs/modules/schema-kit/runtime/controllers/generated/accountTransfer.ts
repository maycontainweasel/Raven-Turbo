import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { AccountTransfer, AccountTransferId, AccountTransferIdSubId } from '@schema/types'
type AccountTransferDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type AccountTransferCreateInput = Pick<AccountTransfer, 'key' | 'sourceSpace' | 'sourceAccount' | 'targetSpace' | 'targetAccount' | 'amountMinor' | 'currency' | 'postedAt' | 'sourceTransaction' | 'targetTransaction' | 'operation' | 'recordedAt'> & Partial<Omit<AccountTransfer, 'id'>>

export type AccountTransferUpdateInput = Partial<Omit<AccountTransfer, 'id'>>
export type AccountTransferRecordId = NonNullable<AccountTransfer['id']> | AccountTransferId
export type AccountTransferIdInput = ControllerIdInput<AccountTransferIdSubId, AccountTransferRecordId, AccountTransfer>

export interface AccountTransferController {
  // Create a new accountTransfer record.
  create: (payload: AccountTransferCreateInput, options?: ApiOptions) => Promise<AccountTransfer | null>
  // Create multiple accountTransfer records in sequence.
  createMany: (payloads: AccountTransferCreateInput[], options?: ApiOptions) => Promise<(AccountTransfer | null)[]>
  // Update a accountTransfer by id (record object or sub-id).
  update: (id: AccountTransferIdInput, payload: AccountTransferUpdateInput, options?: ApiOptions) => Promise<AccountTransfer | null>
  // Update multiple accountTransfer records in sequence.
  updateMany: (
    items: Array<{ id: AccountTransferIdInput; payload: AccountTransferUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(AccountTransfer | null)[]>
  // Delete a accountTransfer by id (record object or sub-id).
  delete: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<AccountTransfer | null>
  // Delete multiple accountTransfer records in sequence.
  deleteMany: (ids: AccountTransferIdInput[], options?: ApiOptions) => Promise<(AccountTransfer | null)[]>
  // Fetch a resource view/function for the accountTransfer.
  get: (id: AccountTransferIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: AccountTransferIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountTransferIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: AccountTransferIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: AccountTransferIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<any>
  get: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: AccountTransferIdInput,
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
  attach: (id: AccountTransferIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountTransferIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: AccountTransferIdInput, options?: ApiOptions) => Promise<AccountTransferDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountTransferDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountTransferDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type AccountTransferControllerOverride = ControllerOverride<AccountTransferController>

export function createGeneratedAccountTransferController(): AccountTransferController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: AccountTransferIdInput) => crud.resolveRecordSubId<AccountTransferIdSubId>(value)

  // Create a accountTransfer via the TRPC endpoint.
  const create: AccountTransferController['create'] = async (payload, options) => {
    return await $process<AccountTransferCreateInput, AccountTransfer>('accountTransfer.create', payload, options)
  }

  // Create multiple accountTransfer records in sequence.
  const createMany: AccountTransferController['createMany'] = async (payloads, options) => {
    const results: Array<AccountTransfer | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a accountTransfer via the TRPC endpoint.
  const update: AccountTransferController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountTransfer update requires a valid id')
    return await $process<{ id: AccountTransferIdSubId; payload: AccountTransferUpdateInput }, AccountTransfer>(
      'accountTransfer.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple accountTransfer records in sequence.
  const updateMany: AccountTransferController['updateMany'] = async (items, options) => {
    const results: Array<AccountTransfer | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a accountTransfer via the TRPC endpoint.
  const del: AccountTransferController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountTransfer delete requires a valid id')
    return await $process<{ id: AccountTransferIdSubId }, AccountTransfer>('accountTransfer.delete', { id: resolvedId }, options)
  }

  // Delete multiple accountTransfer records in sequence.
  const deleteMany: AccountTransferController['deleteMany'] = async (ids, options) => {
    const results: Array<AccountTransfer | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a accountTransfer.
  const get: AccountTransferController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountTransfer get requires a valid id')
    if (!resourceKey) throw new Error('AccountTransfer get requires a resource key')
    return await $process('accountTransfer.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: AccountTransferController['taxonomy'] = (key: string) => {
    const prefix = `accountTransfer.${key}`
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

  const subtable: AccountTransferController['subtable'] = (key: string) => {
    const prefix = `accountTransfer.subtables.${key}`
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

  const relation: AccountTransferController['relation'] = (key: string) => {
    const prefix = `accountTransfer.relations.${key}`
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
  const typesense: AccountTransferController['typesense'] = () => {
    const prefix = `accountTransfer.typesense`
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
  const refreshTypesenseFor: AccountTransferController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'accountTransfer',
      id: resolvedId,
      endpoint: 'accountTransfer.typesense.resource',
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
