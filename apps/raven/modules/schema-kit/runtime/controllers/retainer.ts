import { createGeneratedRetainerController, type RetainerController } from './generated/retainer'
import { mergeController } from './_shared'
import { extendRetainerController } from '@schema/custom-controllers/retainer'

export function createRetainerController(): RetainerController {
  const base = createGeneratedRetainerController()
  return mergeController(base, extendRetainerController)
}

export type { RetainerController }
