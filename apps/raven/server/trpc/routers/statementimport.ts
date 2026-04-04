import { t } from '@schema/server/trpc/context';
import { statementImportRouter as generatedStatementImportRouter } from './generated/statementimport';

const customStatementImportRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementImportRouter = t.mergeRouters(generatedStatementImportRouter, customStatementImportRouter);
export type StatementImportRouter = typeof statementImportRouter;
