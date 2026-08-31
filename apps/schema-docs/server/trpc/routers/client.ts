import { t } from '@schema/server/trpc/context';
import { clientRouter as generatedClientRouter } from './generated/client';

const customClientRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const clientRouter = t.mergeRouters(generatedClientRouter, customClientRouter);
export type ClientRouter = typeof clientRouter;
