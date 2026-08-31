import { t } from '@schema/server/trpc/context';
import { categoryRouter as generatedCategoryRouter } from './generated/category';
import { surrealSelectMany } from './_surreal';

const customCategoryRouter = t.router({
  list: t.procedure.query(async ({ ctx }) => surrealSelectMany(ctx, `
    SELECT
      id, key, name, categoryKind, active, notes,
      space.key AS spaceKey,
      space.name AS spaceName,
      parentCategory.key AS parentKey,
      parentCategory.name AS parentName
    FROM category
    ORDER BY spaceName, parentName, name;
  `)),
});

export const categoryRouter = t.mergeRouters(generatedCategoryRouter, customCategoryRouter);
export type CategoryRouter = typeof categoryRouter;
