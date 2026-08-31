import { t } from '@schema/server/trpc/context';
import { statementTransactionResolutionClaimRouter as generatedStatementTransactionResolutionClaimRouter } from './generated/statementtransactionresolutionclaim';

const customStatementTransactionResolutionClaimRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const statementTransactionResolutionClaimRouter = t.mergeRouters(generatedStatementTransactionResolutionClaimRouter, customStatementTransactionResolutionClaimRouter);
export type StatementTransactionResolutionClaimRouter = typeof statementTransactionResolutionClaimRouter;
