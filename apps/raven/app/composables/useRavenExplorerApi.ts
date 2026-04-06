export function useRavenExplorerApi() {
  const { $api } = useNuxtApp() as any

  return {
    listEnvironments: async () => {
      return await $api.financialSpace.list.query()
    },
    getEnvironmentExplorer: async (spaceKey: string) => {
      return await $api.financialSpace.explorer.query({ spaceKey })
    },
    getAccountExplorer: async (spaceKey: string, accountKey: string) => {
      return await $api.account.explorer.query({ spaceKey, accountKey })
    },
    getAccountMonth: async (spaceKey: string, accountKey: string, month: string) => {
      return await $api.account.month.query({ spaceKey, accountKey, month })
    },
    getTransactionDetail: async (transactionId: string) => {
      return await $api.transaction.detail.query({ transactionId })
    },
  }
}
