import { t } from '@schema/server/trpc/context';
import { transactionPurposeAssignmentRouter as generatedTransactionPurposeAssignmentRouter } from './generated/transactionpurposeassignment';

const customTransactionPurposeAssignmentRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const transactionPurposeAssignmentRouter = t.mergeRouters(generatedTransactionPurposeAssignmentRouter, customTransactionPurposeAssignmentRouter);
export type TransactionPurposeAssignmentRouter = typeof transactionPurposeAssignmentRouter;
