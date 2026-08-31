import { t } from '@schema/server/trpc/context';
import { financialOperationRouter as generatedFinancialOperationRouter } from './generated/financialoperation';

const customFinancialOperationRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const financialOperationRouter = t.mergeRouters(generatedFinancialOperationRouter, customFinancialOperationRouter);
export type FinancialOperationRouter = typeof financialOperationRouter;
