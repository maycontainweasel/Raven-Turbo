import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementTransactionMatch, StatementTransactionMatchId, StatementTransactionMatchIdSubId } from '@schema/types'
type StatementTransactionMatchDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementTransactionMatchCreateInput = Pick<StatementTransactionMatch, 'space' | 'account' | 'statementImport' | 'primaryComponent' | 'componentIds' | 'transaction' | 'key' | 'state' | 'method' | 'reasonCodes' | 'confidence' | 'signedComponentTotalMinor' | 'currency' | 'revision' | 'proposedOperation' | 'proposedAt' | 'sourceState'> & Partial<Omit<StatementTransactionMatch, 'id'>>

export type StatementTransactionMatchUpdateInput = Partial<Omit<StatementTransactionMatch, 'id'>>
export type StatementTransactionMatchRecordId = NonNullable<StatementTransactionMatch['id']> | StatementTransactionMatchId
export type StatementTransactionMatchIdInput = ControllerIdInput<StatementTransactionMatchIdSubId, StatementTransactionMatchRecordId, StatementTransactionMatch>

export interface StatementTransactionMatchController {
  // Create a new statementTransactionMatch record.
  create: (payload: StatementTransactionMatchCreateInput, options?: ApiOptions) => Promise<StatementTransactionMatch | null>
  // Create multiple statementTransactionMatch records in sequence.
  createMany: (payloads: StatementTransactionMatchCreateInput[], options?: ApiOptions) => Promise<(StatementTransactionMatch | null)[]>
  // Update a statementTransactionMatch by id (record object or sub-id).
  update: (id: StatementTransactionMatchIdInput, payload: StatementTransactionMatchUpdateInput, options?: ApiOptions) => Promise<StatementTransactionMatch | null>
  // Update multiple statementTransactionMatch records in sequence.
  updateMany: (
    items: Array<{ id: StatementTransactionMatchIdInput; payload: StatementTransactionMatchUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementTransactionMatch | null)[]>
  // Delete a statementTransactionMatch by id (record object or sub-id).
  delete: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<StatementTransactionMatch | null>
  // Delete multiple statementTransactionMatch records in sequence.
  deleteMany: (ids: StatementTransactionMatchIdInput[], options?: ApiOptions) => Promise<(StatementTransactionMatch | null)[]>
  // Fetch a resource view/function for the statementTransactionMatch.
  get: (id: StatementTransactionMatchIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementTransactionMatchIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementTransactionMatchIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementTransactionMatchIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementTransactionMatchIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementTransactionMatchIdInput,
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
  attach: (id: StatementTransactionMatchIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementTransactionMatchIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementTransactionMatchIdInput, options?: ApiOptions) => Promise<StatementTransactionMatchDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementTransactionMatchDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementTransactionMatchDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementTransactionMatchControllerOverride = ControllerOverride<StatementTransactionMatchController>

export function createGeneratedStatementTransactionMatchController(): StatementTransactionMatchController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementTransactionMatchIdInput) => crud.resolveRecordSubId<StatementTransactionMatchIdSubId>(value)

  // Create a statementTransactionMatch via the TRPC endpoint.
  const create: StatementTransactionMatchController['create'] = async (payload, options) => {
    return await $process<StatementTransactionMatchCreateInput, StatementTransactionMatch>('statementTransactionMatch.create', payload, options)
  }

  // Create multiple statementTransactionMatch records in sequence.
  const createMany: StatementTransactionMatchController['createMany'] = async (payloads, options) => {
    const results: Array<StatementTransactionMatch | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementTransactionMatch via the TRPC endpoint.
  const update: StatementTransactionMatchController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementTransactionMatch update requires a valid id')
    return await $process<{ id: StatementTransactionMatchIdSubId; payload: StatementTransactionMatchUpdateInput }, StatementTransactionMatch>(
      'statementTransactionMatch.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementTransactionMatch records in sequence.
  const updateMany: StatementTransactionMatchController['updateMany'] = async (items, options) => {
    const results: Array<StatementTransactionMatch | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementTransactionMatch via the TRPC endpoint.
  const del: StatementTransactionMatchController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementTransactionMatch delete requires a valid id')
    return await $process<{ id: StatementTransactionMatchIdSubId }, StatementTransactionMatch>('statementTransactionMatch.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementTransactionMatch records in sequence.
  const deleteMany: StatementTransactionMatchController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementTransactionMatch | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementTransactionMatch.
  const get: StatementTransactionMatchController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementTransactionMatch get requires a valid id')
    if (!resourceKey) throw new Error('StatementTransactionMatch get requires a resource key')
    return await $process('statementTransactionMatch.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementTransactionMatchController['taxonomy'] = (key: string) => {
    const prefix = `statementTransactionMatch.${key}`
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

  const subtable: StatementTransactionMatchController['subtable'] = (key: string) => {
    const prefix = `statementTransactionMatch.subtables.${key}`
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

  const relation: StatementTransactionMatchController['relation'] = (key: string) => {
    const prefix = `statementTransactionMatch.relations.${key}`
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
  const typesense: StatementTransactionMatchController['typesense'] = () => {
    const prefix = `statementTransactionMatch.typesense`
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
  const refreshTypesenseFor: StatementTransactionMatchController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementTransactionMatch',
      id: resolvedId,
      endpoint: 'statementTransactionMatch.typesense.resource',
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
