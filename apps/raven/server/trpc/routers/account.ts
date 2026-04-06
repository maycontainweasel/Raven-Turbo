import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { accountRouter as generatedAccountRouter } from './generated/account';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

const AccountExplorerInput = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});

const AccountMonthInput = AccountExplorerInput.extend({
  month: z.string().regex(/^\d{4}-\d{2}$/),
});

const customAccountRouter = t.router({
  explorer: t.procedure
    .input(AccountExplorerInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          account: null,
          statementImports: [],
          months: [],
          openClarificationCount: 0,
        };
      }

      const account = await surrealSelectOne<{
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
          WHERE key = $accountKey AND space = $spaceId
          LIMIT 1;
        `,
        {
          spaceId: space.id,
          accountKey: input.accountKey,
        },
      );

      if (!account) {
        return {
          account: null,
          statementImports: [],
          months: [],
          openClarificationCount: 0,
        };
      }

      const statementImports = await surrealSelectMany<{
        id: string;
        key: string;
        statementDate: string;
        sourceFileName: string;
        rowCount: number;
        normalizedCount: number;
        clarificationCount: number;
        status: string;
      }>(
        ctx,
        `
          SELECT id, key, statementDate, sourceFileName, rowCount, normalizedCount, clarificationCount, status
          FROM statementImport
          WHERE account = $accountId
          ORDER BY statementDate DESC;
        `,
        { accountId: account.id },
      );

      const monthDirectionRows = await surrealSelectMany<{
        month: string;
        direction: 'credit' | 'debit' | 'transfer';
        total: number;
        amountTotal: number;
      }>(
        ctx,
        `
          SELECT string::slice(postedAt, 0, 7) AS month, direction, count() AS total, math::sum(amount) AS amountTotal
          FROM transaction
          WHERE account = $accountId
          GROUP BY month, direction
          ORDER BY month DESC, direction;
        `,
        { accountId: account.id },
      );

      const clarificationCountRows = await surrealSelectMany<{ openClarificationCount?: number }>(
        ctx,
        `
          SELECT count() AS openClarificationCount
          FROM clarificationTask
          WHERE transaction.account = $accountId AND status = 'open'
          GROUP ALL;
        `,
        { accountId: account.id },
      );

      const monthMap = new Map<string, {
        month: string;
        income: number;
        outgoing: number;
        transfers: number;
        transactionCount: number;
        creditCount: number;
        debitCount: number;
        transferCount: number;
        net: number;
      }>();

      for (const row of monthDirectionRows) {
        const current = monthMap.get(row.month) || {
          month: row.month,
          income: 0,
          outgoing: 0,
          transfers: 0,
          transactionCount: 0,
          creditCount: 0,
          debitCount: 0,
          transferCount: 0,
          net: 0,
        };

        if (row.direction === 'credit') {
          current.income = row.amountTotal ?? 0;
          current.creditCount = row.total ?? 0;
        } else if (row.direction === 'transfer') {
          current.transfers = row.amountTotal ?? 0;
          current.transferCount = row.total ?? 0;
        } else {
          current.outgoing = row.amountTotal ?? 0;
          current.debitCount = row.total ?? 0;
        }

        current.transactionCount = current.creditCount + current.debitCount + current.transferCount;
        current.net = current.income - current.outgoing - current.transfers;
        monthMap.set(row.month, current);
      }

      return {
        account,
        statementImports,
        months: Array.from(monthMap.values()).sort((left, right) => right.month.localeCompare(left.month)),
        openClarificationCount: clarificationCountRows[0]?.openClarificationCount ?? 0,
      };
    }),
  month: t.procedure
    .input(AccountMonthInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          categories: [],
          transactions: [],
          openClarificationCount: 0,
        };
      }

      const account = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM account
          WHERE key = $accountKey AND space = $spaceId
          LIMIT 1;
        `,
        {
          spaceId: space.id,
          accountKey: input.accountKey,
        },
      );

      if (!account) {
        return {
          categories: [],
          transactions: [],
          openClarificationCount: 0,
        };
      }

      const categories = await surrealSelectMany<{
        category: string;
        categoryKey?: string | null;
        categoryName?: string | null;
        total: number;
        amountTotal: number;
      }>(
        ctx,
        `
          SELECT category, category.name AS categoryName, category.key AS categoryKey, count() AS total, math::sum(amount) AS amountTotal
          FROM transaction
          WHERE account = $accountId AND string::slice(postedAt, 0, 7) = $month
          GROUP BY category, categoryName, categoryKey
          ORDER BY amountTotal DESC;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      const transactions = await surrealSelectMany<{
        id: string;
        postedAt: string;
        description: string;
        normalizedDescription?: string | null;
        amount: number;
        balance?: number | null;
        direction: 'credit' | 'debit' | 'transfer';
        status: string;
        merchantName?: string | null;
        category?: string | null;
        categoryKey?: string | null;
        categoryName?: string | null;
        notes?: string | null;
        rowNumber?: number | null;
        bankChargeZar?: number | null;
        rawRowText?: string | null;
      }>(
        ctx,
        `
          SELECT id, postedAt, description, normalizedDescription, amount, balance, direction, status, merchantName, category, category.name AS categoryName, category.key AS categoryKey, notes, sourceRow.rowNumber AS rowNumber, sourceRow.rawData.bankChargeZar AS bankChargeZar, sourceRow.rawData.rawRowText AS rawRowText
          FROM transaction
          WHERE account = $accountId AND string::slice(postedAt, 0, 7) = $month
          ORDER BY postedAt DESC, rowNumber DESC, id DESC;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      const clarificationCounts = await surrealSelectMany<{ openClarificationCount?: number }>(
        ctx,
        `
          SELECT count() AS openClarificationCount
          FROM clarificationTask
          WHERE transaction.account = $accountId AND string::slice(transaction.postedAt, 0, 7) = $month AND status = 'open'
          GROUP ALL;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      return {
        categories,
        transactions,
        openClarificationCount: clarificationCounts[0]?.openClarificationCount ?? 0,
      };
    }),
});

export const accountRouter = t.mergeRouters(generatedAccountRouter, customAccountRouter);
export type AccountRouter = typeof accountRouter;
