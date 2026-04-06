import { t } from '@schema/server/trpc/context'
import { adminRouter } from './admin'
import { accountRouter } from './account'
import { apiAttemptRouter } from './apiAttempt'
import { apiRouter, dbRouter } from './api'
import { categoryRouter } from './category'
import { clarificationTaskRouter } from './clarificationtask'
import { classificationRuleRouter } from './classificationrule'
import { financialSpaceRouter } from './financialspace'
import { merchantRouter } from './merchant'
import { monthlySnapshotRouter } from './monthlysnapshot'
import { statementImportRouter } from './statementimport'
import { statementRowRouter } from './statementrow'
import { transactionRouter } from './transaction'
import { userRouter } from './user'

export const appRouter = t.router({
  admin: adminRouter,
  apiAttempt: apiAttemptRouter,
  account: accountRouter,
  category: categoryRouter,
  clarificationTask: clarificationTaskRouter,
  classificationRule: classificationRuleRouter,
  financialSpace: financialSpaceRouter,
  merchant: merchantRouter,
  monthlySnapshot: monthlySnapshotRouter,
  statementImport: statementImportRouter,
  statementRow: statementRowRouter,
  transaction: transactionRouter,
  user: userRouter,
  db: dbRouter,
  api: apiRouter,
})

export type AppRouter = typeof appRouter
