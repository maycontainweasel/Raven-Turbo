import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";
import { classifyBankCost, simulateCreditFirstPayoff } from "./debt-strategy";

test("debt strategy recognizes exact bank-cost descriptions without relying on flow direction", () => {
  assert.equal(classifyBankCost("credit_card", "Finance Charge"), "interest");
  assert.equal(
    classifyBankCost("credit_card", "DECLINED - INSUFFICIENT FUNDS FEE"),
    "declined_fee",
  );
  assert.equal(
    classifyBankCost("credit_card", "RETURNED A.P.O PAYMENT FEE"),
    "returned_repayment_fee",
  );
  assert.equal(
    classifyBankCost("overdraft", "Digital Statement Fee"),
    "statement_fee",
  );
  assert.equal(classifyBankCost("credit_card", "POS PURCHASE CAFE"), null);
});

test("credit-first projection pays the higher-rate facility before rolling into the overdraft", () => {
  const projection = simulateCreditFirstPayoff({
    creditBalanceMinor: 13_032_378,
    overdraftBalanceMinor: 3_513_522,
    creditAnnualRate: 0.21,
    overdraftAnnualRate: 0.115,
    creditMonthlyFeeReserveMinor: 14_454,
    overdraftMonthlyFeeReserveMinor: 15_357,
    monthlyPaymentMinor: 2_000_000,
  });

  assert.equal(projection.completed, true);
  assert.equal(projection.months, 10);
  assert.ok(projection.totalInterestMinor > 1_200_000);
  assert.ok(projection.totalPaidMinor > 17_000_000);
});

test("Debt surface reads canonical account contracts and keeps the payoff target local", async () => {
  const [page, layout] = await Promise.all([
    readFile(new URL("../pages/debt.vue", import.meta.url), "utf8"),
    readFile(new URL("../layouts/default.vue", import.meta.url), "utf8"),
  ]);

  assert.match(page, /api\.listAccounts\(/);
  assert.match(page, /api\.getAccount\(/);
  assert.match(page, /api\.listAccountTransactions\(/);
  assert.match(page, /statement_backed/);
  assert.match(page, /active_ledger_with_legacy_unreconciled/);
  assert.match(page, /raven\.debt-strategy\.monthly-target-rands/);
  assert.match(page, /does not rewrite the statement backbone/i);
  assert.match(page, /APO does not always mean paid/i);
  assert.match(page, /consolidat/i);
  assert.doesNotMatch(page, /demo|sample data|mock/i);
  assert.doesNotMatch(page, /\.mutate\s*\(/);
  assert.match(layout, /to="\/debt"/);
});
