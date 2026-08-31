import { createGeneratedStatementRowComponentController, type StatementRowComponentController } from './generated/statementRowComponent'
import { mergeController } from './_shared'
import { extendStatementRowComponentController } from '@schema/custom-controllers/statementRowComponent'

export function createStatementRowComponentController(): StatementRowComponentController {
  const base = createGeneratedStatementRowComponentController()
  return mergeController(base, extendStatementRowComponentController)
}

export type { StatementRowComponentController }
