import { createGeneratedStatementLegacyResolutionController, type StatementLegacyResolutionController } from './generated/statementLegacyResolution'
import { mergeController } from './_shared'
import { extendStatementLegacyResolutionController } from '@schema/custom-controllers/statementLegacyResolution'

export function createStatementLegacyResolutionController(): StatementLegacyResolutionController {
  const base = createGeneratedStatementLegacyResolutionController()
  return mergeController(base, extendStatementLegacyResolutionController)
}

export type { StatementLegacyResolutionController }
