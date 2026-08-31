import { t } from '@schema/server/trpc/context';
import { statementSourceClaimRouter as generatedStatementSourceClaimRouter } from './generated/statementsourceclaim';

const customStatementSourceClaimRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementSourceClaimRouter = t.mergeRouters(generatedStatementSourceClaimRouter, customStatementSourceClaimRouter);
export type StatementSourceClaimRouter = typeof statementSourceClaimRouter;
