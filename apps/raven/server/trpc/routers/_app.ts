import { t } from '@schema/server/trpc/context'
import { generatedRouters } from './generated'
import { apiRouter, dbRouter } from './api'
export const appRouter = t.router({
  ...generatedRouters,
  db: dbRouter,
  api: apiRouter,
})

export type AppRouter = typeof appRouter
