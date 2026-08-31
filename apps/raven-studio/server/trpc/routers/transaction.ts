import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { transactionRouter as generatedTransactionRouter } from './generated/transaction';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

const TransactionDetailInput = z.object({
  transactionId: z.string().min(1),
});

const customTransactionRouter = t.router({
  detail: t.procedure
    .input(TransactionDetailInput)
    .query(async ({ input, ctx }) => {
      const transaction = await surrealSelectOne<{
        id: string;
        postedAt: string;
        description: string;
        normalizedDescription?: string | null;
        amount: number;
        balance?: number | null;
        direction: 'credit' | 'debit' | 'transfer';
        status: string;
        merchantName?: string | null;
        notes?: string | null;
        category?: {
          id: string;
          key?: string | null;
          name?: string | null;
        } | null;
        merchant?: {
          id: string;
          key?: string | null;
          name?: string | null;
          normalizedName?: string | null;
        } | null;
        sourceRow?: {
          id: string;
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
        } | null;
      }>(
        ctx,
        `
          LET $transaction = <record>$transactionId;
          SELECT * FROM only $transaction FETCH category, merchant, sourceRow;
        `,
        { transactionId: input.transactionId },
      );

      const clarificationTasks = await surrealSelectMany<{
        id: string;
        key: string;
        status: string;
        question: string;
        reason?: string | null;
        confidence?: number | null;
        resolutionNotes?: string | null;
      }>(
        ctx,
        `
          LET $transaction = <record>$transactionId;
          SELECT id, key, status, question, reason, confidence, resolutionNotes
          FROM clarificationTask
          WHERE transaction = $transaction
          ORDER BY status, key;
        `,
        { transactionId: input.transactionId },
      );

      return {
        transaction,
        clarificationTasks,
      };
    }),
});

export const transactionRouter = t.mergeRouters(generatedTransactionRouter, customTransactionRouter);
export type TransactionRouter = typeof transactionRouter;
