
/*
  Are claim denials improving or worsening over time?
*/

WITH monthly_claims AS (
  SELECT
    DATE_TRUNC(claim_submitted_at, MONTH) AS claim_month,
    COUNT(*) AS total_claims,
    COUNTIF(claim_status = 'Denied') AS denied_claims,
    COUNTIF(claim_status = 'Approved') AS approved_claims,

    ROUND(SAFE_DIVIDE(COUNTIF(claim_status = 'Denied'), COUNT(*)) * 100, 2) AS denial_rate_pct,
    SUM(paid_amount) AS total_paid_amount

  FROM `healthcare-project-502404.gjs.claims`
  GROUP BY claim_month
),
claim_trend AS (
  SELECT *,
    LAG(denial_rate_pct) OVER (ORDER BY claim_month) AS previous_month_denial_rate_pct,
    LAG(total_paid_amount) OVER (ORDER BY claim_month) AS previous_month_paid_amount
  FROM monthly_claims
)
SELECT
  claim_month,
  total_claims,
  approved_claims,
  denied_claims,
  denial_rate_pct,
  previous_month_denial_rate_pct,

  ROUND(denial_rate_pct - previous_month_denial_rate_pct, 2) AS denial_rate_change_pct,
  total_paid_amount,
  previous_month_paid_amount,
  ROUND(total_paid_amount - previous_month_paid_amount, 2) AS paid_amount_change
  
FROM claim_trend
ORDER BY claim_month;
