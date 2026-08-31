import path from "node:path";
import { createHash } from "node:crypto";
import {
  createDefaultStatementAdapterRegistry,
  createLocalStatementSourceVault,
  createStatementLegacyResolutionService,
  createStatementResolutionService,
  StatementTruthService,
  type StatementLegacyResolutionApi,
  type StatementTruthApi,
} from "@raven/domain/server";
import type { SurrealQueryClient } from "./repository.js";
import { createSurrealStatementTruthRepository } from "./statement-repository.js";
import { createSurrealStatementResolutionRepository } from "./statement-resolution-repository.js";
import { createSurrealStatementLegacyResolutionRepository } from "./statement-legacy-resolution-repository.js";

export type LocalStatementTruthRuntimeOptions = Readonly<{
  client: SurrealQueryClient;
  repositoryRoot: string;
  vaultRoot?: string;
  allowedInboxRoots?: readonly string[];
  maxSourceBytes?: number;
  databaseFingerprint: string;
}>;

export function createLocalStatementTruthRuntime(
  options: LocalStatementTruthRuntimeOptions,
): StatementTruthApi {
  const repositoryRoot = path.resolve(options.repositoryRoot);
  const sourceRepository = createSurrealStatementTruthRepository(
    options.client,
  );
  const adapters = createDefaultStatementAdapterRegistry();
  const vault = createLocalStatementSourceVault({
    vaultRoot:
      options.vaultRoot ??
      path.join(repositoryRoot, ".raven-private", "statements"),
    allowedInboxRoots: options.allowedInboxRoots ?? [
      path.join(repositoryRoot, ".raven-private", "statement-inbox"),
    ],
    maxSourceBytes: options.maxSourceBytes,
  });
  let sourceService: StatementTruthService;
  const resolution = createStatementResolutionService({
    sourceRepository,
    repository: createSurrealStatementResolutionRepository(options.client),
    prepareSourceSupersession: (input, operation) =>
      sourceService.prepareStatementSupersessionDraft(
        input.replacement,
        operation,
        input.statementImportId,
      ),
  });
  let legacyResolution: StatementLegacyResolutionApi;
  const legacyProxy: StatementLegacyResolutionApi = {
    previewLegacyStatementResolution: (input) =>
      legacyResolution.previewLegacyStatementResolution(input),
    applyLegacyStatementResolution: (input) =>
      legacyResolution.applyLegacyStatementResolution(input),
    reverseLegacyStatementResolution: (input) =>
      legacyResolution.reverseLegacyStatementResolution(input),
  };
  sourceService = new StatementTruthService({
    repository: sourceRepository,
    resolution,
    legacyResolution: legacyProxy,
    adapters,
    vault,
  });
  legacyResolution = createStatementLegacyResolutionService({
    source: sourceService,
    repository: createSurrealStatementLegacyResolutionRepository(
      options.client,
      options.databaseFingerprint,
    ),
  });
  return sourceService;
}

function databaseFingerprintFromEnv(): string {
  const rawUrl =
    process.env.RAVEN_SURREAL_URL ?? process.env.NUXT_SURREALDB_URL ?? "local";
  let endpoint = rawUrl;
  try {
    const parsed = new URL(rawUrl);
    parsed.username = "";
    parsed.password = "";
    parsed.search = "";
    parsed.hash = "";
    endpoint = parsed.toString();
  } catch {
    endpoint = rawUrl.replace(/\/\/[^/@]+@/, "//");
  }
  return createHash("sha256")
    .update(
      JSON.stringify({
        endpoint,
        namespace:
          process.env.RAVEN_SURREAL_NAMESPACE ??
          process.env.NUXT_SURREALDB_NAMESPACE ??
          "",
        database:
          process.env.RAVEN_SURREAL_DATABASE ??
          process.env.NUXT_SURREALDB_DATABASE ??
          "",
      }),
    )
    .digest("hex");
}

export function statementRuntimeOptionsFromEnv(
  client: SurrealQueryClient,
  repositoryRoot: string,
): LocalStatementTruthRuntimeOptions {
  const configuredRoots = process.env.RAVEN_STATEMENT_INBOX_ROOTS?.split(
    path.delimiter,
  )
    .map((value) => value.trim())
    .filter(Boolean);
  return {
    client,
    repositoryRoot,
    vaultRoot: process.env.RAVEN_STATEMENT_VAULT_ROOT,
    allowedInboxRoots: configuredRoots?.length ? configuredRoots : undefined,
    maxSourceBytes: process.env.RAVEN_STATEMENT_MAX_BYTES
      ? Number(process.env.RAVEN_STATEMENT_MAX_BYTES)
      : undefined,
    databaseFingerprint: databaseFingerprintFromEnv(),
  };
}
