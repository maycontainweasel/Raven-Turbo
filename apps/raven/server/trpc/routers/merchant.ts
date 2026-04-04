import { t } from '@schema/server/trpc/context';
import { merchantRouter as generatedMerchantRouter } from './generated/merchant';

const customMerchantRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const merchantRouter = t.mergeRouters(generatedMerchantRouter, customMerchantRouter);
export type MerchantRouter = typeof merchantRouter;
