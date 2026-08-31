import { createGeneratedStatementReconciliationController, type StatementReconciliationController } from './generated/statementReconciliation'
import { mergeController } from './_shared'
import { extendStatementReconciliationController } from '@schema/custom-controllers/statementReconciliation'

export function createStatementReconciliationController(): StatementReconciliationController {
  const base = createGeneratedStatementReconciliationController()
  return mergeController(base, extendStatementReconciliationController)
}

export type { StatementReconciliationController }
