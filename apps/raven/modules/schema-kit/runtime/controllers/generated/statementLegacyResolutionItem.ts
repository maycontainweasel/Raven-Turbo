import { useCRUD, type ApiOptions } from '../../composables/useCRUD'
import type { StatementLegacyResolutionItem, StatementLegacyResolutionItemId, StatementLegacyResolutionItemIdSubId } from '@schema/types'
type StatementLegacyResolutionItemDocument = any;
type TypesenseCollectionSchema = any;
import type { ControllerIdInput, ControllerOverride } from '../_shared'

export type StatementLegacyResolutionItemCreateInput = Pick<StatementLegacyResolutionItem, 'space' | 'account' | 'statementLegacyResolution' | 'canonicalStatementImport' | 'legacyStatementImport' | 'key' | 'compatibilityClass' | 'activeLedgerOutcome' | 'canonicalComponentIds' | 'legacyTransactionIds' | 'itemEvidenceHash' | 'expectedClaimHash' | 'operation' | 'recordedAt'> & Partial<Omit<StatementLegacyResolutionItem, 'id'>>

export type StatementLegacyResolutionItemUpdateInput = Partial<Omit<StatementLegacyResolutionItem, 'id'>>
export type StatementLegacyResolutionItemRecordId = NonNullable<StatementLegacyResolutionItem['id']> | StatementLegacyResolutionItemId
export type StatementLegacyResolutionItemIdInput = ControllerIdInput<StatementLegacyResolutionItemIdSubId, StatementLegacyResolutionItemRecordId, StatementLegacyResolutionItem>

export interface StatementLegacyResolutionItemController {
  // Create a new statementLegacyResolutionItem record.
  create: (payload: StatementLegacyResolutionItemCreateInput, options?: ApiOptions) => Promise<StatementLegacyResolutionItem | null>
  // Create multiple statementLegacyResolutionItem records in sequence.
  createMany: (payloads: StatementLegacyResolutionItemCreateInput[], options?: ApiOptions) => Promise<(StatementLegacyResolutionItem | null)[]>
  // Update a statementLegacyResolutionItem by id (record object or sub-id).
  update: (id: StatementLegacyResolutionItemIdInput, payload: StatementLegacyResolutionItemUpdateInput, options?: ApiOptions) => Promise<StatementLegacyResolutionItem | null>
  // Update multiple statementLegacyResolutionItem records in sequence.
  updateMany: (
    items: Array<{ id: StatementLegacyResolutionItemIdInput; payload: StatementLegacyResolutionItemUpdateInput }>,
    options?: ApiOptions
  ) => Promise<(StatementLegacyResolutionItem | null)[]>
  // Delete a statementLegacyResolutionItem by id (record object or sub-id).
  delete: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<StatementLegacyResolutionItem | null>
  // Delete multiple statementLegacyResolutionItem records in sequence.
  deleteMany: (ids: StatementLegacyResolutionItemIdInput[], options?: ApiOptions) => Promise<(StatementLegacyResolutionItem | null)[]>
  // Fetch a resource view/function for the statementLegacyResolutionItem.
  get: (id: StatementLegacyResolutionItemIdInput, resourceKey: string, options?: ApiOptions) => Promise<any>
  // Taxonomy helper for this model.
  taxonomy: (key: string) => TaxonomyController
  // Subtable helper for this model.
  subtable: (key: string) => SubtableController
  // Relation helper for this model.
  relation: (key: string) => RelationController
  // Typesense helper for this model.
  typesense: () => TypesenseController
  // Refresh Typesense for a specific record id.
  refreshTypesenseFor: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<any>
}

export interface TaxonomyController {
  createTaxonomy: (payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  addTerm: (payload: any, options?: ApiOptions) => Promise<any>
  removeTerm: (term: any, options?: ApiOptions) => Promise<any>
  attach: (id: StatementLegacyResolutionItemIdInput, term: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementLegacyResolutionItemIdInput, term: any, options?: ApiOptions) => Promise<any>
  getTerms: (options?: ApiOptions) => Promise<any>
  getRecordTerms: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<any>
}

export interface SubtableController {
  create: (id: StatementLegacyResolutionItemIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  update: (id: StatementLegacyResolutionItemIdInput, payload: Record<string, any>, options?: ApiOptions) => Promise<any>
  delete: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<any>
  get: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<any>
  list: (
    id: StatementLegacyResolutionItemIdInput,
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
  attach: (id: StatementLegacyResolutionItemIdInput, target: any, options?: ApiOptions) => Promise<any>
  detach: (id: StatementLegacyResolutionItemIdInput, target: any, options?: ApiOptions) => Promise<any>
  list: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<any>
}

export interface TypesenseController {
  get: (id: StatementLegacyResolutionItemIdInput, options?: ApiOptions) => Promise<StatementLegacyResolutionItemDocument | null>
  list: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementLegacyResolutionItemDocument[]>
  refresh: (params?: { start?: number; limit?: number }, options?: ApiOptions) => Promise<StatementLegacyResolutionItemDocument[]>
  count: (options?: ApiOptions) => Promise<number>
  collection: (options?: ApiOptions) => Promise<TypesenseCollectionSchema | null>
}

export type StatementLegacyResolutionItemControllerOverride = ControllerOverride<StatementLegacyResolutionItemController>

export function createGeneratedStatementLegacyResolutionItemController(): StatementLegacyResolutionItemController {
  const crud = useCRUD()
  const { $process } = crud
  const resolveSubId = (value: StatementLegacyResolutionItemIdInput) => crud.resolveRecordSubId<StatementLegacyResolutionItemIdSubId>(value)

  // Create a statementLegacyResolutionItem via the TRPC endpoint.
  const create: StatementLegacyResolutionItemController['create'] = async (payload, options) => {
    return await $process<StatementLegacyResolutionItemCreateInput, StatementLegacyResolutionItem>('statementLegacyResolutionItem.create', payload, options)
  }

  // Create multiple statementLegacyResolutionItem records in sequence.
  const createMany: StatementLegacyResolutionItemController['createMany'] = async (payloads, options) => {
    const results: Array<StatementLegacyResolutionItem | null> = []
    for (const payload of payloads) {
      results.push(await create(payload, options))
    }
    return results
  }

  // Update a statementLegacyResolutionItem via the TRPC endpoint.
  const update: StatementLegacyResolutionItemController['update'] = async (id, payload, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolutionItem update requires a valid id')
    return await $process<{ id: StatementLegacyResolutionItemIdSubId; payload: StatementLegacyResolutionItemUpdateInput }, StatementLegacyResolutionItem>(
      'statementLegacyResolutionItem.update',
      { id: resolvedId, payload },
      options
    )
  }

  // Update multiple statementLegacyResolutionItem records in sequence.
  const updateMany: StatementLegacyResolutionItemController['updateMany'] = async (items, options) => {
    const results: Array<StatementLegacyResolutionItem | null> = []
    for (const item of items) {
      results.push(await update(item.id, item.payload, options))
    }
    return results
  }

  // Delete a statementLegacyResolutionItem via the TRPC endpoint.
  const del: StatementLegacyResolutionItemController['delete'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolutionItem delete requires a valid id')
    return await $process<{ id: StatementLegacyResolutionItemIdSubId }, StatementLegacyResolutionItem>('statementLegacyResolutionItem.delete', { id: resolvedId }, options)
  }

  // Delete multiple statementLegacyResolutionItem records in sequence.
  const deleteMany: StatementLegacyResolutionItemController['deleteMany'] = async (ids, options) => {
    const results: Array<StatementLegacyResolutionItem | null> = []
    for (const id of ids) {
      results.push(await del(id, options))
    }
    return results
  }

  // Fetch a resource view/function for a statementLegacyResolutionItem.
  const get: StatementLegacyResolutionItemController['get'] = async (id, resourceKey, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('StatementLegacyResolutionItem get requires a valid id')
    if (!resourceKey) throw new Error('StatementLegacyResolutionItem get requires a resource key')
    return await $process('statementLegacyResolutionItem.resource', { id: resolvedId, resource: resourceKey }, options)
  }

  const taxonomy: StatementLegacyResolutionItemController['taxonomy'] = (key: string) => {
    const prefix = `statementLegacyResolutionItem.${key}`
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

  const subtable: StatementLegacyResolutionItemController['subtable'] = (key: string) => {
    const prefix = `statementLegacyResolutionItem.subtables.${key}`
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

  const relation: StatementLegacyResolutionItemController['relation'] = (key: string) => {
    const prefix = `statementLegacyResolutionItem.relations.${key}`
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
  const typesense: StatementLegacyResolutionItemController['typesense'] = () => {
    const prefix = `statementLegacyResolutionItem.typesense`
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
  const refreshTypesenseFor: StatementLegacyResolutionItemController['refreshTypesenseFor'] = async (id, options) => {
    const resolvedId = resolveSubId(id)
    if (!resolvedId) throw new Error('refreshTypesenseFor requires a valid id')
    return crud.updateTypesenseForRecord({
      collectionId: 'statementLegacyResolutionItem',
      id: resolvedId,
      endpoint: 'statementLegacyResolutionItem.typesense.resource',
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
