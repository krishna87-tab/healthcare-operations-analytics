/* 
Revenue risk analysis due to denial claims by the insurance companies.
*/

SELECT
  comp.insurance_name,
  COUNT(*) AS denied_claims,
  ROUND(SUM(b.payer_responsibility), 2) AS potential_revenue_at_risk,
  ROUND(AVG(b.payer_responsibility), 2) AS avg_denied_claim_value

FROM `healthcare-project-502404.gjs.claims` c
JOIN `healthcare-project-502404.gjs.bill` b
  ON c.billing_id = b.billing_id
JOIN `healthcare-project-502404.gjs.comp_clean` comp
  ON c.insurance_id = comp.insurance_id

WHERE c.claim_status = 'Denied'
GROUP BY comp.insurance_name
ORDER BY potential_revenue_at_risk DESC;
