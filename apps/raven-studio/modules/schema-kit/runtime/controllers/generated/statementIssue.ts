import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementIssue, StatementIssueId, StatementIssueIdSubId } from '@schema/types'
type StatementIssueDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementIssueCreateInput = Pick<StatementIssue, 'space' | 'account' | 'statementImport' | 'key' | 'code' | 'severity' | 'blocking' | 'state' | 'message' | 'revision' | 'detectedOperation' | 'detectedAt'> & Partial<Omit<StatementIssue, 'id'>>

export type StatementIssueUpdateInput = Partial<Omit<StatementIssue, 'id'>>
export type StatementIssueRecordId = NonNullable<StatementIssue['id']> | StatementIssueId
export type StatementIssueIdInput = ControllerIdInput<StatementIssueIdSubId, StatementIssueRecordId, StatementIssue>

export interface StatementIssueController {
  // Create a new statementIssue record.
  create: (payload: StatementIssueCreateInput, options?: ApiOptions) => Promise<StatementIssue | null>
  // Create multiple statementIssue records in sequence.
  createMany: (payloads: StatementIssueCreateInput[], options?: ApiOptions) => Promise<(StatementIssue | null)[]>
  // Update a statementIssue by id (record object or sub-id).
  update: (id: StatementIssueIdInput, payload: StatementIssueUpdateInput, options?: ApiOptions) => Promise<StatementIssue | null>
  // Update multiple statementIssue records in sequence.
  updateMany: (
    items: Array<{ id: StatementIssueIdInput; payload: StatementIssueUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementIssue | null)[]>
  // Delete a statementIssue by id (record object or sub-id).
  delete: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<StatementIssue | null>
  // Delete multiple statementIssue records in sequence.
  deleteMany: (ids: StatementIssueIdInput[], options?: ApiOptions) => Promise<(StatementIssue | null)[]>
  // Fetch a resource view/function for the statementIssue.
  get: (id: StatementIssueIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementIssueIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementIssueIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementIssueIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementIssueIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementIssueIdInput,
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
  attach: (id: StatementIssueIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementIssueIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementIssueIdInput, options?: ApiOptions) => Promise<StatementIssueDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementIssueDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementIssueDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementIssueControllerOverride = ControllerOverride<StatementIssueController>

export function createGeneratedStatementIssueController(): StatementIssueController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementIssueIdInput) => crud.resolveRecordSubId<StatementIssueIdSubId>(value)

  // Create a statementIssue via the TRPC endpoint.
  const create: StatementIssueController['create'] = async (payload, options) => {
    return await $process<StatementIssueCreateInput, StatementIssue>('statementIssue.create', payload, options)
  }

  // Create multiple statementIssue records in sequence.
  const createMany: StatementIssueController['createMany'] = async (payloads, options) => {
    const results: Array<StatementIssue | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementIssue via the TRPC endpoint.
  const update: StatementIssueController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementIssue update requires a valid id')
    return await $process<{ id: StatementIssueIdSubId; payload: StatementIssueUpdateInput }, StatementIssue>(
      'statementIssue.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementIssue records in sequence.
  const updateMany: StatementIssueController['updateMany'] = async (items, options) => {
    const results: Array<StatementIssue | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementIssue via the TRPC endpoint.
  const del: StatementIssueController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementIssue delete requires a valid id')
    return await $process<{ id: StatementIssueIdSubId }, StatementIssue>('statementIssue.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementIssue records in sequence.
  const deleteMany: StatementIssueController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementIssue | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementIssue.
  const get: StatementIssueController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementIssue get requires a valid id')
    if (!resourceKey) throw new Error('StatementIssue get requires a resource key')
    return await $process('statementIssue.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementIssueController['taxonomy'] = (key: string) => {
    const prefix = `statementIssue.${key}`
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

  const subtable: StatementIssueController['subtable'] = (key: string) => {
    const prefix = `statementIssue.subtables.${key}`
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

  const relation: StatementIssueController['relation'] = (key: string) => {
    const prefix = `statementIssue.relations.${key}`
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
  const typesense: StatementIssueController['typesense'] = () => {
    const prefix = `statementIssue.typesense`
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
  const refreshTypesenseFor: StatementIssueController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementIssue',
      id: resolvedId,
      endpoint: 'statementIssue.typesense.resource',
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
