import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { financialSpaceRouter as generatedFinancialSpaceRouter } from './generated/financialspace';
import { surrealQuery, surrealSelectMany, surrealSelectOne } from './_surreal';

const SpaceKeyInput = z.object({
  spaceKey: z.string().min(1),
});

const customFinancialSpaceRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => {
    const spaces = await surrealSelectMany<{
      id: string;
      key: string;
      name: string;
      spaceType: string;
      currency: string;
      description?: string | null;
    }>(
      ctx,
      `
        SELECT id, key, name, spaceType, currency, description
        FROM financialSpace
        WHERE active = true
        ORDER BY name;
      `,
    );

    const accountCounts = await surrealSelectMany<{ spaceKey?: string; total?: number }>(
      ctx,
      `
        SELECT space.key AS spaceKey, count() AS total
        FROM account
        WHERE active = true
        GROUP BY spaceKey;
      `,
    );

    const transactionCounts = await surrealSelectMany<{ spaceKey?: string; total?: number }>(
      ctx,
      `
        SELECT space.key AS spaceKey, count() AS total
        FROM transaction
        GROUP BY spaceKey;
      `,
    );

    const clarificationCounts = await surrealSelectMany<{ spaceKey?: string; total?: number }>(
      ctx,
      `
        SELECT space.key AS spaceKey, count() AS total
        FROM clarificationTask
        WHERE status = 'open'
        GROUP BY spaceKey;
      `,
    );

    const accountCountMap = new Map(accountCounts.map(row => [row.spaceKey || '', row.total ?? 0]));
    const transactionCountMap = new Map(transactionCounts.map(row => [row.spaceKey || '', row.total ?? 0]));
    const clarificationCountMap = new Map(clarificationCounts.map(row => [row.spaceKey || '', row.total ?? 0]));

    return spaces.map(space => ({
      ...space,
      accountCount: accountCountMap.get(space.key) ?? 0,
      transactionCount: transactionCountMap.get(space.key) ?? 0,
      openClarificationCount: clarificationCountMap.get(space.key) ?? 0,
    }));
  }),
  explorer: t.procedure
    .input(SpaceKeyInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{
        id: string;
        key: string;
        name: string;
        spaceType: string;
        currency: string;
        description?: string | null;
      }>(
        ctx,
        `
          SELECT id, key, name, spaceType, currency, description
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          space: null,
          accounts: [],
        };
      }

      const accounts = await surrealSelectMany<{
        id: string;
        key: string;
        name: string;
        bankName: string;
        accountType: string;
        currency: string;
        accountNumberLast4?: string | null;
        openingBalance?: number | null;
        active: boolean;
        notes?: string | null;
      }>(
        ctx,
        `
          SELECT id, key, name, bankName, accountType, currency, accountNumberLast4, openingBalance, active, notes
          FROM account
          WHERE space = $spaceId AND active = true
          ORDER BY name;
        `,
        { spaceId: space.id },
      );

      const transactionStats = await surrealSelectMany<{
        accountKey?: string;
        transactionCount?: number;
      }>(
        ctx,
        `
          SELECT account.key AS accountKey, count() AS transactionCount
          FROM transaction
          WHERE space = $spaceId
          GROUP BY accountKey;
        `,
        { spaceId: space.id },
      );

      const latestTransactions = await surrealSelectMany<{
        accountKey?: string;
        latestTransactionAt?: string | null;
      }>(
        ctx,
        `
          SELECT account.key AS accountKey, postedAt AS latestTransactionAt
          FROM transaction
          WHERE space = $spaceId
          ORDER BY postedAt DESC;
        `,
        { spaceId: space.id },
      );

      const clarificationStats = await surrealSelectMany<{
        accountKey?: string;
        openClarificationCount?: number;
      }>(
        ctx,
        `
          SELECT transaction.account.key AS accountKey, count() AS openClarificationCount
          FROM clarificationTask
          WHERE space = $spaceId AND status = 'open'
          GROUP BY accountKey;
        `,
        { spaceId: space.id },
      );

      const transactionMap = new Map(transactionStats.map(row => [
        row.accountKey || '',
        {
          transactionCount: row.transactionCount ?? 0,
          latestTransactionAt: latestTransactions.find(latest => latest.accountKey === row.accountKey)?.latestTransactionAt ?? null,
        },
      ]));
      const clarificationMap = new Map(clarificationStats.map(row => [
        row.accountKey || '',
        row.openClarificationCount ?? 0,
      ]));

      return {
        space,
        accounts: accounts.map(account => ({
          ...account,
          transactionCount: transactionMap.get(account.key)?.transactionCount ?? 0,
          latestTransactionAt: transactionMap.get(account.key)?.latestTransactionAt ?? null,
          openClarificationCount: clarificationMap.get(account.key) ?? 0,
        })),
      };
    }),
});

export const financialSpaceRouter = t.mergeRouters(generatedFinancialSpaceRouter, customFinancialSpaceRouter);
export type FinancialSpaceRouter = typeof financialSpaceRouter;
