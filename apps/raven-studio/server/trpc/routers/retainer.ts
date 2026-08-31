import { t } from '@schema/server/trpc/context';
import { retainerRouter as generatedRetainerRouter } from './generated/retainer';
import { surrealSelectMany } from './_surreal';

type RetainerDashboardRow = {
  id: string;
  key: string;
  client?: string | null;
  clientKey?: string | null;
  clientName?: string | null;
  clientBusinessName?: string | null;
  title: string;
  type: string;
  status: string;
  startDate?: string | null;
  billingCadence: string;
  amountCharged?: number | null;
  currency: string;
  quotedAmount?: number | null;
  quotedAt?: string | null;
  quoteReference?: string | null;
  nextBillingDate?: string | null;
  lastBilledDate?: string | null;
  invoiceCount?: number | null;
  amountCollectedToDate?: number | null;
  hostingProvider?: string | null;
  hostingProviderKey?: string | null;
  hostingProviderName?: string | null;
  providerAccountName?: string | null;
  coveredAssets?: string | null;
  costToMe?: number | null;
  costCadence?: string | null;
  renewalReviewDate?: string | null;
  recommendedAction?: string | null;
  risksIssues?: string | null;
  nextAction?: string | null;
  agreementSourceNotes?: string | null;
  termsConditions?: string | null;
  includedServices?: string | null;
  excludedServices?: string | null;
  supportLevel?: string | null;
  notes?: string | null;
};

const cadenceDivisor = (cadence?: string | null) => {
  if (cadence === 'annual') return 12;
  if (cadence === 'quarterly') return 3;
  if (cadence === 'ad_hoc') return 0;
  return 1;
};

const monthlyEquivalent = (amount?: number | null, cadence?: string | null) => {
  const value = Number(amount || 0);
  const divisor = cadenceDivisor(cadence);
  if (!divisor) return 0;
  return value / divisor;
};

const isDueBefore = (date?: string | null, comparison = new Date()) => {
  if (!date) return false;
  const parsed = new Date(`${String(date).slice(0, 10)}T00:00:00.000Z`);
  if (Number.isNaN(parsed.getTime())) return false;
  return parsed.getTime() < Date.UTC(comparison.getUTCFullYear(), comparison.getUTCMonth(), comparison.getUTCDate());
};

const isDueWithinDays = (date?: string | null, days = 30, comparison = new Date()) => {
  if (!date) return false;
  const parsed = new Date(`${String(date).slice(0, 10)}T00:00:00.000Z`);
  if (Number.isNaN(parsed.getTime())) return false;
  const start = Date.UTC(comparison.getUTCFullYear(), comparison.getUTCMonth(), comparison.getUTCDate());
  const end = start + days * 86400000;
  return parsed.getTime() >= start && parsed.getTime() <= end;
};

const round2 = (value: number) => Math.round((value + Number.EPSILON) * 100) / 100;

const customRetainerRouter = t.router({
  dashboard: t.procedure.query(async ({ ctx }) => {
    const clients = await surrealSelectMany(ctx, `
      SELECT id, key, name, businessName, contactPerson, email, phoneWhatsapp, websiteDomain, status, notes
      FROM client
      ORDER BY name;
    `);

    const providers = await surrealSelectMany(ctx, `
      SELECT id, key, name, providerType, accountName, accountReference, billingCadence, monthlyCost, currency, status, notes
      FROM hostingProvider
      ORDER BY name;
    `);

    const retainerRows = await surrealSelectMany<RetainerDashboardRow>(ctx, `
      SELECT
        id,
        key,
        client,
        client.key AS clientKey,
        client.name AS clientName,
        client.businessName AS clientBusinessName,
        title,
        type,
        status,
        startDate,
        billingCadence,
        amountCharged,
        currency,
        quotedAmount,
        quotedAt,
        quoteReference,
        nextBillingDate,
        lastBilledDate,
        invoiceCount,
        amountCollectedToDate,
        agreementSourceNotes,
        termsConditions,
        includedServices,
        excludedServices,
        supportLevel,
        hostingProvider,
        hostingProvider.key AS hostingProviderKey,
        hostingProvider.name AS hostingProviderName,
        providerAccountName,
        coveredAssets,
        costToMe,
        costCadence,
        renewalReviewDate,
        recommendedAction,
        risksIssues,
        nextAction,
        notes
      FROM retainer
      ORDER BY status ASC, nextBillingDate ASC, title ASC;
    `);

    const retainers = retainerRows.map((row) => {
      const monthlyRevenue = monthlyEquivalent(row.amountCharged, row.billingCadence);
      const monthlyCost = monthlyEquivalent(row.costToMe, row.costCadence);
      const monthlyProfit = monthlyRevenue - monthlyCost;
      const marginPercent = monthlyRevenue > 0 ? (monthlyProfit / monthlyRevenue) * 100 : null;
      const activeLike = row.status === 'active' || row.status === 'overdue';
      const overdue = activeLike && isDueBefore(row.nextBillingDate);
      const upcoming = activeLike && isDueWithinDays(row.nextBillingDate, 30);
      const reviewNeeded = overdue ||
        row.status === 'overdue' ||
        monthlyProfit < 0 ||
        Number(row.amountCharged || 0) === 0 ||
        (row.billingCadence !== 'ad_hoc' && !row.nextBillingDate) ||
        Boolean(row.risksIssues) ||
        Boolean(row.nextAction) ||
        (row.recommendedAction && row.recommendedAction !== 'none') ||
        isDueWithinDays(row.renewalReviewDate, 30);

      return {
        ...row,
        amountCharged: Number(row.amountCharged || 0),
        quotedAmount: Number(row.quotedAmount || 0),
        invoiceCount: Number(row.invoiceCount || 0),
        amountCollectedToDate: Number(row.amountCollectedToDate || 0),
        costToMe: Number(row.costToMe || 0),
        monthlyRevenue: round2(monthlyRevenue),
        monthlyCost: round2(monthlyCost),
        monthlyProfit: round2(monthlyProfit),
        marginPercent: marginPercent === null ? null : round2(marginPercent),
        overdue,
        upcoming,
        reviewNeeded,
      };
    });

    const activeRetainers = retainers.filter((row) => row.status === 'active' || row.status === 'overdue');
    const hostingRetainers = retainers.filter((row) => ['hosting', 'email_hosting', 'mixed'].includes(row.type));
    const reviewNeeded = retainers.filter((row) => row.reviewNeeded);

    return {
      clients,
      providers,
      retainers,
      summary: {
        clientCount: clients.length,
        providerCount: providers.length,
        retainerCount: retainers.length,
        activeRetainerCount: activeRetainers.length,
        hostingRetainerCount: hostingRetainers.length,
        overdueCount: retainers.filter((row) => row.overdue).length,
        upcomingBillingCount: retainers.filter((row) => row.upcoming).length,
        reviewNeededCount: reviewNeeded.length,
        monthlyRevenue: round2(activeRetainers.reduce((sum, row) => sum + row.monthlyRevenue, 0)),
        monthlyCost: round2(activeRetainers.reduce((sum, row) => sum + row.monthlyCost, 0)),
        monthlyProfit: round2(activeRetainers.reduce((sum, row) => sum + row.monthlyProfit, 0)),
      },
    };
  }),
});

export const retainerRouter = t.mergeRouters(generatedRetainerRouter, customRetainerRouter);
export type RetainerRouter = typeof retainerRouter;
