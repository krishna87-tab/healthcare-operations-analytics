/*  
  High-Cost Encounter Analysis with Percentile Ranking
  Business question:
  Which encounters fall into the highest-cost segment, and what patterns do they show?
*/

WITH encounter_costs AS (
  SELECT
    b.encounter_id,
    b.patient_id,
    e.department_id,
    d.department_name,
    e.diagnosis_code,
    dx.diagnosis_group,
    e.severity_level,
    b.total_charge,
    b.patient_responsibility,
    b.payer_responsibility
  
  FROM `healthcare-project-502404.gjs.bill` b
  JOIN `healthcare-project-502404.gjs.ent` e
    ON b.encounter_id = e.encounter_id
  JOIN `healthcare-project-502404.gjs.dept_clean` d
    ON e.department_id = d.department_id
  JOIN `healthcare-project-502404.gjs.diagnose_clean` dx
    ON e.diagnosis_code = dx.diagnosis_code
),
ranked_costs AS (
  SELECT
    *,
    NTILE(10) OVER (ORDER BY total_charge DESC) AS cost_decile,
    PERCENT_RANK() OVER (ORDER BY total_charge) AS cost_percent_rank
  FROM encounter_costs
)
SELECT
  encounter_id,
  patient_id,
  department_name,
  diagnosis_group,
  severity_level,
  total_charge,
  patient_responsibility,
  payer_responsibility,
  cost_decile,
  ROUND(cost_percent_rank * 100, 2) AS cost_percentile
FROM ranked_costs
WHERE cost_decile = 1
ORDER BY total_charge DESC;


