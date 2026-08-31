import { createGeneratedStatementLegacyResolutionItemController, type StatementLegacyResolutionItemController } from './generated/statementLegacyResolutionItem'
import { mergeController } from './_shared'
import { extendStatementLegacyResolutionItemController } from '@schema/custom-controllers/statementLegacyResolutionItem'

export function createStatementLegacyResolutionItemController(): StatementLegacyResolutionItemController {
  const base = createGeneratedStatementLegacyResolutionItemController()
  return mergeController(base, extendStatementLegacyResolutionItemController)
}

export type { StatementLegacyResolutionItemController }
