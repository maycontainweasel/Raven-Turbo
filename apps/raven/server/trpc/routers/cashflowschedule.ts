import { t } from '@schema/server/trpc/context';
import { cashflowScheduleRouter as generatedCashflowScheduleRouter } from './generated/cashflowschedule';

const customCashflowScheduleRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const cashflowScheduleRouter = t.mergeRouters(generatedCashflowScheduleRouter, customCashflowScheduleRouter);
export type CashflowScheduleRouter = typeof cashflowScheduleRouter;
