// Define unique key conditions for specific tables.
// Format: uniqueKeyConditions = { tableName : [column1, column2, ...] }
const uniqueKeyConditions = {
  "t_rpt_template": ["dummy_ingestion_date", "dummy_country"]
};

// Do not modify this function unless you have specific requirements.
const createUniqueKeyAssertion = (tableName, columns) => {
  const uniqueColumns = columns.join(', ');

  assert(`assert_unique_key_${tableName}`)
    .database(dataform.projectConfig.vars.project + dataform.projectConfig.vars.env)
    .schema(`d_${dataform.projectConfig.vars.use_case}_assertions_eu_${dataform.projectConfig.vars.env}`)
    .description(`Check that values in columns (${uniqueColumns}) in ${tableName} form a unique key`)
    .tags("assertions")
    .query(ctx => `SELECT ${uniqueColumns}
                       FROM ${ctx.ref(tableName)}
                       GROUP BY ${uniqueColumns}
                       HAVING COUNT(*) > 1`);
};

// Loop through uniqueKeyConditions to create unique key check assertions.
// Do not modify this loop unless you have specific requirements.
for (let tableName in uniqueKeyConditions) {
  const columns = uniqueKeyConditions[tableName];
  createUniqueKeyAssertion(tableName, columns);
}
// Do not modify this loop unless you have specific requirements.
