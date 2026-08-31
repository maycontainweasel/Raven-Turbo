import type { FinancialAnalyticsApi } from "@raven/domain";
import { createFinancialAnalyticsService } from "@raven/domain/server";
import { createSurrealFinancialAnalyticsRepository } from "@raven/surreal";
import type { Ctx } from "@schema/server/trpc/context";

export function getFinancialAnalyticsService(ctx: Ctx): FinancialAnalyticsApi {
  return createFinancialAnalyticsService(
    createSurrealFinancialAnalyticsRepository(ctx.db),
  );
}
