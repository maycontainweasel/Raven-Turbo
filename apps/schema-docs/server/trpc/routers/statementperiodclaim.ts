import { t } from '@schema/server/trpc/context';
import { statementPeriodClaimRouter as generatedStatementPeriodClaimRouter } from './generated/statementperiodclaim';

const customStatementPeriodClaimRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementPeriodClaimRouter = t.mergeRouters(generatedStatementPeriodClaimRouter, customStatementPeriodClaimRouter);
export type StatementPeriodClaimRouter = typeof statementPeriodClaimRouter;
