import { createGeneratedTransactionPurposeAssignmentController, type TransactionPurposeAssignmentController } from './generated/transactionPurposeAssignment'
import { mergeController } from './_shared'
import { extendTransactionPurposeAssignmentController } from '@schema/custom-controllers/transactionPurposeAssignment'

export function createTransactionPurposeAssignmentController(): TransactionPurposeAssignmentController {
  const base = createGeneratedTransactionPurposeAssignmentController()
  return mergeController(base, extendTransactionPurposeAssignmentController)
}

export type { TransactionPurposeAssignmentController }
