import { t } from '@schema/server/trpc/context';
import { transactionRouter as generatedTransactionRouter } from './generated/transaction';

const customTransactionRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const transactionRouter = t.mergeRouters(generatedTransactionRouter, customTransactionRouter);
export type TransactionRouter = typeof transactionRouter;
