import { createGeneratedCashflowScheduleController, type CashflowScheduleController } from './generated/cashflowSchedule'
import { mergeController } from './_shared'
import { extendCashflowScheduleController } from '@schema/custom-controllers/cashflowSchedule'

export function createCashflowScheduleController(): CashflowScheduleController {
  const base = createGeneratedCashflowScheduleController()
  return mergeController(base, extendCashflowScheduleController)
}

export type { CashflowScheduleController }
