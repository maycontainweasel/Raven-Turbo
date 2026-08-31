import { type AccountControlApi } from '@raven/domain'
import { createAccountControlService } from '@raven/domain/server'
import { createSurrealAccountControlRepository } from '@raven/surreal'
import type { Ctx } from '@schema/server/trpc/context'

export function getAccountControlService(ctx: Ctx): AccountControlApi {
  return createAccountControlService(createSurrealAccountControlRepository(ctx.db))
}
