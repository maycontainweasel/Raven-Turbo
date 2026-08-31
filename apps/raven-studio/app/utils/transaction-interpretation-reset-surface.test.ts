import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

test("a reviewed transaction can return to immutable statement presentation", async () => {
  const [page, composable, router] = await Promise.all([
    readFile(new URL("../pages/activity.vue", import.meta.url), "utf8"),
    readFile(new URL("../composables/useClassificationApi.ts", import.meta.url), "utf8"),
    readFile(
      new URL("../../server/trpc/routers/transactionpurposeassignment.ts", import.meta.url),
      "utf8",
    ),
  ]);

  assert.match(page, /What this was <small>transaction purpose<\/small>/);
  assert.match(page, /Return to statement text/);
  assert.match(page, /classificationApi\.clear\(selectedTransactionId\.value\)/);
  assert.match(composable, /transactionPurposeAssignment\.clear/);
  assert.match(router, /clear: t\.procedure/);
  assert.match(router, /merchant: NONE/);
  assert.match(router, /merchantName: ''/);
  assert.match(router, /category: NONE/);
  assert.match(router, /manualOverride: false/);
  assert.match(router, /state = IF state IN \['confirmed', 'proposed'\] \{ 'superseded' \}/);
  assert.doesNotMatch(router, /description:\s*NONE/);
});
