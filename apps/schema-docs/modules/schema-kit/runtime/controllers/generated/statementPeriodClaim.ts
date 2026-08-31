import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementPeriodClaim, StatementPeriodClaimId, StatementPeriodClaimIdSubId } from '@schema/types'
type StatementPeriodClaimDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementPeriodClaimCreateInput = Pick<StatementPeriodClaim, 'space' | 'account' | 'statementImport' | 'key' | 'periodStart' | 'periodEnd' | 'originalFileSha256' | 'state' | 'claimedAt' | 'operation'> & Partial<Omit<StatementPeriodClaim, 'id'>>

export type StatementPeriodClaimUpdateInput = Partial<Omit<StatementPeriodClaim, 'id'>>
export type StatementPeriodClaimRecordId = NonNullable<StatementPeriodClaim['id']> | StatementPeriodClaimId
export type StatementPeriodClaimIdInput = ControllerIdInput<StatementPeriodClaimIdSubId, StatementPeriodClaimRecordId, StatementPeriodClaim>

export interface StatementPeriodClaimController {
  // Create a new statementPeriodClaim record.
  create: (payload: StatementPeriodClaimCreateInput, options?: ApiOptions) => Promise<StatementPeriodClaim | null>
  // Create multiple statementPeriodClaim records in sequence.
  createMany: (payloads: StatementPeriodClaimCreateInput[], options?: ApiOptions) => Promise<(StatementPeriodClaim | null)[]>
  // Update a statementPeriodClaim by id (record object or sub-id).
  update: (id: StatementPeriodClaimIdInput, payload: StatementPeriodClaimUpdateInput, options?: ApiOptions) => Promise<StatementPeriodClaim | null>
  // Update multiple statementPeriodClaim records in sequence.
  updateMany: (
    items: Array<{ id: StatementPeriodClaimIdInput; payload: StatementPeriodClaimUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementPeriodClaim | null)[]>
  // Delete a statementPeriodClaim by id (record object or sub-id).
  delete: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<StatementPeriodClaim | null>
  // Delete multiple statementPeriodClaim records in sequence.
  deleteMany: (ids: StatementPeriodClaimIdInput[], options?: ApiOptions) => Promise<(StatementPeriodClaim | null)[]>
  // Fetch a resource view/function for the statementPeriodClaim.
  get: (id: StatementPeriodClaimIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementPeriodClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementPeriodClaimIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementPeriodClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementPeriodClaimIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementPeriodClaimIdInput,
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
  attach: (id: StatementPeriodClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementPeriodClaimIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementPeriodClaimIdInput, options?: ApiOptions) => Promise<StatementPeriodClaimDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementPeriodClaimDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementPeriodClaimDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementPeriodClaimControllerOverride = ControllerOverride<StatementPeriodClaimController>

export function createGeneratedStatementPeriodClaimController(): StatementPeriodClaimController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementPeriodClaimIdInput) => crud.resolveRecordSubId<StatementPeriodClaimIdSubId>(value)

  // Create a statementPeriodClaim via the TRPC endpoint.
  const create: StatementPeriodClaimController['create'] = async (payload, options) => {
    return await $process<StatementPeriodClaimCreateInput, StatementPeriodClaim>('statementPeriodClaim.create', payload, options)
  }

  // Create multiple statementPeriodClaim records in sequence.
  const createMany: StatementPeriodClaimController['createMany'] = async (payloads, options) => {
    const results: Array<StatementPeriodClaim | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementPeriodClaim via the TRPC endpoint.
  const update: StatementPeriodClaimController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementPeriodClaim update requires a valid id')
    return await $process<{ id: StatementPeriodClaimIdSubId; payload: StatementPeriodClaimUpdateInput }, StatementPeriodClaim>(
      'statementPeriodClaim.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementPeriodClaim records in sequence.
  const updateMany: StatementPeriodClaimController['updateMany'] = async (items, options) => {
    const results: Array<StatementPeriodClaim | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementPeriodClaim via the TRPC endpoint.
  const del: StatementPeriodClaimController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementPeriodClaim delete requires a valid id')
    return await $process<{ id: StatementPeriodClaimIdSubId }, StatementPeriodClaim>('statementPeriodClaim.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementPeriodClaim records in sequence.
  const deleteMany: StatementPeriodClaimController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementPeriodClaim | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementPeriodClaim.
  const get: StatementPeriodClaimController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementPeriodClaim get requires a valid id')
    if (!resourceKey) throw new Error('StatementPeriodClaim get requires a resource key')
    return await $process('statementPeriodClaim.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementPeriodClaimController['taxonomy'] = (key: string) => {
    const prefix = `statementPeriodClaim.${key}`
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

  const subtable: StatementPeriodClaimController['subtable'] = (key: string) => {
    const prefix = `statementPeriodClaim.subtables.${key}`
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

  const relation: StatementPeriodClaimController['relation'] = (key: string) => {
    const prefix = `statementPeriodClaim.relations.${key}`
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
  const typesense: StatementPeriodClaimController['typesense'] = () => {
    const prefix = `statementPeriodClaim.typesense`
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
  const refreshTypesenseFor: StatementPeriodClaimController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementPeriodClaim',
      id: resolvedId,
      endpoint: 'statementPeriodClaim.typesense.resource',
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
