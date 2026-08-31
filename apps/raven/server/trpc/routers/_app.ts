import { t } from '@schema/server/trpc/context'
import { adminRouter } from './admin'
import { accountRouter } from './account'
import { apiAttemptRouter } from './apiAttempt'
import { apiRouter, dbRouter } from './api'
import { categoryRouter } from './category'
import { clarificationTaskRouter } from './clarificationtask'
import { classificationRuleRouter } from './classificationrule'
import { clientRouter } from './client'
import { financialSpaceRouter } from './financialspace'
import { hostingProviderRouter } from './hostingprovider'
import { merchantRouter } from './merchant'
import { monthlySnapshotRouter } from './monthlysnapshot'
import { retainerRouter } from './retainer'
import { statementImportRouter } from './statementimport'
import { statementRowRouter } from './statementrow'
import { transactionRouter } from './transaction'
import { transactionPurposeRouter } from './transactionpurpose'
import { transactionPurposeAssignmentRouter } from './transactionpurposeassignment'
import { userRouter } from './user'

export const appRouter = t.router({
  admin: adminRouter,
  apiAttempt: apiAttemptRouter,
  account: accountRouter,
  category: categoryRouter,
  clarificationTask: clarificationTaskRouter,
  classificationRule: classificationRuleRouter,
  client: clientRouter,
  financialSpace: financialSpaceRouter,
  hostingProvider: hostingProviderRouter,
  merchant: merchantRouter,
  monthlySnapshot: monthlySnapshotRouter,
  retainer: retainerRouter,
  statementImport: statementImportRouter,
  statementRow: statementRowRouter,
  transaction: transactionRouter,
  transactionPurpose: transactionPurposeRouter,
  transactionPurposeAssignment: transactionPurposeAssignmentRouter,
  user: userRouter,
  db: dbRouter,
  api: apiRouter,
})

export type AppRouter = typeof appRouter
