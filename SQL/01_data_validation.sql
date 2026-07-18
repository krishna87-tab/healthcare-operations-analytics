
SELECT 'admission' AS table_name, COUNT(*) AS row_count FROM `healthcare-project-502404.gjs.admission`
UNION ALL
SELECT 'appointments', COUNT(*) FROM `healthcare-project-502404.gjs.appointments`
UNION ALL
SELECT 'pat', COUNT(*) FROM `healthcare-project-502404.gjs.pat`
UNION ALL
SELECT 'doc', COUNT(*) FROM `healthcare-project-502404.gjs.doc`
UNION ALL
SELECT 'ent', COUNT(*) FROM `healthcare-project-502404.gjs.ent`
UNION ALL
SELECT 'bill', COUNT(*) FROM `healthcare-project-502404.gjs.bill`
UNION ALL
SELECT 'claims', COUNT(*) FROM `healthcare-project-502404.gjs.claims`
UNION ALL
SELECT 'dept', COUNT(*) FROM `healthcare-project-502404.gjs.dept`;


SELECT column_name, data_type
FROM `healthcare-project-502404.gjs.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'dept_clean'
ORDER BY ordinal_position;

select * from `healthcare-project-502404.gjs.dept_clean`;


CREATE OR REPLACE TABLE `healthcare-project-502404.gjs.dept_clean` AS
SELECT
  string_field_0 AS department_id,
  string_field_1 AS department_name,
  string_field_2 AS department_group
FROM `healthcare-project-502404.gjs.dept_clean`
WHERE string_field_0 != 'department_id';


SELECT *
FROM `healthcare-project-502404.gjs.dept_clean`
LIMIT 10;

CREATE OR REPLACE TABLE `healthcare-project-502404.gjs.catalog_clean` AS
SELECT
  string_field_0 AS procedure_code,
  string_field_1 AS procedure_name,
  string_field_2 AS department_id,
  SAFE_CAST(NULLIF(string_field_3, '') AS NUMERIC) AS standard_cost
FROM `healthcare-project-502404.gjs.catalog`
WHERE string_field_0 != 'procedure_code';

CREATE OR REPLACE TABLE `healthcare-project-502404.gjs.catalog_clean` AS
SELECT
  procedure_code,
  procedure_name,
  department_id,
  SAFE_CAST(standard_cost AS NUMERIC) AS standard_cost
FROM `healthcare-project-502404.gjs.catalog`;

CREATE OR REPLACE TABLE `healthcare-project-502404.gjs.diagnose_clean` AS
SELECT
  string_field_0 AS diagnosis_code,
  string_field_1 AS diagnosis_description,
  string_field_2 AS diagnosis_group
FROM `healthcare-project-502404.gjs.diagnose`
WHERE string_field_0 != 'diagnosis_code';

CREATE OR REPLACE TABLE `healthcare-project-502404.gjs.med_clean` AS
SELECT
  string_field_0 AS medication_id,
  string_field_1 AS medication_name,
  string_field_2 AS medication_class
FROM `healthcare-project-502404.gjs.med`
WHERE string_field_0 != 'medication_id';

SELECT column_name, data_type
FROM `healthcare-project-502404.gjs.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'catalog'
ORDER BY ordinal_position;
