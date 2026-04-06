import { z } from 'zod';
import { t } from '@schema/server/trpc/context';
import { accountRouter as generatedAccountRouter } from './generated/account';
import { surrealSelectMany, surrealSelectOne } from './_surreal';

const AccountExplorerInput = z.object({
  spaceKey: z.string().min(1),
  accountKey: z.string().min(1),
});

const AccountMonthInput = AccountExplorerInput.extend({
  month: z.string().regex(/^\d{4}-\d{2}$/),
});

type TransferLikeRow = {
  id: string;
  postedAt: string;
  amount: number;
  direction: 'credit' | 'debit' | 'transfer';
  description: string;
  normalizedDescription?: string | null;
  merchantName?: string | null;
  categoryKey?: string | null;
  categoryName?: string | null;
  notes?: string | null;
  rawRowText?: string | null;
  accountId?: string | null;
  accountKey?: string | null;
  accountName?: string | null;
  accountType?: string | null;
  accountLast4?: string | null;
  spaceKey?: string | null;
  spaceName?: string | null;
};

const startOfMonth = (month: string) => new Date(`${month}-01T00:00:00.000Z`);

const addDays = (value: Date, days: number) => {
  const next = new Date(value);
  next.setUTCDate(next.getUTCDate() + days);
  return next;
};

const addMonths = (value: Date, months: number) => {
  const next = new Date(value);
  next.setUTCMonth(next.getUTCMonth() + months);
  return next;
};

const isoDate = (value: Date) => value.toISOString().slice(0, 10);

const normalize = (value: string | null | undefined) =>
  String(value || '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, ' ')
    .trim();

const buildTransferText = (row: TransferLikeRow) =>
  normalize([
    row.description,
    row.normalizedDescription,
    row.merchantName,
    row.categoryName,
    row.notes,
    row.rawRowText,
    row.accountName,
    row.accountKey,
    row.accountLast4,
  ].filter(Boolean).join(' '));

const inferTransferKind = (source: TransferLikeRow, candidate?: TransferLikeRow | null) => {
  const sourceText = buildTransferText(source);
  const candidateText = candidate ? buildTransferText(candidate) : '';
  const combinedText = `${sourceText} ${candidateText}`.trim();

  if (combinedText.includes('credit card') || combinedText.includes('credit crd') || combinedText.includes('debt payment')) {
    return 'debt_payment';
  }

  if (combinedText.includes('cash advance')) {
    return 'cash_advance';
  }

  if (candidate && source.spaceKey && candidate.spaceKey && source.spaceKey !== candidate.spaceKey) {
    return 'cross_environment_transfer';
  }

  return 'internal_transfer';
};

const scoreTransferMatch = (source: TransferLikeRow, candidate: TransferLikeRow) => {
  if (source.id === candidate.id) return -1;

  const amountDelta = Math.abs(Math.abs(source.amount) - Math.abs(candidate.amount));
  if (amountDelta > 0.01) return -1;

  const sourceDate = new Date(source.postedAt);
  const candidateDate = new Date(candidate.postedAt);
  const dayDelta = Math.abs(Math.round((candidateDate.getTime() - sourceDate.getTime()) / 86400000));
  if (dayDelta > 3) return -1;

  let score = 60;
  if (dayDelta === 0) score += 16;
  else if (dayDelta === 1) score += 12;
  else if (dayDelta === 2) score += 8;
  else score += 4;

  const sourceText = buildTransferText(source);
  const candidateText = buildTransferText(candidate);

  const sourceMentionsCandidateAccount =
    (candidate.accountLast4 && sourceText.includes(normalize(candidate.accountLast4))) ||
    (candidate.accountName && sourceText.includes(normalize(candidate.accountName))) ||
    (candidate.accountKey && sourceText.includes(normalize(candidate.accountKey)));

  const candidateMentionsSourceAccount =
    (source.accountLast4 && candidateText.includes(normalize(source.accountLast4))) ||
    (source.accountName && candidateText.includes(normalize(source.accountName))) ||
    (source.accountKey && candidateText.includes(normalize(source.accountKey)));

  if (sourceMentionsCandidateAccount) score += 18;
  if (candidateMentionsSourceAccount) score += 18;

  if (source.categoryKey && candidate.categoryKey && source.categoryKey === candidate.categoryKey) {
    score += 8;
  }

  const inferredKind = inferTransferKind(source, candidate);
  if (inferredKind === 'debt_payment') score += 10;
  if (inferredKind === 'cash_advance') score += 6;

  if (source.spaceKey && candidate.spaceKey && source.spaceKey !== candidate.spaceKey) {
    score += 4;
  }

  if (source.accountType === 'credit_card' || candidate.accountType === 'credit_card') {
    score += 5;
  }

  let confidence: 'high' | 'medium' | 'low' = 'low';
  if (score >= 94) confidence = 'high';
  else if (score >= 78) confidence = 'medium';

  return {
    score,
    confidence,
    dayDelta,
    inferredKind,
    amountDelta,
    reason: sourceMentionsCandidateAccount || candidateMentionsSourceAccount
      ? 'Matched amount and date window, with account references in the statement text.'
      : 'Matched amount and date window across another tracked account.',
  };
};

const customAccountRouter = t.router({
  explorer: t.procedure
    .input(AccountExplorerInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          account: null,
          statementImports: [],
          months: [],
          openClarificationCount: 0,
        };
      }

      const account = await surrealSelectOne<{
        id: string;
        key: string;
        name: string;
        bankName: string;
        accountType: string;
        currency: string;
        accountNumberLast4?: string | null;
        openingBalance?: number | null;
        active: boolean;
        notes?: string | null;
      }>(
        ctx,
        `
          SELECT id, key, name, bankName, accountType, currency, accountNumberLast4, openingBalance, active, notes
          FROM account
          WHERE key = $accountKey AND space = $spaceId
          LIMIT 1;
        `,
        {
          spaceId: space.id,
          accountKey: input.accountKey,
        },
      );

      if (!account) {
        return {
          account: null,
          statementImports: [],
          months: [],
          openClarificationCount: 0,
        };
      }

      const statementImports = await surrealSelectMany<{
        id: string;
        key: string;
        statementDate: string;
        sourceFileName: string;
        rowCount: number;
        normalizedCount: number;
        clarificationCount: number;
        status: string;
      }>(
        ctx,
        `
          SELECT id, key, statementDate, sourceFileName, rowCount, normalizedCount, clarificationCount, status
          FROM statementImport
          WHERE account = $accountId
          ORDER BY statementDate DESC;
        `,
        { accountId: account.id },
      );

      const monthDirectionRows = await surrealSelectMany<{
        month: string;
        direction: 'credit' | 'debit' | 'transfer';
        total: number;
        amountTotal: number;
      }>(
        ctx,
        `
          SELECT string::slice(postedAt, 0, 7) AS month, direction, count() AS total, math::sum(amount) AS amountTotal
          FROM transaction
          WHERE account = $accountId
          GROUP BY month, direction
          ORDER BY month DESC, direction;
        `,
        { accountId: account.id },
      );

      const clarificationCountRows = await surrealSelectMany<{ openClarificationCount?: number }>(
        ctx,
        `
          SELECT count() AS openClarificationCount
          FROM clarificationTask
          WHERE transaction.account = $accountId AND status = 'open'
          GROUP ALL;
        `,
        { accountId: account.id },
      );

      const monthMap = new Map<string, {
        month: string;
        income: number;
        outgoing: number;
        transfers: number;
        transactionCount: number;
        creditCount: number;
        debitCount: number;
        transferCount: number;
        net: number;
      }>();

      for (const row of monthDirectionRows) {
        const current = monthMap.get(row.month) || {
          month: row.month,
          income: 0,
          outgoing: 0,
          transfers: 0,
          transactionCount: 0,
          creditCount: 0,
          debitCount: 0,
          transferCount: 0,
          net: 0,
        };

        if (row.direction === 'credit') {
          current.income = row.amountTotal ?? 0;
          current.creditCount = row.total ?? 0;
        } else if (row.direction === 'transfer') {
          current.transfers = row.amountTotal ?? 0;
          current.transferCount = row.total ?? 0;
        } else {
          current.outgoing = row.amountTotal ?? 0;
          current.debitCount = row.total ?? 0;
        }

        current.transactionCount = current.creditCount + current.debitCount + current.transferCount;
        current.net = current.income - current.outgoing - current.transfers;
        monthMap.set(row.month, current);
      }

      return {
        account,
        statementImports,
        months: Array.from(monthMap.values()).sort((left, right) => right.month.localeCompare(left.month)),
        openClarificationCount: clarificationCountRows[0]?.openClarificationCount ?? 0,
      };
    }),
  month: t.procedure
    .input(AccountMonthInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          categories: [],
          transactions: [],
          openClarificationCount: 0,
        };
      }

      const account = await surrealSelectOne<{ id: string }>(
        ctx,
        `
          SELECT id
          FROM account
          WHERE key = $accountKey AND space = $spaceId
          LIMIT 1;
        `,
        {
          spaceId: space.id,
          accountKey: input.accountKey,
        },
      );

      if (!account) {
        return {
          categories: [],
          transactions: [],
          openClarificationCount: 0,
        };
      }

      const categories = await surrealSelectMany<{
        category: string;
        categoryKey?: string | null;
        categoryName?: string | null;
        total: number;
        amountTotal: number;
      }>(
        ctx,
        `
          SELECT category, category.name AS categoryName, category.key AS categoryKey, count() AS total, math::sum(amount) AS amountTotal
          FROM transaction
          WHERE account = $accountId AND string::slice(postedAt, 0, 7) = $month
          GROUP BY category, categoryName, categoryKey
          ORDER BY amountTotal DESC;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      const transactions = await surrealSelectMany<{
        id: string;
        postedAt: string;
        description: string;
        normalizedDescription?: string | null;
        amount: number;
        balance?: number | null;
        direction: 'credit' | 'debit' | 'transfer';
        status: string;
        merchantName?: string | null;
        category?: string | null;
        categoryKey?: string | null;
        categoryName?: string | null;
        notes?: string | null;
        rowNumber?: number | null;
        bankChargeZar?: number | null;
        rawRowText?: string | null;
      }>(
        ctx,
        `
          SELECT id, postedAt, description, normalizedDescription, amount, balance, direction, status, merchantName, category, category.name AS categoryName, category.key AS categoryKey, notes, sourceRow.rowNumber AS rowNumber, sourceRow.rawData.bankChargeZar AS bankChargeZar, sourceRow.rawData.rawRowText AS rawRowText
          FROM transaction
          WHERE account = $accountId AND string::slice(postedAt, 0, 7) = $month
          ORDER BY postedAt DESC, rowNumber DESC, id DESC;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      const clarificationCounts = await surrealSelectMany<{ openClarificationCount?: number }>(
        ctx,
        `
          SELECT count() AS openClarificationCount
          FROM clarificationTask
          WHERE transaction.account = $accountId AND string::slice(transaction.postedAt, 0, 7) = $month AND status = 'open'
          GROUP ALL;
        `,
        {
          accountId: account.id,
          month: input.month,
        },
      );

      return {
        categories,
        transactions,
        openClarificationCount: clarificationCounts[0]?.openClarificationCount ?? 0,
      };
    }),
  transferMatches: t.procedure
    .input(AccountMonthInput)
    .query(async ({ input, ctx }) => {
      const space = await surrealSelectOne<{ id: string; key: string; name: string }>(
        ctx,
        `
          SELECT id, key, name
          FROM financialSpace
          WHERE key = $spaceKey AND active = true
          LIMIT 1;
        `,
        { spaceKey: input.spaceKey },
      );

      if (!space) {
        return {
          summary: {
            transferCount: 0,
            matchedCount: 0,
            unmatchedCount: 0,
            matchedAmount: 0,
            unmatchedAmount: 0,
          },
          matches: [],
        };
      }

      const account = await surrealSelectOne<{
        id: string;
        key: string;
        name: string;
        accountType: string;
        accountNumberLast4?: string | null;
      }>(
        ctx,
        `
          SELECT id, key, name, accountType, accountNumberLast4
          FROM account
          WHERE key = $accountKey AND space = $spaceId
          LIMIT 1;
        `,
        {
          spaceId: space.id,
          accountKey: input.accountKey,
        },
      );

      if (!account) {
        return {
          summary: {
            transferCount: 0,
            matchedCount: 0,
            unmatchedCount: 0,
            matchedAmount: 0,
            unmatchedAmount: 0,
          },
          matches: [],
        };
      }

      const monthStart = startOfMonth(input.month);
      const rangeStart = isoDate(addDays(monthStart, -3));
      const rangeEnd = isoDate(addDays(addMonths(monthStart, 1), 3));

      const transferRows = await surrealSelectMany<TransferLikeRow>(
        ctx,
        `
          SELECT id, postedAt, amount, direction, description, normalizedDescription, merchantName, category.key AS categoryKey, category.name AS categoryName, notes, sourceRow.rawData.rawRowText AS rawRowText, account.id AS accountId, account.key AS accountKey, account.name AS accountName, account.accountType AS accountType, account.accountNumberLast4 AS accountLast4, space.key AS spaceKey, space.name AS spaceName
          FROM transaction
          WHERE postedAt >= <datetime>($rangeStart + "T00:00:00Z")
            AND postedAt <= <datetime>($rangeEnd + "T23:59:59Z")
            AND (direction = "transfer" OR isTransfer = true OR category.categoryKind = "transfer")
          ORDER BY postedAt DESC, id DESC;
        `,
        {
          rangeStart,
          rangeEnd,
        },
      );

      const sourceTransfers = transferRows.filter(row =>
        row.accountId === account.id && String(row.postedAt || '').slice(0, 7) === input.month,
      );

      const candidateTransfers = transferRows.filter(row => row.accountId !== account.id);

      const matches = sourceTransfers
        .map(source => {
          const candidates = candidateTransfers
            .map(candidate => {
              const scored = scoreTransferMatch(
                {
                  ...source,
                  accountType: source.accountType || account.accountType,
                  accountLast4: source.accountLast4 || account.accountNumberLast4,
                  accountName: source.accountName || account.name,
                  accountKey: source.accountKey || account.key,
                  spaceKey: source.spaceKey || space.key,
                  spaceName: source.spaceName || space.name,
                },
                candidate,
              );

              if (!scored || scored.score < 0) return null;

              return {
                candidate,
                ...scored,
              };
            })
            .filter(Boolean)
            .sort((left, right) => (right?.score ?? 0) - (left?.score ?? 0))
            .slice(0, 3);

          const bestMatch = candidates[0] || null;

          return {
            source: {
              id: source.id,
              postedAt: source.postedAt,
              amount: source.amount,
              description: source.description,
              merchantName: source.merchantName || null,
              categoryKey: source.categoryKey || null,
              categoryName: source.categoryName || null,
              notes: source.notes || null,
              rawRowText: source.rawRowText || null,
              accountKey: source.accountKey || account.key,
              accountName: source.accountName || account.name,
              spaceKey: source.spaceKey || space.key,
              spaceName: source.spaceName || space.name,
            },
            bestMatch: bestMatch
              ? {
                  confidence: bestMatch.confidence,
                  score: bestMatch.score,
                  dayDelta: bestMatch.dayDelta,
                  inferredKind: bestMatch.inferredKind,
                  reason: bestMatch.reason,
                  candidate: {
                    id: bestMatch.candidate.id,
                    postedAt: bestMatch.candidate.postedAt,
                    amount: bestMatch.candidate.amount,
                    description: bestMatch.candidate.description,
                    merchantName: bestMatch.candidate.merchantName || null,
                    categoryKey: bestMatch.candidate.categoryKey || null,
                    categoryName: bestMatch.candidate.categoryName || null,
                    accountKey: bestMatch.candidate.accountKey || null,
                    accountName: bestMatch.candidate.accountName || null,
                    accountType: bestMatch.candidate.accountType || null,
                    accountLast4: bestMatch.candidate.accountLast4 || null,
                    spaceKey: bestMatch.candidate.spaceKey || null,
                    spaceName: bestMatch.candidate.spaceName || null,
                  },
                }
              : null,
            candidates: candidates.map(item => ({
              confidence: item?.confidence,
              score: item?.score,
              dayDelta: item?.dayDelta,
              inferredKind: item?.inferredKind,
              reason: item?.reason,
              candidate: {
                id: item?.candidate.id,
                postedAt: item?.candidate.postedAt,
                amount: item?.candidate.amount,
                description: item?.candidate.description,
                merchantName: item?.candidate.merchantName || null,
                categoryKey: item?.candidate.categoryKey || null,
                categoryName: item?.candidate.categoryName || null,
                accountKey: item?.candidate.accountKey || null,
                accountName: item?.candidate.accountName || null,
                accountType: item?.candidate.accountType || null,
                accountLast4: item?.candidate.accountLast4 || null,
                spaceKey: item?.candidate.spaceKey || null,
                spaceName: item?.candidate.spaceName || null,
              },
            })),
          };
        })
        .sort((left, right) => right.source.postedAt.localeCompare(left.source.postedAt));

      const matchedRows = matches.filter(row => row.bestMatch);
      const unmatchedRows = matches.filter(row => !row.bestMatch);

      return {
        summary: {
          transferCount: matches.length,
          matchedCount: matchedRows.length,
          unmatchedCount: unmatchedRows.length,
          matchedAmount: matchedRows.reduce((total, row) => total + Math.abs(row.source.amount || 0), 0),
          unmatchedAmount: unmatchedRows.reduce((total, row) => total + Math.abs(row.source.amount || 0), 0),
        },
        matches,
      };
    }),
});

export const accountRouter = t.mergeRouters(generatedAccountRouter, customAccountRouter);
export type AccountRouter = typeof accountRouter;
