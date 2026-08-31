import { t } from '@schema/server/trpc/context';
import { statementReconciliationRouter as generatedStatementReconciliationRouter } from './generated/statementreconciliation';

const customStatementReconciliationRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementReconciliationRouter = t.mergeRouters(generatedStatementReconciliationRouter, customStatementReconciliationRouter);
export type StatementReconciliationRouter = typeof statementReconciliationRouter;
