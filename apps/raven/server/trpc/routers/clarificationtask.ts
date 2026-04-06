import { t } from '@schema/server/trpc/context';
import { clarificationTaskRouter as generatedClarificationTaskRouter } from './generated/clarificationtask';
import { surrealSelectMany, surrealSelectOne } from './_surreal';
import { z } from 'zod';

const ClarificationQueueInput = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1).optional(),
  status: z.enum(['open', 'resolved', 'all']).default('open'),
});

const customClarificationTaskRouter = t.router({
  queue: t.procedure
    .input(ClarificationQueueInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string; key: string; name: string; spaceType: string; currency: string }>(
        ctx,
        `
          SELECT id, key, name, spaceType, currency
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          space: null,
          summary: {
            total: 0,
            open: 0,
            resolved: 0,
            accountCount: 0,
            merchantCount: 0,
          },
          accounts: [],
          tasks: [],
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
      }>(
        ctx,
        `
          SELECT id, key, name, bankName, accountType, currency, accountNumberLast4
          FROM account
          WHERE space = $spaceId AND active = true
          ORDER BY name ASC;
        `,
        { spaceId: space.id },
      );

      const whereClauses = ['transaction.account.space = $spaceId'];
      const vars: Record<string, unknown> = { spaceId: space.id };

      if (input.accountKey) {
        whereClauses.push('transaction.account.key = $accountKey');
        vars.accountKey = input.accountKey;
      }

      if (input.status !== 'all') {
        whereClauses.push('status = $status');
        vars.status = input.status;
      }

      const tasks = await surrealSelectMany<{
        id: string;
        key: string;
        status: string;
        question: string;
        reason?: string | null;
        confidence?: number | null;
        resolutionNotes?: string | null;
        transactionId: string;
        postedAt: string;
        amount: number;
        direction: 'credit' | 'debit' | 'transfer';
        description: string;
        normalizedDescription?: string | null;
        transactionNotes?: string | null;
        accountId?: string | null;
        accountKey?: string | null;
        accountName?: string | null;
        accountBankName?: string | null;
        accountType?: string | null;
        categoryId?: string | null;
        categoryKey?: string | null;
        categoryName?: string | null;
        merchantId?: string | null;
        merchantKey?: string | null;
        merchantName?: string | null;
        sourceRowId?: string | null;
        rowNumber?: number | null;
        rawData?: {
          rawRowText?: string | null;
          bankChargeZar?: number | null;
          category?: string | null;
          clarificationStatus?: string | null;
          feeType?: string | null;
          normalizedMerchant?: string | null;
          sourceFileName?: string | null;
          statementPeriodStart?: string | null;
          statementPeriodEnd?: string | null;
          transactionType?: string | null;
        } | null;
      }>(
        ctx,
        `
          SELECT
            id,
            key,
            status,
            question,
            reason,
            confidence,
            resolutionNotes,
            transaction.id AS transactionId,
            transaction.postedAt AS postedAt,
            transaction.amount AS amount,
            transaction.direction AS direction,
            transaction.description AS description,
            transaction.normalizedDescription AS normalizedDescription,
            transaction.notes AS transactionNotes,
            transaction.account.id AS accountId,
            transaction.account.key AS accountKey,
            transaction.account.name AS accountName,
            transaction.account.bankName AS accountBankName,
            transaction.account.accountType AS accountType,
            transaction.category.id AS categoryId,
            transaction.category.key AS categoryKey,
            transaction.category.name AS categoryName,
            transaction.merchant.id AS merchantId,
            transaction.merchant.key AS merchantKey,
            transaction.merchant.name AS merchantName,
            transaction.sourceRow.id AS sourceRowId,
            transaction.sourceRow.rowNumber AS rowNumber,
            transaction.sourceRow.rawData AS rawData
          FROM clarificationTask
          WHERE ${whereClauses.join(' AND ')}
          ORDER BY transaction.postedAt DESC, transaction.amount DESC, key ASC
          FETCH transaction, transaction.account, transaction.category, transaction.merchant, transaction.sourceRow;
        `,
        vars,
      );

      const accountKeySet = new Set<string>();
      const merchantKeySet = new Set<string>();
      let open = 0;
      let resolved = 0;

      for (const task of tasks) {
        if (task.accountKey) accountKeySet.add(task.accountKey);
        if (task.merchantKey) merchantKeySet.add(task.merchantKey);
        if (task.status === 'resolved') resolved += 1;
        else open += 1;
      }

      return {
        space,
        summary: {
          total: tasks.length,
          open,
          resolved,
          accountCount: accountKeySet.size,
          merchantCount: merchantKeySet.size,
        },
        accounts,
        tasks,
      };
    }),
});

export const clarificationTaskRouter = t.mergeRouters(generatedClarificationTaskRouter, customClarificationTaskRouter);
export type ClarificationTaskRouter = typeof clarificationTaskRouter;
