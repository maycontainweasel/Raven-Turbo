import { createGeneratedTransactionPurposeController, type TransactionPurposeController } from './generated/transactionPurpose'
import { mergeController } from './_shared'
import { extendTransactionPurposeController } from '@schema/custom-controllers/transactionPurpose'

export function createTransactionPurposeController(): TransactionPurposeController {
  const base = createGeneratedTransactionPurposeController()
  return mergeController(base, extendTransactionPurposeController)
}

export type { TransactionPurposeController }
