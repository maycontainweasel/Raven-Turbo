import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementComponentResolutionClaim, StatementComponentResolutionClaimId, StatementComponentResolutionClaimIdSubId } from '@schema/types'
type StatementComponentResolutionClaimDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementComponentResolutionClaimCreateInput = Pick<StatementComponentResolutionClaim, 'space' | 'account' | 'statementImport' | 'statementRowComponent' | 'statementTransactionMatch' | 'transaction' | 'key' | 'state' | 'claimedAt' | 'operation'> & Partial<Omit<StatementComponentResolutionClaim, 'id'>>

export type StatementComponentResolutionClaimUpdateInput = Partial<Omit<StatementComponentResolutionClaim, 'id'>>
export type StatementComponentResolutionClaimRecordId = NonNullable<StatementComponentResolutionClaim['id']> | StatementComponentResolutionClaimId
export type StatementComponentResolutionClaimIdInput = ControllerIdInput<StatementComponentResolutionClaimIdSubId, StatementComponentResolutionClaimRecordId, StatementComponentResolutionClaim>

export interface StatementComponentResolutionClaimController {
  // Create a new statementComponentResolutionClaim record.
  create: (payload: StatementComponentResolutionClaimCreateInput, options?: ApiOptions) => Promise<StatementComponentResolutionClaim | null>
  // Create multiple statementComponentResolutionClaim records in sequence.
  createMany: (payloads: StatementComponentResolutionClaimCreateInput[], options?: ApiOptions) => Promise<(StatementComponentResolutionClaim | null)[]>
  // Update a statementComponentResolutionClaim by id (record object or sub-id).
  update: (id: StatementComponentResolutionClaimIdInput, payload: StatementComponentResolutionClaimUpdateInput, options?: ApiOptions) => Promise<StatementComponentResolutionClaim | null>
  // Update multiple statementComponentResolutionClaim records in sequence.
  updateMany: (
    items: Array<{ id: StatementComponentResolutionClaimIdInput; payload: StatementComponentResolutionClaimUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementComponentResolutionClaim | null)[]>
  // Delete a statementComponentResolutionClaim by id (record object or sub-id).
  delete: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<StatementComponentResolutionClaim | null>
  // Delete multiple statementComponentResolutionClaim records in sequence.
  deleteMany: (ids: StatementComponentResolutionClaimIdInput[], options?: ApiOptions) => Promise<(StatementComponentResolutionClaim | null)[]>
  // Fetch a resource view/function for the statementComponentResolutionClaim.
  get: (id: StatementComponentResolutionClaimIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementComponentResolutionClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementComponentResolutionClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementComponentResolutionClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementComponentResolutionClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementComponentResolutionClaimIdInput,
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
  attach: (id: StatementComponentResolutionClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementComponentResolutionClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementComponentResolutionClaimIdInput, options?: ApiOptions) => Promise<StatementComponentResolutionClaimDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementComponentResolutionClaimDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementComponentResolutionClaimDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementComponentResolutionClaimControllerOverride = ControllerOverride<StatementComponentResolutionClaimController>

export function createGeneratedStatementComponentResolutionClaimController(): StatementComponentResolutionClaimController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementComponentResolutionClaimIdInput) => crud.resolveRecordSubId<StatementComponentResolutionClaimIdSubId>(value)

  // Create a statementComponentResolutionClaim via the TRPC endpoint.
  const create: StatementComponentResolutionClaimController['create'] = async (payload, options) => {
    return await $process<StatementComponentResolutionClaimCreateInput, StatementComponentResolutionClaim>('statementComponentResolutionClaim.create', payload, options)
  }

  // Create multiple statementComponentResolutionClaim records in sequence.
  const createMany: StatementComponentResolutionClaimController['createMany'] = async (payloads, options) => {
    const results: Array<StatementComponentResolutionClaim | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementComponentResolutionClaim via the TRPC endpoint.
  const update: StatementComponentResolutionClaimController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementComponentResolutionClaim update requires a valid id')
    return await $process<{ id: StatementComponentResolutionClaimIdSubId; payload: StatementComponentResolutionClaimUpdateInput }, StatementComponentResolutionClaim>(
      'statementComponentResolutionClaim.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementComponentResolutionClaim records in sequence.
  const updateMany: StatementComponentResolutionClaimController['updateMany'] = async (items, options) => {
    const results: Array<StatementComponentResolutionClaim | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementComponentResolutionClaim via the TRPC endpoint.
  const del: StatementComponentResolutionClaimController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementComponentResolutionClaim delete requires a valid id')
    return await $process<{ id: StatementComponentResolutionClaimIdSubId }, StatementComponentResolutionClaim>('statementComponentResolutionClaim.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementComponentResolutionClaim records in sequence.
  const deleteMany: StatementComponentResolutionClaimController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementComponentResolutionClaim | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementComponentResolutionClaim.
  const get: StatementComponentResolutionClaimController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementComponentResolutionClaim get requires a valid id')
    if (!resourceKey) throw new Error('StatementComponentResolutionClaim get requires a resource key')
    return await $process('statementComponentResolutionClaim.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementComponentResolutionClaimController['taxonomy'] = (key: string) => {
    const prefix = `statementComponentResolutionClaim.${key}`
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

  const subtable: StatementComponentResolutionClaimController['subtable'] = (key: string) => {
    const prefix = `statementComponentResolutionClaim.subtables.${key}`
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

  const relation: StatementComponentResolutionClaimController['relation'] = (key: string) => {
    const prefix = `statementComponentResolutionClaim.relations.${key}`
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
  const typesense: StatementComponentResolutionClaimController['typesense'] = () => {
    const prefix = `statementComponentResolutionClaim.typesense`
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
  const refreshTypesenseFor: StatementComponentResolutionClaimController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementComponentResolutionClaim',
      id: resolvedId,
      endpoint: 'statementComponentResolutionClaim.typesense.resource',
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
