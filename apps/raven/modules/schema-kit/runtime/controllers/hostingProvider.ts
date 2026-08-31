import { createGeneratedHostingProviderController, type HostingProviderController } from './generated/hostingProvider'
import { mergeController } from './_shared'
import { extendHostingProviderController } from '@schema/custom-controllers/hostingProvider'

export function createHostingProviderController(): HostingProviderController {
  const base = createGeneratedHostingProviderController()
  return mergeController(base, extendHostingProviderController)
}

export type { HostingProviderController }
