import { TRPCError } from '@trpc/server';
import { z } from 'zod';
import { RequestSchema } from '@schema/request-schema';
import { t } from '@schema/server/trpc/context';
import { transactionPurposeAssignmentRouter as generatedTransactionPurposeAssignmentRouter } from './generated/transactionpurposeassignment';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

const CurrentClassificationInput = z.object({
  transactionId: z.string().min(1),
});

const AssignClassificationInput = z.object({
  transactionId: z.string().min(1),
  purposeKey: z.string().min(1),
  merchantKey: z.string().optional().default(''),
  categoryKey: z.string().optional().default(''),
  clientKey: z.string().optional().default(''),
  occurrenceLabel: z.string().max(240).optional().default(''),
  tags: z.array(z.string().min(1).max(80)).max(30).optional().default([]),
  notes: z.string().max(2000).optional().default(''),
});

const ClearClassificationInput = z.object({
  transactionId: z.string().min(1),
});

type LookupRow = { id: string; key: string; name: string };

const transactionKey = (value: string) => value.trim().replace(/^transaction:/, '').replace(/^`|`$/g, '');

const requireLookup = async (
  ctx: Parameters<typeof surrealSelectOne>[0],
  table: 'transactionPurpose' | 'merchant' | 'category',
  spaceId: string,
  key: string,
  label: string,
) => {
  const row = await surrealSelectOne<LookupRow>(ctx, `
    SELECT id, key, name
    FROM ${table}
    WHERE space = $spaceId AND key = $key AND active = true
    LIMIT 1;
  `, { spaceId, key });
  if (!row) {
    throw new TRPCError({ code: 'BAD_REQUEST', message: `${label} “${key}” does not exist in this Financial Space.` });
  }
  return row;
};

const customTransactionPurposeAssignmentRouter = t.router({
  options: t.procedure.query(async ({ ctx }) => {
    const [spaces, merchants, categories, taxCategories, purposes, clients, tagRows] = await Promise.all([
      surrealSelectMany(ctx, `
        SELECT id, key, name, spaceType, currency
        FROM financialSpace
        WHERE active = true
        ORDER BY name;
      `),
      surrealSelectMany(ctx, `
        SELECT id, key, name, normalizedName, notes, space.key AS spaceKey
        FROM merchant
        WHERE active = true
        ORDER BY name;
      `),
      surrealSelectMany(ctx, `
        SELECT id, key, name, categoryKind, notes, space.key AS spaceKey,
          parentCategory.key AS parentKey, parentCategory.name AS parentName
        FROM category
        WHERE active = true
        ORDER BY parentName, name;
      `),
      surrealSelectMany(ctx, `
        SELECT id, key, name, notes, space.key AS spaceKey,
          parentTaxCategory.key AS parentKey, parentTaxCategory.name AS parentName
        FROM taxCategory
        WHERE active = true
        ORDER BY parentName, name;
      `),
      surrealSelectMany(ctx, `
        SELECT id, key, name, description, purposeKind, occurrencePattern, aliases,
          space.key AS spaceKey,
          defaultMerchant.key AS merchantKey,
          defaultCategory.key AS categoryKey
        FROM transactionPurpose
        WHERE active = true
        ORDER BY name;
      `),
      surrealSelectMany(ctx, `
        SELECT id, key, name, businessName, status
        FROM client
        WHERE status IN ['active', 'paused']
        ORDER BY name;
      `),
      surrealSelectMany<{ tags?: string[] | null }>(ctx, `
        SELECT context.tags AS tags
        FROM transactionPurposeAssignment
        WHERE isCurrent = true AND state = 'confirmed' AND context.tags != NONE;
      `),
    ]);
    const tags = [...new Set(tagRows.flatMap(row => row.tags ?? []).map(tag => String(tag).trim()).filter(Boolean))].sort();
    return { spaces, merchants, categories, taxCategories, purposes, clients, tags };
  }),

  current: t.procedure
    .input(CurrentClassificationInput)
    .query(async ({ input, ctx }) => {
      const vars = { transactionKey: transactionKey(input.transactionId) };
      const transaction = await surrealSelectOne<{
        id: string;
        spaceKey: string;
        merchantKey?: string | null;
        categoryKey?: string | null;
      }>(ctx, `
        SELECT id, space.key AS spaceKey, merchant.key AS merchantKey, category.key AS categoryKey
        FROM ONLY type::record('transaction', $transactionKey);
      `, vars);
      if (!transaction) return { transaction: null, assignment: null };

      const assignment = await surrealSelectOne(ctx, `
        SELECT
          id, revision, state, isCurrent, assignmentSource, confidence,
          occurrenceLabel, context.tags AS tags, context.client.key AS clientKey,
          context.client.name AS clientName, notes, recordedAt, reviewedAt,
          purpose.key AS purposeKey, purpose.name AS purposeName,
          purpose.description AS purposeDescription,
          purpose.purposeKind AS purposeKind,
          purpose.occurrencePattern AS occurrencePattern
        FROM transactionPurposeAssignment
        WHERE transaction = type::record('transaction', $transactionKey) AND isCurrent = true
        ORDER BY revision DESC
        LIMIT 1;
      `, vars);
      return { transaction, assignment };
    }),

  assign: t.procedure
    .input(RequestSchema(AssignClassificationInput))
    .mutation(async ({ input, ctx }) => {
      const payload = input.data;
      if (!payload) throw new TRPCError({ code: 'BAD_REQUEST', message: 'Classification payload is required.' });

      const db = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : ctx.db;
      const transaction = await surrealSelectOne<{
        id: string;
        space: string;
        spaceKey: string;
      }>({ ...ctx, db } as typeof ctx, `
        SELECT id, space, space.key AS spaceKey
        FROM ONLY type::record('transaction', $transactionKey);
      `, { transactionKey: transactionKey(payload.transactionId) });
      if (!transaction) throw new TRPCError({ code: 'NOT_FOUND', message: 'The transaction no longer exists.' });

      const purpose = await requireLookup({ ...ctx, db } as typeof ctx, 'transactionPurpose', transaction.space, payload.purposeKey, 'Purpose');
      const merchant = payload.merchantKey
        ? await requireLookup({ ...ctx, db } as typeof ctx, 'merchant', transaction.space, payload.merchantKey, 'Merchant')
        : null;
      const category = payload.categoryKey
        ? await requireLookup({ ...ctx, db } as typeof ctx, 'category', transaction.space, payload.categoryKey, 'Category')
        : null;
      const client = payload.clientKey
        ? await surrealSelectOne<LookupRow>({ ...ctx, db } as typeof ctx, `
            SELECT id, key, name FROM client WHERE key = $key LIMIT 1;
          `, { key: payload.clientKey })
        : null;
      if (payload.clientKey && !client) {
        throw new TRPCError({ code: 'BAD_REQUEST', message: `Client “${payload.clientKey}” does not exist.` });
      }

      const now = new Date().toISOString();
      const context = {
        tags: [...new Set(payload.tags.map(tag => tag.trim().toLowerCase()).filter(Boolean))],
        client: client?.id ?? null,
      };
      const response = await db.query(`
        BEGIN TRANSACTION;
        LET $transactionId = type::record('transaction', $transactionKey);
        LET $transaction = SELECT * FROM ONLY $transactionId;
        IF !$transaction { THROW 'TRANSACTION_NOT_FOUND'; };
        LET $revisions = SELECT VALUE revision FROM transactionPurposeAssignment WHERE transaction = $transaction.id;
        LET $revision = math::max(array::concat([0], $revisions)) + 1;
        LET $previous = array::first((SELECT * FROM transactionPurposeAssignment WHERE transaction = $transaction.id AND isCurrent = true ORDER BY revision DESC LIMIT 1));
        UPDATE transactionPurposeAssignment
          SET isCurrent = false,
              state = IF state IN ['confirmed', 'proposed'] { 'superseded' } ELSE { state }
          WHERE transaction = $transaction.id AND isCurrent = true;
        LET $assignment = fn::createTransactionPurposeAssignment({
          space: $transaction.space,
          transaction: $transaction.id,
          purpose: $purposeId,
          revision: $revision,
          state: 'confirmed',
          isCurrent: true,
          assignmentSource: 'manual',
          confidence: 1,
          occurrenceLabel: $occurrenceLabel,
          context: $context,
          supersedes: IF $previous { $previous.id } ELSE { NONE },
          recordedAt: $recordedAt,
          reviewedAt: $recordedAt,
          notes: $notes
        });
        LET $updatedTransaction = UPDATE $transaction.id MERGE {
          merchant: IF $merchantId { $merchantId } ELSE { NONE },
          merchantName: IF $merchantId { $merchantName } ELSE { '' },
          category: IF $categoryId { $categoryId } ELSE { NONE },
          status: 'clarified',
          manualOverride: true
        };
        RETURN {
          assignment: $assignment,
          transaction: array::first($updatedTransaction)
        };
        COMMIT TRANSACTION;
      `, {
        transactionKey: transactionKey(payload.transactionId),
        purposeId: purpose.id,
        merchantId: merchant?.id ?? null,
        merchantName: merchant?.name ?? '',
        categoryId: category?.id ?? null,
        occurrenceLabel: payload.occurrenceLabel.trim(),
        context,
        recordedAt: now,
        notes: payload.notes.trim(),
      });

      return ctx.LRS(response as any);
    }),

  clear: t.procedure
    .input(RequestSchema(ClearClassificationInput))
    .mutation(async ({ input, ctx }) => {
      const payload = input.data;
      if (!payload) throw new TRPCError({ code: 'BAD_REQUEST', message: 'Transaction identity is required.' });

      const db = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : ctx.db;
      const response = await db.query(`
        BEGIN TRANSACTION;
        LET $transactionId = type::record('transaction', $transactionKey);
        LET $transaction = SELECT * FROM ONLY $transactionId;
        IF !$transaction { THROW 'TRANSACTION_NOT_FOUND'; };
        LET $previous = array::first((
          SELECT * FROM transactionPurposeAssignment
          WHERE transaction = $transaction.id AND isCurrent = true
          ORDER BY revision DESC LIMIT 1
        ));
        UPDATE transactionPurposeAssignment
          SET isCurrent = false,
              state = IF state IN ['confirmed', 'proposed'] { 'superseded' } ELSE { state }
          WHERE transaction = $transaction.id AND isCurrent = true;
        LET $updatedTransaction = UPDATE $transaction.id MERGE {
          merchant: NONE,
          merchantName: '',
          category: NONE,
          manualOverride: false,
          status: IF $transaction.status IN ['classified', 'clarified'] {
            IF $transaction.normalizedDescription != NONE
              AND string::len(string::trim($transaction.normalizedDescription)) > 0 {
              'normalized'
            } ELSE {
              'imported'
            }
          } ELSE {
            $transaction.status
          }
        };
        RETURN {
          previous: $previous,
          transaction: array::first($updatedTransaction)
        };
        COMMIT TRANSACTION;
      `, { transactionKey: transactionKey(payload.transactionId) });
      return ctx.LRS(response as any);
    }),
});

export const transactionPurposeAssignmentRouter = t.mergeRouters(generatedTransactionPurposeAssignmentRouter, customTransactionPurposeAssignmentRouter);
export type TransactionPurposeAssignmentRouter = typeof transactionPurposeAssignmentRouter;
