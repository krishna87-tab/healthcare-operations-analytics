/*This query analyzes monthly doctor workload by department. 
It counts completed patient encounters for each doctor,
then uses RANK() to identify the top 
3 busiest doctors within every department for each month.*/

WITH doctor_monthly_volume AS (
  SELECT
    DATE_TRUNC(DATE(e.encounter_started_at), MONTH) AS encounter_month,
    d.department_name,
    e.doctor_id,
    doc.doctor_name,
    COUNT(e.encounter_id) AS completed_encounters

  FROM `healthcare-project-502404.gjs.ent` e
  JOIN `healthcare-project-502404.gjs.dept_clean` d

    ON e.department_id = d.department_id
  JOIN `healthcare-project-502404.gjs.doc` doc
    ON e.doctor_id = doc.doctor_id

  GROUP BY
    encounter_month,
    d.department_name,
    e.doctor_id,
    doc.doctor_name
),

ranked_doctors AS (
  SELECT
    *,
    RANK() OVER ( PARTITION BY encounter_month, department_name ORDER BY completed_encounters DESC) AS workload_rank
    
  FROM doctor_monthly_volume
)

SELECT *
FROM ranked_doctors
WHERE workload_rank <= 3
ORDER BY encounter_month, department_name, workload_rank;
