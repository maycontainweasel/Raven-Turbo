import { createGeneratedClientController, type ClientController } from './generated/client'
import { mergeController } from './_shared'
import { extendClientController } from '@schema/custom-controllers/client'

export function createClientController(): ClientController {
  const base = createGeneratedClientController()
  return mergeController(base, extendClientController)
}

export type { ClientController }
