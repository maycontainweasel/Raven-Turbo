import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";
import {
  extractRecordReferences,
  identityFromParsedTable,
} from "../generate-raven-data-atlas.mjs";

function argument(name: string): string | undefined {
  const index = process.argv.indexOf(name);
  return index >= 0 ? process.argv[index + 1] : undefined;
}

async function main(): Promise<void> {
  const graphPath = resolve(argument("--graph") ?? "config/graph.mpdg");
  const parserPath = resolve(argument("--parser") ?? "scripts/mpdg-to-spec.ts");
  const originalLog = console.log;
  console.log = () => undefined;

  let parser: {
    parseFile: (source: string) => any[];
    auditTables: (tables: any[]) => {
      errors: Array<{ message: string }>;
      warnings: Array<{ message: string }>;
    };
    buildSpec: (table: any) => any;
  };
  try {
    parser = await import(pathToFileURL(parserPath).href);
  } finally {
    console.log = originalLog;
  }

  const tables = parser.parseFile(readFileSync(graphPath, "utf8"));
  const audit = parser.auditTables(tables);
  if (audit.errors.length > 0) {
    throw new Error(
      `Canonical MPDG parser reported ${audit.errors.length} error(s): ${audit.errors
        .map((issue) => issue.message)
        .join("; ")}`,
    );
  }

  const models = tables.map((table) => {
    const spec = parser.buildSpec(table);
    return {
      label: table.label,
      model: table.model,
      description: table.description ?? "",
      tableType: table.tableType ?? "primary",
      authority: table.modelSettings?.authority ?? "implicit",
      identity: identityFromParsedTable(table, spec),
      references: extractRecordReferences(table.fields, table.model),
    };
  });

  process.stdout.write(
    JSON.stringify({
      models,
      audit: {
        errors: audit.errors.length,
        warnings: audit.warnings.length,
      },
    }),
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
