import { createGeneratedTransactionTaxDeclarationController, type TransactionTaxDeclarationController } from './generated/transactionTaxDeclaration'
import { mergeController } from './_shared'
import { extendTransactionTaxDeclarationController } from '@schema/custom-controllers/transactionTaxDeclaration'

export function createTransactionTaxDeclarationController(): TransactionTaxDeclarationController {
  const base = createGeneratedTransactionTaxDeclarationController()
  return mergeController(base, extendTransactionTaxDeclarationController)
}

export type { TransactionTaxDeclarationController }
