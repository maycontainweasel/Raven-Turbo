import { createGeneratedStatementTransactionResolutionClaimController, type StatementTransactionResolutionClaimController } from './generated/statementTransactionResolutionClaim'
import { mergeController } from './_shared'
import { extendStatementTransactionResolutionClaimController } from '@schema/custom-controllers/statementTransactionResolutionClaim'

export function createStatementTransactionResolutionClaimController(): StatementTransactionResolutionClaimController {
  const base = createGeneratedStatementTransactionResolutionClaimController()
  return mergeController(base, extendStatementTransactionResolutionClaimController)
}

export type { StatementTransactionResolutionClaimController }
