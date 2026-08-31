import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { AccountBalanceSnapshot, AccountBalanceSnapshotId, AccountBalanceSnapshotIdSubId } from '@schema/types'
type AccountBalanceSnapshotDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type AccountBalanceSnapshotCreateInput = Pick<AccountBalanceSnapshot, 'space' | 'account' | 'key' | 'balanceKind' | 'amountMinor' | 'currency' | 'economicNature' | 'asOf' | 'recordedAt' | 'evidenceLevel' | 'sourceKind'> & Partial<Omit<AccountBalanceSnapshot, 'id'>>

export type AccountBalanceSnapshotUpdateInput = Partial<Omit<AccountBalanceSnapshot, 'id'>>
export type AccountBalanceSnapshotRecordId = NonNullable<AccountBalanceSnapshot['id']> | AccountBalanceSnapshotId
export type AccountBalanceSnapshotIdInput = ControllerIdInput<AccountBalanceSnapshotIdSubId, AccountBalanceSnapshotRecordId, AccountBalanceSnapshot>

export interface AccountBalanceSnapshotController {
  // Create a new accountBalanceSnapshot record.
  create: (payload: AccountBalanceSnapshotCreateInput, options?: ApiOptions) => Promise<AccountBalanceSnapshot | null>
  // Create multiple accountBalanceSnapshot records in sequence.
  createMany: (payloads: AccountBalanceSnapshotCreateInput[], options?: ApiOptions) => Promise<(AccountBalanceSnapshot | null)[]>
  // Update a accountBalanceSnapshot by id (record object or sub-id).
  update: (id: AccountBalanceSnapshotIdInput, payload: AccountBalanceSnapshotUpdateInput, options?: ApiOptions) => Promise<AccountBalanceSnapshot | null>
  // Update multiple accountBalanceSnapshot records in sequence.
  updateMany: (
    items: Array<{ id: AccountBalanceSnapshotIdInput; payload: AccountBalanceSnapshotUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(AccountBalanceSnapshot | null)[]>
  // Delete a accountBalanceSnapshot by id (record object or sub-id).
  delete: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<AccountBalanceSnapshot | null>
  // Delete multiple accountBalanceSnapshot records in sequence.
  deleteMany: (ids: AccountBalanceSnapshotIdInput[], options?: ApiOptions) => Promise<(AccountBalanceSnapshot | null)[]>
  // Fetch a resource view/function for the accountBalanceSnapshot.
  get: (id: AccountBalanceSnapshotIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: AccountBalanceSnapshotIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountBalanceSnapshotIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: AccountBalanceSnapshotIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: AccountBalanceSnapshotIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<any>
  get: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: AccountBalanceSnapshotIdInput,
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
  attach: (id: AccountBalanceSnapshotIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountBalanceSnapshotIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: AccountBalanceSnapshotIdInput, options?: ApiOptions) => Promise<AccountBalanceSnapshotDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountBalanceSnapshotDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountBalanceSnapshotDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type AccountBalanceSnapshotControllerOverride = ControllerOverride<AccountBalanceSnapshotController>

export function createGeneratedAccountBalanceSnapshotController(): AccountBalanceSnapshotController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: AccountBalanceSnapshotIdInput) => crud.resolveRecordSubId<AccountBalanceSnapshotIdSubId>(value)

  // Create a accountBalanceSnapshot via the TRPC endpoint.
  const create: AccountBalanceSnapshotController['create'] = async (payload, options) => {
    return await $process<AccountBalanceSnapshotCreateInput, AccountBalanceSnapshot>('accountBalanceSnapshot.create', payload, options)
  }

  // Create multiple accountBalanceSnapshot records in sequence.
  const createMany: AccountBalanceSnapshotController['createMany'] = async (payloads, options) => {
    const results: Array<AccountBalanceSnapshot | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a accountBalanceSnapshot via the TRPC endpoint.
  const update: AccountBalanceSnapshotController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountBalanceSnapshot update requires a valid id')
    return await $process<{ id: AccountBalanceSnapshotIdSubId; payload: AccountBalanceSnapshotUpdateInput }, AccountBalanceSnapshot>(
      'accountBalanceSnapshot.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple accountBalanceSnapshot records in sequence.
  const updateMany: AccountBalanceSnapshotController['updateMany'] = async (items, options) => {
    const results: Array<AccountBalanceSnapshot | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a accountBalanceSnapshot via the TRPC endpoint.
  const del: AccountBalanceSnapshotController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountBalanceSnapshot delete requires a valid id')
    return await $process<{ id: AccountBalanceSnapshotIdSubId }, AccountBalanceSnapshot>('accountBalanceSnapshot.delete', { id: resolvedId }, options)
  }

  // Delete multiple accountBalanceSnapshot records in sequence.
  const deleteMany: AccountBalanceSnapshotController['deleteMany'] = async (ids, options) => {
    const results: Array<AccountBalanceSnapshot | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a accountBalanceSnapshot.
  const get: AccountBalanceSnapshotController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountBalanceSnapshot get requires a valid id')
    if (!resourceKey) throw new Error('AccountBalanceSnapshot get requires a resource key')
    return await $process('accountBalanceSnapshot.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: AccountBalanceSnapshotController['taxonomy'] = (key: string) => {
    const prefix = `accountBalanceSnapshot.${key}`
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

  const subtable: AccountBalanceSnapshotController['subtable'] = (key: string) => {
    const prefix = `accountBalanceSnapshot.subtables.${key}`
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

  const relation: AccountBalanceSnapshotController['relation'] = (key: string) => {
    const prefix = `accountBalanceSnapshot.relations.${key}`
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
  const typesense: AccountBalanceSnapshotController['typesense'] = () => {
    const prefix = `accountBalanceSnapshot.typesense`
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
  const refreshTypesenseFor: AccountBalanceSnapshotController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'accountBalanceSnapshot',
      id: resolvedId,
      endpoint: 'accountBalanceSnapshot.typesense.resource',
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
