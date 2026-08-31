import { readFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

type SdbMachineData = Readonly<{
  endpoints: Readonly<{ http: string }>;
  bootstrap: Readonly<{ user: string; password: string }>;
  namespace: string;
  database: string;
}>;

export type RavenLocalConnectionConfig = Readonly<{
  repositoryRoot: string;
  url: string;
  username: string;
  password: string;
  namespace: string;
  database: string;
}>;

export function defaultRepositoryRoot(): string {
  return path.resolve(fileURLToPath(new URL("../../..", import.meta.url)));
}

async function readSdbMachineData(
  repositoryRoot: string,
): Promise<SdbMachineData> {
  const source = await readFile(
    path.join(repositoryRoot, "surreal.md"),
    "utf8",
  );
  const match = source.match(/```sdb-json\s*\n([\s\S]*?)\n```/);
  if (!match)
    throw new Error("Raven local database machine data is unavailable");
  return JSON.parse(match[1]!) as SdbMachineData;
}

export async function loadRavenLocalConnectionConfig(): Promise<RavenLocalConnectionConfig> {
  const repositoryRoot = path.resolve(
    process.env.RAVEN_REPOSITORY_ROOT ?? defaultRepositoryRoot(),
  );
  const url = process.env.RAVEN_SURREAL_URL;
  const username = process.env.RAVEN_SURREAL_USER;
  const password = process.env.RAVEN_SURREAL_PASS;
  const namespace = process.env.RAVEN_SURREAL_NAMESPACE;
  const database = process.env.RAVEN_SURREAL_DATABASE;
  if (url && username && password && namespace && database) {
    return {
      repositoryRoot,
      url,
      username,
      password,
      namespace,
      database,
    };
  }
  const machine = await readSdbMachineData(repositoryRoot);
  return {
    repositoryRoot,
    url: machine.endpoints.http,
    username: machine.bootstrap.user,
    password: machine.bootstrap.password,
    namespace: machine.namespace,
    database: machine.database,
  };
}

export function applyRavenLocalConnectionConfig(
  config: RavenLocalConnectionConfig,
): void {
  process.env.RAVEN_REPOSITORY_ROOT = config.repositoryRoot;
  process.env.RAVEN_SURREAL_URL = config.url;
  process.env.RAVEN_SURREAL_USER = config.username;
  process.env.RAVEN_SURREAL_PASS = config.password;
  process.env.RAVEN_SURREAL_NAMESPACE = config.namespace;
  process.env.RAVEN_SURREAL_DATABASE = config.database;
}
