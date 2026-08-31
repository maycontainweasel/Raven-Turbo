import { t } from '@schema/server/trpc/context';
import { transactionPurposeRouter as generatedTransactionPurposeRouter } from './generated/transactionpurpose';

const customTransactionPurposeRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const transactionPurposeRouter = t.mergeRouters(generatedTransactionPurposeRouter, customTransactionPurposeRouter);
export type TransactionPurposeRouter = typeof transactionPurposeRouter;
