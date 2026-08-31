import { t } from '@schema/server/trpc/context';
import { statementReconciliationEventRouter as generatedStatementReconciliationEventRouter } from './generated/statementreconciliationevent';

const customStatementReconciliationEventRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementReconciliationEventRouter = t.mergeRouters(generatedStatementReconciliationEventRouter, customStatementReconciliationEventRouter);
export type StatementReconciliationEventRouter = typeof statementReconciliationEventRouter;
