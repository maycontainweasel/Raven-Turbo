type ClientPayload = {
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

export function useRavenClientsApi() {
  const { $api } = useNuxtApp() as any

  return {
    list: async () => {
      return await $api.client.list.query()
    },
    create: async (payload: ClientPayload) => {
      return await $api.client.create.mutate({ data: payload })
    },
    update: async (id: string, payload: Partial<ClientPayload>) => {
      return await $api.client.update.mutate({ data: { id, payload } })
    },
  }
}
