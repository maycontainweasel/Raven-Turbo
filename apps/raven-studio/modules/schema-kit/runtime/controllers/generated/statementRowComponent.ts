import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementRowComponent, StatementRowComponentId, StatementRowComponentIdSubId } from '@schema/types'
type StatementRowComponentDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementRowComponentCreateInput = Pick<StatementRowComponent, 'space' | 'account' | 'statementImport' | 'statementRow' | 'key' | 'componentKind' | 'componentRole' | 'description' | 'amountMinor' | 'currency' | 'sourceDirection' | 'sourceFlow' | 'balanceEffectMinor' | 'sourceChecksum' | 'sourceState' | 'commitOperation'> & Partial<Omit<StatementRowComponent, 'id'>>

export type StatementRowComponentUpdateInput = Partial<Omit<StatementRowComponent, 'id'>>
export type StatementRowComponentRecordId = NonNullable<StatementRowComponent['id']> | StatementRowComponentId
export type StatementRowComponentIdInput = ControllerIdInput<StatementRowComponentIdSubId, StatementRowComponentRecordId, StatementRowComponent>

export interface StatementRowComponentController {
  // Create a new statementRowComponent record.
  create: (payload: StatementRowComponentCreateInput, options?: ApiOptions) => Promise<StatementRowComponent | null>
  // Create multiple statementRowComponent records in sequence.
  createMany: (payloads: StatementRowComponentCreateInput[], options?: ApiOptions) => Promise<(StatementRowComponent | null)[]>
  // Update a statementRowComponent by id (record object or sub-id).
  update: (id: StatementRowComponentIdInput, payload: StatementRowComponentUpdateInput, options?: ApiOptions) => Promise<StatementRowComponent | null>
  // Update multiple statementRowComponent records in sequence.
  updateMany: (
    items: Array<{ id: StatementRowComponentIdInput; payload: StatementRowComponentUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementRowComponent | null)[]>
  // Delete a statementRowComponent by id (record object or sub-id).
  delete: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<StatementRowComponent | null>
  // Delete multiple statementRowComponent records in sequence.
  deleteMany: (ids: StatementRowComponentIdInput[], options?: ApiOptions) => Promise<(StatementRowComponent | null)[]>
  // Fetch a resource view/function for the statementRowComponent.
  get: (id: StatementRowComponentIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementRowComponentIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementRowComponentIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementRowComponentIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementRowComponentIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementRowComponentIdInput,
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
  attach: (id: StatementRowComponentIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementRowComponentIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementRowComponentIdInput, options?: ApiOptions) => Promise<StatementRowComponentDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementRowComponentDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementRowComponentDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementRowComponentControllerOverride = ControllerOverride<StatementRowComponentController>

export function createGeneratedStatementRowComponentController(): StatementRowComponentController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementRowComponentIdInput) => crud.resolveRecordSubId<StatementRowComponentIdSubId>(value)

  // Create a statementRowComponent via the TRPC endpoint.
  const create: StatementRowComponentController['create'] = async (payload, options) => {
    return await $process<StatementRowComponentCreateInput, StatementRowComponent>('statementRowComponent.create', payload, options)
  }

  // Create multiple statementRowComponent records in sequence.
  const createMany: StatementRowComponentController['createMany'] = async (payloads, options) => {
    const results: Array<StatementRowComponent | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementRowComponent via the TRPC endpoint.
  const update: StatementRowComponentController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementRowComponent update requires a valid id')
    return await $process<{ id: StatementRowComponentIdSubId; payload: StatementRowComponentUpdateInput }, StatementRowComponent>(
      'statementRowComponent.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementRowComponent records in sequence.
  const updateMany: StatementRowComponentController['updateMany'] = async (items, options) => {
    const results: Array<StatementRowComponent | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementRowComponent via the TRPC endpoint.
  const del: StatementRowComponentController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementRowComponent delete requires a valid id')
    return await $process<{ id: StatementRowComponentIdSubId }, StatementRowComponent>('statementRowComponent.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementRowComponent records in sequence.
  const deleteMany: StatementRowComponentController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementRowComponent | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementRowComponent.
  const get: StatementRowComponentController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementRowComponent get requires a valid id')
    if (!resourceKey) throw new Error('StatementRowComponent get requires a resource key')
    return await $process('statementRowComponent.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementRowComponentController['taxonomy'] = (key: string) => {
    const prefix = `statementRowComponent.${key}`
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

  const subtable: StatementRowComponentController['subtable'] = (key: string) => {
    const prefix = `statementRowComponent.subtables.${key}`
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

  const relation: StatementRowComponentController['relation'] = (key: string) => {
    const prefix = `statementRowComponent.relations.${key}`
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
  const typesense: StatementRowComponentController['typesense'] = () => {
    const prefix = `statementRowComponent.typesense`
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
  const refreshTypesenseFor: StatementRowComponentController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementRowComponent',
      id: resolvedId,
      endpoint: 'statementRowComponent.typesense.resource',
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
