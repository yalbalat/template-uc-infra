// Define data types expectations.
// Format: schemaConditions = { dataset_name : { table_name : {column_expected : type_expected} } }
const schemaConditions = {
    "emea-sbxhrialan-gbl-emea-dv.d_uc_infra_reporting_eu_dv": {
      "t_rpt_template": {
        "dummy_ingestion_date" : "DATE",
        "dummy_country" : "STRING",
        "dummy_field" : "STRING"
      }
    }
  };

  // Do not modify this function unless you have specific requirements.
  const createRowConditionAssertion = (datasetName, tableName, fieldExpected) => {
    assert(`assert_schema_${datasetName}_${tableName}`)
      .database(dataform.projectConfig.vars.project + dataform.projectConfig.vars.env)
      .schema(`d_${dataform.projectConfig.vars.use_case}_assertions_eu_${dataform.projectConfig.vars.env}`)
      .description(`Assert that column in ${tableName} meet the rexpected schema`)
      .tags("assertions")
      .query(ctx => `
  DECLARE table_name STRING;
  DECLARE expected_types ARRAY<STRUCT<column_name STRING, expected_type STRING>>;


  -- Define the expected types with column names (modify)
  SET expected_types = [${fieldExpected}];
  -- Replace with your expected column names and types

  -- Check column types against expected types
  WITH ColumnMismatch AS (
    SELECT
      column_name,
      data_type AS actual_type
    FROM
      \`${datasetName}.INFORMATION_SCHEMA.COLUMNS\`
    WHERE
      table_name = "${tableName}"
      )
  SELECT
    ColumnMismatch.column_name,
    ColumnMismatch.actual_type,
    expected_type.expected_type
  FROM
    ColumnMismatch
  LEFT JOIN
    UNNEST(expected_types) AS expected_type
  ON
    expected_type.column_name = ColumnMismatch.column_name
  WHERE
    expected_type IS NULL
    OR expected_type.expected_type != actual_type`);
  };

  function convertJSONToArray(inputJSON) {
    const outputArray = Object.keys(inputJSON).map((columnName) => {
      const expectedType = inputJSON[columnName];
      return `STRUCT('${columnName}' AS column_name, '${expectedType}' AS expected_type)`;
    });

    return outputArray;
  }
  // Loop through schemaConditions to create assertions.
  // Do not modify this loop unless you have specific requirements.
  for (let datasetName in schemaConditions) {
    for (let tableName in schemaConditions[datasetName]) {
      const fieldExpected = schemaConditions[datasetName][tableName];
      createRowConditionAssertion(datasetName, tableName, convertJSONToArray(fieldExpected));
    }
  }
  // Do not modify this loop unless you have specific requirements.
