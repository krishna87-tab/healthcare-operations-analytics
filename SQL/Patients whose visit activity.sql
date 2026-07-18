
/*  Patients whose visit activity is increasing over time. */

WITH patient_monthly_visits AS (
  SELECT
    patient_id,
    DATE_TRUNC(DATE(encounter_started_at), MONTH) AS visit_month,
    COUNT(*) AS visit_count

  FROM `healthcare-project-502404.gjs.ent`

  GROUP BY
    patient_id, visit_month
),

visit_trend AS (
  SELECT
    pmv.patient_id,
    pmv.visit_month, 
    pmv.visit_count,

    LAG(pmv.visit_count) OVER ( PARTITION BY pmv.patient_id ORDER BY pmv.visit_month ) 
    AS previous_month_visit_count

  FROM patient_monthly_visits pmv
)

SELECT
  patient_id,
  visit_month,
  visit_count,
  previous_month_visit_count,
  visit_count - previous_month_visit_count AS visit_increase
FROM visit_trend
WHERE previous_month_visit_count IS NOT NULL
  AND visit_count > previous_month_visit_count
ORDER BY visit_increase DESC, patient_id, visit_month;

