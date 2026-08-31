import { z } from 'zod';
import { t } from '@schema/server/trpc/context';

import { RequestSchema } from '@schema/request-schema';
import { Z_CashflowSchedule, RecordID_z } from '@schema/types';

const CashflowScheduleCreateInput = Z_CashflowSchedule.partial().merge(
  Z_CashflowSchedule.pick({
  space: true,
  key: true,
  title: true,
  direction: true,
  certainty: true,
  amountMinor: true,
  currency: true,
  timezone: true,
  cadence: true,
  interval: true,
  startDate: true,
  status: true,
  revision: true,
  termsEffectiveFrom: true,
  createdOperation: true,
  lastOperation: true,
  recordedAt: true,
  updatedAt: true,
  })
);

const CashflowScheduleUpdateInput = z.union([
  z.object({
    id: z.union([z.string().min(1), z.number(), RecordID_z]),
    payload: Z_CashflowSchedule.omit({ id: true }).partial(),
  }),
  z.object({
    id: z.union([z.string().min(1), z.number(), RecordID_z]),
  }).merge(Z_CashflowSchedule.omit({ id: true }).partial()),
]);

const CashflowScheduleDeleteInput = z.object({
  id: z.union([z.string().min(1), z.number(), RecordID_z]),
});

const CashflowScheduleResourceKey = z.enum(['Admin']);
const CashflowScheduleResourceInput = z.object({
  id: z.union([z.string().min(1), z.number(), z.object({ tb: z.string(), id: z.any() }).passthrough()]),
  key: CashflowScheduleResourceKey.optional(),
  resource: z.string().min(1).optional(),
}).refine((value) => Boolean(value.key ?? value.resource), {
  message: 'A resource key or name is required',
  path: ['resource'],
});

export const cashflowScheduleRouter = t.router({
  create: t.procedure
    .input(RequestSchema(CashflowScheduleCreateInput))
    .mutation(async ({ input, ctx }) => {
      const { db, LRS } = ctx;
      const dbInstance = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : db;
      const payload = input.data;
      if (!payload) {
        throw new Error('CashflowSchedule create payload is required');
      }
      const query = /* surql */ `
        RETURN fn::createCashflowSchedule($payload);
      `;
      const result = await LRS(await dbInstance.query(query, { payload }));
      return result;
    }),
  update: t.procedure
    .input(RequestSchema(CashflowScheduleUpdateInput))
    .mutation(async ({ input, ctx }) => {
      const { db, LRS } = ctx;
      const dbInstance = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : db;
      const data = input.data || {};
      let { id } = data as any;
      let payload = (data as any).payload;
      if (!payload) {
        const { id: _id, payload: _payload, ...rest } = data as any;
        payload = rest;
      }
      if (!id || !payload || Object.keys(payload).length === 0) {
        throw new Error('updateCashflowSchedule requires an id and payload');
      }
      if (id && typeof id === 'object') {
        id = (id as any).id ?? (id as any).value ?? id;
      }
      if (typeof id === 'string') {
        const trimmed = id.trim();
        const asNumber = Number(trimmed);
        id = trimmed !== '' && !Number.isNaN(asNumber) ? asNumber : trimmed;
      }
      const query = /* surql */ `
        RETURN fn::updateCashflowSchedule($id, $payload);
      `;
      const result = await LRS(await dbInstance.query(query, { id, payload }));
      return result;
    }),
  delete: t.procedure
    .input(RequestSchema(CashflowScheduleDeleteInput))
    .mutation(async ({ input, ctx }) => {
      const { db, LRS } = ctx;
      const dbInstance = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : db;
      let id = input.data?.id;
      if (!id) {
        throw new Error('deleteCashflowSchedule requires an id');
      }
      if (id && typeof id === 'object') {
        id = (id as any).id ?? (id as any).value ?? id;
      }
      if (typeof id === 'string') {
        const trimmed = id.trim();
        const asNumber = Number(trimmed);
        id = trimmed !== '' && !Number.isNaN(asNumber) ? asNumber : trimmed;
      }
      const query = /* surql */ `
        RETURN fn::deleteCashflowSchedule($id);
      `;
      const result = await LRS(await dbInstance.query(query, { id }));
      return result;
    }),
  resource: t.procedure
    .input(RequestSchema(CashflowScheduleResourceInput))
    .query(async ({ input, ctx }) => {
      const { db, LRS } = ctx;
      const dbInstance = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : db;
      const normalizeResourceSelector = (value: string): string =>
        value.replace(/[^a-zA-Z0-9]/g, '').toLowerCase();
      const warnMissingResource = (reason: string, meta: Record<string, any> = {}) => {
        console.warn('[schema-kit] resource lookup unavailable', {
          model: 'cashflowSchedule',
          table: 'CashflowSchedule',
          reason,
          instance: input.instance ?? null,
          ...meta,
        });
      };
      const resourceSelectorMap: Record<string, string> = {
        "admin": "Admin",
      };
      const { id, key, resource } = input.data || { id: undefined, key: undefined, resource: undefined };
      if (!id) {
        throw new Error('CashflowSchedule resource requires an id and resource key');
      }
      let resolvedId: any = id;
      if (resolvedId && typeof resolvedId === 'object') {
        resolvedId = (resolvedId as any).id ?? (resolvedId as any).value ?? resolvedId;
      }
      if (typeof resolvedId === 'string') {
        const trimmed = resolvedId.trim();
        const asNumber = Number(trimmed);
        resolvedId = trimmed !== '' && !Number.isNaN(asNumber) ? asNumber : trimmed;
      }
      const selector = resource ?? key;
      if (!selector) {
        throw new Error('CashflowSchedule resource requires an id and resource key');
      }
      const normalizedSelector = normalizeResourceSelector(selector);
      const resolvedKey = resourceSelectorMap[normalizedSelector];
      if (!resolvedKey) {
        warnMissingResource('Unsupported resource key', {
          selector,
          normalizedSelector,
          availableResourceKeys: Object.values(resourceSelectorMap),
        });
        return null;
      }
      let resourceFn: string | null = null;
      let resourceView: string | null = null;
      let resourceReturnId: 'record' | 'view' = 'record';
      let resourceBaseModel: string = 'cashflowSchedule';
      switch (resolvedKey) {
      case 'Admin':
        resourceView = "CashflowScheduleAdmin";
        resourceReturnId = 'record';
        resourceBaseModel = 'cashflowSchedule';
        break;
      default:
        warnMissingResource('Unsupported resolved resource key', { resolvedKey });
        return null;

      }
      if (resourceView) {
        const selectIdClause = resourceReturnId === 'record'
          ? ',(type::record("cashflowSchedule", record::id($this.id))) as id'
          : '';
        const query = /* surql */ `
          SELECT * ${selectIdClause} FROM only type::record("${resourceView}", $id);
        `;
        try {
          const result = await LRS(await dbInstance.query(query, { id: resolvedId }));
          return result;
        } catch (error: any) {
          const message = String(error?.message || error || '');
          if (/does not exist|not exist|unknown table|unknown function/i.test(message)) {
            warnMissingResource('Resource view unavailable', {
              selector: resolvedKey,
              resourceView,
              id: resolvedId,
              message,
            });
            return null;
          }
          throw error;
        }
      }
      if (resourceFn) {
        const query = /* surql */ `
          LET $rid = type::record('cashflowSchedule', $id);
          RETURN ${resourceFn}($rid);
        `;
        try {
          const result = await LRS(await dbInstance.query(query, { id: resolvedId }));
          return result;
        } catch (error: any) {
          const message = String(error?.message || error || '');
          if (/does not exist|not exist|unknown table|unknown function/i.test(message)) {
            warnMissingResource('Resource function unavailable', {
              selector: resolvedKey,
              resourceFn,
              id: resolvedId,
              message,
            });
            return null;
          }
          throw error;
        }
      }
      warnMissingResource('Resolved resource has no backing target', { resolvedKey });
      return null;
    }),
});
