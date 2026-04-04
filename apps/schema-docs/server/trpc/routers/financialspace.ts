import { t } from '@schema/server/trpc/context';
import { financialSpaceRouter as generatedFinancialSpaceRouter } from './generated/financialspace';

const customFinancialSpaceRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const financialSpaceRouter = t.mergeRouters(generatedFinancialSpaceRouter, customFinancialSpaceRouter);
export type FinancialSpaceRouter = typeof financialSpaceRouter;
