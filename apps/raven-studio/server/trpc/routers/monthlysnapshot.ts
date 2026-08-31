import { t } from '@schema/server/trpc/context';
import { monthlySnapshotRouter as generatedMonthlySnapshotRouter } from './generated/monthlysnapshot';

const customMonthlySnapshotRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const monthlySnapshotRouter = t.mergeRouters(generatedMonthlySnapshotRouter, customMonthlySnapshotRouter);
export type MonthlySnapshotRouter = typeof monthlySnapshotRouter;
