import type {
  AccountRecord,
  CategoryRecord,
  TransactionRecord,
} from "./contracts.js";
import type { FinancialAnalyticsAuthorityScope } from "./financial-analytics-contracts.js";

export type FinancialAnalyticsTransactionFilter = Readonly<{
  accountIds: string[];
  currency: string;
  authorityScope: FinancialAnalyticsAuthorityScope;
  from: string;
  through: string;
}>;

export interface FinancialAnalyticsRepository {
  listAccounts(spaceKeys?: string[]): Promise<AccountRecord[]>;
  listCategories(spaceKey: string): Promise<CategoryRecord[]>;
  listFinancialAnalyticsTransactions(
    filter: FinancialAnalyticsTransactionFilter,
  ): Promise<TransactionRecord[]>;
}
