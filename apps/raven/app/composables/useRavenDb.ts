type RavenQueryStatement<T = unknown> = {
  status: 'OK' | 'ERR'
  result: T
  detail?: string
  description?: string
  information?: string
  time?: string
  type?: string | null
}

export async function queryRavenDb(query: string, vars: Record<string, unknown> = {}) {
  const { $api } = useNuxtApp() as any

  const response = await $api.db.query.mutate({
    data: {
      query,
      vars,
    },
  })

  return response as RavenQueryStatement[]
}

export function statementResult<T>(response: RavenQueryStatement[], index: number) {
  const statement = response[index]

  if (!statement) {
    throw new Error(`Missing Raven query statement at index ${index}`)
  }

  if (statement.status !== 'OK') {
    const detail = statement.detail || statement.description || statement.information || 'Unknown query error'
    throw new Error(detail)
  }

  return statement.result as T
}
