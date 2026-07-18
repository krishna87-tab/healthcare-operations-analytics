/*
  Monthly Revenue and Paid Amount Trend
  Business question:
  How are billed charges and insurance payments changing month over month?
*/

WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC(b.bill_date, MONTH) AS bill_month,
    COUNT(DISTINCT b.encounter_id) AS billed_encounters,
    SUM(b.total_charge) AS total_charges,
    SUM(b.patient_responsibility) AS total_patient_responsibility,
    SUM(b.payer_responsibility) AS total_payer_responsibility,
    SUM(c.paid_amount) AS total_paid_amount
    
  FROM `healthcare-project-502404.gjs.bill` b
  LEFT JOIN `healthcare-project-502404.gjs.claims` c
    ON b.billing_id = c.billing_id
  GROUP BY bill_month
),
revenue_trend AS (
  SELECT
    *,
    LAG(total_charges) OVER (ORDER BY bill_month) AS previous_month_charges,
    LAG(total_paid_amount) OVER (ORDER BY bill_month) AS previous_month_paid_amount
  FROM monthly_revenue
)
SELECT
  bill_month,
  billed_encounters,
  total_charges,
  previous_month_charges,
  ROUND(SAFE_DIVIDE(total_charges - previous_month_charges, previous_month_charges) * 100, 2) AS charge_mom_growth_pct,
  total_paid_amount,
  previous_month_paid_amount,
  ROUND(SAFE_DIVIDE(total_paid_amount - previous_month_paid_amount, previous_month_paid_amount) * 100, 2) AS paid_mom_growth_pct,
  total_patient_responsibility,
  total_payer_responsibility
FROM revenue_trend
ORDER BY bill_month;
