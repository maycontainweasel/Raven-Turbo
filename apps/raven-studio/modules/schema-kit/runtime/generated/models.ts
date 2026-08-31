// AUTO-GENERATED — models manifest for schema-kit runtime
export type ModelEntry = {
  table: string;
  authority: 'source' | 'tenant';
  data: 'local' | 'remote';
  schemaType?: 'schemaless' | 'schemafull';
  slugPolicy?: string;
};

export const models = {
  "account": { table: "account", authority: "source", data: "local", schemaType: "schemaless" },
  "accountBalanceSnapshot": { table: "accountbalancesnapshot", authority: "source", data: "local", schemaType: "schemaless" },
  "accountFacilitySnapshot": { table: "accountfacilitysnapshot", authority: "source", data: "local", schemaType: "schemaless" },
  "accountTransfer": { table: "accounttransfer", authority: "source", data: "local", schemaType: "schemaless" },
  "cashflowOccurrence": { table: "cashflowoccurrence", authority: "source", data: "local", schemaType: "schemaless" },
  "cashflowSchedule": { table: "cashflowschedule", authority: "source", data: "local", schemaType: "schemaless" },
  "category": { table: "category", authority: "source", data: "local", schemaType: "schemaless" },
  "clarificationTask": { table: "clarificationtask", authority: "source", data: "local", schemaType: "schemaless" },
  "classificationRule": { table: "classificationrule", authority: "source", data: "local", schemaType: "schemaless" },
  "client": { table: "client", authority: "source", data: "local", schemaType: "schemaless" },
  "financialOperation": { table: "financialoperation", authority: "source", data: "local", schemaType: "schemaless" },
  "financialSpace": { table: "financialspace", authority: "source", data: "local", schemaType: "schemaless" },
  "hostingProvider": { table: "hostingprovider", authority: "source", data: "local", schemaType: "schemaless" },
  "merchant": { table: "merchant", authority: "source", data: "local", schemaType: "schemaless" },
  "monthlySnapshot": { table: "monthlysnapshot", authority: "source", data: "local", schemaType: "schemaless" },
  "retainer": { table: "retainer", authority: "source", data: "local", schemaType: "schemaless" },
  "statementComponentResolutionClaim": { table: "statementcomponentresolutionclaim", authority: "source", data: "local", schemaType: "schemaless" },
  "statementImport": { table: "statementimport", authority: "source", data: "local", schemaType: "schemaless" },
  "statementIssue": { table: "statementissue", authority: "source", data: "local", schemaType: "schemaless" },
  "statementLegacyResolution": { table: "statementlegacyresolution", authority: "source", data: "local", schemaType: "schemaless" },
  "statementLegacyResolutionItem": { table: "statementlegacyresolutionitem", authority: "source", data: "local", schemaType: "schemaless" },
  "statementPeriodClaim": { table: "statementperiodclaim", authority: "source", data: "local", schemaType: "schemaless" },
  "statementReconciliation": { table: "statementreconciliation", authority: "source", data: "local", schemaType: "schemaless" },
  "statementReconciliationEvent": { table: "statementreconciliationevent", authority: "source", data: "local", schemaType: "schemaless" },
  "statementRow": { table: "statementrow", authority: "source", data: "local", schemaType: "schemaless" },
  "statementRowComponent": { table: "statementrowcomponent", authority: "source", data: "local", schemaType: "schemaless" },
  "statementSourceClaim": { table: "statementsourceclaim", authority: "source", data: "local", schemaType: "schemaless" },
  "statementTransactionMatch": { table: "statementtransactionmatch", authority: "source", data: "local", schemaType: "schemaless" },
  "statementTransactionResolutionClaim": { table: "statementtransactionresolutionclaim", authority: "source", data: "local", schemaType: "schemaless" },
  "taxCategory": { table: "taxcategory", authority: "source", data: "local", schemaType: "schemaless" },
  "transaction": { table: "transaction", authority: "source", data: "local", schemaType: "schemaless" },
  "transactionPurpose": { table: "transactionpurpose", authority: "source", data: "local", schemaType: "schemaless" },
  "transactionPurposeAssignment": { table: "transactionpurposeassignment", authority: "source", data: "local", schemaType: "schemaless" },
  "transactionTaxDeclaration": { table: "transactiontaxdeclaration", authority: "source", data: "local", schemaType: "schemaless" },
  "user": { table: "u", authority: "source", data: "local", schemaType: "schemaless" }
} as const;

export type ModelKey = keyof typeof models;
