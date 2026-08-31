import { createGeneratedAccountFacilitySnapshotController, type AccountFacilitySnapshotController } from './generated/accountFacilitySnapshot'
import { mergeController } from './_shared'
import { extendAccountFacilitySnapshotController } from '@schema/custom-controllers/accountFacilitySnapshot'

export function createAccountFacilitySnapshotController(): AccountFacilitySnapshotController {
  const base = createGeneratedAccountFacilitySnapshotController()
  return mergeController(base, extendAccountFacilitySnapshotController)
}

export type { AccountFacilitySnapshotController }
