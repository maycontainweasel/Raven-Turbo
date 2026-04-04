import { t } from '@schema/server/trpc/context';
import { accountRouter as generatedAccountRouter } from './generated/account';

const customAccountRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const accountRouter = t.mergeRouters(generatedAccountRouter, customAccountRouter);
export type AccountRouter = typeof accountRouter;
