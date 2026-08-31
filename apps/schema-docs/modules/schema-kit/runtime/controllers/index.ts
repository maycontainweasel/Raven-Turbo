import { createAccountController } from './account'
import { createAccountBalanceSnapshotController } from './accountBalanceSnapshot'
import { createAccountFacilitySnapshotController } from './accountFacilitySnapshot'
import { createAccountTransferController } from './accountTransfer'
import { createCashflowOccurrenceController } from './cashflowOccurrence'
import { createCashflowScheduleController } from './cashflowSchedule'
import { createCategoryController } from './category'
import { createClarificationTaskController } from './clarificationTask'
import { createClassificationRuleController } from './classificationRule'
import { createClientController } from './client'
import { createFinancialOperationController } from './financialOperation'
import { createFinancialSpaceController } from './financialSpace'
import { createHostingProviderController } from './hostingProvider'
import { createMerchantController } from './merchant'
import { createMonthlySnapshotController } from './monthlySnapshot'
import { createRetainerController } from './retainer'
import { createStatementComponentResolutionClaimController } from './statementComponentResolutionClaim'
import { createStatementImportController } from './statementImport'
import { createStatementIssueController } from './statementIssue'
import { createStatementLegacyResolutionController } from './statementLegacyResolution'
import { createStatementLegacyResolutionItemController } from './statementLegacyResolutionItem'
import { createStatementPeriodClaimController } from './statementPeriodClaim'
import { createStatementReconciliationController } from './statementReconciliation'
import { createStatementReconciliationEventController } from './statementReconciliationEvent'
import { createStatementRowController } from './statementRow'
import { createStatementRowComponentController } from './statementRowComponent'
import { createStatementSourceClaimController } from './statementSourceClaim'
import { createStatementTransactionMatchController } from './statementTransactionMatch'
import { createStatementTransactionResolutionClaimController } from './statementTransactionResolutionClaim'
import { createTransactionController } from './transaction'
import { createUserController } from './user'
import type { AccountController } from './account'
import type { AccountBalanceSnapshotController } from './accountBalanceSnapshot'
import type { AccountFacilitySnapshotController } from './accountFacilitySnapshot'
import type { AccountTransferController } from './accountTransfer'
import type { CashflowOccurrenceController } from './cashflowOccurrence'
import type { CashflowScheduleController } from './cashflowSchedule'
import type { CategoryController } from './category'
import type { ClarificationTaskController } from './clarificationTask'
import type { ClassificationRuleController } from './classificationRule'
import type { ClientController } from './client'
import type { FinancialOperationController } from './financialOperation'
import type { FinancialSpaceController } from './financialSpace'
import type { HostingProviderController } from './hostingProvider'
import type { MerchantController } from './merchant'
import type { MonthlySnapshotController } from './monthlySnapshot'
import type { RetainerController } from './retainer'
import type { StatementComponentResolutionClaimController } from './statementComponentResolutionClaim'
import type { StatementImportController } from './statementImport'
import type { StatementIssueController } from './statementIssue'
import type { StatementLegacyResolutionController } from './statementLegacyResolution'
import type { StatementLegacyResolutionItemController } from './statementLegacyResolutionItem'
import type { StatementPeriodClaimController } from './statementPeriodClaim'
import type { StatementReconciliationController } from './statementReconciliation'
import type { StatementReconciliationEventController } from './statementReconciliationEvent'
import type { StatementRowController } from './statementRow'
import type { StatementRowComponentController } from './statementRowComponent'
import type { StatementSourceClaimController } from './statementSourceClaim'
import type { StatementTransactionMatchController } from './statementTransactionMatch'
import type { StatementTransactionResolutionClaimController } from './statementTransactionResolutionClaim'
import type { TransactionController } from './transaction'
import type { UserController } from './user'

export type ControllersMap = {
  account: AccountController;
  accountBalanceSnapshot: AccountBalanceSnapshotController;
  accountFacilitySnapshot: AccountFacilitySnapshotController;
  accountTransfer: AccountTransferController;
  cashflowOccurrence: CashflowOccurrenceController;
  cashflowSchedule: CashflowScheduleController;
  category: CategoryController;
  clarificationTask: ClarificationTaskController;
  classificationRule: ClassificationRuleController;
  client: ClientController;
  financialOperation: FinancialOperationController;
  financialSpace: FinancialSpaceController;
  hostingProvider: HostingProviderController;
  merchant: MerchantController;
  monthlySnapshot: MonthlySnapshotController;
  retainer: RetainerController;
  statementComponentResolutionClaim: StatementComponentResolutionClaimController;
  statementImport: StatementImportController;
  statementIssue: StatementIssueController;
  statementLegacyResolution: StatementLegacyResolutionController;
  statementLegacyResolutionItem: StatementLegacyResolutionItemController;
  statementPeriodClaim: StatementPeriodClaimController;
  statementReconciliation: StatementReconciliationController;
  statementReconciliationEvent: StatementReconciliationEventController;
  statementRow: StatementRowController;
  statementRowComponent: StatementRowComponentController;
  statementSourceClaim: StatementSourceClaimController;
  statementTransactionMatch: StatementTransactionMatchController;
  statementTransactionResolutionClaim: StatementTransactionResolutionClaimController;
  transaction: TransactionController;
  user: UserController;
}

export function createControllers(): ControllersMap {
  return {
  account: createAccountController(),
  accountBalanceSnapshot: createAccountBalanceSnapshotController(),
  accountFacilitySnapshot: createAccountFacilitySnapshotController(),
  accountTransfer: createAccountTransferController(),
  cashflowOccurrence: createCashflowOccurrenceController(),
  cashflowSchedule: createCashflowScheduleController(),
  category: createCategoryController(),
  clarificationTask: createClarificationTaskController(),
  classificationRule: createClassificationRuleController(),
  client: createClientController(),
  financialOperation: createFinancialOperationController(),
  financialSpace: createFinancialSpaceController(),
  hostingProvider: createHostingProviderController(),
  merchant: createMerchantController(),
  monthlySnapshot: createMonthlySnapshotController(),
  retainer: createRetainerController(),
  statementComponentResolutionClaim: createStatementComponentResolutionClaimController(),
  statementImport: createStatementImportController(),
  statementIssue: createStatementIssueController(),
  statementLegacyResolution: createStatementLegacyResolutionController(),
  statementLegacyResolutionItem: createStatementLegacyResolutionItemController(),
  statementPeriodClaim: createStatementPeriodClaimController(),
  statementReconciliation: createStatementReconciliationController(),
  statementReconciliationEvent: createStatementReconciliationEventController(),
  statementRow: createStatementRowController(),
  statementRowComponent: createStatementRowComponentController(),
  statementSourceClaim: createStatementSourceClaimController(),
  statementTransactionMatch: createStatementTransactionMatchController(),
  statementTransactionResolutionClaim: createStatementTransactionResolutionClaimController(),
  transaction: createTransactionController(),
  user: createUserController(),
  }
}
