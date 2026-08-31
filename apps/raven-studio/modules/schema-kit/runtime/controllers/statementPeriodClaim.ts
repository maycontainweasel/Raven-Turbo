import { createGeneratedStatementPeriodClaimController, type StatementPeriodClaimController } from './generated/statementPeriodClaim'
import { mergeController } from './_shared'
import { extendStatementPeriodClaimController } from '@schema/custom-controllers/statementPeriodClaim'

export function createStatementPeriodClaimController(): StatementPeriodClaimController {
  const base = createGeneratedStatementPeriodClaimController()
  return mergeController(base, extendStatementPeriodClaimController)
}

export type { StatementPeriodClaimController }
