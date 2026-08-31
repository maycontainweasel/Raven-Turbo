import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { CashflowSchedule, CashflowScheduleId, CashflowScheduleIdSubId } from '@schema/types'
type CashflowScheduleDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type CashflowScheduleCreateInput = Pick<CashflowSchedule, 'space' | 'key' | 'title' | 'direction' | 'certainty' | 'amountMinor' | 'currency' | 'timezone' | 'cadence' | 'interval' | 'startDate' | 'status' | 'revision' | 'termsEffectiveFrom' | 'createdOperation' | 'lastOperation' | 'recordedAt' | 'updatedAt'> & Partial<Omit<CashflowSchedule, 'id'>>

export type CashflowScheduleUpdateInput = Partial<Omit<CashflowSchedule, 'id'>>
export type CashflowScheduleRecordId = NonNullable<CashflowSchedule['id']> | CashflowScheduleId
export type CashflowScheduleIdInput = ControllerIdInput<CashflowScheduleIdSubId, CashflowScheduleRecordId, CashflowSchedule>

export interface CashflowScheduleController {
  // Create a new cashflowSchedule record.
  create: (payload: CashflowScheduleCreateInput, options?: ApiOptions) => Promise<CashflowSchedule | null>
  // Create multiple cashflowSchedule records in sequence.
  createMany: (payloads: CashflowScheduleCreateInput[], options?: ApiOptions) => Promise<(CashflowSchedule | null)[]>
  // Update a cashflowSchedule by id (record object or sub-id).
  update: (id: CashflowScheduleIdInput, payload: CashflowScheduleUpdateInput, options?: ApiOptions) => Promise<CashflowSchedule | null>
  // Update multiple cashflowSchedule records in sequence.
  updateMany: (
    items: Array<{ id: CashflowScheduleIdInput; payload: CashflowScheduleUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(CashflowSchedule | null)[]>
  // Delete a cashflowSchedule by id (record object or sub-id).
  delete: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<CashflowSchedule | null>
  // Delete multiple cashflowSchedule records in sequence.
  deleteMany: (ids: CashflowScheduleIdInput[], options?: ApiOptions) => Promise<(CashflowSchedule | null)[]>
  // Fetch a resource view/function for the cashflowSchedule.
  get: (id: CashflowScheduleIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: CashflowScheduleIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: CashflowScheduleIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: CashflowScheduleIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: CashflowScheduleIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<any>
  get: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: CashflowScheduleIdInput,
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
  attach: (id: CashflowScheduleIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: CashflowScheduleIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: CashflowScheduleIdInput, options?: ApiOptions) => Promise<CashflowScheduleDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<CashflowScheduleDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<CashflowScheduleDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type CashflowScheduleControllerOverride = ControllerOverride<CashflowScheduleController>

export function createGeneratedCashflowScheduleController(): CashflowScheduleController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: CashflowScheduleIdInput) => crud.resolveRecordSubId<CashflowScheduleIdSubId>(value)

  // Create a cashflowSchedule via the TRPC endpoint.
  const create: CashflowScheduleController['create'] = async (payload, options) => {
    return await $process<CashflowScheduleCreateInput, CashflowSchedule>('cashflowSchedule.create', payload, options)
  }

  // Create multiple cashflowSchedule records in sequence.
  const createMany: CashflowScheduleController['createMany'] = async (payloads, options) => {
    const results: Array<CashflowSchedule | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a cashflowSchedule via the TRPC endpoint.
  const update: CashflowScheduleController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowSchedule update requires a valid id')
    return await $process<{ id: CashflowScheduleIdSubId; payload: CashflowScheduleUpdateInput }, CashflowSchedule>(
      'cashflowSchedule.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple cashflowSchedule records in sequence.
  const updateMany: CashflowScheduleController['updateMany'] = async (items, options) => {
    const results: Array<CashflowSchedule | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a cashflowSchedule via the TRPC endpoint.
  const del: CashflowScheduleController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowSchedule delete requires a valid id')
    return await $process<{ id: CashflowScheduleIdSubId }, CashflowSchedule>('cashflowSchedule.delete', { id: resolvedId }, options)
  }

  // Delete multiple cashflowSchedule records in sequence.
  const deleteMany: CashflowScheduleController['deleteMany'] = async (ids, options) => {
    const results: Array<CashflowSchedule | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a cashflowSchedule.
  const get: CashflowScheduleController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('CashflowSchedule get requires a valid id')
    if (!resourceKey) throw new Error('CashflowSchedule get requires a resource key')
    return await $process('cashflowSchedule.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: CashflowScheduleController['taxonomy'] = (key: string) => {
    const prefix = `cashflowSchedule.${key}`
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

  const subtable: CashflowScheduleController['subtable'] = (key: string) => {
    const prefix = `cashflowSchedule.subtables.${key}`
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

  const relation: CashflowScheduleController['relation'] = (key: string) => {
    const prefix = `cashflowSchedule.relations.${key}`
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
  const typesense: CashflowScheduleController['typesense'] = () => {
    const prefix = `cashflowSchedule.typesense`
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
  const refreshTypesenseFor: CashflowScheduleController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'cashflowSchedule',
      id: resolvedId,
      endpoint: 'cashflowSchedule.typesense.resource',
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
