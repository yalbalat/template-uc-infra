// Define tables where you want to check the no duplicate assertion.
// Format: tables = {sourceTable : targetTable}
const tables = {
    // "source_table" : "target_table",
    "dummy_table"  : "t_rpt_template"
  };

  // Do not modify this function unless you have specific requirements.
  const createRowConditionAssertion = (sourceTable, target_table) => {
    assert(`assert_no_duplicates_${target_table}_with_source`)
      .database(dataform.projectConfig.vars.project + dataform.projectConfig.vars.env)
      .schema(`d_${dataform.projectConfig.vars.use_case}_assertions_eu_${dataform.projectConfig.vars.env}`)
      .description(`Assert there is no duplicates in ${target_table}`)
      .tags("assertions")
      .query(ctx => `
    SELECT
      "TS" AS Table_source,
      COUNT(*) AS nb_rows
    FROM
     ${ctx.ref(target_table)}
      EXCEPT DISTINCT
    SELECT
      "TS" AS Table_source,
      COUNT(*) AS nb_rows
    FROM
    ${ctx.ref(sourceTable)}

  `);
  };

  // Loop through tables to create assertions.
  // Do not modify this loop unless you have specific requirements.
  for (let sourceTable in tables) {
      const target_table = tables[sourceTable];
      createRowConditionAssertion(sourceTable, target_table);
  }
  // Do not modify this loop unless you have specific requirements.
