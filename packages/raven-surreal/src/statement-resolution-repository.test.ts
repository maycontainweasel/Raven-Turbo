import assert from "node:assert/strict";
import test from "node:test";
import {
  RavenDomainError,
  type StatementAttestationDraft,
  type StatementConfirmationDraft,
  type StatementMatchMutationDraft,
  type StatementMaterializationDraft,
} from "@raven/domain/server";
import { createSurrealStatementResolutionRepository } from "./statement-resolution-repository.js";

const IMPORT_ID = "statementImport:fictional-account|2026-07";
const COMPONENT_ID = "statementRowComponent:fictional-component";
const TRANSACTION_ID = "transaction:fictional-manual";
const MATCH_ID = "statementTransactionMatch:fictional-match";

test("attestation infers liability for legacy credit-card Account metadata", async () => {
  let captured = "";
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      captured = query;
      return [
        {
          status: "OK",
          result: [
            {
              reconciliation: {
                id: "statementReconciliation:fictional-current",
                space: "financialSpace:fictional-space",
                account: "account:fictional-account",
                statementImport: IMPORT_ID,
                counts: {},
                calculationHash: "c".repeat(64),
                attestationState: "reconciled",
              },
              event: null,
              operation: rawOperation(
                "attest_statement_reconciled",
                "fictional-attestation",
              ),
            },
          ],
        },
      ];
    },
  });
  const draft: StatementAttestationDraft = {
    statementImportId: IMPORT_ID,
    expectedRevision: 4,
    calculationHash: "c".repeat(64),
    expectedAccountContext: {
      spaceId: "financialSpace:fictional-space",
      accountId: "account:fictional-account",
      spaceKey: "fictional-space",
      accountKey: "fictional-account",
      currency: "ZAR",
      normalNature: "liability",
      accountNumberLast4: "1234",
      spaceTimezone: "Africa/Johannesburg",
      accountContextFingerprint: "f".repeat(64),
    },
    actorId: "fictional-operator",
    attestedAt: "2026-08-24T12:00:00.000Z",
    operation: operation(
      "attest_statement_reconciled",
      "fictional-attestation",
    ),
  };

  await repository.attestStatementReconciled(draft);
  assert.match(captured, /accountContext\.normalNature = NONE/);
  assert.match(captured, /accountContext\.accountType IN \["credit_card", "loan", "debt"\]/);
  assert.match(captured, /\$accountNature != \$expectedAccount\.normalNature/);
});

function operation(command: string, key: string) {
  return {
    key,
    command: command as any,
    idempotencyKey: `${key}-idempotency`,
    requestHash: "a".repeat(64),
    channel: "system" as const,
    recordedAt: "2026-08-04T12:00:00.000Z",
    warningCodes: [],
    auditMeta: { workline: "ST-02" },
  };
}

function match() {
  return {
    key: "fictional-match",
    spaceId: "financialSpace:fictional-space",
    accountId: "account:fictional-account",
    statementImportId: IMPORT_ID,
    componentIds: [COMPONENT_ID],
    transactionId: TRANSACTION_ID,
    method: "explicit" as const,
    reasonCodes: ["EXPLICIT_OPERATOR_SELECTION" as const],
    confidence: 1,
    signedComponentTotalMinor: 1_000,
    currency: "ZAR",
    proposedBy: null,
    proposedAt: "2026-08-04T12:00:00.000Z",
    proposedOperationId: "financialOperation:fictional-proposal",
    supersedesId: null,
  };
}

function validation() {
  return {
    componentIds: [COMPONENT_ID],
    componentChecksums: ["b".repeat(64)],
    transactionId: TRANSACTION_ID,
    accountId: "account:fictional-account",
    currency: "ZAR",
    signedComponentTotalMinor: 1_000,
    transactionAmountMinor: 1_000,
    flowDirection: "inflow" as const,
    acceptedTransactionDates: ["2026-07-09", "2026-07-10", "2026-07-11"],
    sourceRowId: "statementRow:fictional-row",
    canonicalFinancialDate: "2026-07-10",
  };
}

function rawMatch(state = "proposed") {
  return {
    id: MATCH_ID,
    key: "fictional-match",
    space: "financialSpace:fictional-space",
    account: "account:fictional-account",
    statementImport: IMPORT_ID,
    primaryComponent: COMPONENT_ID,
    componentIds: [COMPONENT_ID],
    transaction: TRANSACTION_ID,
    state,
    method: "explicit",
    reasonCodes: ["EXPLICIT_OPERATOR_SELECTION"],
    confidence: 1,
    signedComponentTotalMinor: 1_000,
    currency: "ZAR",
    revision: state === "confirmed" ? 2 : 1,
    proposedOperation: "financialOperation:fictional-proposal",
    confirmedOperation:
      state === "confirmed"
        ? "financialOperation:fictional-confirmation"
        : null,
    proposedAt: "2026-08-04T12:00:00.000Z",
    confirmedAt: state === "confirmed" ? "2026-08-04T12:01:00.000Z" : null,
    sourceState: "committed",
  };
}

function rawOperation(command: string, key: string) {
  return {
    id: `financialOperation:${key}`,
    key,
    command,
    idempotencyKey: `${key}-idempotency`,
    requestHash: "a".repeat(64),
    channel: "system",
    status: "applied",
    resultRefs: [MATCH_ID],
    warningCodes: [],
    auditMeta: {},
    recordedAt: "2026-08-04T12:00:00.000Z",
    completedAt: "2026-08-04T12:00:00.000Z",
  };
}

function mutationResponse(command: string, key: string, state = "proposed") {
  return [
    {
      status: "OK",
      result: [
        {
          match: rawMatch(state),
          reconciliation: {
            id: "statementReconciliation:fictional-current",
            statementImport: IMPORT_ID,
            counts: {},
          },
          operation: rawOperation(command, key),
        },
      ],
    },
  ];
}

test("proposal transaction re-reads exact source and Transaction invariants", async () => {
  const queries: Array<{ query: string; vars?: Record<string, unknown> }> = [];
  const repository = createSurrealStatementResolutionRepository({
    async query(query, vars) {
      queries.push({ query, vars });
      if (query.trimStart().startsWith("RETURN type::string")) {
        return [{ status: "OK", result: [MATCH_ID] }];
      }
      return mutationResponse(
        "propose_statement_transaction_match",
        "fictional-proposal",
      );
    },
  });
  const draft: StatementMatchMutationDraft = {
    match: match(),
    validation: validation(),
    operation: operation(
      "propose_statement_transaction_match",
      "fictional-proposal",
    ),
    reconciliation: null,
    expectedReconciliationRevision: null,
    expectedReconciliationHash: null,
  };
  await repository.proposeStatementTransactionMatch(draft);
  const query = queries.at(-1)?.query ?? "";
  assert.match(query, /BEGIN TRANSACTION;/);
  assert.match(query, /math::sum\(\$components\.balanceEffectMinor\)/);
  assert.match(query, /sourceChecksum IN \$validation\.componentChecksums/);
  assert.match(query, /acceptedTransactionDates/);
  assert.match(query, /statementComponentResolutionClaim/);
  assert.match(query, /statementTransactionResolutionClaim/);
  assert.match(query, /entrySource IN \["manual", "generated"\]/);
  assert.match(query, /STATEMENT_COMPONENT_GROUP_INVALID/);
  assert.match(query, /expectedReconciliationHash/);
  assert.doesNotMatch(query, /CREATE ONLY \$transactionId CONTENT/);
});

test("candidate discovery includes active tracked Accounts across financial spaces", async () => {
  let captured = "";
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      captured = query;
      return [[]];
    },
  });

  await repository.listCandidateTransactions({
    spaceId: "financialSpace:fictional-business",
    accountId: "account:fictional-business-current",
    periodStart: "2026-07-01",
    periodEnd: "2026-07-31",
    includeCounterpartAccounts: true,
  });

  assert.match(
    captured,
    /account\.active = true AND account\.space\.active = true/,
  );
  assert.match(captured, /\$includeCounterparts OR \(/);
  assert.doesNotMatch(captured, /WHERE space = type::record/);
});

test("confirmation acquires deterministic claims and updates only evidence projection", async () => {
  let captured = "";
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      captured = query;
      return mutationResponse(
        "confirm_statement_transaction_match",
        "fictional-confirmation",
        "confirmed",
      );
    },
  });
  const draft: StatementConfirmationDraft = {
    matchId: MATCH_ID,
    expectedRevision: 1,
    validation: validation(),
    actorId: "fictional-operator",
    confirmedAt: "2026-08-04T12:01:00.000Z",
    operation: operation(
      "confirm_statement_transaction_match",
      "fictional-confirmation",
    ),
    reconciliation: null,
    expectedReconciliationRevision: null,
    expectedReconciliationHash: null,
  };
  await repository.confirmStatementTransactionMatch(draft);
  assert.match(captured, /fn::stringID\(\[\$componentId, "active"\]\)/);
  assert.match(
    captured,
    /fn::stringID\(\[\$current\.transaction, "active"\]\)/,
  );
  assert.match(
    captured,
    /UPDATE ONLY \$current\.transaction SET\s+statementMatch = \$matchId,\s+effectiveAt = \$validation\.canonicalFinancialDate/,
  );
  assert.match(captured, /expectedReconciliationHash/);
  assert.match(captured, /effectiveAt = \$validation\.canonicalFinancialDate/);
  assert.doesNotMatch(
    captured,
    /UPDATE ONLY \$current\.transaction SET[^;]*(amountMinor|postedAt|category)/s,
  );
});

test("materialization creates exactly one Transaction, one confirmed match, and canonical edges", async () => {
  const queries: string[] = [];
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      queries.push(query);
      if (
        query.trimStart().startsWith("RETURN") &&
        query.includes('type::record("statementTransactionMatch"')
      ) {
        return [{ status: "OK", result: [MATCH_ID] }];
      }
      if (
        query.includes('type::record("transaction"') &&
        query.trimStart().startsWith("RETURN")
      ) {
        return [{ status: "OK", result: ["transaction:fictional-imported"] }];
      }
      return [
        {
          status: "OK",
          result: [
            {
              transaction: {
                id: "transaction:fictional-imported",
                key: "fictional-imported",
                space: "financialSpace:fictional-space",
                account: "account:fictional-account",
                postedAt: "2026-07-10",
                recordedAt: "2026-08-04T12:00:00.000Z",
                description: "Fictional imported movement",
                amountMinor: 1_000,
                currency: "ZAR",
                transactionKind: "income",
                flowDirection: "inflow",
                entrySource: "imported",
                status: "imported",
              },
              match: rawMatch("confirmed"),
              reconciliation: {
                id: "statementReconciliation:fictional-current",
                statementImport: IMPORT_ID,
                counts: {},
              },
              operation: rawOperation(
                "materialize_statement_component_transaction",
                "fictional-materialization",
              ),
            },
          ],
        },
      ];
    },
  });
  const draft: StatementMaterializationDraft = {
    statementImportId: IMPORT_ID,
    componentIds: [COMPONENT_ID],
    componentChecksums: ["b".repeat(64)],
    transferCandidateDates: ["2026-07-09", "2026-07-10", "2026-07-11"],
    transaction: {
      key: "fictional-imported",
      spaceId: "financialSpace:fictional-space",
      accountId: "account:fictional-account",
      sourceRowId: "statementRow:fictional-row",
      sourceChecksum: "c".repeat(64),
      postedAt: "2026-07-10",
      effectiveAt: "2026-07-10",
      description: "Fictional imported movement",
      amountMinor: 1_000,
      currency: "ZAR",
      direction: "credit",
      transactionKind: "income",
      flowDirection: "inflow",
      recordedAt: "2026-08-04T12:00:00.000Z",
      operationId: "financialOperation:fictional-materialization",
    },
    match: {
      ...match(),
      transactionId: "transaction:fictional-imported",
      method: "created_from_component",
      reasonCodes: ["CREATED_FROM_COMPONENT"],
    },
    operation: operation(
      "materialize_statement_component_transaction",
      "fictional-materialization",
    ),
    reconciliation: null,
    expectedReconciliationRevision: null,
    expectedReconciliationHash: null,
  };
  await repository.materializeStatementComponentTransaction(draft);
  const query = queries.at(-1) ?? "";
  assert.equal(
    (query.match(/CREATE ONLY \$transactionId CONTENT/g) ?? []).length,
    1,
  );
  assert.equal(
    (query.match(/LET \$matchRecord = CREATE ONLY \$matchId CONTENT/g) ?? [])
      .length,
    1,
  );
  assert.match(query, /StatementRowTransactions/);
  assert.match(query, /AccountTransactions/);
  assert.match(query, /STATEMENT_TRANSFER_REVIEW_REQUIRED/);
  assert.match(
    query,
    /account\.active = true AND account\.space\.active = true/,
  );
  assert.match(query, /postedAt IN \$transferCandidateDates/);
  assert.doesNotMatch(
    query,
    /CREATE ONLY .*?(category|merchant|accountTransfer|clarificationTask|cashflowSchedule)/i,
  );
});

test("retryable storage races are translated through active deterministic claims", async () => {
  let call = 0;
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      call += 1;
      if (call === 1) return [{ status: "OK", result: [MATCH_ID] }];
      if (query.includes("BEGIN TRANSACTION")) {
        throw new Error(
          "The query was not executed due to a failed transaction",
        );
      }
      if (query.includes("FROM financialOperation")) {
        return [{ status: "OK", result: [] }];
      }
      return [
        {
          status: "OK",
          result: [
            {
              componentClaimCount: 1,
              transactionClaimCount: 0,
              transactionMatched: false,
            },
          ],
        },
      ];
    },
  });
  await assert.rejects(
    repository.proposeStatementTransactionMatch({
      match: match(),
      validation: validation(),
      operation: operation(
        "propose_statement_transaction_match",
        "fictional-race",
      ),
      reconciliation: null,
      expectedReconciliationRevision: null,
      expectedReconciliationHash: null,
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_COMPONENT_ALREADY_DISPOSED",
  );
});

test("retryable storage races without claim conflicts become reconciliation staleness", async () => {
  let call = 0;
  const repository = createSurrealStatementResolutionRepository({
    async query(query) {
      call += 1;
      if (call === 1) return [{ status: "OK", result: [MATCH_ID] }];
      if (query.includes("BEGIN TRANSACTION")) {
        throw new Error(
          "Transaction conflict: Write conflict, retry the transaction",
        );
      }
      if (query.includes("FROM financialOperation")) {
        return [{ status: "OK", result: [] }];
      }
      return [
        {
          status: "OK",
          result: [
            {
              componentClaimCount: 0,
              transactionClaimCount: 0,
              transactionMatched: false,
            },
          ],
        },
      ];
    },
  });
  await assert.rejects(
    repository.proposeStatementTransactionMatch({
      match: match(),
      validation: validation(),
      operation: operation(
        "propose_statement_transaction_match",
        "fictional-reconciliation-race",
      ),
      reconciliation: null,
      expectedReconciliationRevision: null,
      expectedReconciliationHash: null,
    }),
    (error: unknown) =>
      error instanceof RavenDomainError &&
      error.code === "STATEMENT_RECONCILIATION_STALE",
  );
});
