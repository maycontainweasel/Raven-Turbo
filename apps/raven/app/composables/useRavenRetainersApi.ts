export function useRavenRetainersApi() {
  const { $api } = useNuxtApp() as any

  return {
    getDashboard: async () => {
      return await $api.retainer.dashboard.query()
    },
  }
}
