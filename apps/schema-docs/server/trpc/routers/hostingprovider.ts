import { t } from '@schema/server/trpc/context';
import { hostingProviderRouter as generatedHostingProviderRouter } from './generated/hostingprovider';

const customHostingProviderRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const hostingProviderRouter = t.mergeRouters(generatedHostingProviderRouter, customHostingProviderRouter);
export type HostingProviderRouter = typeof hostingProviderRouter;
