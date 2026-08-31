import { createGeneratedTaxCategoryController, type TaxCategoryController } from './generated/taxCategory'
import { mergeController } from './_shared'
import { extendTaxCategoryController } from '@schema/custom-controllers/taxCategory'

export function createTaxCategoryController(): TaxCategoryController {
  const base = createGeneratedTaxCategoryController()
  return mergeController(base, extendTaxCategoryController)
}

export type { TaxCategoryController }
