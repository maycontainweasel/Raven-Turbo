import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import test from "node:test";

const root = path.resolve(import.meta.dirname, "../..");

async function source(relativePath) {
  return readFile(path.join(root, relativePath), "utf8");
}

test("transaction purpose remains separate from immutable transaction truth", async () => {
  const [transactionType, purposeType, assignmentType] = await Promise.all([
    source(
      "apps/raven-studio/app/types/schema/generated/tables/transaction.ts",
    ),
    source(
      "apps/raven-studio/app/types/schema/generated/tables/transactionpurpose.ts",
    ),
    source(
      "apps/raven-studio/app/types/schema/generated/tables/transactionpurposeassignment.ts",
    ),
  ]);

  assert.doesNotMatch(transactionType, /^\s*purpose:/m);
  assert.match(purposeType, /space: z\.union/);
  assert.match(purposeType, /name: z\.string\(\)/);
  assert.match(purposeType, /defaultMerchant:/);
  assert.match(purposeType, /defaultCategory:/);
  assert.match(purposeType, /occurrencePattern:/);

  assert.match(assignmentType, /transaction: z\.union/);
  assert.match(assignmentType, /purpose: z\.union/);
  assert.match(assignmentType, /revision: z\.number\(\)\.int\(\)/);
  assert.match(
    assignmentType,
    /state: z\.enum\(\["proposed", "confirmed", "superseded", "rejected"\]\)/,
  );
  assert.match(assignmentType, /isCurrent: z\.boolean\(\)/);
  assert.match(assignmentType, /context: z\.record/);
  assert.match(assignmentType, /supersedes:/);
  assert.match(assignmentType, /operation:/);
});

test("rules, clarifications, generated functions, and routers expose purpose meaning", async () => {
  const [
    ruleType,
    clarificationType,
    purposeCreate,
    assignmentCreate,
    appRouter,
  ] = await Promise.all([
    source(
      "apps/raven-studio/app/types/schema/generated/tables/classificationrule.ts",
    ),
    source(
      "apps/raven-studio/app/types/schema/generated/tables/clarificationtask.ts",
    ),
    source(
      "apps/schema/config/migrations/transactionpurpose/F_createTransactionPurpose.surql",
    ),
    source(
      "apps/schema/config/migrations/transactionpurposeassignment/F_createTransactionPurposeAssignment.surql",
    ),
    source("apps/raven-studio/server/trpc/routers/_app.ts"),
  ]);

  assert.match(ruleType, /targetPurpose:/);
  assert.match(clarificationType, /suggestedPurpose:/);
  assert.match(
    purposeCreate,
    /fn::stringID\(\[\$payload\.space, \$payload\.key\]\)/,
  );
  assert.match(
    assignmentCreate,
    /fn::stringID\(\[\$payload\.transaction, \$payload\.revision\]\)/,
  );
  assert.match(appRouter, /transactionPurpose: transactionPurposeRouter/);
  assert.match(
    appRouter,
    /transactionPurposeAssignment: transactionPurposeAssignmentRouter/,
  );
});

test("the management contract forbids semantic overreach and double counting", async () => {
  const contract = await source(
    "docs/architecture/raven-transaction-management-meaning-contract-v0.1.md",
  );

  assert.match(
    contract,
    /At most one assignment may be\s+current and confirmed/,
  );
  assert.match(contract, /prevents double counting/);
  assert.match(contract, /trading funding, not automatically a trading/);
  assert.match(contract, /counterparty, while the\s+purpose may be/);
  assert.match(contract, /without making an\s+accounting, tax, legal/);
});

test("Raven exposes a revisioned classification workflow and counterparty ledgers", async () => {
  const [
    assignmentRouter,
    activity,
    merchants,
    merchantDetail,
    clients,
    clientDetail,
    meaning,
  ] = await Promise.all([
    source(
      "apps/raven-studio/server/trpc/routers/transactionpurposeassignment.ts",
    ),
    source("apps/raven-studio/app/pages/activity.vue"),
    source("apps/raven-studio/app/pages/merchants/index.vue"),
    source(
      "apps/raven-studio/app/pages/merchants/[spaceKey]/[merchantKey].vue",
    ),
    source("apps/raven-studio/app/pages/clients/index.vue"),
    source("apps/raven-studio/app/pages/clients/[clientKey].vue"),
    source("apps/raven-studio/app/pages/meaning.vue"),
  ]);

  assert.match(assignmentRouter, /BEGIN TRANSACTION/);
  assert.match(
    assignmentRouter,
    /UPDATE transactionPurposeAssignment\s+SET isCurrent = false/,
  );
  assert.match(assignmentRouter, /supersedes: IF \$previous/);
  assert.match(assignmentRouter, /context:\s*\$context/);
  assert.match(assignmentRouter, /tags: \[\.\.\.new Set/);
  assert.match(assignmentRouter, /client: client\?\.id \?\? null/);

  const transactionAugmentation =
    assignmentRouter.match(
      /LET \$updatedTransaction = UPDATE \$transaction\.id MERGE \{([\s\S]*?)\n\s*\};/,
    )?.[1] ?? "";
  assert.match(transactionAugmentation, /merchant:/);
  assert.match(transactionAugmentation, /category:/);
  assert.match(transactionAugmentation, /manualOverride:/);
  assert.doesNotMatch(
    transactionAugmentation,
    /\b(description|amount|amountMinor|postedAt|effectiveAt|currency|sourceRow|statementMatch):/,
  );

  assert.match(activity, /Reviewed meaning/);
  assert.match(activity, /classificationApi\.assign/);
  assert.match(
    activity,
    /statement date, amount, currency, and description stay unchanged/,
  );
  assert.match(merchants, /Merchants &amp; counterparties/);
  assert.match(merchantDetail, /Transaction ledger/);
  assert.match(clients, /ClientCreateDialog/);
  assert.match(clientDetail, /Client transaction ledger/);
  assert.match(meaning, /Statement truth remains intact/);
});

test("the tax lens is a sparse, revisioned override that preserves normal meaning", async () => {
  const [
    transactionType,
    taxCategoryType,
    declarationType,
    declarationRouter,
    appRouter,
    activity,
    meaning,
    contract,
  ] = await Promise.all([
    source(
      "apps/raven-studio/app/types/schema/generated/tables/transaction.ts",
    ),
    source(
      "apps/raven-studio/app/types/schema/generated/tables/taxcategory.ts",
    ),
    source(
      "apps/raven-studio/app/types/schema/generated/tables/transactiontaxdeclaration.ts",
    ),
    source(
      "apps/raven-studio/server/trpc/routers/transactiontaxdeclaration.ts",
    ),
    source("apps/raven-studio/server/trpc/routers/_app.ts"),
    source("apps/raven-studio/app/pages/activity.vue"),
    source("apps/raven-studio/app/pages/meaning.vue"),
    source("docs/architecture/raven-tax-lens-baseline-contract-v0.1.md"),
  ]);

  assert.doesNotMatch(transactionType, /^\s*tax(Category|Description):/m);
  assert.match(taxCategoryType, /parentTaxCategory:/);
  assert.match(taxCategoryType, /space: z\.union/);

  assert.match(declarationType, /transaction: z\.union/);
  assert.match(declarationType, /taxCategory:/);
  assert.match(declarationType, /revision: z\.number\(\)\.int\(\)/);
  assert.match(
    declarationType,
    /state: z\.enum\(\["proposed", "user_confirmed", "superseded", "rejected"\]\)/,
  );
  assert.match(declarationType, /isCurrent: z\.boolean\(\)/);
  assert.match(declarationType, /taxDescription:/);
  assert.match(declarationType, /evidenceStatus:/);
  assert.match(declarationType, /supersedes:/);

  assert.match(declarationRouter, /BEGIN TRANSACTION/);
  assert.match(
    declarationRouter,
    /UPDATE transactionTaxDeclaration\s+SET isCurrent = false/,
  );
  assert.match(declarationRouter, /state: 'user_confirmed'/);
  assert.match(declarationRouter, /action: 'inherit_normal'/);
  assert.match(declarationRouter, /taxDescription.*\|\| normalDescription/);
  assert.match(
    declarationRouter,
    /taxCategoryName.*\?\? row\.normalCategoryName/,
  );
  assert.doesNotMatch(declarationRouter, /UPDATE\s+transaction\s+SET/i);
  assert.match(
    appRouter,
    /transactionTaxDeclaration: transactionTaxDeclarationRouter/,
  );

  assert.match(activity, /Transaction meaning mode/);
  assert.match(
    activity,
    /Tax declarations override; everything else inherits normal meaning/,
  );
  assert.match(activity, /Save tax declaration/);
  assert.match(activity, /Use normal classification/);
  assert.match(meaning, /Separate tax vocabulary/);
  assert.match(meaning, /A tax category is a reporting label only/);

  assert.match(
    contract,
    /Tax view = declared tax value, otherwise normal value/,
  );
  assert.match(contract, /does not change the transaction amount/);
  assert.match(contract, /does not determine deductibility/);
});
