import { t } from '@schema/server/trpc/context';
import { statementRowRouter as generatedStatementRowRouter } from './generated/statementrow';

const customStatementRowRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementRowRouter = t.mergeRouters(generatedStatementRowRouter, customStatementRowRouter);
export type StatementRowRouter = typeof statementRowRouter;
