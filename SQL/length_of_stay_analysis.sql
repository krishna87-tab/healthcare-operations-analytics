/* 
Finds the average length of stay per diagnosis group, admission type and room type.
*/

WITH admission_los AS (
  SELECT
    dx.diagnosis_group,
    a.admission_type,
    a.room_type,
    TIMESTAMP_DIFF(a.discharged_at, a.admitted_at, DAY) AS length_of_stay_days

  FROM `healthcare-project-502404.gjs.admission` a
  JOIN `healthcare-project-502404.gjs.ent` e
    ON a.admission_id = e.admission_id
  JOIN `healthcare-project-502404.gjs.diagnose_clean` dx
    ON e.diagnosis_code = dx.diagnosis_code
)

SELECT
  diagnosis_group,
  admission_type,
  room_type,

  COUNT(*) AS total_admissions,
  ROUND(AVG(length_of_stay_days), 2) AS avg_length_of_stay,
  APPROX_QUANTILES(length_of_stay_days, 100)[OFFSET(90)] AS p90_length_of_stay

FROM admission_los
GROUP BY diagnosis_group, admission_type, room_type
ORDER BY avg_length_of_stay DESC;
