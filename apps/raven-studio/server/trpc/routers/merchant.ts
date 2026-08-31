import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { merchantRouter as generatedMerchantRouter } from './generated/merchant';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

type MerchantRow = {
  id: string;
  key: string;
  name: string;
  normalizedName?: string | null;
  active: boolean;
  notes?: string | null;
  spaceKey: string;
  spaceName: string;
  spaceCurrency: string;
};

type MerchantMonthRow = {
  merchantKey: string;
  spaceKey: string;
  month: string;
  currency: string;
  transactionCount?: number | null;
  inflow?: number | null;
  outflow?: number | null;
};

const MerchantDetailInput = z.object({
  spaceKey: z.string().min(1),
  merchantKey: z.string().min(1),
  limit: z.number().int().min(1).max(500).default(200),
});

const summarizeMonths = (rows: MerchantMonthRow[]) => {
  const byCurrency = new Map<string, {
    currency: string;
    transactionCount: number;
    inflow: number;
    outflow: number;
    activeMonths: Set<string>;
  }>();

  for (const row of rows) {
    const summary = byCurrency.get(row.currency) ?? {
      currency: row.currency,
      transactionCount: 0,
      inflow: 0,
      outflow: 0,
      activeMonths: new Set<string>(),
    };
    summary.transactionCount += Number(row.transactionCount || 0);
    summary.inflow += Number(row.inflow || 0);
    summary.outflow += Number(row.outflow || 0);
    if (row.month) summary.activeMonths.add(row.month);
    byCurrency.set(row.currency, summary);
  }

  return [...byCurrency.values()].map((summary) => ({
    currency: summary.currency,
    transactionCount: summary.transactionCount,
    inflow: summary.inflow,
    outflow: summary.outflow,
    net: summary.inflow - summary.outflow,
    activeMonthCount: summary.activeMonths.size,
    averageMonthlyInflow: summary.activeMonths.size ? summary.inflow / summary.activeMonths.size : 0,
    averageMonthlyOutflow: summary.activeMonths.size ? summary.outflow / summary.activeMonths.size : 0,
  }));
};

const merchantMonthQuery = `
  SELECT
    merchant.key AS merchantKey,
    merchant.space.key AS spaceKey,
    string::slice(postedAt, 0, 7) AS month,
    currency,
    count() AS transactionCount,
    math::sum(IF flowDirection = 'inflow' OR (flowDirection = NONE AND direction = 'credit') { math::abs(amount) } ELSE { 0 }) AS inflow,
    math::sum(IF flowDirection = 'outflow' OR (flowDirection = NONE AND direction = 'debit') { math::abs(amount) } ELSE { 0 }) AS outflow
  FROM transaction
  WHERE merchant != NONE AND status != 'ignored'
  GROUP BY merchantKey, spaceKey, month, currency;
`;

const customMerchantRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => {
    const [merchants, monthRows] = await Promise.all([
      surrealSelectMany<MerchantRow>(ctx, `
        SELECT
          id, key, name, normalizedName, active, notes,
          space.key AS spaceKey,
          space.name AS spaceName,
          space.currency AS spaceCurrency
        FROM merchant
        ORDER BY active DESC, name ASC;
      `),
      surrealSelectMany<MerchantMonthRow>(ctx, merchantMonthQuery),
    ]);

    return merchants.map((merchant) => {
      const rows = monthRows.filter(row => row.spaceKey === merchant.spaceKey && row.merchantKey === merchant.key);
      const totals = summarizeMonths(rows);
      return {
        ...merchant,
        transactionCount: totals.reduce((sum, item) => sum + item.transactionCount, 0),
        totals,
      };
    });
  }),

  detail: t.procedure
    .input(MerchantDetailInput)
    .query(async ({ input, ctx }) => {
      const merchant = await surrealSelectOne<MerchantRow>(ctx, `
        SELECT
          id, key, name, normalizedName, active, notes,
          space.key AS spaceKey,
          space.name AS spaceName,
          space.currency AS spaceCurrency
        FROM merchant
        WHERE key = $merchantKey AND space.key = $spaceKey
        LIMIT 1;
      `, input);

      if (!merchant) return { merchant: null, totals: [], months: [], transactions: [] };

      const [months, transactions, assignments] = await Promise.all([
        surrealSelectMany<MerchantMonthRow>(ctx, `
          SELECT
            merchant.key AS merchantKey,
            merchant.space.key AS spaceKey,
            string::slice(postedAt, 0, 7) AS month,
            currency,
            count() AS transactionCount,
            math::sum(IF flowDirection = 'inflow' OR (flowDirection = NONE AND direction = 'credit') { math::abs(amount) } ELSE { 0 }) AS inflow,
            math::sum(IF flowDirection = 'outflow' OR (flowDirection = NONE AND direction = 'debit') { math::abs(amount) } ELSE { 0 }) AS outflow
          FROM transaction
          WHERE merchant = $merchantId AND status != 'ignored'
          GROUP BY merchantKey, spaceKey, month, currency
          ORDER BY month DESC;
        `, { merchantId: merchant.id }),
        surrealSelectMany<{
          id: string;
          key: string;
          postedAt: string;
          description: string;
          amount: number;
          currency: string;
          direction: string;
          flowDirection?: string | null;
          status: string;
          accountKey?: string | null;
          accountName?: string | null;
          categoryName?: string | null;
        }>(ctx, `
          SELECT
            id, key, postedAt, description, amount, currency, direction, flowDirection, status,
            account.key AS accountKey,
            account.name AS accountName,
            category.name AS categoryName
          FROM transaction
          WHERE merchant = $merchantId
          ORDER BY postedAt DESC, id DESC
          LIMIT $limit;
        `, { merchantId: merchant.id, limit: input.limit }),
        surrealSelectMany<{
          transactionKey: string;
          purposeName?: string | null;
          occurrenceLabel?: string | null;
          tags?: string[] | null;
        }>(ctx, `
          SELECT
            transaction.key AS transactionKey,
            purpose.name AS purposeName,
            occurrenceLabel,
            context.tags AS tags
          FROM transactionPurposeAssignment
          WHERE isCurrent = true AND state = 'confirmed' AND transaction.merchant = $merchantId;
        `, { merchantId: merchant.id }),
      ]);

      const assignmentByTransaction = new Map(assignments.map(item => [item.transactionKey, item]));
      return {
        merchant,
        totals: summarizeMonths(months),
        months,
        transactions: transactions.map(transaction => ({
          ...transaction,
          purpose: assignmentByTransaction.get(transaction.key) ?? null,
        })),
      };
    }),
});

export const merchantRouter = t.mergeRouters(generatedMerchantRouter, customMerchantRouter);
export type MerchantRouter = typeof merchantRouter;
