import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { Client, ClientId, ClientIdSubId } from '@schema/types'
type ClientDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type ClientCreateInput = Pick<Client, 'key' | 'name' | 'status'> & Partial<Omit<Client, 'id'>>

export type ClientUpdateInput = Partial<Omit<Client, 'id'>>
export type ClientRecordId = NonNullable<Client['id']> | ClientId
export type ClientIdInput = ControllerIdInput<ClientIdSubId, ClientRecordId, Client>

export interface ClientController {
  // Create a new client record.
  create: (payload: ClientCreateInput, options?: ApiOptions) => Promise<Client | null>
  // Create multiple client records in sequence.
  createMany: (payloads: ClientCreateInput[], options?: ApiOptions) => Promise<(Client | null)[]>
  // Update a client by id (record object or sub-id).
  update: (id: ClientIdInput, payload: ClientUpdateInput, options?: ApiOptions) => Promise<Client | null>
  // Update multiple client records in sequence.
  updateMany: (
    items: Array<{ id: ClientIdInput; payload: ClientUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(Client | null)[]>
  // Delete a client by id (record object or sub-id).
  delete: (id: ClientIdInput, options?: ApiOptions) => Promise<Client | null>
  // Delete multiple client records in sequence.
  deleteMany: (ids: ClientIdInput[], options?: ApiOptions) => Promise<(Client | null)[]>
  // Fetch a resource view/function for the client.
  get: (id: ClientIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: ClientIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: ClientIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: ClientIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: ClientIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: ClientIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: ClientIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: ClientIdInput, options?: ApiOptions) => Promise<any>
  get: (id: ClientIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: ClientIdInput,
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
  attach: (id: ClientIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: ClientIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: ClientIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: ClientIdInput, options?: ApiOptions) => Promise<ClientDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<ClientDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<ClientDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type ClientControllerOverride = ControllerOverride<ClientController>

export function createGeneratedClientController(): ClientController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: ClientIdInput) => crud.resolveRecordSubId<ClientIdSubId>(value)

  // Create a client via the TRPC endpoint.
  const create: ClientController['create'] = async (payload, options) => {
    return await $process<ClientCreateInput, Client>('client.create', payload, options)
  }

  // Create multiple client records in sequence.
  const createMany: ClientController['createMany'] = async (payloads, options) => {
    const results: Array<Client | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a client via the TRPC endpoint.
  const update: ClientController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Client update requires a valid id')
    return await $process<{ id: ClientIdSubId; payload: ClientUpdateInput }, Client>(
      'client.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple client records in sequence.
  const updateMany: ClientController['updateMany'] = async (items, options) => {
    const results: Array<Client | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a client via the TRPC endpoint.
  const del: ClientController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Client delete requires a valid id')
    return await $process<{ id: ClientIdSubId }, Client>('client.delete', { id: resolvedId }, options)
  }

  // Delete multiple client records in sequence.
  const deleteMany: ClientController['deleteMany'] = async (ids, options) => {
    const results: Array<Client | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a client.
  const get: ClientController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('Client get requires a valid id')
    if (!resourceKey) throw new Error('Client get requires a resource key')
    return await $process('client.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: ClientController['taxonomy'] = (key: string) => {
    const prefix = `client.${key}`
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

  const subtable: ClientController['subtable'] = (key: string) => {
    const prefix = `client.subtables.${key}`
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

  const relation: ClientController['relation'] = (key: string) => {
    const prefix = `client.relations.${key}`
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
  const typesense: ClientController['typesense'] = () => {
    const prefix = `client.typesense`
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
  const refreshTypesenseFor: ClientController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'client',
      id: resolvedId,
      endpoint: 'client.typesense.resource',
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
