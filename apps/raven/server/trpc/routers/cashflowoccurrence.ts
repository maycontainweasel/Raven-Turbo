import { t } from '@schema/server/trpc/context';
import { cashflowOccurrenceRouter as generatedCashflowOccurrenceRouter } from './generated/cashflowoccurrence';

const customCashflowOccurrenceRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const cashflowOccurrenceRouter = t.mergeRouters(generatedCashflowOccurrenceRouter, customCashflowOccurrenceRouter);
export type CashflowOccurrenceRouter = typeof cashflowOccurrenceRouter;
