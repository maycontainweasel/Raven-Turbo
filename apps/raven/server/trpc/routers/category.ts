import { t } from '@schema/server/trpc/context';
import { categoryRouter as generatedCategoryRouter } from './generated/category';

const customCategoryRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const categoryRouter = t.mergeRouters(generatedCategoryRouter, customCategoryRouter);
export type CategoryRouter = typeof categoryRouter;
