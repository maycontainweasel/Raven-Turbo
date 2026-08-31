import { createGeneratedFinancialOperationController, type FinancialOperationController } from './generated/financialOperation'
import { mergeController } from './_shared'
import { extendFinancialOperationController } from '@schema/custom-controllers/financialOperation'

export function createFinancialOperationController(): FinancialOperationController {
  const base = createGeneratedFinancialOperationController()
  return mergeController(base, extendFinancialOperationController)
}

export type { FinancialOperationController }
