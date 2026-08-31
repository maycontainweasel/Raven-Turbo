import { createGeneratedStatementReconciliationEventController, type StatementReconciliationEventController } from './generated/statementReconciliationEvent'
import { mergeController } from './_shared'
import { extendStatementReconciliationEventController } from '@schema/custom-controllers/statementReconciliationEvent'

export function createStatementReconciliationEventController(): StatementReconciliationEventController {
  const base = createGeneratedStatementReconciliationEventController()
  return mergeController(base, extendStatementReconciliationEventController)
}

export type { StatementReconciliationEventController }
