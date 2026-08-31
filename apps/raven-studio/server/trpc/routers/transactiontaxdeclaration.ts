import { TRPCError } from '@trpc/server';
import { z } from 'zod';
import { RequestSchema } from '@schema/request-schema';
import { t } from '@schema/server/trpc/context';
import { transactionTaxDeclarationRouter as generatedTransactionTaxDeclarationRouter } from './generated/transactiontaxdeclaration';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

const TransactionInput = z.object({ transactionId: z.string().min(1) });
const EffectiveInput = z.object({
  transactionIds: z.array(z.string().min(1)).min(1).max(500),
});
const SaveInput = z.object({
  transactionId: z.string().min(1),
  taxCategoryKey: z.string().optional().default(''),
  taxDescription: z.string().max(240).optional().default(''),
  evidenceStatus: z.enum(['not_assessed', 'missing', 'partial', 'available', 'not_required'])
    .optional()
    .default('not_assessed'),
  notes: z.string().max(2000).optional().default(''),
});

type EffectiveRow = {
  transactionKey: string;
  statementDescription: string;
  normalCategoryKey?: string | null;
  normalCategoryName?: string | null;
};

type NormalMeaningRow = {
  transactionKey: string;
  occurrenceLabel?: string | null;
  purposeName?: string | null;
};

type DeclarationRow = {
  id: string;
  transactionKey: string;
  revision: number;
  state: string;
  taxDescription?: string | null;
  evidenceStatus: string;
  taxCategoryKey?: string | null;
  taxCategoryName?: string | null;
  notes?: string | null;
  recordedAt: string;
  reviewedAt?: string | null;
};

const transactionKey = (value: string) => value.trim().replace(/^transaction:/, '').replace(/^`|`$/g, '');

const getEffectiveRows = async (
  ctx: Parameters<typeof surrealSelectMany>[0],
  transactionIds: string[],
) => {
  const transactionKeys = [...new Set(transactionIds.map(transactionKey).filter(Boolean))];
  const [transactions, normalMeanings, declarations] = await Promise.all([
    surrealSelectMany<EffectiveRow>(ctx, `
      SELECT
        record::id(id) AS transactionKey,
        description AS statementDescription,
        category.key AS normalCategoryKey,
        category.name AS normalCategoryName
      FROM transaction
      WHERE record::id(id) IN $transactionKeys;
    `, { transactionKeys }),
    surrealSelectMany<NormalMeaningRow>(ctx, `
      SELECT
        record::id(transaction) AS transactionKey,
        occurrenceLabel,
        purpose.name AS purposeName
      FROM transactionPurposeAssignment
      WHERE isCurrent = true
        AND state = 'confirmed'
        AND record::id(transaction) IN $transactionKeys;
    `, { transactionKeys }),
    surrealSelectMany<DeclarationRow>(ctx, `
      SELECT
        id,
        record::id(transaction) AS transactionKey,
        revision,
        state,
        taxDescription,
        evidenceStatus,
        taxCategory.key AS taxCategoryKey,
        taxCategory.name AS taxCategoryName,
        notes,
        recordedAt,
        reviewedAt
      FROM transactionTaxDeclaration
      WHERE isCurrent = true
        AND state = 'user_confirmed'
        AND record::id(transaction) IN $transactionKeys;
    `, { transactionKeys }),
  ]);

  const normalByTransaction = new Map(normalMeanings.map(row => [String(row.transactionKey), row]));
  const taxByTransaction = new Map(declarations.map(row => [String(row.transactionKey), row]));

  return transactions.map(row => {
    const key = String(row.transactionKey);
    const normal = normalByTransaction.get(key);
    const declaration = taxByTransaction.get(key) ?? null;
    const normalDescription = normal?.occurrenceLabel?.trim()
      || normal?.purposeName?.trim()
      || row.statementDescription;
    return {
      transactionId: `transaction:${key}`,
      normal: {
        description: normalDescription,
        categoryKey: row.normalCategoryKey ?? null,
        categoryName: row.normalCategoryName ?? null,
      },
      tax: {
        hasOverride: Boolean(declaration),
        description: declaration?.taxDescription?.trim() || normalDescription,
        categoryKey: declaration?.taxCategoryKey ?? row.normalCategoryKey ?? null,
        categoryName: declaration?.taxCategoryName ?? row.normalCategoryName ?? null,
        categorySource: declaration?.taxCategoryKey ? 'tax' : 'normal',
        declaration,
      },
    };
  });
};

const customTransactionTaxDeclarationRouter = t.router({
  effective: t.procedure
    .input(EffectiveInput)
    .query(async ({ input, ctx }) => getEffectiveRows(ctx, input.transactionIds)),

  current: t.procedure
    .input(TransactionInput)
    .query(async ({ input, ctx }) => {
      const rows = await getEffectiveRows(ctx, [input.transactionId]);
      return rows[0] ?? null;
    }),

  save: t.procedure
    .input(RequestSchema(SaveInput))
    .mutation(async ({ input, ctx }) => {
      const payload = input.data;
      if (!payload) throw new TRPCError({ code: 'BAD_REQUEST', message: 'Tax declaration payload is required.' });
      if (!payload.taxCategoryKey.trim() && !payload.taxDescription.trim()) {
        throw new TRPCError({ code: 'BAD_REQUEST', message: 'Add a tax category or tax description, or use normal inheritance.' });
      }

      const db = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : ctx.db;
      const scopedCtx = { ...ctx, db } as typeof ctx;
      const key = transactionKey(payload.transactionId);
      const transaction = await surrealSelectOne<{ id: string; space: string }>(scopedCtx, `
        SELECT id, space FROM ONLY type::record('transaction', $transactionKey);
      `, { transactionKey: key });
      if (!transaction) throw new TRPCError({ code: 'NOT_FOUND', message: 'The transaction no longer exists.' });

      const taxCategory = payload.taxCategoryKey.trim()
        ? await surrealSelectOne<{ id: string; key: string; name: string }>(scopedCtx, `
            SELECT id, key, name
            FROM taxCategory
            WHERE space = $spaceId AND key = $key AND active = true
            LIMIT 1;
          `, { spaceId: transaction.space, key: payload.taxCategoryKey.trim() })
        : null;
      if (payload.taxCategoryKey.trim() && !taxCategory) {
        throw new TRPCError({ code: 'BAD_REQUEST', message: `Tax category “${payload.taxCategoryKey}” does not exist in this Financial Space.` });
      }

      const now = new Date().toISOString();
      const response = await db.query(`
        BEGIN TRANSACTION;
        LET $transactionId = type::record('transaction', $transactionKey);
        LET $transaction = SELECT * FROM ONLY $transactionId;
        IF !$transaction { THROW 'TRANSACTION_NOT_FOUND'; };
        LET $revisions = SELECT VALUE revision FROM transactionTaxDeclaration WHERE transaction = $transaction.id;
        LET $revision = math::max(array::concat([0], $revisions)) + 1;
        LET $previous = array::first((SELECT * FROM transactionTaxDeclaration WHERE transaction = $transaction.id AND isCurrent = true ORDER BY revision DESC LIMIT 1));
        UPDATE transactionTaxDeclaration
          SET isCurrent = false,
              state = IF state IN ['user_confirmed', 'proposed'] { 'superseded' } ELSE { state }
          WHERE transaction = $transaction.id AND isCurrent = true;
        LET $declaration = fn::createTransactionTaxDeclaration({
          space: $transaction.space,
          transaction: $transaction.id,
          taxCategory: IF $taxCategoryId { $taxCategoryId } ELSE { NONE },
          revision: $revision,
          state: 'user_confirmed',
          isCurrent: true,
          declarationSource: 'manual',
          taxDescription: $taxDescription,
          evidenceStatus: $evidenceStatus,
          context: {},
          supersedes: IF $previous { $previous.id } ELSE { NONE },
          recordedAt: $recordedAt,
          reviewedAt: $recordedAt,
          notes: $notes
        });
        RETURN $declaration;
        COMMIT TRANSACTION;
      `, {
        transactionKey: key,
        taxCategoryId: taxCategory?.id ?? null,
        taxDescription: payload.taxDescription.trim(),
        evidenceStatus: payload.evidenceStatus,
        recordedAt: now,
        notes: payload.notes.trim(),
      });
      return ctx.LRS(response as any);
    }),

  inherit: t.procedure
    .input(RequestSchema(TransactionInput))
    .mutation(async ({ input, ctx }) => {
      const payload = input.data;
      if (!payload) throw new TRPCError({ code: 'BAD_REQUEST', message: 'Transaction identity is required.' });
      const db = input.instance && (ctx as any).$api?.DB
        ? await (ctx as any).$api.DB(input.instance as any)
        : ctx.db;
      const key = transactionKey(payload.transactionId);
      const response = await db.query(`
        BEGIN TRANSACTION;
        LET $transactionId = type::record('transaction', $transactionKey);
        LET $transaction = SELECT * FROM ONLY $transactionId;
        IF !$transaction { THROW 'TRANSACTION_NOT_FOUND'; };
        LET $revisions = SELECT VALUE revision FROM transactionTaxDeclaration WHERE transaction = $transaction.id;
        LET $revision = math::max(array::concat([0], $revisions)) + 1;
        LET $previous = array::first((SELECT * FROM transactionTaxDeclaration WHERE transaction = $transaction.id AND isCurrent = true ORDER BY revision DESC LIMIT 1));
        UPDATE transactionTaxDeclaration
          SET isCurrent = false,
              state = IF state IN ['user_confirmed', 'proposed'] { 'superseded' } ELSE { state }
          WHERE transaction = $transaction.id AND isCurrent = true;
        LET $inheritanceRecord = IF $previous {
          fn::createTransactionTaxDeclaration({
            space: $transaction.space,
            transaction: $transaction.id,
            revision: $revision,
            state: 'rejected',
            isCurrent: false,
            declarationSource: 'manual',
            taxDescription: '',
            evidenceStatus: 'not_assessed',
            context: { action: 'inherit_normal' },
            supersedes: $previous.id,
            recordedAt: $recordedAt,
            reviewedAt: $recordedAt,
            notes: 'Returned to normal-classification inheritance.'
          })
        } ELSE { NONE };
        RETURN $inheritanceRecord;
        COMMIT TRANSACTION;
      `, { transactionKey: key, recordedAt: new Date().toISOString() });
      return ctx.LRS(response as any);
    }),
});

export const transactionTaxDeclarationRouter = t.mergeRouters(generatedTransactionTaxDeclarationRouter, customTransactionTaxDeclarationRouter);
export type TransactionTaxDeclarationRouter = typeof transactionTaxDeclarationRouter;
