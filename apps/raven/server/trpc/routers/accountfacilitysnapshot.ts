import { t } from '@schema/server/trpc/context';
import { accountFacilitySnapshotRouter as generatedAccountFacilitySnapshotRouter } from './generated/accountfacilitysnapshot';

const customAccountFacilitySnapshotRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const accountFacilitySnapshotRouter = t.mergeRouters(generatedAccountFacilitySnapshotRouter, customAccountFacilitySnapshotRouter);
export type AccountFacilitySnapshotRouter = typeof accountFacilitySnapshotRouter;
