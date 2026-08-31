import { createGeneratedStatementIssueController, type StatementIssueController } from './generated/statementIssue'
import { mergeController } from './_shared'
import { extendStatementIssueController } from '@schema/custom-controllers/statementIssue'

export function createStatementIssueController(): StatementIssueController {
  const base = createGeneratedStatementIssueController()
  return mergeController(base, extendStatementIssueController)
}

export type { StatementIssueController }
