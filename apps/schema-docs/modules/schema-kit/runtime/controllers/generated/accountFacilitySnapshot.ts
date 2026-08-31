import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { AccountFacilitySnapshot, AccountFacilitySnapshotId, AccountFacilitySnapshotIdSubId } from '@schema/types'
type AccountFacilitySnapshotDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type AccountFacilitySnapshotCreateInput = Pick<AccountFacilitySnapshot, 'space' | 'account' | 'key' | 'facilityKind' | 'currency' | 'asOf' | 'recordedAt' | 'evidenceLevel' | 'sourceKind' | 'hasFacilityLimit' | 'hasAvailableCredit' | 'hasMinimumPayment'> & Partial<Omit<AccountFacilitySnapshot, 'id'>>

export type AccountFacilitySnapshotUpdateInput = Partial<Omit<AccountFacilitySnapshot, 'id'>>
export type AccountFacilitySnapshotRecordId = NonNullable<AccountFacilitySnapshot['id']> | AccountFacilitySnapshotId
export type AccountFacilitySnapshotIdInput = ControllerIdInput<AccountFacilitySnapshotIdSubId, AccountFacilitySnapshotRecordId, AccountFacilitySnapshot>

export interface AccountFacilitySnapshotController {
  // Create a new accountFacilitySnapshot record.
  create: (payload: AccountFacilitySnapshotCreateInput, options?: ApiOptions) => Promise<AccountFacilitySnapshot | null>
  // Create multiple accountFacilitySnapshot records in sequence.
  createMany: (payloads: AccountFacilitySnapshotCreateInput[], options?: ApiOptions) => Promise<(AccountFacilitySnapshot | null)[]>
  // Update a accountFacilitySnapshot by id (record object or sub-id).
  update: (id: AccountFacilitySnapshotIdInput, payload: AccountFacilitySnapshotUpdateInput, options?: ApiOptions) => Promise<AccountFacilitySnapshot | null>
  // Update multiple accountFacilitySnapshot records in sequence.
  updateMany: (
    items: Array<{ id: AccountFacilitySnapshotIdInput; payload: AccountFacilitySnapshotUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(AccountFacilitySnapshot | null)[]>
  // Delete a accountFacilitySnapshot by id (record object or sub-id).
  delete: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<AccountFacilitySnapshot | null>
  // Delete multiple accountFacilitySnapshot records in sequence.
  deleteMany: (ids: AccountFacilitySnapshotIdInput[], options?: ApiOptions) => Promise<(AccountFacilitySnapshot | null)[]>
  // Fetch a resource view/function for the accountFacilitySnapshot.
  get: (id: AccountFacilitySnapshotIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: AccountFacilitySnapshotIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountFacilitySnapshotIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: AccountFacilitySnapshotIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: AccountFacilitySnapshotIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<any>
  get: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: AccountFacilitySnapshotIdInput,
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
  attach: (id: AccountFacilitySnapshotIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: AccountFacilitySnapshotIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: AccountFacilitySnapshotIdInput, options?: ApiOptions) => Promise<AccountFacilitySnapshotDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountFacilitySnapshotDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<AccountFacilitySnapshotDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type AccountFacilitySnapshotControllerOverride = ControllerOverride<AccountFacilitySnapshotController>

export function createGeneratedAccountFacilitySnapshotController(): AccountFacilitySnapshotController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: AccountFacilitySnapshotIdInput) => crud.resolveRecordSubId<AccountFacilitySnapshotIdSubId>(value)

  // Create a accountFacilitySnapshot via the TRPC endpoint.
  const create: AccountFacilitySnapshotController['create'] = async (payload, options) => {
    return await $process<AccountFacilitySnapshotCreateInput, AccountFacilitySnapshot>('accountFacilitySnapshot.create', payload, options)
  }

  // Create multiple accountFacilitySnapshot records in sequence.
  const createMany: AccountFacilitySnapshotController['createMany'] = async (payloads, options) => {
    const results: Array<AccountFacilitySnapshot | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a accountFacilitySnapshot via the TRPC endpoint.
  const update: AccountFacilitySnapshotController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountFacilitySnapshot update requires a valid id')
    return await $process<{ id: AccountFacilitySnapshotIdSubId; payload: AccountFacilitySnapshotUpdateInput }, AccountFacilitySnapshot>(
      'accountFacilitySnapshot.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple accountFacilitySnapshot records in sequence.
  const updateMany: AccountFacilitySnapshotController['updateMany'] = async (items, options) => {
    const results: Array<AccountFacilitySnapshot | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a accountFacilitySnapshot via the TRPC endpoint.
  const del: AccountFacilitySnapshotController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountFacilitySnapshot delete requires a valid id')
    return await $process<{ id: AccountFacilitySnapshotIdSubId }, AccountFacilitySnapshot>('accountFacilitySnapshot.delete', { id: resolvedId }, options)
  }

  // Delete multiple accountFacilitySnapshot records in sequence.
  const deleteMany: AccountFacilitySnapshotController['deleteMany'] = async (ids, options) => {
    const results: Array<AccountFacilitySnapshot | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a accountFacilitySnapshot.
  const get: AccountFacilitySnapshotController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('AccountFacilitySnapshot get requires a valid id')
    if (!resourceKey) throw new Error('AccountFacilitySnapshot get requires a resource key')
    return await $process('accountFacilitySnapshot.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: AccountFacilitySnapshotController['taxonomy'] = (key: string) => {
    const prefix = `accountFacilitySnapshot.${key}`
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

  const subtable: AccountFacilitySnapshotController['subtable'] = (key: string) => {
    const prefix = `accountFacilitySnapshot.subtables.${key}`
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

  const relation: AccountFacilitySnapshotController['relation'] = (key: string) => {
    const prefix = `accountFacilitySnapshot.relations.${key}`
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
  const typesense: AccountFacilitySnapshotController['typesense'] = () => {
    const prefix = `accountFacilitySnapshot.typesense`
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
  const refreshTypesenseFor: AccountFacilitySnapshotController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'accountFacilitySnapshot',
      id: resolvedId,
      endpoint: 'accountFacilitySnapshot.typesense.resource',
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
