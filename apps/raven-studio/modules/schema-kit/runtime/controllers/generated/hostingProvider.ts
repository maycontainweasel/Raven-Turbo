import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { HostingProvider, HostingProviderId, HostingProviderIdSubId } from '@schema/types'
type HostingProviderDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type HostingProviderCreateInput = Pick<HostingProvider, 'key' | 'name' | 'providerType' | 'billingCadence' | 'currency' | 'status'> & Partial<Omit<HostingProvider, 'id'>>

export type HostingProviderUpdateInput = Partial<Omit<HostingProvider, 'id'>>
export type HostingProviderRecordId = NonNullable<HostingProvider['id']> | HostingProviderId
export type HostingProviderIdInput = ControllerIdInput<HostingProviderIdSubId, HostingProviderRecordId, HostingProvider>

export interface HostingProviderController {
  // Create a new hostingProvider record.
  create: (payload: HostingProviderCreateInput, options?: ApiOptions) => Promise<HostingProvider | null>
  // Create multiple hostingProvider records in sequence.
  createMany: (payloads: HostingProviderCreateInput[], options?: ApiOptions) => Promise<(HostingProvider | null)[]>
  // Update a hostingProvider by id (record object or sub-id).
  update: (id: HostingProviderIdInput, payload: HostingProviderUpdateInput, options?: ApiOptions) => Promise<HostingProvider | null>
  // Update multiple hostingProvider records in sequence.
  updateMany: (
    items: Array<{ id: HostingProviderIdInput; payload: HostingProviderUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(HostingProvider | null)[]>
  // Delete a hostingProvider by id (record object or sub-id).
  delete: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<HostingProvider | null>
  // Delete multiple hostingProvider records in sequence.
  deleteMany: (ids: HostingProviderIdInput[], options?: ApiOptions) => Promise<(HostingProvider | null)[]>
  // Fetch a resource view/function for the hostingProvider.
  get: (id: HostingProviderIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: HostingProviderIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: HostingProviderIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: HostingProviderIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: HostingProviderIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<any>
  get: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: HostingProviderIdInput,
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
  attach: (id: HostingProviderIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: HostingProviderIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: HostingProviderIdInput, options?: ApiOptions) => Promise<HostingProviderDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<HostingProviderDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<HostingProviderDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type HostingProviderControllerOverride = ControllerOverride<HostingProviderController>

export function createGeneratedHostingProviderController(): HostingProviderController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: HostingProviderIdInput) => crud.resolveRecordSubId<HostingProviderIdSubId>(value)

  // Create a hostingProvider via the TRPC endpoint.
  const create: HostingProviderController['create'] = async (payload, options) => {
    return await $process<HostingProviderCreateInput, HostingProvider>('hostingProvider.create', payload, options)
  }

  // Create multiple hostingProvider records in sequence.
  const createMany: HostingProviderController['createMany'] = async (payloads, options) => {
    const results: Array<HostingProvider | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a hostingProvider via the TRPC endpoint.
  const update: HostingProviderController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('HostingProvider update requires a valid id')
    return await $process<{ id: HostingProviderIdSubId; payload: HostingProviderUpdateInput }, HostingProvider>(
      'hostingProvider.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple hostingProvider records in sequence.
  const updateMany: HostingProviderController['updateMany'] = async (items, options) => {
    const results: Array<HostingProvider | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a hostingProvider via the TRPC endpoint.
  const del: HostingProviderController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('HostingProvider delete requires a valid id')
    return await $process<{ id: HostingProviderIdSubId }, HostingProvider>('hostingProvider.delete', { id: resolvedId }, options)
  }

  // Delete multiple hostingProvider records in sequence.
  const deleteMany: HostingProviderController['deleteMany'] = async (ids, options) => {
    const results: Array<HostingProvider | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a hostingProvider.
  const get: HostingProviderController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('HostingProvider get requires a valid id')
    if (!resourceKey) throw new Error('HostingProvider get requires a resource key')
    return await $process('hostingProvider.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: HostingProviderController['taxonomy'] = (key: string) => {
    const prefix = `hostingProvider.${key}`
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

  const subtable: HostingProviderController['subtable'] = (key: string) => {
    const prefix = `hostingProvider.subtables.${key}`
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

  const relation: HostingProviderController['relation'] = (key: string) => {
    const prefix = `hostingProvider.relations.${key}`
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
  const typesense: HostingProviderController['typesense'] = () => {
    const prefix = `hostingProvider.typesense`
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
  const refreshTypesenseFor: HostingProviderController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'hostingProvider',
      id: resolvedId,
      endpoint: 'hostingProvider.typesense.resource',
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
