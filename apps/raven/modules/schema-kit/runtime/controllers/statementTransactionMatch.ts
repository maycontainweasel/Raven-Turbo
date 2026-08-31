import { createGeneratedStatementTransactionMatchController, type StatementTransactionMatchController } from './generated/statementTransactionMatch'
import { mergeController } from './_shared'
import { extendStatementTransactionMatchController } from '@schema/custom-controllers/statementTransactionMatch'

export function createStatementTransactionMatchController(): StatementTransactionMatchController {
  const base = createGeneratedStatementTransactionMatchController()
  return mergeController(base, extendStatementTransactionMatchController)
}

export type { StatementTransactionMatchController }
