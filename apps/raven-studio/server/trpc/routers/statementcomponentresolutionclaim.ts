import { t } from '@schema/server/trpc/context';
import { statementComponentResolutionClaimRouter as generatedStatementComponentResolutionClaimRouter } from './generated/statementcomponentresolutionclaim';

const customStatementComponentResolutionClaimRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementComponentResolutionClaimRouter = t.mergeRouters(generatedStatementComponentResolutionClaimRouter, customStatementComponentResolutionClaimRouter);
export type StatementComponentResolutionClaimRouter = typeof statementComponentResolutionClaimRouter;
