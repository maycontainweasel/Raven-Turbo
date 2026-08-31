import { createGeneratedStatementComponentResolutionClaimController, type StatementComponentResolutionClaimController } from './generated/statementComponentResolutionClaim'
import { mergeController } from './_shared'
import { extendStatementComponentResolutionClaimController } from '@schema/custom-controllers/statementComponentResolutionClaim'

export function createStatementComponentResolutionClaimController(): StatementComponentResolutionClaimController {
  const base = createGeneratedStatementComponentResolutionClaimController()
  return mergeController(base, extendStatementComponentResolutionClaimController)
}

export type { StatementComponentResolutionClaimController }
