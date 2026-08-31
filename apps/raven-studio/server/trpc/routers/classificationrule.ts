import { t } from '@schema/server/trpc/context';
import { classificationRuleRouter as generatedClassificationRuleRouter } from './generated/classificationrule';

const customClassificationRuleRouter = t.router({
  // Add or override endpoints here. Example:
  // exampleEndpoint: t.procedure.query(async ({ ctx }) => ctx.db.select('...')),
});

export const classificationRuleRouter = t.mergeRouters(generatedClassificationRuleRouter, customClassificationRuleRouter);
export type ClassificationRuleRouter = typeof classificationRuleRouter;
