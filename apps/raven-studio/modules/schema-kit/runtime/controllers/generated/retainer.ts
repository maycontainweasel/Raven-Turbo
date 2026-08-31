import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { Retainer, RetainerId, RetainerIdSubId } from '@schema/types'
type RetainerDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type RetainerCreateInput = Pick<Retainer, 'key' | 'client' | 'title' | 'type' | 'status' | 'billingCadence' | 'currency' | 'costCadence' | 'recommendedAction'> & Partial<Omit<Retainer, 'id'>>

export type RetainerUpdateInput = Partial<Omit<Retainer, 'id'>>
export type RetainerRecordId = NonNullable<Retainer['id']> | RetainerId
export type RetainerIdInput = ControllerIdInput<RetainerIdSubId, RetainerRecordId, Retainer>

export interface RetainerController {
  // Create a new retainer record.
  create: (payload: RetainerCreateInput, options?: ApiOptions) => Promise<Retainer | null>
  // Create multiple retainer records in sequence.
  createMany: (payloads: RetainerCreateInput[], options?: ApiOptions) => Promise<(Retainer | null)[]>
  // Update a retainer by id (record object or sub-id).
  update: (id: RetainerIdInput, payload: RetainerUpdateInput, options?: ApiOptions) => Promise<Retainer | null>
  // Update multiple retainer records in sequence.
  updateMany: (
    items: Array<{ id: RetainerIdInput; payload: RetainerUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(Retainer | null)[]>
  // Delete a retainer by id (record object or sub-id).
  delete: (id: RetainerIdInput, options?: ApiOptions) => Promise<Retainer | null>
  // Delete multiple retainer records in sequence.
  deleteMany: (ids: RetainerIdInput[], options?: ApiOptions) => Promise<(Retainer | null)[]>
  // Fetch a resource view/function for the retainer.
  get: (id: RetainerIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: RetainerIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: RetainerIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: RetainerIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: RetainerIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: RetainerIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: RetainerIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: RetainerIdInput, options?: ApiOptions) => Promise<any>
  get: (id: RetainerIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: RetainerIdInput,
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
  attach: (id: RetainerIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: RetainerIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: RetainerIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: RetainerIdInput, options?: ApiOptions) => Promise<RetainerDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<RetainerDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<RetainerDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type RetainerControllerOverride = ControllerOverride<RetainerController>

export function createGeneratedRetainerController(): RetainerController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: RetainerIdInput) => crud.resolveRecordSubId<RetainerIdSubId>(value)

  // Create a retainer via the TRPC endpoint.
  const create: RetainerController['create'] = async (payload, options) => {
    return await $process<RetainerCreateInput, Retainer>('retainer.create', payload, options)
  }

  // Create multiple retainer records in sequence.
  const createMany: RetainerController['createMany'] = async (payloads, options) => {
    const results: Array<Retainer | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a retainer via the TRPC endpoint.
  const update: RetainerController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Retainer update requires a valid id')
    return await $process<{ id: RetainerIdSubId; payload: RetainerUpdateInput }, Retainer>(
      'retainer.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple retainer records in sequence.
  const updateMany: RetainerController['updateMany'] = async (items, options) => {
    const results: Array<Retainer | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a retainer via the TRPC endpoint.
  const del: RetainerController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Retainer delete requires a valid id')
    return await $process<{ id: RetainerIdSubId }, Retainer>('retainer.delete', { id: resolvedId }, options)
  }

  // Delete multiple retainer records in sequence.
  const deleteMany: RetainerController['deleteMany'] = async (ids, options) => {
    const results: Array<Retainer | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a retainer.
  const get: RetainerController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Retainer get requires a valid id')
    if (!resourceKey) throw new Error('Retainer get requires a resource key')
    return await $process('retainer.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: RetainerController['taxonomy'] = (key: string) => {
    const prefix = `retainer.${key}`
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

  const subtable: RetainerController['subtable'] = (key: string) => {
    const prefix = `retainer.subtables.${key}`
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

  const relation: RetainerController['relation'] = (key: string) => {
    const prefix = `retainer.relations.${key}`
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
  const typesense: RetainerController['typesense'] = () => {
    const prefix = `retainer.typesense`
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
  const refreshTypesenseFor: RetainerController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'retainer',
      id: resolvedId,
      endpoint: 'retainer.typesense.resource',
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
