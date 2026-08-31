import assert from "node:assert/strict";
import {
  chmod,
  mkdir,
  mkdtemp,
  readFile,
  symlink,
  writeFile,
} from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";
import {
  buildSourceInventory,
  deterministicJson,
  exactTransferCandidates,
  extractStatementAssistance,
  preparePrivateRunRoot,
  PROVISIONAL_AUTHORITY,
  writePrivateJson,
  writePrivateNdjson,
  internal as libraryInternal,
} from "./emergency-statement-intake-lib.js";
import { internal as operatorInternal } from "./emergency-statement-intake.js";

const repositoryRoot = path.resolve(
  fileURLToPath(new URL("../../..", import.meta.url)),
);

test("exact minor-unit parsing rejects fractions, malformed values and overflow", () => {
  assert.equal(libraryInternal.exactMinor("R 1,234.50"), 123450);
  assert.equal(libraryInternal.exactMinor("-0.01"), -1);
  assert.equal(libraryInternal.exactMinor("-R1.00"), -100);
  assert.throws(
    () => libraryInternal.exactMinor("1.001"),
    /INVALID_EXACT_MONEY/,
  );
  assert.throws(
    () => libraryInternal.exactMinor("90071992547410.00"),
    /UNSAFE_EXACT_MONEY/,
  );
  assert.throws(
    () => operatorInternal.checkedAdd(Number.MAX_SAFE_INTEGER, 1),
    /INTAKE_MONEY_OVERFLOW/,
  );
});

test("deterministic JSON and NDJSON are stable and owner-only", async () => {
  const root = await mkdtemp(path.join(os.homedir(), ".raven-intake-test-"));
  await chmod(root, 0o700);
  const json = path.join(root, "value.json");
  const ndjson = path.join(root, "value.ndjson");
  assert.equal(
    deterministicJson({ z: 1, a: { d: 2, b: 1 } }),
    '{"a":{"b":1,"d":2},"z":1}\n',
  );
  await writePrivateJson(json, { z: 1, a: 2 });
  await writePrivateNdjson(ndjson, [{ z: 1 }, { a: 2 }]);
  assert.equal(await readFile(json, "utf8"), '{"a":2,"z":1}\n');
  assert.equal(await readFile(ndjson, "utf8"), '{"z":1}\n{"a":2}\n');
  const details = await (await import("node:fs/promises")).stat(json);
  assert.equal(details.mode & 0o777, 0o600);
});

test("private run root rejects repository paths and symlink roots", async () => {
  await assert.rejects(
    preparePrivateRunRoot({
      repositoryRoot,
      privateRunRoot: path.join(repositoryRoot, ".private-intake-test"),
    }),
    /PRIVATE_ROOT_INSIDE_REPOSITORY/,
  );
  const ownerRoot = await mkdtemp(
    path.join(os.homedir(), ".raven-intake-test-"),
  );
  const real = path.join(ownerRoot, "real");
  const linked = path.join(ownerRoot, "linked");
  await mkdir(real, { mode: 0o700 });
  await symlink(real, linked);
  await assert.rejects(
    preparePrivateRunRoot({ repositoryRoot, privateRunRoot: linked }),
    /INTAKE_DIRECTORY_INVALID/,
  );
});

test("inventory preserves occurrences and deterministically deduplicates source bytes", async () => {
  const root = await mkdtemp(path.join(os.homedir(), ".raven-source-test-"));
  await mkdir(path.join(root, "business"), { recursive: true });
  await mkdir(path.join(root, "personal", "current"), { recursive: true });
  const pdf = Buffer.from("%PDF-fictional\n");
  await writeFile(path.join(root, "business", "a.pdf"), pdf);
  await writeFile(path.join(root, "business", "b.pdf"), pdf);
  await writeFile(
    path.join(root, "personal", "current", "legacy.surql"),
    "RETURN NONE;",
  );
  const generatedAt = "2026-08-17T00:00:00.000Z";
  const first = await buildSourceInventory({ sourceRoot: root, generatedAt });
  const second = await buildSourceInventory({ sourceRoot: root, generatedAt });
  assert.equal(deterministicJson(first), deterministicJson(second));
  assert.equal(first.occurrences.length, 3);
  const pdfs = first.occurrences.filter((item) => item.sourceKind === "pdf");
  assert.equal(new Set(pdfs.map((item) => item.fingerprint)).size, 1);
  assert.equal(pdfs.filter((item) => item.canonicalOccurrence).length, 1);
  assert.equal(
    first.occurrences.find((item) => item.sourceKind === "compatibility_only")
      ?.compatibilityOnly,
    true,
  );
});

test("FNB extraction uses printed credit marker and exact balance equation", () => {
  const result = extractStatementAssistance({
    accountClass: "business",
    pageCount: 1,
    text: [
      "Statement Period: 01 January 2026 to 31 January 2026",
      "Account number: 1234567890",
      "Opening balance 1,000.00 Cr",
      "01 Jan Fictional incoming                 100.00 Cr  1,100.00 Cr",
      "Closing balance 1,100.00 Cr",
    ].join("\n"),
  });
  assert.equal(result.assistance?.rows.length, 1);
  assert.equal(result.assistance?.rows[0]?.components[0]?.sourceFlow, "inflow");
  assert.equal(result.assistance?.rows[0]?.components[0]?.amountMinor, 10000);
  assert.equal(result.assistance?.coverage.status, "complete");
  assert.equal(result.assistance?.accountHints.maskedAccount, "1234567890");
});

test("FNB preserves the exact raw row when the printed description cell is empty", () => {
  const rawRow = `01 Jan ${" ".repeat(20)}100.00 Cr  1,100.00 Cr`;
  const result = extractStatementAssistance({
    accountClass: "business",
    pageCount: 1,
    text: [
      "Statement Period: 01 January 2026 to 31 January 2026",
      "Opening balance 1,000.00 Cr",
      rawRow,
      "Closing balance 1,100.00 Cr",
    ].join("\n"),
  });
  assert.equal(
    result.assistance?.rows[0]?.components[0]?.description,
    rawRow.trim(),
  );
});

test("FNB keeps optional accrued bank charges out of amount and balance columns", () => {
  const result = extractStatementAssistance({
    accountClass: "business",
    pageCount: 1,
    text: [
      "Statement Period: 01 January 2026 to 31 January 2026",
      "Opening balance 4,159.14 Cr",
      `31 Jan ${" ".repeat(20)}0.00${" ".repeat(12)}4,159.14 Cr${" ".repeat(6)}15.00`,
      "Closing balance 4,159.14 Cr",
    ].join("\n"),
  });
  const row = result.assistance?.rows[0];
  assert.equal(row?.reportedBalanceMinor, 415914);
  assert.equal(row?.rowKind, "informational");
  assert.equal(row?.components.length, 1);
  assert.equal(row?.components[0]?.amountMinor, 1500);
  assert.equal(row?.components[0]?.componentRole, "informational_breakdown");
  assert.equal(result.assistance?.coverage.status, "complete");
});

test("Nedbank asset extraction follows printed monetary columns", () => {
  const header = `${" ".repeat(80)}Fees${" ".repeat(24)}Debit${" ".repeat(23)}Credit${" ".repeat(22)}Balance`;
  const opening = `000001 01/01/2026 Opening balance${" ".repeat(118)}1,000.00`;
  const debit = `000002 02/01/2026 Fictional purchase${" ".repeat(71)}100.00${" ".repeat(51)}900.00`;
  const result = extractStatementAssistance({
    accountClass: "personal_current",
    pageCount: 1,
    text: [
      "Statement period: 01/01/2026 - 31/01/2026",
      "Opening balance R1,000.00",
      header,
      opening,
      debit,
      "Closing balance R900.00",
    ].join("\n"),
  });
  assert.equal(result.assistance?.rows.length, 1);
  assert.equal(
    result.assistance?.rows[0]?.components[0]?.sourceFlow,
    "outflow",
  );
  assert.equal(result.assistance?.rows[0]?.components[0]?.amountMinor, 10000);
});

test("Nedbank zero-effect dated notices remain informational and complete", () => {
  const header = `${" ".repeat(80)}Fees${" ".repeat(24)}Debit${" ".repeat(23)}Credit${" ".repeat(22)}Balance`;
  const opening = `000001 01/01/2026 Opening balance${" ".repeat(118)}1,000.00`;
  const notice = `02/01/2026 DEBIT RATE DECREASED TO 11,50%${" ".repeat(72)}0.00${" ".repeat(24)}1,000.00`;
  const result = extractStatementAssistance({
    accountClass: "personal_savings",
    pageCount: 1,
    text: [
      "Statement period: 01/01/2026 - 31/01/2026",
      "Opening balance R1,000.00",
      header,
      opening,
      notice,
      "Closing balance R1,000.00",
    ].join("\n"),
  });
  assert.equal(result.assistance?.profileHint, "nedbank-savings");
  assert.equal(result.assistance?.coverage.status, "complete");
  assert.equal(result.assistance?.rows[0]?.rowKind, "informational");
  assert.equal(result.assistance?.rows[0]?.components.length, 0);
  assert.deepEqual(result.issues, []);
});

test("credit direction follows printed columns, never description wording", () => {
  const result = extractStatementAssistance({
    accountClass: "personal_credit",
    pageCount: 1,
    text: [
      "Statement period: 01 January 2026 - 31 January 2026",
      "Previous balance R1,000.00",
      "Account transaction details",
      `${" ".repeat(90)}Debit${" ".repeat(9)}Credit`,
      `02/01/2026 Fictional refund wording${" ".repeat(60)}R100.00`,
      `03/01/2026 Fictional purchase wording${" ".repeat(75)}R200.00`,
      "Interest rates and facility details",
      "Statement balance R900.00",
    ].join("\n"),
  });
  const components =
    result.assistance?.rows.flatMap((row) => row.components) ?? [];
  assert.equal(components[0]?.sourceFlow, "outflow");
  assert.equal(components[1]?.sourceFlow, "inflow");
});

test("credit extraction does not bind a revolving facility to a replaceable card suffix", () => {
  const result = extractStatementAssistance({
    accountClass: "personal_credit",
    pageCount: 1,
    text: [
      "Account no: 5898460810785253",
      "Statement period: 01 January 2026 - 31 January 2026",
      "Previous balance R1,000.00",
      "Account transaction details",
      `${" ".repeat(90)}Debit${" ".repeat(9)}Credit`,
      `02/01/2026 Fictional purchase${" ".repeat(70)}R100.00`,
      "Card transaction details",
      "Visa Credit. Card no 492213XXXXXX8996",
      "Interest rates and facility details",
      "Statement balance R1,100.00",
    ].join("\n"),
  });

  assert.equal(result.assistance?.accountHints.maskedAccount, null);
});

test("Account mapping accepts an exact stored suffix without assuming four digits", () => {
  const candidates = operatorInternal.accountCandidates(
    "business",
    [
      {
        id: "account:one",
        spaceId: "financialSpace:business",
        spaceKey: "business",
        key: "one",
        name: "One",
        bankName: "Fictional",
        accountType: "current",
        currency: "ZAR",
        accountNumberLast4: "56789",
        normalNature: "asset",
        liquidityClass: "liquid",
        freshnessWindowHours: 72,
        active: true,
      },
      {
        id: "account:two",
        spaceId: "financialSpace:business",
        spaceKey: "business",
        key: "two",
        name: "Two",
        bankName: "Fictional",
        accountType: "current",
        currency: "ZAR",
        accountNumberLast4: null,
        normalNature: "asset",
        liquidityClass: "liquid",
        freshnessWindowHours: 72,
        active: true,
      },
    ],
    [
      {
        id: "financialSpace:business",
        key: "business",
        name: "Business",
        spaceType: "business",
        currency: "ZAR",
      },
    ],
    "123456789",
    "Account number 123456789",
  );
  assert.deepEqual(
    candidates.map((item) => item.id),
    ["account:one"],
  );
});

test("a sole structural Account remains a proposed binding for mismatch validation", () => {
  const candidates = operatorInternal.accountCandidates(
    "personal_credit",
    [
      {
        id: "account:card",
        spaceId: "financialSpace:personal",
        spaceKey: "personal",
        key: "card",
        name: "Card",
        bankName: "Fictional",
        accountType: "credit_card",
        currency: "ZAR",
        accountNumberLast4: "1111",
        normalNature: "liability",
        liquidityClass: "non_liquid",
        freshnessWindowHours: 72,
        active: true,
      },
    ],
    [
      {
        id: "financialSpace:personal",
        key: "personal",
        name: "Personal",
        spaceType: "personal",
        currency: "ZAR",
      },
    ],
    "9999999999992222",
    "Account number 9999999999992222",
  );
  assert.deepEqual(
    candidates.map((item) => item.id),
    ["account:card"],
  );
});

test("transfer candidates require exact magnitude, opposite flow, other Account and bounded date", () => {
  const candidates = exactTransferCandidates([
    {
      componentRef: "a",
      accountRef: "one",
      currency: "ZAR",
      date: "2026-01-01",
      amountMinor: 10000,
      sourceFlow: "outflow",
    },
    {
      componentRef: "b",
      accountRef: "two",
      currency: "ZAR",
      date: "2026-01-03",
      amountMinor: 10000,
      sourceFlow: "inflow",
    },
    {
      componentRef: "c",
      accountRef: "three",
      currency: "ZAR",
      date: "2026-01-10",
      amountMinor: 10000,
      sourceFlow: "inflow",
    },
  ]);
  assert.deepEqual(candidates, [
    {
      leftComponentRef: "a",
      rightComponentRef: "b",
      evidenceClass: "exact_magnitude_opposite_flow_bounded_date",
      reviewState: "pending",
      authority: PROVISIONAL_AUTHORITY,
    },
  ]);
});

test("read-only database guard rejects every non-SELECT statement", async () => {
  let calls = 0;
  const client = operatorInternal.readOnlyClient({
    async query() {
      calls += 1;
      return [];
    },
  } as never);
  await client.query("SELECT * FROM account;");
  await assert.rejects(
    client.query("CREATE transaction:test CONTENT {};"),
    /INTAKE_NON_SELECT_QUERY_BLOCKED/,
  );
  await assert.rejects(
    client.query("BEGIN; SELECT * FROM account; COMMIT;"),
    /INTAKE_NON_SELECT_QUERY_BLOCKED/,
  );
  assert.equal(calls, 1);
});

test("operator source invokes only the five approved Statement Truth methods", async () => {
  assert.deepEqual([...operatorInternal.ALLOWED_SERVICE_CALLS].sort(), [
    "detectStatementProfile",
    "listStatementProfiles",
    "previewStatementImport",
    "stageStatementSource",
    "validateStatementPreview",
  ]);
  const source = await readFile(
    path.join(
      repositoryRoot,
      "apps",
      "raven-mcp",
      "src",
      "emergency-statement-intake.ts",
    ),
    "utf8",
  );
  for (const forbidden of [
    "service.commitStatementImport(",
    "service.materializeStatementComponentTransaction(",
    "service.confirmStatementTransactionMatch(",
    "service.recalculateStatementReconciliation(",
    "service.attestStatementReconciled(",
    "service.applyLegacyStatementResolution(",
    "service.reverseLegacyStatementResolution(",
  ]) {
    assert.equal(source.includes(forbidden), false, forbidden);
  }
  assert.equal(/duckdb|node:sqlite|CREATE\s+TABLE/i.test(source), false);
});
