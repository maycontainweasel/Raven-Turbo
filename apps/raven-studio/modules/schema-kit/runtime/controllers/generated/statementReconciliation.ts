import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementReconciliation, StatementReconciliationId, StatementReconciliationIdSubId } from '@schema/types'
type StatementReconciliationDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementReconciliationCreateInput = Pick<StatementReconciliation, 'space' | 'account' | 'statementImport' | 'key' | 'periodStart' | 'periodEnd' | 'currency' | 'signedMovementEffectMinor' | 'printedRowCount' | 'extractedRowCount' | 'movementComponentCount' | 'informationalComponentCount' | 'pendingCount' | 'proposedCount' | 'confirmedExistingCount' | 'newlyMaterializedCount' | 'unresolvedCount' | 'transferCandidateCount' | 'activeIssueCount' | 'blockingIssueCount' | 'calculationState' | 'coverageState' | 'attestationState' | 'calculationHash' | 'revision' | 'calculatedAt' | 'calculationOperation'> & Partial<Omit<StatementReconciliation, 'id'>>

export type StatementReconciliationUpdateInput = Partial<Omit<StatementReconciliation, 'id'>>
export type StatementReconciliationRecordId = NonNullable<StatementReconciliation['id']> | StatementReconciliationId
export type StatementReconciliationIdInput = ControllerIdInput<StatementReconciliationIdSubId, StatementReconciliationRecordId, StatementReconciliation>

export interface StatementReconciliationController {
  // Create a new statementReconciliation record.
  create: (payload: StatementReconciliationCreateInput, options?: ApiOptions) => Promise<StatementReconciliation | null>
  // Create multiple statementReconciliation records in sequence.
  createMany: (payloads: StatementReconciliationCreateInput[], options?: ApiOptions) => Promise<(StatementReconciliation | null)[]>
  // Update a statementReconciliation by id (record object or sub-id).
  update: (id: StatementReconciliationIdInput, payload: StatementReconciliationUpdateInput, options?: ApiOptions) => Promise<StatementReconciliation | null>
  // Update multiple statementReconciliation records in sequence.
  updateMany: (
    items: Array<{ id: StatementReconciliationIdInput; payload: StatementReconciliationUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementReconciliation | null)[]>
  // Delete a statementReconciliation by id (record object or sub-id).
  delete: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<StatementReconciliation | null>
  // Delete multiple statementReconciliation records in sequence.
  deleteMany: (ids: StatementReconciliationIdInput[], options?: ApiOptions) => Promise<(StatementReconciliation | null)[]>
  // Fetch a resource view/function for the statementReconciliation.
  get: (id: StatementReconciliationIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementReconciliationIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementReconciliationIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementReconciliationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementReconciliationIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementReconciliationIdInput,
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
  attach: (id: StatementReconciliationIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementReconciliationIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementReconciliationIdInput, options?: ApiOptions) => Promise<StatementReconciliationDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementReconciliationDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementReconciliationDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementReconciliationControllerOverride = ControllerOverride<StatementReconciliationController>

export function createGeneratedStatementReconciliationController(): StatementReconciliationController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementReconciliationIdInput) => crud.resolveRecordSubId<StatementReconciliationIdSubId>(value)

  // Create a statementReconciliation via the TRPC endpoint.
  const create: StatementReconciliationController['create'] = async (payload, options) => {
    return await $process<StatementReconciliationCreateInput, StatementReconciliation>('statementReconciliation.create', payload, options)
  }

  // Create multiple statementReconciliation records in sequence.
  const createMany: StatementReconciliationController['createMany'] = async (payloads, options) => {
    const results: Array<StatementReconciliation | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementReconciliation via the TRPC endpoint.
  const update: StatementReconciliationController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliation update requires a valid id')
    return await $process<{ id: StatementReconciliationIdSubId; payload: StatementReconciliationUpdateInput }, StatementReconciliation>(
      'statementReconciliation.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementReconciliation records in sequence.
  const updateMany: StatementReconciliationController['updateMany'] = async (items, options) => {
    const results: Array<StatementReconciliation | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementReconciliation via the TRPC endpoint.
  const del: StatementReconciliationController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliation delete requires a valid id')
    return await $process<{ id: StatementReconciliationIdSubId }, StatementReconciliation>('statementReconciliation.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementReconciliation records in sequence.
  const deleteMany: StatementReconciliationController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementReconciliation | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementReconciliation.
  const get: StatementReconciliationController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementReconciliation get requires a valid id')
    if (!resourceKey) throw new Error('StatementReconciliation get requires a resource key')
    return await $process('statementReconciliation.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementReconciliationController['taxonomy'] = (key: string) => {
    const prefix = `statementReconciliation.${key}`
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

  const subtable: StatementReconciliationController['subtable'] = (key: string) => {
    const prefix = `statementReconciliation.subtables.${key}`
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

  const relation: StatementReconciliationController['relation'] = (key: string) => {
    const prefix = `statementReconciliation.relations.${key}`
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
  const typesense: StatementReconciliationController['typesense'] = () => {
    const prefix = `statementReconciliation.typesense`
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
  const refreshTypesenseFor: StatementReconciliationController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementReconciliation',
      id: resolvedId,
      endpoint: 'statementReconciliation.typesense.resource',
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
