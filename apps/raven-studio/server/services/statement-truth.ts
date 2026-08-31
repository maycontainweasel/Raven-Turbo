import path from "node:path";
import type { StatementTruthApi } from "@raven/domain";
import {
  createLocalStatementTruthRuntime,
  statementRuntimeOptionsFromEnv,
} from "@raven/surreal";
import type { Ctx } from "@schema/server/trpc/context";

function repositoryRoot(): string {
  if (process.env.RAVEN_REPOSITORY_ROOT)
    return process.env.RAVEN_REPOSITORY_ROOT;
  return path.basename(process.cwd()) === "raven-studio"
    ? path.resolve(process.cwd(), "../..")
    : process.cwd();
}

export function getStatementTruthService(ctx: Ctx): StatementTruthApi {
  return createLocalStatementTruthRuntime(
    statementRuntimeOptionsFromEnv(ctx.db, repositoryRoot()),
  );
}
