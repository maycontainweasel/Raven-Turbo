#!/usr/bin/env node
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { Surreal } from "surrealdb";
import path from "node:path";
import {
  createAccountControlService,
  createFinancialAnalyticsService,
} from "@raven/domain/server";
import {
  createLocalStatementTruthRuntime,
  createSurrealAccountControlRepository,
  createSurrealFinancialAnalyticsRepository,
  statementRuntimeOptionsFromEnv,
} from "@raven/surreal";
import { createRavenMcpServer } from "./tools.js";

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

async function main() {
  const client = new Surreal();
  await client.connect(required("RAVEN_SURREAL_URL"));
  await client.signin({
    username: required("RAVEN_SURREAL_USER"),
    password: required("RAVEN_SURREAL_PASS"),
  });
  await client.use({
    namespace: required("RAVEN_SURREAL_NAMESPACE"),
    database: required("RAVEN_SURREAL_DATABASE"),
  });

  const service = createAccountControlService(
    createSurrealAccountControlRepository(client),
  );
  const repositoryRoot =
    process.env.RAVEN_REPOSITORY_ROOT ?? path.resolve(process.cwd());
  const statementService = createLocalStatementTruthRuntime(
    statementRuntimeOptionsFromEnv(client, repositoryRoot),
  );
  const financialAnalyticsService = createFinancialAnalyticsService(
    createSurrealFinancialAnalyticsRepository(client),
  );
  const server = createRavenMcpServer(
    service,
    statementService,
    financialAnalyticsService,
  );
  await server.connect(new StdioServerTransport());
}

main().catch((error) => {
  process.stderr.write(
    `${error instanceof Error ? error.stack || error.message : String(error)}\n`,
  );
  process.exitCode = 1;
});
