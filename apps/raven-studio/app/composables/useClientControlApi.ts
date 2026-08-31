export type ClientDirectoryRow = {
  id: string
  key: string
  name: string
  businessName?: string | null
  contactPerson?: string | null
  email?: string | null
  phoneWhatsapp?: string | null
  websiteDomain?: string | null
  status: string
  relatedProjects?: string | null
  orbitClientId?: string | null
  notes?: string | null
  retainerCount: number
  activeRetainerCount: number
  monthlyRevenue: number
}

export type RetainerDashboardRow = {
  id: string
  key: string
  client?: string | null
  clientKey?: string | null
  clientName?: string | null
  title: string
  type: string
  status: string
  billingCadence: string
  amountCharged: number
  currency: string
  nextBillingDate?: string | null
  lastBilledDate?: string | null
  amountCollectedToDate: number
  monthlyRevenue: number
  monthlyCost: number
  monthlyProfit: number
  marginPercent?: number | null
  overdue: boolean
  upcoming: boolean
  reviewNeeded: boolean
  nextAction?: string | null
  notes?: string | null
}

export type RetainerDashboard = {
  clients: ClientDirectoryRow[]
  retainers: RetainerDashboardRow[]
  summary: {
    clientCount: number
    providerCount: number
    retainerCount: number
    activeRetainerCount: number
    hostingRetainerCount: number
    overdueCount: number
    upcomingBillingCount: number
    reviewNeededCount: number
    monthlyRevenue: number
    monthlyCost: number
    monthlyProfit: number
  }
}

export type ClientLedgerTransaction = {
  assignmentId: string
  transactionId: string
  transactionKey: string
  postedAt: string
  description: string
  amount: number
  currency: string
  direction: string
  flowDirection?: string | null
  status: string
  accountKey?: string | null
  accountName?: string | null
  merchantKey?: string | null
  merchantName?: string | null
  categoryName?: string | null
  purposeKey: string
  purposeName: string
  occurrenceLabel?: string | null
  tags?: string[] | null
  notes?: string | null
}

export type ClientLedgerDetail = {
  client: ClientDirectoryRow | null
  totals: Array<{
    currency: string
    inflow: number
    outflow: number
    net: number
    transactionCount: number
    activeMonthCount: number
    averageMonthlyInflow: number
  }>
  transactions: ClientLedgerTransaction[]
}

export type CreateClientInput = {
  key: string
  name: string
  businessName?: string
  contactPerson?: string
  email?: string
  phoneWhatsapp?: string
  websiteDomain?: string
  status: 'active' | 'paused' | 'inactive' | 'closed'
  relatedProjects?: string
  orbitClientId?: string
  notes?: string
}

export function useClientControlApi() {
  const { $api } = useNuxtApp() as any
  const { $processAs } = useApiProcess()

  return {
    listClients: (): Promise<ClientDirectoryRow[]> => $api.client.list.query(),
    getClientDetail: (clientKey: string): Promise<ClientLedgerDetail> =>
      $api.client.detail.query({ clientKey, limit: 300 }),
    getRetainerDashboard: (): Promise<RetainerDashboard> => $api.retainer.dashboard.query(),
    createClient: (payload: CreateClientInput) =>
      $processAs<ClientDirectoryRow>()('client.create', payload, {
        method: 'mutate',
        authority: 'source',
      }),
  }
}
