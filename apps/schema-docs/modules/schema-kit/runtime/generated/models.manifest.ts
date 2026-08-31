// AUTO-GENERATED — canonical models manifest
export const modelsManifest = {
  "manifestVersion": "1.0.0",
  "generatedAt": "2026-08-24T12:09:55.188Z",
  "source": "schema.modelsManifest",
  "warnings": [],
  "models": {
    "account": {
      "key": "account",
      "table": "account",
      "label": "Account",
      "description": "Real-world bank, card, savings, loan, debt, investment, cash, or other account inside a financial space",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "key",
        "name",
        "bankname",
        "accounttype",
        "facilitykind",
        "currency",
        "accountnumberlast4",
        "openingbalance",
        "openingbalanceminor",
        "normalnature",
        "liquidityclass",
        "freshnesswindowhours",
        "active",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "name",
        "bankname",
        "accounttype",
        "facilitykind",
        "currency",
        "normalnature",
        "liquidityclass",
        "freshnesswindowhours",
        "active"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "account.create__NAME__",
        "update": "account.update__NAME__",
        "delete": "account.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "account",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "account.create__NAME__",
          "account.delete__NAME__",
          "account.update__NAME__",
          "account.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "account",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "accountBalanceSnapshot": {
      "key": "accountBalanceSnapshot",
      "table": "accountbalancesnapshot",
      "label": "AccountBalanceSnapshot",
      "description": "Immutable as-of account balance evidence with explicit freshness provenance",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "key",
        "balancekind",
        "amountminor",
        "currency",
        "economicnature",
        "asof",
        "recordedat",
        "evidencelevel",
        "sourcekind",
        "sourceref",
        "operation",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "key",
        "balancekind",
        "amountminor",
        "currency",
        "economicnature",
        "asof",
        "recordedat",
        "evidencelevel",
        "sourcekind"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "accountBalanceSnapshot.create__NAME__",
        "update": "accountBalanceSnapshot.update__NAME__",
        "delete": "accountBalanceSnapshot.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "accountBalanceSnapshot",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "accountBalanceSnapshot.create__NAME__",
          "accountBalanceSnapshot.delete__NAME__",
          "accountBalanceSnapshot.update__NAME__",
          "accountBalanceSnapshot.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "accountbalancesnapshot",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "accountFacilitySnapshot": {
      "key": "accountFacilitySnapshot",
      "table": "accountfacilitysnapshot",
      "label": "AccountFacilitySnapshot",
      "description": "Immutable dated evidence of a credit, overdraft, loan, or revolving facility and its exact observed or contractual terms",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "key",
        "facilitykind",
        "currency",
        "asof",
        "effectivefrom",
        "recordedat",
        "evidencelevel",
        "sourcekind",
        "sourceref",
        "statementimport",
        "hasfacilitylimit",
        "facilitylimitminor",
        "hasavailablecredit",
        "availablecreditminor",
        "hasminimumpayment",
        "minimumpaymentminor",
        "paymentdueon",
        "interestrates",
        "feeterms",
        "terms",
        "operation",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "key",
        "facilitykind",
        "currency",
        "asof",
        "recordedat",
        "evidencelevel",
        "sourcekind",
        "hasfacilitylimit",
        "hasavailablecredit",
        "hasminimumpayment"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "accountFacilitySnapshot.create__NAME__",
        "update": "accountFacilitySnapshot.update__NAME__",
        "delete": "accountFacilitySnapshot.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "accountFacilitySnapshot",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "accountFacilitySnapshot.create__NAME__",
          "accountFacilitySnapshot.delete__NAME__",
          "accountFacilitySnapshot.update__NAME__",
          "accountFacilitySnapshot.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "accountfacilitysnapshot",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "accountTransfer": {
      "key": "accountTransfer",
      "table": "accounttransfer",
      "label": "AccountTransfer",
      "description": "Source-authority aggregate linking two exact observed transfer legs between tracked accounts",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "sourcespace",
        "sourceaccount",
        "targetspace",
        "targetaccount",
        "amountminor",
        "currency",
        "postedat",
        "description",
        "sourcetransaction",
        "targettransaction",
        "operation",
        "recordedat"
      ],
      "requiredFields": [
        "key",
        "sourcespace",
        "sourceaccount",
        "targetspace",
        "targetaccount",
        "amountminor",
        "currency",
        "postedat",
        "sourcetransaction",
        "targettransaction",
        "operation",
        "recordedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "accountTransfer.create__NAME__",
        "update": "accountTransfer.update__NAME__",
        "delete": "accountTransfer.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "accountTransfer",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "accountTransfer.create__NAME__",
          "accountTransfer.delete__NAME__",
          "accountTransfer.update__NAME__",
          "accountTransfer.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "accounttransfer",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "cashflowOccurrence": {
      "key": "cashflowOccurrence",
      "table": "cashflowoccurrence",
      "label": "CashflowOccurrence",
      "description": "Concrete accepted due item materialized from a cashflow schedule",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "schedule",
        "space",
        "account",
        "category",
        "scheduleddueon",
        "dueon",
        "schedulerevision",
        "revision",
        "title",
        "direction",
        "certainty",
        "cadence",
        "scheduledamountminor",
        "amountminor",
        "currency",
        "status",
        "settledat",
        "transaction",
        "overridereason",
        "statusreason",
        "notes",
        "lastoperation",
        "recordedat",
        "updatedat"
      ],
      "requiredFields": [
        "schedule",
        "space",
        "scheduleddueon",
        "dueon",
        "schedulerevision",
        "revision",
        "title",
        "direction",
        "certainty",
        "cadence",
        "scheduledamountminor",
        "amountminor",
        "currency",
        "status",
        "lastoperation",
        "recordedat",
        "updatedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "cashflowOccurrence.create__NAME__",
        "update": "cashflowOccurrence.update__NAME__",
        "delete": "cashflowOccurrence.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "cashflowOccurrence",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "cashflowOccurrence.create__NAME__",
          "cashflowOccurrence.delete__NAME__",
          "cashflowOccurrence.update__NAME__",
          "cashflowOccurrence.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "cashflowoccurrence",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "cashflowSchedule": {
      "key": "cashflowSchedule",
      "table": "cashflowschedule",
      "label": "CashflowSchedule",
      "description": "Accepted one-off or recurring future money rule",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "category",
        "key",
        "title",
        "direction",
        "certainty",
        "amountminor",
        "currency",
        "timezone",
        "cadence",
        "interval",
        "startdate",
        "enddate",
        "oncedueon",
        "dayofweek",
        "dayofmonth",
        "monthofyear",
        "status",
        "revision",
        "materializedthrough",
        "termseffectivefrom",
        "pausedon",
        "resumedon",
        "endedon",
        "cancelledon",
        "createdoperation",
        "lastoperation",
        "recordedat",
        "updatedat",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "title",
        "direction",
        "certainty",
        "amountminor",
        "currency",
        "timezone",
        "cadence",
        "interval",
        "startdate",
        "status",
        "revision",
        "termseffectivefrom",
        "createdoperation",
        "lastoperation",
        "recordedat",
        "updatedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "cashflowSchedule.create__NAME__",
        "update": "cashflowSchedule.update__NAME__",
        "delete": "cashflowSchedule.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "cashflowSchedule",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "cashflowSchedule.create__NAME__",
          "cashflowSchedule.delete__NAME__",
          "cashflowSchedule.update__NAME__",
          "cashflowSchedule.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "cashflowschedule",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "category": {
      "key": "category",
      "table": "category",
      "label": "Category",
      "description": "Transaction category and category hierarchy node",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "key",
        "name",
        "categorykind",
        "parentcategory",
        "active",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "name",
        "categorykind",
        "active"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "category.create__NAME__",
        "update": "category.update__NAME__",
        "delete": "category.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "category",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "category.create__NAME__",
          "category.delete__NAME__",
          "category.update__NAME__",
          "category.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "category",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "clarificationTask": {
      "key": "clarificationTask",
      "table": "clarificationtask",
      "label": "ClarificationTask",
      "description": "Review task for uncertain transaction meaning",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "key",
        "transaction",
        "status",
        "question",
        "reason",
        "suggestedspace",
        "suggestedmerchant",
        "suggestedcategory",
        "resolvedat",
        "resolutionnotes",
        "confidence",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "transaction",
        "status",
        "question"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "clarificationTask.create__NAME__",
        "update": "clarificationTask.update__NAME__",
        "delete": "clarificationTask.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "clarificationTask",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "clarificationTask.create__NAME__",
          "clarificationTask.delete__NAME__",
          "clarificationTask.update__NAME__",
          "clarificationTask.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "clarificationtask",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "classificationRule": {
      "key": "classificationRule",
      "table": "classificationrule",
      "label": "ClassificationRule",
      "description": "Rule for automatic transaction matching and future classification suggestions",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "key",
        "name",
        "matcher",
        "scope",
        "targetmerchant",
        "targetcategory",
        "priority",
        "active",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "name",
        "matcher",
        "scope",
        "active"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "classificationRule.create__NAME__",
        "update": "classificationRule.update__NAME__",
        "delete": "classificationRule.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "classificationRule",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "classificationRule.create__NAME__",
          "classificationRule.delete__NAME__",
          "classificationRule.update__NAME__",
          "classificationRule.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "classificationrule",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "client": {
      "key": "client",
      "table": "client",
      "label": "Client",
      "description": "Global Raven client record for retainers, hosting, maintenance, and future billing relationships",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "name",
        "businessname",
        "contactperson",
        "email",
        "phonewhatsapp",
        "websitedomain",
        "status",
        "relatedprojects",
        "orbitclientid",
        "notes"
      ],
      "requiredFields": [
        "key",
        "name",
        "status"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "client.create__NAME__",
        "update": "client.update__NAME__",
        "delete": "client.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "client",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "client.create__NAME__",
          "client.delete__NAME__",
          "client.update__NAME__",
          "client.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "client",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "financialOperation": {
      "key": "financialOperation",
      "table": "financialoperation",
      "label": "FinancialOperation",
      "description": "Immutable receipt for an idempotent semantic Raven command",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "command",
        "idempotencykey",
        "requesthash",
        "channel",
        "actorid",
        "status",
        "resultrefs",
        "warningcodes",
        "auditmeta",
        "recordedat",
        "completedat",
        "failurecode"
      ],
      "requiredFields": [
        "key",
        "command",
        "idempotencykey",
        "requesthash",
        "channel",
        "status",
        "recordedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "financialOperation.create__NAME__",
        "update": "financialOperation.update__NAME__",
        "delete": "financialOperation.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "financialOperation",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "financialOperation.create__NAME__",
          "financialOperation.delete__NAME__",
          "financialOperation.update__NAME__",
          "financialOperation.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "financialoperation",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "financialSpace": {
      "key": "financialSpace",
      "table": "financialspace",
      "label": "FinancialSpace",
      "description": "Personal, business, trading, family, or other money context",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "name",
        "spacetype",
        "currency",
        "timezone",
        "description",
        "active",
        "archivedat"
      ],
      "requiredFields": [
        "key",
        "name",
        "spacetype",
        "currency",
        "timezone",
        "active"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "financialSpace.create__NAME__",
        "update": "financialSpace.update__NAME__",
        "delete": "financialSpace.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "financialSpace",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "financialSpace.create__NAME__",
          "financialSpace.delete__NAME__",
          "financialSpace.update__NAME__",
          "financialSpace.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "financialspace",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "hostingProvider": {
      "key": "hostingProvider",
      "table": "hostingprovider",
      "label": "HostingProvider",
      "description": "Hosting, reseller, domain, email, VPS, or infrastructure provider account used to deliver retainers",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "name",
        "providertype",
        "accountname",
        "accountreference",
        "websiteurl",
        "billingcadence",
        "monthlycost",
        "currency",
        "status",
        "notes"
      ],
      "requiredFields": [
        "key",
        "name",
        "providertype",
        "billingcadence",
        "currency",
        "status"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "hostingProvider.create__NAME__",
        "update": "hostingProvider.update__NAME__",
        "delete": "hostingProvider.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "hostingProvider",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "hostingProvider.create__NAME__",
          "hostingProvider.delete__NAME__",
          "hostingProvider.update__NAME__",
          "hostingProvider.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "hostingprovider",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "merchant": {
      "key": "merchant",
      "table": "merchant",
      "label": "Merchant",
      "description": "Merchant, customer, vendor, or counterparty memory record",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "key",
        "name",
        "normalizedname",
        "active",
        "notes"
      ],
      "requiredFields": [
        "space",
        "key",
        "name",
        "active"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "merchant.create__NAME__",
        "update": "merchant.update__NAME__",
        "delete": "merchant.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "merchant",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "merchant.create__NAME__",
          "merchant.delete__NAME__",
          "merchant.update__NAME__",
          "merchant.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "merchant",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "monthlySnapshot": {
      "key": "monthlySnapshot",
      "table": "monthlysnapshot",
      "label": "MonthlySnapshot",
      "description": "Month-level financial truth snapshot for a financial space",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "month",
        "currency",
        "incometotal",
        "outflowtotal",
        "nettotal",
        "transfertotal",
        "cashavailable",
        "recurringtotal",
        "businessspendtotal",
        "personalspendtotal",
        "generatedat",
        "status",
        "notes"
      ],
      "requiredFields": [
        "space",
        "month",
        "currency",
        "incometotal",
        "outflowtotal",
        "nettotal",
        "generatedat",
        "status"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "monthlySnapshot.create__NAME__",
        "update": "monthlySnapshot.update__NAME__",
        "delete": "monthlySnapshot.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "monthlySnapshot",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "monthlySnapshot.create__NAME__",
          "monthlySnapshot.delete__NAME__",
          "monthlySnapshot.update__NAME__",
          "monthlySnapshot.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "monthlysnapshot",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "retainer": {
      "key": "retainer",
      "table": "retainer",
      "label": "Retainer",
      "description": "Client retainer, hosting agreement, support arrangement, or recurring maintenance commitment",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "key",
        "client",
        "title",
        "type",
        "status",
        "startdate",
        "billingcadence",
        "amountcharged",
        "currency",
        "quotedamount",
        "quotedat",
        "quotereference",
        "nextbillingdate",
        "lastbilleddate",
        "invoicecount",
        "amountcollectedtodate",
        "agreementsourcenotes",
        "termsconditions",
        "includedservices",
        "excludedservices",
        "supportlevel",
        "hostingprovider",
        "provideraccountname",
        "coveredassets",
        "costtome",
        "costcadence",
        "renewalreviewdate",
        "recommendedaction",
        "risksissues",
        "nextaction",
        "notes"
      ],
      "requiredFields": [
        "key",
        "client",
        "title",
        "type",
        "status",
        "billingcadence",
        "currency",
        "costcadence",
        "recommendedaction"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "retainer.create__NAME__",
        "update": "retainer.update__NAME__",
        "delete": "retainer.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "retainer",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "retainer.create__NAME__",
          "retainer.delete__NAME__",
          "retainer.update__NAME__",
          "retainer.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "retainer",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementComponentResolutionClaim": {
      "key": "statementComponentResolutionClaim",
      "table": "statementcomponentresolutionclaim",
      "label": "StatementComponentResolutionClaim",
      "description": "Deterministic active claim allowing one confirmed resolution per movement component",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "statementrowcomponent",
        "statementtransactionmatch",
        "transaction",
        "key",
        "state",
        "claimedat",
        "releasedat",
        "operation"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "statementrowcomponent",
        "statementtransactionmatch",
        "transaction",
        "key",
        "state",
        "claimedat",
        "operation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementComponentResolutionClaim.create__NAME__",
        "update": "statementComponentResolutionClaim.update__NAME__",
        "delete": "statementComponentResolutionClaim.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementComponentResolutionClaim",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementComponentResolutionClaim.create__NAME__",
          "statementComponentResolutionClaim.delete__NAME__",
          "statementComponentResolutionClaim.update__NAME__",
          "statementComponentResolutionClaim.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementcomponentresolutionclaim",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementImport": {
      "key": "statementImport",
      "table": "statementimport",
      "label": "StatementImport",
      "description": "Source statement import batch for an account cycle",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "key",
        "sourcefilename",
        "sourceformat",
        "privatesourceref",
        "extractionassistref",
        "originalfilesha256",
        "extractioninputsha256",
        "canonicalextractionsha256",
        "previewhash",
        "sourcemimetype",
        "sourcebytesize",
        "profileid",
        "profileversion",
        "extractorversion",
        "validationrulesetversion",
        "periodstart",
        "periodend",
        "currency",
        "balanceconvention",
        "balanceconventionauthority",
        "accountcontextfingerprint",
        "openingbalanceminor",
        "closingbalanceminor",
        "closingbalanceeconomicnature",
        "coverage",
        "sourcestate",
        "commitoperation",
        "committedat",
        "replacementof",
        "importedat",
        "statementdate",
        "status",
        "rowcount",
        "componentcount",
        "issuecount",
        "revision",
        "normalizedcount",
        "clarificationcount",
        "sourcechecksum",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "key",
        "sourcefilename",
        "sourceformat",
        "importedat",
        "status",
        "revision"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementImport.create__NAME__",
        "update": "statementImport.update__NAME__",
        "delete": "statementImport.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementImport",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementImport.create__NAME__",
          "statementImport.delete__NAME__",
          "statementImport.update__NAME__",
          "statementImport.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementimport",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementIssue": {
      "key": "statementIssue",
      "table": "statementissue",
      "label": "StatementIssue",
      "description": "Source extraction or validation issue kept separate from management clarification",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "statementrow",
        "statementrowcomponent",
        "key",
        "code",
        "severity",
        "blocking",
        "state",
        "message",
        "revision",
        "detectedoperation",
        "dispositionoperation",
        "detectedat",
        "acknowledgedat",
        "resolvedat",
        "reviewedby",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "key",
        "code",
        "severity",
        "blocking",
        "state",
        "message",
        "revision",
        "detectedoperation",
        "detectedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementIssue.create__NAME__",
        "update": "statementIssue.update__NAME__",
        "delete": "statementIssue.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementIssue",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementIssue.create__NAME__",
          "statementIssue.delete__NAME__",
          "statementIssue.update__NAME__",
          "statementIssue.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementissue",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementLegacyResolution": {
      "key": "statementLegacyResolution",
      "table": "statementlegacyresolution",
      "label": "StatementLegacyResolution",
      "description": "Append-only selected-source compatibility authority event for one legacy and canonical statement pair",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [],
      "fields": [
        "space",
        "account",
        "legacystatementimport",
        "canonicalstatementimport",
        "key",
        "resolutiontype",
        "strategy",
        "authorityeffect",
        "previouslegacysourcestate",
        "previoussourceclaimstate",
        "previousperiodclaimstate",
        "targetresolution",
        "predecessorresolution",
        "databasefingerprint",
        "sourceidentityhash",
        "canonicalpreviewhash",
        "legacyevidencehash",
        "accountcontextfingerprint",
        "crosswalkhash",
        "expectedrevisionclaimhash",
        "resultauthorityhash",
        "aggregatecounts",
        "idempotencykey",
        "requesthash",
        "channel",
        "actorid",
        "operation",
        "recordedat"
      ],
      "requiredFields": [
        "space",
        "account",
        "legacystatementimport",
        "canonicalstatementimport",
        "key",
        "resolutiontype",
        "strategy",
        "authorityeffect",
        "previouslegacysourcestate",
        "previoussourceclaimstate",
        "previousperiodclaimstate",
        "databasefingerprint",
        "sourceidentityhash",
        "canonicalpreviewhash",
        "legacyevidencehash",
        "accountcontextfingerprint",
        "crosswalkhash",
        "expectedrevisionclaimhash",
        "resultauthorityhash",
        "aggregatecounts",
        "idempotencykey",
        "requesthash",
        "channel",
        "operation",
        "recordedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": false,
        "create": null,
        "update": null,
        "delete": null
      },
      "router": {
        "enabled": false,
        "key": "statementLegacyResolution",
        "parent": null,
        "embedInParent": false,
        "procedures": []
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementlegacyresolution",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": false
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementLegacyResolutionItem": {
      "key": "statementLegacyResolutionItem",
      "table": "statementlegacyresolutionitem",
      "label": "StatementLegacyResolutionItem",
      "description": "Immutable compatibility disposition item belonging to one selected-source resolution event",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [],
      "fields": [
        "space",
        "account",
        "statementlegacyresolution",
        "canonicalstatementimport",
        "legacystatementimport",
        "key",
        "compatibilityclass",
        "activeledgeroutcome",
        "canonicalcomponent",
        "canonicalcomponentids",
        "legacystatementrow",
        "legacytransaction",
        "legacytransactionids",
        "accounttransfer",
        "itemevidencehash",
        "expectedclaimhash",
        "operation",
        "recordedat"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementlegacyresolution",
        "canonicalstatementimport",
        "legacystatementimport",
        "key",
        "compatibilityclass",
        "activeledgeroutcome",
        "canonicalcomponentids",
        "legacytransactionids",
        "itemevidencehash",
        "expectedclaimhash",
        "operation",
        "recordedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": false,
        "create": null,
        "update": null,
        "delete": null
      },
      "router": {
        "enabled": false,
        "key": "statementLegacyResolutionItem",
        "parent": null,
        "embedInParent": false,
        "procedures": []
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementlegacyresolutionitem",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": false
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementPeriodClaim": {
      "key": "statementPeriodClaim",
      "table": "statementperiodclaim",
      "label": "StatementPeriodClaim",
      "description": "Deterministic active claim allowing one committed statement source for an exact account period",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "key",
        "periodstart",
        "periodend",
        "originalfilesha256",
        "state",
        "claimedat",
        "operation"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "key",
        "periodstart",
        "periodend",
        "originalfilesha256",
        "state",
        "claimedat",
        "operation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementPeriodClaim.create__NAME__",
        "update": "statementPeriodClaim.update__NAME__",
        "delete": "statementPeriodClaim.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementPeriodClaim",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementPeriodClaim.create__NAME__",
          "statementPeriodClaim.delete__NAME__",
          "statementPeriodClaim.update__NAME__",
          "statementPeriodClaim.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementperiodclaim",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementReconciliation": {
      "key": "statementReconciliation",
      "table": "statementreconciliation",
      "label": "StatementReconciliation",
      "description": "Current exact reconciliation state for one Account and committed statement import",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "key",
        "periodstart",
        "periodend",
        "currency",
        "openingbalanceminor",
        "signedmovementeffectminor",
        "expectedclosingbalanceminor",
        "reportedclosingbalanceminor",
        "differenceminor",
        "printedrowcount",
        "extractedrowcount",
        "movementcomponentcount",
        "informationalcomponentcount",
        "pendingcount",
        "proposedcount",
        "confirmedexistingcount",
        "newlymaterializedcount",
        "unresolvedcount",
        "transfercandidatecount",
        "activeissuecount",
        "blockingissuecount",
        "calculationstate",
        "coveragestate",
        "attestationstate",
        "calculationhash",
        "revision",
        "calculatedat",
        "calculationoperation",
        "latestattestationoperation",
        "latestreopeningoperation",
        "attestedat",
        "reopenedat",
        "provenance"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "key",
        "periodstart",
        "periodend",
        "currency",
        "signedmovementeffectminor",
        "printedrowcount",
        "extractedrowcount",
        "movementcomponentcount",
        "informationalcomponentcount",
        "pendingcount",
        "proposedcount",
        "confirmedexistingcount",
        "newlymaterializedcount",
        "unresolvedcount",
        "transfercandidatecount",
        "activeissuecount",
        "blockingissuecount",
        "calculationstate",
        "coveragestate",
        "attestationstate",
        "calculationhash",
        "revision",
        "calculatedat",
        "calculationoperation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementReconciliation.create__NAME__",
        "update": "statementReconciliation.update__NAME__",
        "delete": "statementReconciliation.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementReconciliation",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementReconciliation.create__NAME__",
          "statementReconciliation.delete__NAME__",
          "statementReconciliation.update__NAME__",
          "statementReconciliation.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementreconciliation",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementReconciliationEvent": {
      "key": "statementReconciliationEvent",
      "table": "statementreconciliationevent",
      "label": "StatementReconciliationEvent",
      "description": "Append-only attestation or reopening history for an exact statement reconciliation",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "statementreconciliation",
        "key",
        "eventtype",
        "reconciliationrevision",
        "calculationhash",
        "calculationsnapshot",
        "reason",
        "actorid",
        "channel",
        "operation",
        "recordedat"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "statementreconciliation",
        "key",
        "eventtype",
        "reconciliationrevision",
        "calculationhash",
        "calculationsnapshot",
        "channel",
        "operation",
        "recordedat"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementReconciliationEvent.create__NAME__",
        "update": "statementReconciliationEvent.update__NAME__",
        "delete": "statementReconciliationEvent.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementReconciliationEvent",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementReconciliationEvent.create__NAME__",
          "statementReconciliationEvent.delete__NAME__",
          "statementReconciliationEvent.update__NAME__",
          "statementReconciliationEvent.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementreconciliationevent",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementRow": {
      "key": "statementRow",
      "table": "statementrow",
      "label": "StatementRow",
      "description": "Raw statement row preserved from imported source material",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "key",
        "rownumber",
        "rowkind",
        "transactiondate",
        "postingdate",
        "valuedate",
        "sourcereference",
        "sourcelocator",
        "reportedbalanceminor",
        "componentcount",
        "extractionconfidence",
        "rowhash",
        "commitoperation",
        "postedat",
        "description",
        "normalizeddescription",
        "amount",
        "balance",
        "currency",
        "direction",
        "status",
        "confidence",
        "rawdata",
        "sourcechecksum",
        "transaction",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "key",
        "rownumber",
        "description",
        "amount",
        "currency",
        "direction",
        "status"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementRow.create__NAME__",
        "update": "statementRow.update__NAME__",
        "delete": "statementRow.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementRow",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementRow.create__NAME__",
          "statementRow.delete__NAME__",
          "statementRow.update__NAME__",
          "statementRow.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementrow",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementRowComponent": {
      "key": "statementRowComponent",
      "table": "statementrowcomponent",
      "label": "StatementRowComponent",
      "description": "Exact neutral source component extracted from one printed statement row",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "statementrow",
        "key",
        "componentkind",
        "componentrole",
        "transactiondate",
        "postingdate",
        "valuedate",
        "description",
        "sourcereference",
        "amountminor",
        "currency",
        "sourcedirection",
        "sourceflow",
        "balanceeffectminor",
        "sourcelocator",
        "confidence",
        "sourcechecksum",
        "sourcestate",
        "commitoperation",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "statementrow",
        "key",
        "componentkind",
        "componentrole",
        "description",
        "amountminor",
        "currency",
        "sourcedirection",
        "sourceflow",
        "balanceeffectminor",
        "sourcechecksum",
        "sourcestate",
        "commitoperation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementRowComponent.create__NAME__",
        "update": "statementRowComponent.update__NAME__",
        "delete": "statementRowComponent.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementRowComponent",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementRowComponent.create__NAME__",
          "statementRowComponent.delete__NAME__",
          "statementRowComponent.update__NAME__",
          "statementRowComponent.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementrowcomponent",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementSourceClaim": {
      "key": "statementSourceClaim",
      "table": "statementsourceclaim",
      "label": "StatementSourceClaim",
      "description": "Deterministic active claim preventing one exact statement source from being committed twice for an account",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "key",
        "originalfilesha256",
        "periodstart",
        "periodend",
        "state",
        "claimedat",
        "operation"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "key",
        "originalfilesha256",
        "periodstart",
        "periodend",
        "state",
        "claimedat",
        "operation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementSourceClaim.create__NAME__",
        "update": "statementSourceClaim.update__NAME__",
        "delete": "statementSourceClaim.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementSourceClaim",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementSourceClaim.create__NAME__",
          "statementSourceClaim.delete__NAME__",
          "statementSourceClaim.update__NAME__",
          "statementSourceClaim.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementsourceclaim",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementTransactionMatch": {
      "key": "statementTransactionMatch",
      "table": "statementtransactionmatch",
      "label": "StatementTransactionMatch",
      "description": "Audited interpretation linking exact statement movement components to one observed transaction",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "primarycomponent",
        "componentids",
        "transaction",
        "key",
        "state",
        "method",
        "reasoncodes",
        "confidence",
        "signedcomponenttotalminor",
        "currency",
        "revision",
        "proposedoperation",
        "confirmedoperation",
        "rejectedoperation",
        "supersededoperation",
        "proposedby",
        "reviewedby",
        "proposedat",
        "confirmedat",
        "rejectedat",
        "supersededat",
        "rejectionreason",
        "supersessionreason",
        "supersedes",
        "supersededby",
        "sourcestate",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "primarycomponent",
        "componentids",
        "transaction",
        "key",
        "state",
        "method",
        "reasoncodes",
        "confidence",
        "signedcomponenttotalminor",
        "currency",
        "revision",
        "proposedoperation",
        "proposedat",
        "sourcestate"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementTransactionMatch.create__NAME__",
        "update": "statementTransactionMatch.update__NAME__",
        "delete": "statementTransactionMatch.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementTransactionMatch",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementTransactionMatch.create__NAME__",
          "statementTransactionMatch.delete__NAME__",
          "statementTransactionMatch.update__NAME__",
          "statementTransactionMatch.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementtransactionmatch",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "statementTransactionResolutionClaim": {
      "key": "statementTransactionResolutionClaim",
      "table": "statementtransactionresolutionclaim",
      "label": "StatementTransactionResolutionClaim",
      "description": "Deterministic active claim preventing one transaction from being claimed by multiple statement imports",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "statementimport",
        "statementtransactionmatch",
        "transaction",
        "key",
        "periodstart",
        "periodend",
        "state",
        "claimedat",
        "releasedat",
        "operation"
      ],
      "requiredFields": [
        "space",
        "account",
        "statementimport",
        "statementtransactionmatch",
        "transaction",
        "key",
        "periodstart",
        "periodend",
        "state",
        "claimedat",
        "operation"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "statementTransactionResolutionClaim.create__NAME__",
        "update": "statementTransactionResolutionClaim.update__NAME__",
        "delete": "statementTransactionResolutionClaim.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "statementTransactionResolutionClaim",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "statementTransactionResolutionClaim.create__NAME__",
          "statementTransactionResolutionClaim.delete__NAME__",
          "statementTransactionResolutionClaim.update__NAME__",
          "statementTransactionResolutionClaim.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "statementtransactionresolutionclaim",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "transaction": {
      "key": "transaction",
      "table": "transaction",
      "label": "Transaction",
      "description": "Normalized money movement derived from a statement row or manual entry",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud"
      ],
      "fields": [
        "space",
        "account",
        "key",
        "sourcerow",
        "sourcechecksum",
        "postedat",
        "effectiveat",
        "description",
        "normalizeddescription",
        "amount",
        "amountminor",
        "balance",
        "currency",
        "direction",
        "transactionkind",
        "flowdirection",
        "entrysource",
        "recordedat",
        "status",
        "confidence",
        "merchantname",
        "merchant",
        "category",
        "istransfer",
        "operation",
        "statementmatch",
        "transfer",
        "manualoverride",
        "notes"
      ],
      "requiredFields": [
        "space",
        "account",
        "key",
        "postedat",
        "description",
        "amount",
        "currency",
        "direction",
        "status"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [],
      "subtableKeys": [],
      "taxonomies": [],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "transaction.create__NAME__",
        "update": "transaction.update__NAME__",
        "delete": "transaction.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "transaction",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "transaction.create__NAME__",
          "transaction.delete__NAME__",
          "transaction.update__NAME__",
          "transaction.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "transaction",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    },
    "user": {
      "key": "user",
      "table": "u",
      "label": "User",
      "description": "Minimal Raven user profile",
      "authority": "source",
      "data": "local",
      "schemaType": "schemaless",
      "capabilities": [
        "router",
        "crud",
        "taxonomies"
      ],
      "fields": [
        "email",
        "uniqueid",
        "firstname",
        "surname",
        "role"
      ],
      "requiredFields": [
        "email",
        "firstname",
        "surname",
        "role"
      ],
      "typesense": {
        "enabled": false,
        "collection": null,
        "fields": [],
        "sortableFields": []
      },
      "taxonomyKeys": [
        "role"
      ],
      "subtableKeys": [],
      "taxonomies": [
        {
          "key": "role",
          "actions": {
            "getTerms": "user.role.getTerms",
            "getRecordTerms": "user.role.getRecordTerms",
            "attach": "user.role.attach",
            "detach": "user.role.detach",
            "addTerm": "user.role.addTerm"
          }
        }
      ],
      "subtables": [],
      "relations": [],
      "crud": {
        "enabled": true,
        "create": "user.create__NAME__",
        "update": "user.update__NAME__",
        "delete": "user.delete__NAME__"
      },
      "router": {
        "enabled": true,
        "key": "user",
        "parent": null,
        "embedInParent": false,
        "procedures": [
          "user.create__NAME__",
          "user.delete__NAME__",
          "user.update__NAME__",
          "user.views"
        ]
      },
      "bootstrap": {
        "ensureTable": true,
        "tableDefinition": {
          "model": "u",
          "type": "NORMAL",
          "schemaType": "schemaless",
          "permissions": "full"
        }
      },
      "admin": {
        "enabled": true
      },
      "settingsRaw": {
        "authority": "source"
      },
      "warnings": []
    }
  }
} as const;

export type ModelsManifest = typeof modelsManifest;
export type ModelsManifestModel = ModelsManifest['models'][keyof ModelsManifest['models']];
