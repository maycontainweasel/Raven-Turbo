import { createGeneratedCashflowOccurrenceController, type CashflowOccurrenceController } from './generated/cashflowOccurrence'
import { mergeController } from './_shared'
import { extendCashflowOccurrenceController } from '@schema/custom-controllers/cashflowOccurrence'

export function createCashflowOccurrenceController(): CashflowOccurrenceController {
  const base = createGeneratedCashflowOccurrenceController()
  return mergeController(base, extendCashflowOccurrenceController)
}

export type { CashflowOccurrenceController }
