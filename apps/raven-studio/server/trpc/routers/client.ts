import { t } from '@schema/server/trpc/context';
import { z } from 'zod';
import { clientRouter as generatedClientRouter } from './generated/client';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

type ClientRow = {
  id: string;
  key: string;
  name: string;
  businessName?: string | null;
  contactPerson?: string | null;
  email?: string | null;
  phoneWhatsapp?: string | null;
  websiteDomain?: string | null;
  status: string;
  relatedProjects?: string | null;
  orbitClientId?: string | null;
  notes?: string | null;
};

const ClientDetailInput = z.object({
  clientKey: z.string().min(1),
  limit: z.number().int().min(1).max(500).default(200),
});

const summarizeClientLedger = (rows: Array<{
  currency: string;
  amount: number;
  direction: string;
  flowDirection?: string | null;
  postedAt: string;
}>) => {
  const totals = new Map<string, { currency: string; inflow: number; outflow: number; transactionCount: number; months: Set<string> }>();
  for (const row of rows) {
    const item = totals.get(row.currency) ?? { currency: row.currency, inflow: 0, outflow: 0, transactionCount: 0, months: new Set<string>() };
    const amount = Math.abs(Number(row.amount || 0));
    if (row.flowDirection === 'inflow' || (!row.flowDirection && row.direction === 'credit')) item.inflow += amount;
    if (row.flowDirection === 'outflow' || (!row.flowDirection && row.direction === 'debit')) item.outflow += amount;
    item.transactionCount += 1;
    if (row.postedAt) item.months.add(row.postedAt.slice(0, 7));
    totals.set(row.currency, item);
  }
  return [...totals.values()].map(item => ({
    currency: item.currency,
    inflow: item.inflow,
    outflow: item.outflow,
    net: item.inflow - item.outflow,
    transactionCount: item.transactionCount,
    activeMonthCount: item.months.size,
    averageMonthlyInflow: item.months.size ? item.inflow / item.months.size : 0,
  }));
};

const customClientRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => {
    const clients = await surrealSelectMany<ClientRow>(ctx, `
      SELECT id, key, name, businessName, contactPerson, email, phoneWhatsapp, websiteDomain, status, relatedProjects, orbitClientId, notes
      FROM client
      ORDER BY status ASC, name ASC;
    `);

    const retainerStats = await surrealSelectMany<{
      clientKey?: string | null;
      retainerCount?: number | null;
      activeRetainerCount?: number | null;
      monthlyRevenue?: number | null;
    }>(ctx, `
      SELECT
        client.key AS clientKey,
        count() AS retainerCount,
        math::sum(if status IN ['active', 'overdue'] { 1 } else { 0 }) AS activeRetainerCount,
        math::sum(if status IN ['active', 'overdue'] { amountCharged } else { 0 }) AS monthlyRevenue
      FROM retainer
      GROUP BY clientKey;
    `);

    const statsByClient = new Map(retainerStats.map(row => [row.clientKey || '', row]));

    return clients.map(client => {
      const stats = statsByClient.get(client.key);
      return {
        ...client,
        retainerCount: Number(stats?.retainerCount || 0),
        activeRetainerCount: Number(stats?.activeRetainerCount || 0),
        monthlyRevenue: Number(stats?.monthlyRevenue || 0),
      };
    });
  }),

  detail: t.procedure
    .input(ClientDetailInput)
    .query(async ({ input, ctx }) => {
      const client = await surrealSelectOne<ClientRow>(ctx, `
        SELECT id, key, name, businessName, contactPerson, email, phoneWhatsapp, websiteDomain, status, relatedProjects, orbitClientId, notes
        FROM client
        WHERE key = $clientKey
        LIMIT 1;
      `, input);
      if (!client) return { client: null, totals: [], transactions: [] };

      const transactions = await surrealSelectMany<{
        assignmentId: string;
        transactionId: string;
        transactionKey: string;
        postedAt: string;
        description: string;
        amount: number;
        currency: string;
        direction: string;
        flowDirection?: string | null;
        status: string;
        accountKey?: string | null;
        accountName?: string | null;
        merchantKey?: string | null;
        merchantName?: string | null;
        categoryName?: string | null;
        purposeKey: string;
        purposeName: string;
        occurrenceLabel?: string | null;
        tags?: string[] | null;
        notes?: string | null;
      }>(ctx, `
        SELECT
          id AS assignmentId,
          transaction.id AS transactionId,
          transaction.key AS transactionKey,
          transaction.postedAt AS postedAt,
          transaction.description AS description,
          transaction.amount AS amount,
          transaction.currency AS currency,
          transaction.direction AS direction,
          transaction.flowDirection AS flowDirection,
          transaction.status AS status,
          transaction.account.key AS accountKey,
          transaction.account.name AS accountName,
          transaction.merchant.key AS merchantKey,
          transaction.merchant.name AS merchantName,
          transaction.category.name AS categoryName,
          purpose.key AS purposeKey,
          purpose.name AS purposeName,
          occurrenceLabel,
          context.tags AS tags,
          notes
        FROM transactionPurposeAssignment
        WHERE isCurrent = true
          AND state = 'confirmed'
          AND context.client = $clientId
        ORDER BY transaction.postedAt DESC, transaction.id DESC
        LIMIT $limit;
      `, { clientId: client.id, limit: input.limit });

      return {
        client,
        totals: summarizeClientLedger(transactions),
        transactions,
      };
    }),
});

export const clientRouter = t.mergeRouters(generatedClientRouter, customClientRouter);
export type ClientRouter = typeof clientRouter;
