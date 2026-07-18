/* 
Reasons for insurance denial by the insurance company.
*/


WITH denial_summary AS (
  SELECT
    comp.insurance_name,
    c.denial_reason,
    COUNT(*) AS denied_claims

  FROM `healthcare-project-502404.gjs.claims` c
  JOIN `healthcare-project-502404.gjs.comp_clean` comp
    ON c.insurance_id = comp.insurance_id

  WHERE c.claim_status = 'Denied'
  GROUP BY comp.insurance_name, c.denial_reason
),

ranked_denials AS (
  SELECT
    *,
    RANK() OVER ( PARTITION BY insurance_name ORDER BY denied_claims DESC ) AS denial_reason_rank

  FROM denial_summary
)

SELECT *
FROM ranked_denials
WHERE denial_reason_rank <= 3
ORDER BY insurance_name, denial_reason_rank;

