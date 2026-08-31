import { t } from '@schema/server/trpc/context';
import { retainerRouter as generatedRetainerRouter } from './generated/retainer';

const customRetainerRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const retainerRouter = t.mergeRouters(generatedRetainerRouter, customRetainerRouter);
export type RetainerRouter = typeof retainerRouter;
