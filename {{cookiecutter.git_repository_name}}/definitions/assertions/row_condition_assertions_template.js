// Define row-level conditions for assertions.
// Format: rowConditions = { tableName : { conditionName : conditionQuery } }
const rowConditions = {
  "t_rpt_template": {
    "not_null": "dummy_ingestion_date IS NOT NULL AND dummy_country IS NOT NULL",
    "len_country": "LENGTH(dummy_country) = 2"
  }
};

// Do not modify this function unless you have specific requirements.
const createRowConditionAssertion = (tableName, conditionName, conditionQuery) => {
  assert(`assert_${conditionName}_${tableName}`)
    .database(dataform.projectConfig.vars.project + dataform.projectConfig.vars.env)
    .schema(`d_${dataform.projectConfig.vars.use_case}_assertions_eu_${dataform.projectConfig.vars.env}`)
    .description(`Assert that rows in ${tableName} meet ${conditionName}`)
    .tags("assertions")
    .query(ctx => `SELECT "Condition not met: ${conditionQuery}, Table: ${ctx.ref(tableName)}" AS assertion_description
                       FROM ${ctx.ref(tableName)}
                       WHERE NOT (${conditionQuery})`);
};

// Loop through rowConditions to create assertions.
// Do not modify this loop unless you have specific requirements.
for (let tableName in rowConditions) {
  for (let conditionName in rowConditions[tableName]) {
    const conditionQuery = rowConditions[tableName][conditionName];
    createRowConditionAssertion(tableName, conditionName, conditionQuery);
  }
}
// Do not modify this loop unless you have specific requirements.
