import assert from "node:assert/strict";
import test from "node:test";
import { createCommandIntent } from "@raven/domain";
import {
  statementPeriodState,
  statementPeriodStateLabel,
  statementSourceStateLabel,
} from "./statement-source-state.js";
import { createReviewedCommandIntents } from "./statement-resolution-intents.js";

test("statement source labels never upgrade legacy evidence", () => {
  assert.equal(
    statementSourceStateLabel("legacy"),
    "Legacy import — source authority not yet verified",
  );
  assert.equal(
    statementSourceStateLabel("committed"),
    "ST-01 committed source",
  );
  assert.equal(statementSourceStateLabel("superseded"), "Superseded source");
});

test("statement period labels distinguish pending, exception, ready, reconciled, and reopened states", () => {
  const reconciliation = (
    attestationState: "open" | "ready" | "reconciled" | "reopened",
    activeIssueCount = 0,
  ) => ({
    attestationState,
    counts: { activeIssueCount, blockingIssueCount: 0 },
  });
  assert.equal(statementPeriodState("committed", null), "committed_pending");
  assert.equal(
    statementPeriodState("committed", reconciliation("open", 1)),
    "exceptions",
  );
  assert.equal(
    statementPeriodState("committed", reconciliation("ready")),
    "ready",
  );
  assert.equal(
    statementPeriodState("committed", reconciliation("reconciled")),
    "reconciled",
  );
  assert.equal(
    statementPeriodState("committed", reconciliation("reopened")),
    "reopened",
  );
  assert.equal(statementPeriodStateLabel("ready"), "Ready to attest");
});

test("reviewed command intent survives retries and changes only with reviewed payload", () => {
  const keys = ["intent-001", "intent-002", "intent-003"];
  const intents = createReviewedCommandIntents(
    () => keys.shift() ?? "unexpected",
  );
  assert.equal(
    intents.begin("confirm", { match: "one", revision: 1 }),
    "intent-001",
  );
  assert.equal(
    intents.begin("confirm", { match: "one", revision: 1 }),
    "intent-001",
  );
  assert.equal(
    intents.begin("confirm", { match: "one", revision: 2 }),
    "intent-002",
  );
  intents.clear("confirm");
  assert.equal(
    intents.begin("confirm", { match: "one", revision: 2 }),
    "intent-003",
  );
});

test("one reviewed statement intent reuses its key until explicitly cleared", () => {
  const keys = ["statement-intent-001", "statement-intent-002"];
  const intent = createCommandIntent(() => keys.shift() ?? "unexpected");

  assert.equal(intent.begin(), "statement-intent-001");
  assert.equal(intent.current(), "statement-intent-001");
  assert.equal(intent.current(), "statement-intent-001");
  intent.clear();
  assert.equal(intent.begin(), "statement-intent-002");
});
