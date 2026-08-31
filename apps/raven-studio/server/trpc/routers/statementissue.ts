import { t } from '@schema/server/trpc/context';
import { statementIssueRouter as generatedStatementIssueRouter } from './generated/statementissue';

const customStatementIssueRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementIssueRouter = t.mergeRouters(generatedStatementIssueRouter, customStatementIssueRouter);
export type StatementIssueRouter = typeof statementIssueRouter;
