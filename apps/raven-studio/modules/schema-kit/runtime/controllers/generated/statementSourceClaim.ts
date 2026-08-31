import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementSourceClaim, StatementSourceClaimId, StatementSourceClaimIdSubId } from '@schema/types'
type StatementSourceClaimDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementSourceClaimCreateInput = Pick<StatementSourceClaim, 'space' | 'account' | 'statementImport' | 'key' | 'originalFileSha256' | 'periodStart' | 'periodEnd' | 'state' | 'claimedAt' | 'operation'> & Partial<Omit<StatementSourceClaim, 'id'>>

export type StatementSourceClaimUpdateInput = Partial<Omit<StatementSourceClaim, 'id'>>
export type StatementSourceClaimRecordId = NonNullable<StatementSourceClaim['id']> | StatementSourceClaimId
export type StatementSourceClaimIdInput = ControllerIdInput<StatementSourceClaimIdSubId, StatementSourceClaimRecordId, StatementSourceClaim>

export interface StatementSourceClaimController {
  // Create a new statementSourceClaim record.
  create: (payload: StatementSourceClaimCreateInput, options?: ApiOptions) => Promise<StatementSourceClaim | null>
  // Create multiple statementSourceClaim records in sequence.
  createMany: (payloads: StatementSourceClaimCreateInput[], options?: ApiOptions) => Promise<(StatementSourceClaim | null)[]>
  // Update a statementSourceClaim by id (record object or sub-id).
  update: (id: StatementSourceClaimIdInput, payload: StatementSourceClaimUpdateInput, options?: ApiOptions) => Promise<StatementSourceClaim | null>
  // Update multiple statementSourceClaim records in sequence.
  updateMany: (
    items: Array<{ id: StatementSourceClaimIdInput; payload: StatementSourceClaimUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementSourceClaim | null)[]>
  // Delete a statementSourceClaim by id (record object or sub-id).
  delete: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<StatementSourceClaim | null>
  // Delete multiple statementSourceClaim records in sequence.
  deleteMany: (ids: StatementSourceClaimIdInput[], options?: ApiOptions) => Promise<(StatementSourceClaim | null)[]>
  // Fetch a resource view/function for the statementSourceClaim.
  get: (id: StatementSourceClaimIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementSourceClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementSourceClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementSourceClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementSourceClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementSourceClaimIdInput,
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
  attach: (id: StatementSourceClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementSourceClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementSourceClaimIdInput, options?: ApiOptions) => Promise<StatementSourceClaimDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementSourceClaimDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementSourceClaimDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementSourceClaimControllerOverride = ControllerOverride<StatementSourceClaimController>

export function createGeneratedStatementSourceClaimController(): StatementSourceClaimController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementSourceClaimIdInput) => crud.resolveRecordSubId<StatementSourceClaimIdSubId>(value)

  // Create a statementSourceClaim via the TRPC endpoint.
  const create: StatementSourceClaimController['create'] = async (payload, options) => {
    return await $process<StatementSourceClaimCreateInput, StatementSourceClaim>('statementSourceClaim.create', payload, options)
  }

  // Create multiple statementSourceClaim records in sequence.
  const createMany: StatementSourceClaimController['createMany'] = async (payloads, options) => {
    const results: Array<StatementSourceClaim | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementSourceClaim via the TRPC endpoint.
  const update: StatementSourceClaimController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementSourceClaim update requires a valid id')
    return await $process<{ id: StatementSourceClaimIdSubId; payload: StatementSourceClaimUpdateInput }, StatementSourceClaim>(
      'statementSourceClaim.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementSourceClaim records in sequence.
  const updateMany: StatementSourceClaimController['updateMany'] = async (items, options) => {
    const results: Array<StatementSourceClaim | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementSourceClaim via the TRPC endpoint.
  const del: StatementSourceClaimController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementSourceClaim delete requires a valid id')
    return await $process<{ id: StatementSourceClaimIdSubId }, StatementSourceClaim>('statementSourceClaim.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementSourceClaim records in sequence.
  const deleteMany: StatementSourceClaimController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementSourceClaim | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementSourceClaim.
  const get: StatementSourceClaimController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementSourceClaim get requires a valid id')
    if (!resourceKey) throw new Error('StatementSourceClaim get requires a resource key')
    return await $process('statementSourceClaim.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementSourceClaimController['taxonomy'] = (key: string) => {
    const prefix = `statementSourceClaim.${key}`
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

  const subtable: StatementSourceClaimController['subtable'] = (key: string) => {
    const prefix = `statementSourceClaim.subtables.${key}`
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

  const relation: StatementSourceClaimController['relation'] = (key: string) => {
    const prefix = `statementSourceClaim.relations.${key}`
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
  const typesense: StatementSourceClaimController['typesense'] = () => {
    const prefix = `statementSourceClaim.typesense`
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
  const refreshTypesenseFor: StatementSourceClaimController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementSourceClaim',
      id: resolvedId,
      endpoint: 'statementSourceClaim.typesense.resource',
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
