import { t } from "@schema/server/trpc/context";
import { adminRouter } from "./admin";
import { accountRouter } from "./account";
import { accountControlRouter } from "./account-control";
import { apiAttemptRouter } from "./apiAttempt";
import { apiRouter, dbRouter } from "./api";
import { categoryRouter } from "./category";
import { clarificationTaskRouter } from "./clarificationtask";
import { classificationRuleRouter } from "./classificationrule";
import { clientRouter } from "./client";
import { financialSpaceRouter } from "./financialspace";
import { financialAnalyticsRouter } from "./financial-analytics";
import { hostingProviderRouter } from "./hostingprovider";
import { merchantRouter } from "./merchant";
import { monthlySnapshotRouter } from "./monthlysnapshot";
import { retainerRouter } from "./retainer";
import { statementImportRouter } from "./statementimport";
import { statementIssueRouter } from "./statementissue";
import { statementRowRouter } from "./statementrow";
import { statementRowComponentRouter } from "./statementrowcomponent";
import { statementTruthRouter } from "./statement-truth";
import { taxCategoryRouter } from "./taxcategory";
import { transactionRouter } from "./transaction";
import { transactionPurposeRouter } from "./transactionpurpose";
import { transactionPurposeAssignmentRouter } from "./transactionpurposeassignment";
import { transactionTaxDeclarationRouter } from "./transactiontaxdeclaration";
import { userRouter } from "./user";

export const appRouter = t.router({
  admin: adminRouter,
  apiAttempt: apiAttemptRouter,
  account: accountRouter,
  accountControl: accountControlRouter,
  category: categoryRouter,
  clarificationTask: clarificationTaskRouter,
  classificationRule: classificationRuleRouter,
  client: clientRouter,
  financialSpace: financialSpaceRouter,
  financialAnalytics: financialAnalyticsRouter,
  hostingProvider: hostingProviderRouter,
  merchant: merchantRouter,
  monthlySnapshot: monthlySnapshotRouter,
  retainer: retainerRouter,
  statementImport: statementImportRouter,
  statementIssue: statementIssueRouter,
  statementRow: statementRowRouter,
  statementRowComponent: statementRowComponentRouter,
  statementTruth: statementTruthRouter,
  taxCategory: taxCategoryRouter,
  transaction: transactionRouter,
  transactionPurpose: transactionPurposeRouter,
  transactionPurposeAssignment: transactionPurposeAssignmentRouter,
  transactionTaxDeclaration: transactionTaxDeclarationRouter,
  user: userRouter,
  db: dbRouter,
  api: apiRouter,
});

export type AppRouter = typeof appRouter;
