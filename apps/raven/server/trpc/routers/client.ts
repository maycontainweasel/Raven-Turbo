import { t } from '@schema/server/trpc/context';
import { clientRouter as generatedClientRouter } from './generated/client';
import { surrealSelectMany } from './_surreal';

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
});

export const clientRouter = t.mergeRouters(generatedClientRouter, customClientRouter);
export type ClientRouter = typeof clientRouter;
