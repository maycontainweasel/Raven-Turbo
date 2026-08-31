import { t } from '@schema/server/trpc/context';
import { statementRowComponentRouter as generatedStatementRowComponentRouter } from './generated/statementrowcomponent';

const customStatementRowComponentRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementRowComponentRouter = t.mergeRouters(generatedStatementRowComponentRouter, customStatementRowComponentRouter);
export type StatementRowComponentRouter = typeof statementRowComponentRouter;
