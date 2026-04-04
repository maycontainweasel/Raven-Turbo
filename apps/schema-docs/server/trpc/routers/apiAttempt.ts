import { t } from '@schema/server/trpc/context';
import { apiAttemptRouter as generatedApiAttemptRouter } from './generated/apiAttempt';

const customApiAttemptRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const apiAttemptRouter = t.mergeRouters(generatedApiAttemptRouter, customApiAttemptRouter);
export type ApiAttemptRouter = typeof apiAttemptRouter;
