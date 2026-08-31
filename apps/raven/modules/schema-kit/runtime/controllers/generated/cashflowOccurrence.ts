import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { CashflowOccurrence, CashflowOccurrenceId, CashflowOccurrenceIdSubId } from '@schema/types'
type CashflowOccurrenceDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type CashflowOccurrenceCreateInput = Pick<CashflowOccurrence, 'schedule' | 'space' | 'scheduledDueOn' | 'dueOn' | 'scheduleRevision' | 'revision' | 'title' | 'direction' | 'certainty' | 'cadence' | 'scheduledAmountMinor' | 'amountMinor' | 'currency' | 'status' | 'lastOperation' | 'recordedAt' | 'updatedAt'> & Partial<Omit<CashflowOccurrence, 'id'>>

export type CashflowOccurrenceUpdateInput = Partial<Omit<CashflowOccurrence, 'id'>>
export type CashflowOccurrenceRecordId = NonNullable<CashflowOccurrence['id']> | CashflowOccurrenceId
export type CashflowOccurrenceIdInput = ControllerIdInput<CashflowOccurrenceIdSubId, CashflowOccurrenceRecordId, CashflowOccurrence>

export interface CashflowOccurrenceController {
  // Create a new cashflowOccurrence record.
  create: (payload: CashflowOccurrenceCreateInput, options?: ApiOptions) => Promise<CashflowOccurrence | null>
  // Create multiple cashflowOccurrence records in sequence.
  createMany: (payloads: CashflowOccurrenceCreateInput[], options?: ApiOptions) => Promise<(CashflowOccurrence | null)[]>
  // Update a cashflowOccurrence by id (record object or sub-id).
  update: (id: CashflowOccurrenceIdInput, payload: CashflowOccurrenceUpdateInput, options?: ApiOptions) => Promise<CashflowOccurrence | null>
  // Update multiple cashflowOccurrence records in sequence.
  updateMany: (
    items: Array<{ id: CashflowOccurrenceIdInput; payload: CashflowOccurrenceUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(CashflowOccurrence | null)[]>
  // Delete a cashflowOccurrence by id (record object or sub-id).
  delete: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<CashflowOccurrence | null>
  // Delete multiple cashflowOccurrence records in sequence.
  deleteMany: (ids: CashflowOccurrenceIdInput[], options?: ApiOptions) => Promise<(CashflowOccurrence | null)[]>
  // Fetch a resource view/function for the cashflowOccurrence.
  get: (id: CashflowOccurrenceIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: CashflowOccurrenceIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: CashflowOccurrenceIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: CashflowOccurrenceIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: CashflowOccurrenceIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<any>
  get: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: CashflowOccurrenceIdInput,
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
  attach: (id: CashflowOccurrenceIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: CashflowOccurrenceIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: CashflowOccurrenceIdInput, options?: ApiOptions) => Promise<CashflowOccurrenceDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<CashflowOccurrenceDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<CashflowOccurrenceDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type CashflowOccurrenceControllerOverride = ControllerOverride<CashflowOccurrenceController>

export function createGeneratedCashflowOccurrenceController(): CashflowOccurrenceController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: CashflowOccurrenceIdInput) => crud.resolveRecordSubId<CashflowOccurrenceIdSubId>(value)

  // Create a cashflowOccurrence via the TRPC endpoint.
  const create: CashflowOccurrenceController['create'] = async (payload, options) => {
    return await $process<CashflowOccurrenceCreateInput, CashflowOccurrence>('cashflowOccurrence.create', payload, options)
  }

  // Create multiple cashflowOccurrence records in sequence.
  const createMany: CashflowOccurrenceController['createMany'] = async (payloads, options) => {
    const results: Array<CashflowOccurrence | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a cashflowOccurrence via the TRPC endpoint.
  const update: CashflowOccurrenceController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowOccurrence update requires a valid id')
    return await $process<{ id: CashflowOccurrenceIdSubId; payload: CashflowOccurrenceUpdateInput }, CashflowOccurrence>(
      'cashflowOccurrence.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple cashflowOccurrence records in sequence.
  const updateMany: CashflowOccurrenceController['updateMany'] = async (items, options) => {
    const results: Array<CashflowOccurrence | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a cashflowOccurrence via the TRPC endpoint.
  const del: CashflowOccurrenceController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowOccurrence delete requires a valid id')
    return await $process<{ id: CashflowOccurrenceIdSubId }, CashflowOccurrence>('cashflowOccurrence.delete', { id: resolvedId }, options)
  }

  // Delete multiple cashflowOccurrence records in sequence.
  const deleteMany: CashflowOccurrenceController['deleteMany'] = async (ids, options) => {
    const results: Array<CashflowOccurrence | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a cashflowOccurrence.
  const get: CashflowOccurrenceController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowOccurrence get requires a valid id')
    if (!resourceKey) throw new Error('CashflowOccurrence get requires a resource key')
    return await $process('cashflowOccurrence.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: CashflowOccurrenceController['taxonomy'] = (key: string) => {
    const prefix = `cashflowOccurrence.${key}`
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

  const subtable: CashflowOccurrenceController['subtable'] = (key: string) => {
    const prefix = `cashflowOccurrence.subtables.${key}`
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

  const relation: CashflowOccurrenceController['relation'] = (key: string) => {
    const prefix = `cashflowOccurrence.relations.${key}`
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
  const typesense: CashflowOccurrenceController['typesense'] = () => {
    const prefix = `cashflowOccurrence.typesense`
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
  const refreshTypesenseFor: CashflowOccurrenceController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'cashflowOccurrence',
      id: resolvedId,
      endpoint: 'cashflowOccurrence.typesense.resource',
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
