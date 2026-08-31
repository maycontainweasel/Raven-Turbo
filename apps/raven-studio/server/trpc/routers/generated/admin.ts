import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { RequestSchema } from '@schema/request-schema';

const UpdatePostStatusRecordIdInput = z.object({
  tb: z.string().trim().min(1),
  id: z.any(),
});

const UpdatePostStatusInput = z.object({
  table: z.string().trim().min(1).optional(),
  id: z.any().optional(),
  recordId: UpdatePostStatusRecordIdInput.optional(),
  status: z.enum(['draft', 'publish']),
});

export const adminRouter = t.router({
  updatePostStatus: t.procedure
    .input(RequestSchema(UpdatePostStatusInput))
    .mutation(async ({ input, ctx }) => {
      const { db, LRS } = ctx;
      const dbInstance = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : db;
      const { table, id, recordId, status } = input.data || { table: undefined, id: undefined, recordId: undefined, status: undefined };
      const normalizeSubId = (value: any): any => {
        if (value === null || value === undefined) return value;
        if (typeof value === 'object') {
          if ('id' in value) {
            return normalizeSubId((value as any).id);
          }
          return value;
        }
        return value;
      };
      const resolvedTable = String(table || (recordId as any)?.tb || '').trim();
      const resolvedId = normalizeSubId(id ?? (recordId as any)?.id);
      if (!resolvedTable) {
        throw new Error('admin updatePostStatus requires table');
      }
      if (resolvedId === undefined || resolvedId === null || String(resolvedId).trim() === '') {
        throw new Error('admin updatePostStatus requires id');
      }
      if (!status) {
        throw new Error('admin updatePostStatus requires status');
      }
      const query = /* surql */ `
        let $rid = fn::ridParam($tb, $id);
        RETURN fn::updateAdminPostStatus($rid, $status);
      `;
      const result = await LRS(await dbInstance.query(query, { tb: resolvedTable, id: resolvedId, status }));
      return result;
    }),
});
