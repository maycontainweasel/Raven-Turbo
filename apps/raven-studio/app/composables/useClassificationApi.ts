export type FinancialSpaceOption = {
  id: string
  key: string
  name: string
  spaceType: string
  currency: string
}

export type MerchantOption = {
  id: string
  key: string
  name: string
  normalizedName?: string | null
  notes?: string | null
  spaceKey: string
}

export type CategoryOption = {
  id: string
  key: string
  name: string
  categoryKind: string
  active?: boolean
  notes?: string | null
  spaceKey: string
  parentKey?: string | null
  parentName?: string | null
}

export type TaxCategoryOption = {
  id: string
  key: string
  name: string
  active?: boolean
  notes?: string | null
  spaceKey: string
  parentKey?: string | null
  parentName?: string | null
}

export type PurposeOption = {
  id: string
  key: string
  name: string
  description?: string | null
  purposeKind: string
  occurrencePattern: string
  aliases?: string[] | null
  spaceKey: string
  merchantKey?: string | null
  categoryKey?: string | null
}

export type ClientOption = {
  id: string
  key: string
  name: string
  businessName?: string | null
  status: string
}

export type ClassificationOptions = {
  spaces: FinancialSpaceOption[]
  merchants: MerchantOption[]
  categories: CategoryOption[]
  taxCategories: TaxCategoryOption[]
  purposes: PurposeOption[]
  clients: ClientOption[]
  tags: string[]
}

export type EffectiveTransactionLens = {
  transactionId: string
  normal: {
    description: string
    categoryKey?: string | null
    categoryName?: string | null
  }
  tax: {
    hasOverride: boolean
    description: string
    categoryKey?: string | null
    categoryName?: string | null
    categorySource: 'normal' | 'tax'
    declaration: {
      id: string
      revision: number
      state: string
      taxDescription?: string | null
      evidenceStatus: 'not_assessed' | 'missing' | 'partial' | 'available' | 'not_required'
      taxCategoryKey?: string | null
      taxCategoryName?: string | null
      notes?: string | null
      recordedAt: string
      reviewedAt?: string | null
    } | null
  }
}

export type TaxDeclarationInput = {
  transactionId: string
  taxCategoryKey?: string
  taxDescription?: string
  evidenceStatus?: 'not_assessed' | 'missing' | 'partial' | 'available' | 'not_required'
  notes?: string
}

export type CurrentClassification = {
  transaction: {
    id: string
    spaceKey: string
    merchantKey?: string | null
    categoryKey?: string | null
  } | null
  assignment: {
    id: string
    revision: number
    state: string
    isCurrent: boolean
    assignmentSource: string
    confidence?: number | null
    occurrenceLabel?: string | null
    tags?: string[] | null
    clientKey?: string | null
    clientName?: string | null
    notes?: string | null
    recordedAt: string
    reviewedAt?: string | null
    purposeKey: string
    purposeName: string
    purposeDescription?: string | null
    purposeKind: string
    occurrencePattern: string
  } | null
}

export type ClassificationAssignmentInput = {
  transactionId: string
  purposeKey: string
  merchantKey?: string
  categoryKey?: string
  clientKey?: string
  occurrenceLabel?: string
  tags?: string[]
  notes?: string
}

export type MerchantDirectoryRow = MerchantOption & {
  active: boolean
  spaceName: string
  spaceCurrency: string
  transactionCount: number
  totals: MoneyLedgerTotal[]
}

export type MoneyLedgerTotal = {
  currency: string
  transactionCount: number
  inflow: number
  outflow: number
  net: number
  activeMonthCount: number
  averageMonthlyInflow: number
  averageMonthlyOutflow: number
}

export type MerchantDetail = {
  merchant: MerchantDirectoryRow | null
  totals: MoneyLedgerTotal[]
  months: Array<MoneyLedgerTotal & { month: string }>
  transactions: Array<{
    id: string
    key: string
    postedAt: string
    description: string
    amount: number
    currency: string
    direction: string
    flowDirection?: string | null
    status: string
    accountKey?: string | null
    accountName?: string | null
    categoryName?: string | null
    purpose?: {
      purposeName?: string | null
      occurrenceLabel?: string | null
      tags?: string[] | null
    } | null
  }>
}

export type PurposeDirectoryRow = PurposeOption & {
  active: boolean
  spaceName: string
  merchantName?: string | null
  categoryName?: string | null
  assignmentCount: number
  notes?: string | null
}

export function useClassificationApi() {
  const { $api } = useNuxtApp() as any
  const { $processAs } = useApiProcess()

  return {
    getOptions: (): Promise<ClassificationOptions> =>
      $api.transactionPurposeAssignment.options.query(),
    getCurrent: (transactionId: string): Promise<CurrentClassification> =>
      $api.transactionPurposeAssignment.current.query({ transactionId }),
    getEffectiveLenses: (transactionIds: string[]): Promise<EffectiveTransactionLens[]> =>
      $api.transactionTaxDeclaration.effective.query({ transactionIds }),
    getTaxCurrent: (transactionId: string): Promise<EffectiveTransactionLens | null> =>
      $api.transactionTaxDeclaration.current.query({ transactionId }),
    assign: (payload: ClassificationAssignmentInput) =>
      $processAs<{ assignment: unknown; transaction: unknown }>()(
        'transactionPurposeAssignment.assign',
        payload,
        { method: 'mutate', authority: 'source' },
      ),
    clear: (transactionId: string) =>
      $processAs<{ previous: unknown; transaction: unknown }>()(
        'transactionPurposeAssignment.clear',
        { transactionId },
        { method: 'mutate', authority: 'source' },
      ),
    saveTaxDeclaration: (payload: TaxDeclarationInput) =>
      $processAs<unknown>()('transactionTaxDeclaration.save', payload, { method: 'mutate', authority: 'source' }),
    inheritNormalTaxMeaning: (transactionId: string) =>
      $processAs<unknown>()('transactionTaxDeclaration.inherit', { transactionId }, { method: 'mutate', authority: 'source' }),
    listMerchants: (): Promise<MerchantDirectoryRow[]> => $api.merchant.list.query(),
    getMerchant: (spaceKey: string, merchantKey: string): Promise<MerchantDetail> =>
      $api.merchant.detail.query({ spaceKey, merchantKey, limit: 300 }),
    listPurposes: (): Promise<PurposeDirectoryRow[]> => $api.transactionPurpose.list.query(),
    listCategories: (): Promise<CategoryOption[]> => $api.category.list.query(),
    listTaxCategories: (): Promise<TaxCategoryOption[]> => $api.taxCategory.list.query(),
    createMerchant: (payload: {
      space: string
      key: string
      name: string
      normalizedName?: string
      active: boolean
      notes?: string
    }) => $processAs<MerchantOption>()('merchant.create', payload, { method: 'mutate', authority: 'source' }),
    createCategory: (payload: {
      space: string
      key: string
      name: string
      categoryKind: string
      parentCategory?: unknown
      active: boolean
      notes?: string
    }) => $processAs<CategoryOption>()('category.create', payload, { method: 'mutate', authority: 'source' }),
    createTaxCategory: (payload: {
      space: string
      key: string
      name: string
      parentTaxCategory?: unknown
      active: boolean
      notes?: string
    }) => $processAs<TaxCategoryOption>()('taxCategory.create', payload, { method: 'mutate', authority: 'source' }),
    createPurpose: (payload: {
      space: string
      key: string
      name: string
      description?: string
      purposeKind: string
      occurrencePattern: string
      defaultMerchant?: unknown
      defaultCategory?: unknown
      aliases?: string[]
      active: boolean
      notes?: string
    }) => $processAs<PurposeOption>()('transactionPurpose.create', payload, { method: 'mutate', authority: 'source' }),
  }
}
