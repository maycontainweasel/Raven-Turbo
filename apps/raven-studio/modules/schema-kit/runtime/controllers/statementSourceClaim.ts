import { createGeneratedStatementSourceClaimController, type StatementSourceClaimController } from './generated/statementSourceClaim'
import { mergeController } from './_shared'
import { extendStatementSourceClaimController } from '@schema/custom-controllers/statementSourceClaim'

export function createStatementSourceClaimController(): StatementSourceClaimController {
  const base = createGeneratedStatementSourceClaimController()
  return mergeController(base, extendStatementSourceClaimController)
}

export type { StatementSourceClaimController }
