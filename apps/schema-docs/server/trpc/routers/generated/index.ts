import { adminRouter } from '../admin';
import { apiAttemptRouter } from './apiAttempt';
import { accountRouter } from './account';
import { categoryRouter } from './category';
import { clarificationTaskRouter } from './clarificationtask';
import { classificationRuleRouter } from './classificationrule';
import { financialSpaceRouter } from './financialspace';
import { merchantRouter } from './merchant';
import { monthlySnapshotRouter } from './monthlysnapshot';
import { statementImportRouter } from './statementimport';
import { statementRowRouter } from './statementrow';
import { transactionRouter } from './transaction';
import { userRouter } from './user';

export const generatedRouters = {
  "admin": adminRouter,
  "apiAttempt": apiAttemptRouter,
  "account": accountRouter,
  "category": categoryRouter,
  "clarificationTask": clarificationTaskRouter,
  "classificationRule": classificationRuleRouter,
  "financialSpace": financialSpaceRouter,
  "merchant": merchantRouter,
  "monthlySnapshot": monthlySnapshotRouter,
  "statementImport": statementImportRouter,
  "statementRow": statementRowRouter,
  "transaction": transactionRouter,
  "user": userRouter,
};

export { adminRouter };
export { apiAttemptRouter };
export { accountRouter };
export { categoryRouter };
export { clarificationTaskRouter };
export { classificationRuleRouter };
export { financialSpaceRouter };
export { merchantRouter };
export { monthlySnapshotRouter };
export { statementImportRouter };
export { statementRowRouter };
export { transactionRouter };
export { userRouter };
