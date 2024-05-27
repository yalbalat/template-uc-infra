// Define tables where you want to check the month assertion.
// Format: tables = {target_table : limit_date_check}
const tables = {
    "t_rpt_template" : "2022"
  };

  // Do not modify this function unless you have specific requirements.
  const createRowConditionAssertion = (target_table, limit_date_check) => {
    assert(`assert_month_${target_table}`)
      .database(dataform.projectConfig.vars.project + dataform.projectConfig.vars.env)
      .schema(`d_${dataform.projectConfig.vars.use_case}_assertions_eu_${dataform.projectConfig.vars.env}`)
      .description(`Assert there is 12 months for each year in ${target_table}`)
      .tags("assertions")
      .query(ctx => `
  WITH monthly_counts AS (
    SELECT
      COUNT(DISTINCT MONTH) AS nb_month,
      dummy_year
    FROM
     ${ctx.ref(target_table)}
    WHERE
      dummy_year >= ${limit_date_check}
      AND dummy_year != EXTRACT(YEAR
                  FROM
                  CURRENT_DATE())
    GROUP BY dummy_year
  )
  SELECT *
  FROM monthly_counts
  WHERE nb_month != 12

  `);
  };

  // Loop through tables to create assertions.
  // Do not modify this loop unless you have specific requirements.
  for (let target_table in tables) {
      const limit_date_check = tables[target_table];
      createRowConditionAssertion(target_table, limit_date_check);
  }
  // Do not modify this loop unless you have specific requirements.
