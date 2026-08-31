import type {
  AccountTransferRecord,
  CategoryRecord,
  CategoryView,
  FinancialOperationRecord,
  ManagementMeaningState,
  TaxMeaningState,
  TransactionDetailView,
  TransactionEvidenceState,
  TransactionRecord,
  TransactionView,
} from "./contracts.js";
import { RavenDomainError, type RavenWarningCode } from "./errors.js";
import { money } from "./money.js";

const DATE_PATTERN = /^(\d{4})-(\d{2})-(\d{2})$/;
const MONTH_PATTERN = /^(\d{4})-(\d{2})$/;

export function normalizeFinancialDate(value: string): string {
  const trimmed = value.trim();
  const match = DATE_PATTERN.exec(trimmed);
  if (!match) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial date must use YYYY-MM-DD",
    );
  }
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const date = new Date(Date.UTC(year, month - 1, day));
  if (
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Financial date is not a valid calendar date",
    );
  }
  return trimmed;
}

export function normalizeLegacyFinancialDate(value: unknown): string | null {
  const leading = /^(\d{4}-\d{2}-\d{2})/.exec(String(value ?? "").trim())?.[1];
  if (!leading) return null;
  try {
    return normalizeFinancialDate(leading);
  } catch {
    return null;
  }
}

export function normalizeMonth(value: string): string {
  const trimmed = value.trim();
  const match = MONTH_PATTERN.exec(trimmed);
  if (!match || Number(match[2]) < 1 || Number(match[2]) > 12) {
    throw new RavenDomainError(
      "INVALID_TRANSACTION_DATE",
      "Month must use YYYY-MM",
    );
  }
  return trimmed;
}

export function transactionWarnings(
  records: readonly TransactionRecord[],
): RavenWarningCode[] {
  return [...new Set(records.flatMap((record) => record.warnings))];
}

export function toCategoryView(category: CategoryRecord): CategoryView {
  return {
    key: category.key,
    name: category.name,
    kind: category.kind,
    parent:
      category.parentKey && category.parentName
        ? { key: category.parentKey, name: category.parentName }
        : null,
  };
}

export function transactionEvidenceState(
  record: TransactionRecord,
): TransactionEvidenceState {
  if (
    record.statementMatchId &&
    record.statementMatchState === "confirmed" &&
    record.statementMatchSourceState === "committed" &&
    record.statementImportSourceState === "committed"
  ) {
    return "statement_backed";
  }
  if (
    record.entrySource === "manual" ||
    record.entrySource === "generated" ||
    record.operationId ||
    record.transferId
  ) {
    return "provisional";
  }
  return "unresolved";
}

export function transactionManagementMeaningState(
  record: TransactionRecord,
): ManagementMeaningState {
  if (record.categoryKind === "tax") return "needs_clarification";
  if (record.categoryKey && record.categoryName && record.categoryKind) {
    return "classified";
  }
  return "unclassified";
}

export function transactionTaxMeaningState(): TaxMeaningState {
  return "not_assessed";
}

export function transactionFinancialDate(
  record: TransactionRecord,
): string | null {
  return record.statementMatchId
    ? (record.effectiveAt ?? record.postedAt)
    : record.postedAt;
}

export function transactionLedgerAuthority(
  record: TransactionRecord,
): NonNullable<TransactionRecord["ledgerAuthority"]> {
  if (record.ledgerAuthority) return record.ledgerAuthority;
  if (record.entrySource !== "imported" || !record.sourceRowId) return "active";
  const hasCanonicalStatementMatchHistory =
    record.hasCanonicalStatementMatchHistory === true ||
    (Boolean(record.statementMatchId) &&
      (record.statementMatchState === "confirmed" ||
        record.statementMatchState === "superseded") &&
      (record.statementMatchSourceState === "committed" ||
        record.statementMatchSourceState === "superseded"));
  return hasCanonicalStatementMatchHistory
    ? "canonical_historical_superseded"
    : "legacy_unreconciled";
}

export function toTransactionView(record: TransactionRecord): TransactionView {
  return {
    id: record.id,
    account: { spaceKey: record.spaceKey, accountKey: record.accountKey },
    financialDate: transactionFinancialDate(record),
    observationDate: record.postedAt,
    financialDateProvenance:
      record.statementMatchId && record.effectiveAt
        ? "statement_source"
        : "observation",
    recordedAt: record.recordedAt,
    description: record.description,
    amount:
      record.amountMinor === null
        ? null
        : money(
            { currency: record.currency, minorUnits: record.amountMinor },
            { nonNegative: true },
          ),
    reportedBalance:
      record.reportedBalanceMinor === null ||
      record.reportedBalanceMinor === undefined
        ? null
        : money({
            currency: record.currency,
            minorUnits: record.reportedBalanceMinor,
          }),
    kind: record.kind,
    flowDirection: record.flowDirection,
    entrySource: record.entrySource,
    status: record.status,
    evidenceState: transactionEvidenceState(record),
    ledgerAuthority: transactionLedgerAuthority(record),
    managementMeaningState: transactionManagementMeaningState(record),
    taxMeaningState: transactionTaxMeaningState(),
    category:
      record.categoryKey && record.categoryName && record.categoryKind
        ? {
            key: record.categoryKey,
            name: record.categoryName,
            kind: record.categoryKind,
          }
        : null,
    merchantName: record.merchantName ?? null,
    transferId: record.transferId ?? null,
    warnings: record.warnings,
  };
}

export function toTransactionDetailView(
  record: TransactionRecord,
  operation: FinancialOperationRecord | null,
  transfer: AccountTransferRecord | null,
  clarifications: TransactionDetailView["clarifications"],
): TransactionDetailView {
  const counterpart = transfer
    ? record.id === transfer.sourceTransactionId
      ? { ref: transfer.target, transactionId: transfer.targetTransactionId }
      : { ref: transfer.source, transactionId: transfer.sourceTransactionId }
    : null;
  return {
    ...toTransactionView(record),
    notes: record.notes ?? null,
    provenance: {
      sourceRowId: record.sourceRowId ?? null,
      statementMatchId: record.statementMatchId ?? null,
      statementImportId: record.statementImportId ?? null,
      entrySource: record.entrySource,
      observationDate: record.postedAt,
      statementFinancialDate: record.effectiveAt ?? null,
    },
    operation: operation
      ? {
          id: operation.id,
          command: operation.command,
          recordedAt: operation.recordedAt,
        }
      : null,
    transfer:
      transfer && counterpart
        ? {
            id: transfer.id,
            counterpart: {
              spaceKey: counterpart.ref.spaceKey,
              accountKey: counterpart.ref.accountKey,
            },
            counterpartTransactionId: counterpart.transactionId,
          }
        : null,
    clarifications,
  };
}
