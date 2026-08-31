import assert from "node:assert/strict";
import test from "node:test";
import type {
  BalanceSnapshotDraft,
  CashflowOccurrenceDraft,
  CashflowOccurrenceMutation,
  CashflowScheduleMutation,
  CreateAccountInput,
  OperationDraft,
  TransactionDraft,
  TransferDraft,
} from "@raven/domain/server";
import { RavenDomainError } from "@raven/domain";
import {
  normalizeTransaction,
  SurrealAccountControlRepository,
  type SurrealQueryClient,
} from "./repository.js";

const NOW = "2026-07-11T10:00:00.000Z";

const operationDraft = (
  command: OperationDraft["command"],
): OperationDraft => ({
  key: `fictional-${command}`,
  command,
  idempotencyKey: `fictional-${command}-001`,
  requestHash: "fictional-request-hash",
  channel: "system",
  recordedAt: NOW,
});

const rawSchedule = {
  id: "cashflowSchedule:fictional-schedule",
  key: "fictional-schedule",
  space: "financialSpace:fictional-personal",
  spaceKey: "fictional-personal",
  account: "account:fictional-current",
  accountKey: "fictional-current",
  category: null,
  categoryKey: null,
  categoryName: null,
  title: "Fictional rent",
  direction: "outflow",
  certainty: "committed",
  amountMinor: 125_000,
  currency: "ZAR",
  timezone: "Africa/Johannesburg",
  cadence: "monthly",
  interval: 1,
  startDate: "2026-07-01",
  endDate: null,
  onceDueOn: null,
  dayOfWeek: null,
  dayOfMonth: 1,
  monthOfYear: null,
  status: "active",
  revision: 1,
  materializedThrough: "2026-09-01",
  termsEffectiveFrom: "2026-07-01",
  pausedOn: null,
  resumedOn: null,
  endedOn: null,
  cancelledOn: null,
  createdOperation: "financialOperation:fictional-create",
  lastOperation: "financialOperation:fictional-create",
  recordedAt: NOW,
  updatedAt: NOW,
  notes: null,
};

const rawOccurrence = {
  id: "cashflowOccurrence:fictional-occurrence",
  schedule: rawSchedule.id,
  space: rawSchedule.space,
  spaceKey: rawSchedule.spaceKey,
  account: rawSchedule.account,
  accountKey: rawSchedule.accountKey,
  category: null,
  categoryKey: null,
  categoryName: null,
  scheduledDueOn: "2026-08-01",
  dueOn: "2026-08-01",
  scheduleRevision: 1,
  revision: 1,
  title: rawSchedule.title,
  direction: "outflow",
  certainty: "committed",
  cadence: "monthly",
  scheduledAmountMinor: 125_000,
  amountMinor: 125_000,
  currency: "ZAR",
  status: "due",
  settledAt: null,
  transaction: null,
  overrideReason: null,
  statusReason: null,
  notes: null,
  lastOperation: "financialOperation:fictional-create",
  recordedAt: NOW,
  updatedAt: NOW,
};

test("account persistence derives record identity from financial space and account key", async () => {
  let capturedQuery = "";
  const client: SurrealQueryClient = {
    async query(query) {
      capturedQuery = query;
      return [
        [
          {
            account: {
              id: "account:financialSpace:fictional-personal|current-account",
              space: "financialSpace:fictional-personal",
              key: "current-account",
              name: "Current Account",
              bankName: "Example Bank",
              accountType: "current",
              currency: "ZAR",
              normalNature: "asset",
              liquidityClass: "liquid",
              freshnessWindowHours: 72,
              active: true,
            },
            operation: {
              id: "financialOperation:fictional-create-account",
              key: "fictional-create-account",
              command: "create_account",
              idempotencyKey: "fictional-create-account-001",
              requestHash: "fictional-request-hash",
              channel: "system",
              status: "applied",
              resultRefs: [
                "account:financialSpace:fictional-personal|current-account",
              ],
              warningCodes: [],
              recordedAt: NOW,
            },
          },
        ],
      ];
    },
  };
  const input: CreateAccountInput = {
    idempotencyKey: "fictional-create-account-001",
    channel: "system",
    spaceKey: "fictional-personal",
    accountKey: "current-account",
    name: "Current Account",
    bankName: "Example Bank",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
  };

  const result = await new SurrealAccountControlRepository(
    client,
  ).createAccountWithOperation(input, operationDraft("create_account"));

  assert.equal(
    result.account.id,
    "account:financialSpace:fictional-personal|current-account",
  );
  assert.match(capturedQuery, /fn::stringID\(\[\$space, \$accountKey\]\)/);
  assert.match(capturedQuery, /type::record\("account", \$accountId\)/);
});

test("balance confirmation stores and returns its evidence note", async () => {
  let persistedNotes: unknown;
  const client: SurrealQueryClient = {
    async query(_query, vars) {
      persistedNotes = vars?.notes;
      return [
        [
          {
            snapshot: {
              id: "accountBalanceSnapshot:fictional-balance",
              key: "fictional-balance",
              space: "financialSpace:fictional-personal",
              account:
                "account:financialSpace:fictional-personal|current-account",
              balanceKind: "available",
              amountMinor: 12_345,
              currency: "ZAR",
              economicNature: "asset",
              asOf: NOW,
              recordedAt: NOW,
              evidenceLevel: "confirmed",
              sourceKind: "manual_confirmation",
              operation: "financialOperation:fictional-confirm-account-balance",
              notes: vars?.notes,
            },
            operation: {
              id: "financialOperation:fictional-confirm-account-balance",
              key: "fictional-confirm-account-balance",
              command: "confirm_account_balance",
              idempotencyKey: "fictional-confirm-account-balance-001",
              requestHash: "fictional-request-hash",
              channel: "system",
              status: "applied",
              resultRefs: ["accountBalanceSnapshot:fictional-balance"],
              warningCodes: [],
              recordedAt: NOW,
            },
          },
        ],
      ];
    },
  };
  const snapshot: BalanceSnapshotDraft = {
    key: "fictional-balance",
    spaceId: "financialSpace:fictional-personal",
    accountId: "account:financialSpace:fictional-personal|current-account",
    balanceKind: "available",
    amountMinor: 12_345,
    currency: "ZAR",
    economicNature: "asset",
    asOf: NOW,
    recordedAt: NOW,
    evidenceLevel: "confirmed",
    sourceKind: "manual_confirmation",
    operationId: "financialOperation:fictional-confirm-account-balance",
    notes: "Fictional reconciliation note",
  };

  const result = await new SurrealAccountControlRepository(
    client,
  ).confirmBalanceWithOperation(
    snapshot,
    operationDraft("confirm_account_balance"),
  );

  assert.equal(persistedNotes, "Fictional reconciliation note");
  assert.equal(result.snapshot.notes, "Fictional reconciliation note");
});

test("a storage identity conflict is returned as a stable domain error", async () => {
  const client: SurrealQueryClient = {
    async query() {
      throw new Error("Database record already exists");
    },
  };
  const input: CreateAccountInput = {
    idempotencyKey: "fictional-create-account-002",
    channel: "system",
    spaceKey: "fictional-personal",
    accountKey: "current-account",
    name: "Current Account",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset",
    liquidityClass: "liquid",
    freshnessWindowHours: 72,
  };

  await assert.rejects(
    new SurrealAccountControlRepository(client).createAccountWithOperation(
      input,
      operationDraft("create_account"),
    ),
    (error: unknown) =>
      error instanceof RavenDomainError && error.code === "ALREADY_EXISTS",
  );
});

test("new manual transaction and transfer legs use account-scoped identities and actual result references", async () => {
  const queries: string[] = [];
  const client: SurrealQueryClient = {
    async query(query) {
      queries.push(query);
      throw new Error("capture only");
    },
  };
  const repository = new SurrealAccountControlRepository(client);
  const transaction: TransactionDraft = {
    key: "fictional-entry",
    spaceId: "financialSpace:fictional",
    spaceKey: "fictional",
    accountId: "account:fictional-current",
    accountKey: "fictional-current",
    postedAt: "2026-07-12",
    recordedAt: NOW,
    description: "Fictional entry",
    amountMinor: 1_250,
    currency: "ZAR",
    kind: "expense",
    flowDirection: "outflow",
    operationId: "financialOperation:fictional-record-expense",
  };
  await assert.rejects(
    repository.recordTransactionWithOperation(
      transaction,
      operationDraft("record_expense"),
    ),
  );
  const account = {
    id: "account:fictional-current",
    spaceId: "financialSpace:fictional",
    spaceKey: "fictional",
    key: "fictional-current",
    name: "Fictional",
    bankName: "",
    accountType: "current",
    currency: "ZAR",
    normalNature: "asset" as const,
    liquidityClass: "liquid" as const,
    freshnessWindowHours: 72,
    active: true,
  };
  const transfer: TransferDraft = {
    key: "fictional-transfer",
    sourceTransactionKey: "fictional-source",
    targetTransactionKey: "fictional-target",
    sourceAccount: account,
    targetAccount: {
      ...account,
      id: "account:fictional-savings",
      key: "fictional-savings",
    },
    postedAt: "2026-07-12",
    recordedAt: NOW,
    amountMinor: 2_500,
    currency: "ZAR",
    operationId: "financialOperation:fictional-record-transfer",
  };
  await assert.rejects(
    repository.recordTransferWithOperation(
      transfer,
      operationDraft("record_transfer"),
    ),
  );
  assert.match(
    queries[0]!,
    /fn::stringID\(\[\$accountRef, \$transactionKey\]\)/,
  );
  assert.match(
    queries[0]!,
    /resultRefs: \[type::string\(\$transaction\.id\)\]/,
  );
  assert.match(
    queries[1]!,
    /fn::stringID\(\[\$sourceAccountRef, \$sourceTransactionKey\]\)/,
  );
  assert.match(
    queries[1]!,
    /fn::stringID\(\[\$targetAccountRef, \$targetTransactionKey\]\)/,
  );
  assert.match(
    queries[1]!,
    /type::string\(\$sourceTransactionId\), type::string\(\$targetTransactionId\)/,
  );
});

test("canonical transaction fields win over conflicting legacy values", () => {
  const normalized = normalizeTransaction({
    id: "transaction:canonical",
    key: "canonical",
    space: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    account: "account:fictional-daily",
    accountKey: "fictional-daily",
    postedAt: "2026-07-10T08:00:00.000Z",
    recordedAt: NOW,
    description: "Fictional canonical row",
    amount: "999.99",
    amountMinor: 12_345,
    currency: "ZAR",
    direction: "debit",
    transactionKind: "income",
    flowDirection: "inflow",
    entrySource: "manual",
  });

  assert.equal(normalized.amountMinor, 12_345);
  assert.equal(normalized.kind, "income");
  assert.equal(normalized.flowDirection, "inflow");
  assert.equal(normalized.postedAt, "2026-07-10");
  assert.deepEqual(normalized.warnings, ["CANONICAL_LEGACY_CONFLICT"]);
});

test("legacy debit fallback is exact and ambiguous legacy transfer remains unresolved", () => {
  const debit = normalizeTransaction({
    id: "transaction:legacy-debit",
    space: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    account: "account:fictional-daily",
    accountKey: "fictional-daily",
    postedAt: "2026-07-09T08:00:00.000Z",
    description: "Fictional legacy debit",
    amount: "-12.50",
    currency: "ZAR",
    direction: "debit",
  });
  const transfer = normalizeTransaction({
    id: "transaction:legacy-transfer",
    space: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    account: "account:fictional-daily",
    accountKey: "fictional-daily",
    postedAt: "2026-07-09",
    description: "Fictional legacy transfer",
    amount: "50.00",
    currency: "ZAR",
    direction: "transfer",
    isTransfer: true,
  });

  assert.equal(debit.amountMinor, 1_250);
  assert.equal(debit.kind, "expense");
  assert.equal(debit.flowDirection, "outflow");
  assert.deepEqual(debit.warnings, ["LEGACY_MONEY_FALLBACK"]);
  assert.equal(transfer.kind, "transfer");
  assert.equal(transfer.flowDirection, null);
  assert.deepEqual(transfer.warnings.sort(), [
    "LEGACY_MONEY_FALLBACK",
    "LEGACY_TRANSFER_AMBIGUOUS",
  ]);
});

test("statement-row balances remain exact and are unavailable without source evidence", () => {
  const canonical = normalizeTransaction({
    id: "transaction:canonical-balance",
    space: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    account: "account:fictional-daily",
    accountKey: "fictional-daily",
    sourceRowId: "statementRow:fictional-canonical-row",
    sourceReportedBalanceMinor: -250_075,
    postedAt: "2026-07-09",
    recordedAt: NOW,
    description: "Fictional canonical balance row",
    amountMinor: 1_250,
    currency: "ZAR",
    transactionKind: "expense",
    flowDirection: "outflow",
    entrySource: "imported",
  });
  const legacy = normalizeTransaction({
    id: "transaction:legacy-balance",
    sourceRowId: "statementRow:fictional-legacy-row",
    sourceLegacyBalance: "-2500.75",
    postedAt: "2026-07-09",
    description: "Fictional legacy balance row",
    amount: "12.50",
    currency: "ZAR",
    direction: "debit",
  });
  const manual = normalizeTransaction({
    id: "transaction:manual-no-source-balance",
    transactionLegacyBalance: "9999.99",
    postedAt: "2026-07-09",
    recordedAt: NOW,
    description: "Fictional manual row",
    amountMinor: 1_250,
    currency: "ZAR",
    transactionKind: "expense",
    flowDirection: "outflow",
    entrySource: "manual",
  });

  assert.equal(canonical.reportedBalanceMinor, -250_075);
  assert.equal(legacy.reportedBalanceMinor, -250_075);
  assert.equal(manual.reportedBalanceMinor, null);
});

test("generated defaults cannot override legacy credit or unknown direction evidence", () => {
  const generatedCredit = normalizeTransaction({
    id: "transaction:generated-credit",
    postedAt: "2026-07-10",
    recordedAt: "",
    description: "Fictional generated-default credit",
    amount: "25.00",
    amountMinor: 0,
    currency: "ZAR",
    direction: "credit",
    transactionKind: "expense",
    flowDirection: "outflow",
    entrySource: "imported",
    status: "matched",
  });
  const malformed = normalizeTransaction({
    id: "transaction:generated-unknown",
    postedAt: "2026-07-10",
    recordedAt: "",
    description: "Fictional generated-default unknown",
    amount: "8.00",
    amountMinor: 0,
    currency: "ZAR",
    direction: "unknown",
    transactionKind: "expense",
    flowDirection: "outflow",
    entrySource: "imported",
    status: "ignored",
  });

  assert.equal(generatedCredit.amountMinor, 2_500);
  assert.equal(generatedCredit.kind, "income");
  assert.equal(generatedCredit.flowDirection, "inflow");
  assert.equal(generatedCredit.status, "matched");
  assert.deepEqual(generatedCredit.warnings, ["LEGACY_MONEY_FALLBACK"]);
  assert.equal(malformed.kind, "unresolved");
  assert.equal(malformed.flowDirection, null);
  assert.equal(malformed.status, "ignored");
  assert.deepEqual(malformed.warnings.sort(), [
    "LEGACY_MONEY_FALLBACK",
    "LEGACY_TRANSACTION_INVALID",
    "TRANSACTION_SEMANTICS_UNRESOLVED",
  ]);
});

test("exact imported transfer remains unresolved without falling back to legacy money", () => {
  const transfer = normalizeTransaction({
    id: "transaction:exact-unresolved-transfer",
    postedAt: "2026-07-10",
    recordedAt: NOW,
    description: "Fictional exact unresolved transfer",
    amount: "99.99",
    amountMinor: 1_250,
    currency: "ZAR",
    direction: "transfer",
    transactionKind: "transfer",
    flowDirection: "",
    entrySource: "imported",
    status: "matched",
    isTransfer: true,
  });

  assert.equal(transfer.amountMinor, 1_250);
  assert.equal(transfer.kind, "transfer");
  assert.equal(transfer.flowDirection, null);
  assert.deepEqual(transfer.warnings, ["LEGACY_TRANSFER_AMBIGUOUS"]);
});

test("an explicit empty account scope returns no transactions without a database query", async () => {
  let queryCount = 0;
  const repository = new SurrealAccountControlRepository({
    async query() {
      queryCount += 1;
      return [[]];
    },
  });

  assert.deepEqual(
    await repository.listTransactions({ accountIds: [], month: "2026-07" }),
    [],
  );
  assert.equal(queryCount, 0);
});

test("active ledger projection uses confirmed statement dates and excludes superseded source transactions", async () => {
  let capturedQuery = "";
  const base = {
    spaceId: "financialSpace:fictional-personal",
    spaceKey: "fictional-personal",
    accountId: "account:fictional-current",
    accountKey: "fictional-current",
    recordedAt: NOW,
    amount: 0,
    amountMinor: 1_000,
    currency: "ZAR",
    direction: "credit",
    transactionKind: "income",
    flowDirection: "inflow",
    status: "matched",
    merchantName: "",
    notes: "",
    isTransfer: false,
  };
  const client: SurrealQueryClient = {
    async query(query) {
      capturedQuery = query;
      return [
        [
          {
            ...base,
            id: "transaction:statement-backed",
            key: "statement-backed",
            postedAt: "2026-07-01",
            effectiveAt: "2026-06-30",
            description: "Fictional statement-backed movement",
            entrySource: "manual",
            statementMatchId: "statementTransactionMatch:active",
            statementImportId: "statementImport:active",
            statementMatchState: "confirmed",
            statementMatchSourceState: "committed",
            statementImportSourceState: "committed",
          },
          {
            ...base,
            id: "transaction:superseded-source",
            key: "superseded-source",
            postedAt: "2026-06-29",
            effectiveAt: null,
            description: "Fictional superseded source movement",
            entrySource: "imported",
            sourceRowId: "statementRow:superseded",
            statementMatchId: null,
            hasCanonicalStatementMatchHistory: true,
          },
          {
            ...base,
            id: "transaction:renderer-legacy",
            key: "renderer-legacy",
            postedAt: "2026-06-28",
            effectiveAt: null,
            description: "Fictional renderer-era source movement",
            entrySource: "imported",
            sourceRowId: "statementRow:renderer-legacy",
            statementMatchId: null,
          },
        ],
      ];
    },
  };

  const records = await new SurrealAccountControlRepository(
    client,
  ).listTransactions({
    accountIds: ["account:fictional-current"],
    month: "2026-06",
  });

  assert.deepEqual(
    records.map((record) => record.id),
    ["transaction:statement-backed"],
  );
  assert.equal(records[0]?.postedAt, "2026-07-01");
  assert.equal(records[0]?.effectiveAt, "2026-06-30");
  assert.equal(records[0]?.ledgerAuthority, "active");
  assert.match(
    capturedQuery,
    /sourceRow\.reportedBalanceMinor AS sourceReportedBalanceMinor/,
  );
  assert.match(capturedQuery, /sourceRow\.balance AS sourceLegacyBalance/);

  const evidenceRecords = await new SurrealAccountControlRepository(
    client,
  ).listTransactions({
    accountIds: ["account:fictional-current"],
    month: "2026-06",
    includeLegacyUnreconciled: true,
  });
  assert.deepEqual(
    evidenceRecords.map((record) => record.id),
    ["transaction:statement-backed", "transaction:renderer-legacy"],
  );
  assert.equal(evidenceRecords[1]?.ledgerAuthority, "legacy_unreconciled");
});

test("current position snapshots exclude closing evidence from superseded sources", async () => {
  let queryCount = 0;
  const client: SurrealQueryClient = {
    async query(query) {
      queryCount += 1;
      if (query.includes("FROM statementImport"))
        return [["statementImport:superseded"]];
      return [
        [
          {
            id: "accountBalanceSnapshot:active",
            key: "active",
            spaceId: "financialSpace:fictional",
            accountId: "account:fictional-current",
            balanceKind: "statement",
            amountMinor: 2_000,
            currency: "ZAR",
            economicNature: "asset",
            asOf: "2026-07-31",
            recordedAt: NOW,
            evidenceLevel: "observed",
            sourceKind: "statement_closing",
            sourceRef: "statementImport:active",
            operation: "financialOperation:active",
            notes: "",
          },
          {
            id: "accountBalanceSnapshot:superseded",
            key: "superseded",
            spaceId: "financialSpace:fictional",
            accountId: "account:fictional-current",
            balanceKind: "statement",
            amountMinor: 1_000,
            currency: "ZAR",
            economicNature: "asset",
            asOf: "2026-06-30",
            recordedAt: NOW,
            evidenceLevel: "observed",
            sourceKind: "statement_closing",
            sourceRef: "statementImport:superseded",
            operation: "financialOperation:superseded",
            notes: "",
          },
        ],
      ];
    },
  };

  const snapshots = await new SurrealAccountControlRepository(
    client,
  ).listBalanceSnapshots(["account:fictional-current"]);

  assert.equal(queryCount, 2);
  assert.deepEqual(
    snapshots.map((snapshot) => snapshot.id),
    ["accountBalanceSnapshot:active"],
  );
});

test("schedule mutation validates schedule and every occurrence before any write or operation", async () => {
  let transactionQuery = "";
  const client: SurrealQueryClient = {
    async query(query) {
      if (query.includes("FROM cashflowSchedule WHERE record::id"))
        return [[rawSchedule]];
      if (
        !query.includes("BEGIN TRANSACTION") &&
        query.includes("FROM cashflowOccurrence")
      )
        return [[rawOccurrence]];
      transactionQuery = query;
      throw new Error("capture only");
    },
  };
  const mutation: CashflowScheduleMutation = {
    scheduleId: rawSchedule.id,
    expectedRevision: 1,
    expectedStatus: "active",
    patch: {
      revision: 2,
      title: "Fictional revised rent",
      lastOperationId: "financialOperation:fictional-update",
    },
    createOccurrences: [],
    occurrencePatches: [
      {
        occurrenceId: rawOccurrence.id,
        expectedRevision: 1,
        expectedStatus: "due",
        patch: {
          revision: 2,
          title: "Fictional revised rent",
          lastOperationId: "financialOperation:fictional-update",
        },
      },
    ],
  };

  await assert.rejects(
    new SurrealAccountControlRepository(
      client,
    ).mutateCashflowScheduleWithOperation(mutation, {
      ...operationDraft("update_scheduled_cashflow"),
      key: "fictional-update",
    }),
  );

  assert.match(transactionQuery, /\$current\.status != \$expectedStatus/);
  assert.match(
    transactionQuery,
    /\$occurrence\.revision != \$item\.expectedRevision OR \$occurrence\.status != \$item\.expectedStatus/,
  );
  assert.match(
    transactionQuery,
    /IF record::exists\(\$occurrenceId\) \{ THROW "SCHEDULE_REVISION_CONFLICT"; \}/,
  );
  assert.ok(
    transactionQuery.indexOf("FOR $item IN $occurrenceUpdates") <
      transactionQuery.indexOf("LET $schedule = UPDATE ONLY"),
  );
  assert.ok(
    transactionQuery.indexOf("LET $schedule = UPDATE ONLY") <
      transactionQuery.indexOf("LET $operation = CREATE ONLY"),
  );
  assert.match(
    transactionQuery,
    /resultRefs: array::concat\(\[type::string\(\$scheduleId\)\], \$affectedRefs\)/,
  );
});

test("occurrence settlement validation and unique linking are atomic with the occurrence write", async () => {
  let transactionQuery = "";
  const client: SurrealQueryClient = {
    async query(query) {
      if (
        !query.includes("BEGIN TRANSACTION") &&
        query.includes("FROM cashflowOccurrence WHERE record::id")
      )
        return [[rawOccurrence]];
      transactionQuery = query;
      throw new Error("capture only");
    },
  };
  const mutation: CashflowOccurrenceMutation = {
    occurrenceId: rawOccurrence.id,
    expectedRevision: 1,
    expectedStatus: "due",
    settlementTransactionId: "transaction:fictional-match",
    patch: {
      revision: 2,
      status: "settled",
      settledAt: NOW,
      transactionId: "transaction:fictional-match",
      lastOperationId: "financialOperation:fictional-settle",
    },
  };

  await assert.rejects(
    new SurrealAccountControlRepository(
      client,
    ).mutateCashflowOccurrenceWithOperation(mutation, {
      ...operationDraft("settle_cashflow_occurrence"),
      key: "fictional-settle",
    }),
  );

  assert.match(transactionQuery, /type::is_int\(\$transaction\.amountMinor\)/);
  assert.match(transactionQuery, /\$transaction\.space != \$current\.space/);
  assert.match(
    transactionQuery,
    /\$transaction\.account != \$current\.account/,
  );
  assert.match(
    transactionQuery,
    /WHERE transaction = \$transactionId AND id != \$occurrenceId/,
  );
  assert.match(transactionQuery, /THROW "OCCURRENCE_CONFLICT"/);
  assert.ok(
    transactionQuery.indexOf("LET $linked = SELECT VALUE id") <
      transactionQuery.indexOf("LET $occurrence = UPDATE ONLY"),
  );
  assert.ok(
    transactionQuery.indexOf("LET $occurrence = UPDATE ONLY") <
      transactionQuery.indexOf("LET $operation = CREATE ONLY"),
  );
});

test("materialization advances the boundary only when the requested horizon is later", async () => {
  let transactionQuery = "";
  const client: SurrealQueryClient = {
    async query(query) {
      if (
        !query.includes("BEGIN TRANSACTION") &&
        query.includes("FROM cashflowSchedule WHERE record::id")
      )
        return [[rawSchedule]];
      transactionQuery = query;
      throw new Error("capture only");
    },
  };
  const draft: CashflowOccurrenceDraft = {
    scheduleId: rawSchedule.id,
    spaceId: rawSchedule.space,
    spaceKey: rawSchedule.spaceKey,
    accountId: rawSchedule.account,
    accountKey: rawSchedule.accountKey,
    categoryId: null,
    categoryKey: null,
    categoryName: null,
    scheduledDueOn: "2026-10-01",
    dueOn: "2026-10-01",
    scheduleRevision: 1,
    revision: 1,
    title: rawSchedule.title,
    direction: "outflow",
    certainty: "committed",
    cadence: "monthly",
    scheduledAmountMinor: 125_000,
    amountMinor: 125_000,
    currency: "ZAR",
    status: "due",
    settledAt: null,
    transactionId: null,
    overrideReason: null,
    statusReason: null,
    notes: null,
    lastOperationId: "financialOperation:fictional-create",
    recordedAt: NOW,
    updatedAt: NOW,
  };

  await assert.rejects(
    new SurrealAccountControlRepository(client).materializeCashflowOccurrences(
      rawSchedule.id,
      1,
      "2026-10-01",
      [draft],
    ),
  );

  assert.match(transactionQuery, /IF \$current\.status != "active"/);
  assert.match(
    transactionQuery,
    /IF \$current\.materializedThrough = NONE OR \$current\.materializedThrough < \$through/,
  );
  assert.match(
    transactionQuery,
    /UPDATE ONLY \$scheduleId SET materializedThrough = \$through/,
  );
});
