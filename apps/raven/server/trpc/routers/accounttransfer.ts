import { t } from '@schema/server/trpc/context';
import { accountTransferRouter as generatedAccountTransferRouter } from './generated/accounttransfer';

const customAccountTransferRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const accountTransferRouter = t.mergeRouters(generatedAccountTransferRouter, customAccountTransferRouter);
export type AccountTransferRouter = typeof accountTransferRouter;
