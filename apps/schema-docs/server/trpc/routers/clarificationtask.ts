import { t } from '@schema/server/trpc/context';
import { clarificationTaskRouter as generatedClarificationTaskRouter } from './generated/clarificationtask';

const customClarificationTaskRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const clarificationTaskRouter = t.mergeRouters(generatedClarificationTaskRouter, customClarificationTaskRouter);
export type ClarificationTaskRouter = typeof clarificationTaskRouter;
