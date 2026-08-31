import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { TaxCategory, TaxCategoryId, TaxCategoryIdSubId } from '@schema/types'
type TaxCategoryDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type TaxCategoryCreateInput = Pick<TaxCategory, 'space' | 'key' | 'name' | 'active'> & Partial<Omit<TaxCategory, 'id'>>

export type TaxCategoryUpdateInput = Partial<Omit<TaxCategory, 'id'>>
export type TaxCategoryRecordId = NonNullable<TaxCategory['id']> | TaxCategoryId
export type TaxCategoryIdInput = ControllerIdInput<TaxCategoryIdSubId, TaxCategoryRecordId, TaxCategory>

export interface TaxCategoryController {
  // Create a new taxCategory record.
  create: (payload: TaxCategoryCreateInput, options?: ApiOptions) => Promise<TaxCategory | null>
  // Create multiple taxCategory records in sequence.
  createMany: (payloads: TaxCategoryCreateInput[], options?: ApiOptions) => Promise<(TaxCategory | null)[]>
  // Update a taxCategory by id (record object or sub-id).
  update: (id: TaxCategoryIdInput, payload: TaxCategoryUpdateInput, options?: ApiOptions) => Promise<TaxCategory | null>
  // Update multiple taxCategory records in sequence.
  updateMany: (
    items: Array<{ id: TaxCategoryIdInput; payload: TaxCategoryUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(TaxCategory | null)[]>
  // Delete a taxCategory by id (record object or sub-id).
  delete: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<TaxCategory | null>
  // Delete multiple taxCategory records in sequence.
  deleteMany: (ids: TaxCategoryIdInput[], options?: ApiOptions) => Promise<(TaxCategory | null)[]>
  // Fetch a resource view/function for the taxCategory.
  get: (id: TaxCategoryIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: TaxCategoryIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: TaxCategoryIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: TaxCategoryIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: TaxCategoryIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<any>
  get: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: TaxCategoryIdInput,
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
  attach: (id: TaxCategoryIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: TaxCategoryIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: TaxCategoryIdInput, options?: ApiOptions) => Promise<TaxCategoryDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TaxCategoryDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<TaxCategoryDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type TaxCategoryControllerOverride = ControllerOverride<TaxCategoryController>

export function createGeneratedTaxCategoryController(): TaxCategoryController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: TaxCategoryIdInput) => crud.resolveRecordSubId<TaxCategoryIdSubId>(value)

  // Create a taxCategory via the TRPC endpoint.
  const create: TaxCategoryController['create'] = async (payload, options) => {
    return await $process<TaxCategoryCreateInput, TaxCategory>('taxCategory.create', payload, options)
  }

  // Create multiple taxCategory records in sequence.
  const createMany: TaxCategoryController['createMany'] = async (payloads, options) => {
    const results: Array<TaxCategory | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a taxCategory via the TRPC endpoint.
  const update: TaxCategoryController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TaxCategory update requires a valid id')
    return await $process<{ id: TaxCategoryIdSubId; payload: TaxCategoryUpdateInput }, TaxCategory>(
      'taxCategory.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple taxCategory records in sequence.
  const updateMany: TaxCategoryController['updateMany'] = async (items, options) => {
    const results: Array<TaxCategory | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a taxCategory via the TRPC endpoint.
  const del: TaxCategoryController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TaxCategory delete requires a valid id')
    return await $process<{ id: TaxCategoryIdSubId }, TaxCategory>('taxCategory.delete', { id: resolvedId }, options)
  }

  // Delete multiple taxCategory records in sequence.
  const deleteMany: TaxCategoryController['deleteMany'] = async (ids, options) => {
    const results: Array<TaxCategory | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a taxCategory.
  const get: TaxCategoryController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('TaxCategory get requires a valid id')
    if (!resourceKey) throw new Error('TaxCategory get requires a resource key')
    return await $process('taxCategory.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: TaxCategoryController['taxonomy'] = (key: string) => {
    const prefix = `taxCategory.${key}`
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

  const subtable: TaxCategoryController['subtable'] = (key: string) => {
    const prefix = `taxCategory.subtables.${key}`
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

  const relation: TaxCategoryController['relation'] = (key: string) => {
    const prefix = `taxCategory.relations.${key}`
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
  const typesense: TaxCategoryController['typesense'] = () => {
    const prefix = `taxCategory.typesense`
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
  const refreshTypesenseFor: TaxCategoryController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'taxCategory',
      id: resolvedId,
      endpoint: 'taxCategory.typesense.resource',
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
