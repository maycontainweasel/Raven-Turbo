import { t } from '@schema/server/trpc/context';
import { taxCategoryRouter as generatedTaxCategoryRouter } from './generated/taxcategory';
import { surrealSelectMany } from './_surreal';

const customTaxCategoryRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => surrealSelectMany(ctx, `
    SELECT
      id,
      key,
      name,
      notes,
      active,
      space.key AS spaceKey,
      parentTaxCategory.key AS parentKey,
      parentTaxCategory.name AS parentName
    FROM taxCategory
    WHERE active = true
    ORDER BY parentName, name;
  `)),
});

export const taxCategoryRouter = t.mergeRouters(generatedTaxCategoryRouter, customTaxCategoryRouter);
export type TaxCategoryRouter = typeof taxCategoryRouter;
