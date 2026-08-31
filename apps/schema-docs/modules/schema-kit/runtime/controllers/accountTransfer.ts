import { createGeneratedAccountTransferController, type AccountTransferController } from './generated/accountTransfer'
import { mergeController } from './_shared'
import { extendAccountTransferController } from '@schema/custom-controllers/accountTransfer'

export function createAccountTransferController(): AccountTransferController {
  const base = createGeneratedAccountTransferController()
  return mergeController(base, extendAccountTransferController)
}

export type { AccountTransferController }
