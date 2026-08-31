import { t } from '@schema/server/trpc/context';
import { transactionPurposeRouter as generatedTransactionPurposeRouter } from './generated/transactionpurpose';
import { surrealSelectMany } from './_surreal';

const customTransactionPurposeRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => {
    const [purposes, counts] = await Promise.all([
      surrealSelectMany<{
        id: string;
        key: string;
        name: string;
        description?: string | null;
        purposeKind: string;
        occurrencePattern: string;
        aliases?: string[] | null;
        active: boolean;
        notes?: string | null;
        spaceKey: string;
        spaceName: string;
        merchantKey?: string | null;
        merchantName?: string | null;
        categoryKey?: string | null;
        categoryName?: string | null;
      }>(ctx, `
        SELECT
          id, key, name, description, purposeKind, occurrencePattern, aliases, active, notes,
          space.key AS spaceKey,
          space.name AS spaceName,
          defaultMerchant.key AS merchantKey,
          defaultMerchant.name AS merchantName,
          defaultCategory.key AS categoryKey,
          defaultCategory.name AS categoryName
        FROM transactionPurpose
        ORDER BY active DESC, spaceName, name;
      `),
      surrealSelectMany<{ purposeKey: string; spaceKey: string; assignmentCount?: number | null }>(ctx, `
        SELECT purpose.key AS purposeKey, purpose.space.key AS spaceKey, count() AS assignmentCount
        FROM transactionPurposeAssignment
        WHERE isCurrent = true AND state = 'confirmed'
        GROUP BY purposeKey, spaceKey;
      `),
    ]);
    const countMap = new Map(counts.map(item => [`${item.spaceKey}:${item.purposeKey}`, Number(item.assignmentCount || 0)]));
    return purposes.map(purpose => ({
      ...purpose,
      assignmentCount: countMap.get(`${purpose.spaceKey}:${purpose.key}`) ?? 0,
    }));
  }),
});

export const transactionPurposeRouter = t.mergeRouters(generatedTransactionPurposeRouter, customTransactionPurposeRouter);
export type TransactionPurposeRouter = typeof transactionPurposeRouter;
