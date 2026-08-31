import { t } from '@schema/server/trpc/context';
import { statementTransactionMatchRouter as generatedStatementTransactionMatchRouter } from './generated/statementtransactionmatch';

const customStatementTransactionMatchRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementTransactionMatchRouter = t.mergeRouters(generatedStatementTransactionMatchRouter, customStatementTransactionMatchRouter);
export type StatementTransactionMatchRouter = typeof statementTransactionMatchRouter;
