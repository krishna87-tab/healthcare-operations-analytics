/* 

Problem Statement
Hospitals and healthcare providers closely monitor readmission rates, 
especially within 30 days of discharge, because they are a key quality metric. 
High readmission rates often indicate gaps in patient care,
discharge planning, or follow‑up treatment.

The challenge: Identify which diagnosis groups have the highest 30‑day readmission rates.

 */

WITH admission_sequence AS (
  SELECT
    a.patient_id,
    a.admission_id,
    e.diagnosis_code,
    dx.diagnosis_group,
    a.admitted_at,
    a.discharged_at,

  LEAD(a.admitted_at) OVER ( PARTITION BY a.patient_id ORDER BY a.admitted_at ) AS next_admitted_at

  FROM `healthcare-project-502404.gjs.admission` a
  JOIN `healthcare-project-502404.gjs.ent` e

    ON a.admission_id = e.admission_id
  JOIN `healthcare-project-502404.gjs.diagnose_clean` dx
    ON e.diagnosis_code = dx.diagnosis_code
),
readmission_flags AS (
  SELECT 
    *,
    CASE
      WHEN next_admitted_at IS NOT NULL
       AND TIMESTAMP_DIFF(next_admitted_at, discharged_at, DAY) BETWEEN 0 AND 30
      THEN 1
      ELSE 0
    END AS readmitted_30d
  FROM admission_sequence
)
SELECT
  diagnosis_group,
  COUNT(*) AS total_admissions,
  SUM(readmitted_30d) AS readmissions_30d,
  ROUND(SAFE_DIVIDE(SUM(readmitted_30d), COUNT(*)) * 100, 2) AS readmission_rate_pct

FROM readmission_flags
GROUP BY diagnosis_group
ORDER BY readmission_rate_pct DESC;


