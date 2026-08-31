import { t } from '@schema/server/trpc/context';
import { accountBalanceSnapshotRouter as generatedAccountBalanceSnapshotRouter } from './generated/accountbalancesnapshot';

const customAccountBalanceSnapshotRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const accountBalanceSnapshotRouter = t.mergeRouters(generatedAccountBalanceSnapshotRouter, customAccountBalanceSnapshotRouter);
export type AccountBalanceSnapshotRouter = typeof accountBalanceSnapshotRouter;
