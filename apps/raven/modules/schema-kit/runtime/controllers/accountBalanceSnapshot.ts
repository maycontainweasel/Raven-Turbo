import { createGeneratedAccountBalanceSnapshotController, type AccountBalanceSnapshotController } from './generated/accountBalanceSnapshot'
import { mergeController } from './_shared'
import { extendAccountBalanceSnapshotController } from '@schema/custom-controllers/accountBalanceSnapshot'

export function createAccountBalanceSnapshotController(): AccountBalanceSnapshotController {
  const base = createGeneratedAccountBalanceSnapshotController()
  return mergeController(base, extendAccountBalanceSnapshotController)
}

export type { AccountBalanceSnapshotController }
