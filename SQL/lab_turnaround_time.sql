/* 
  Lab Turnaround Time Analysis
  Business question:
  Which lab tests have the longest result turnaround times?

  Business impact: This helps hospital labs identify bottleneck tests (slow turnaround), 
  monitor quality indicators (abnormal/critical results), and  track cost efficiency.
*/

WITH lab_turnaround AS (
  SELECT
    test_name,
    result_flag,
    lab_test_id,
    patient_id,
    ordered_at,
    resulted_at,
    TIMESTAMP_DIFF(resulted_at, ordered_at, HOUR) AS turnaround_hours,
    test_cost
  FROM `healthcare-project-502404.gjs.test`
),
test_summary AS (
  SELECT
    test_name,
    COUNT(*) AS total_tests,
    COUNTIF(result_flag = 'Abnormal') AS abnormal_results,
    COUNTIF(result_flag = 'Critical') AS critical_results,
    ROUND(AVG(turnaround_hours), 2) AS avg_turnaround_hours,
    APPROX_QUANTILES(turnaround_hours, 100)[OFFSET(90)] AS p90_turnaround_hours,
    ROUND(AVG(test_cost), 2) AS avg_test_cost
    
  FROM lab_turnaround
  GROUP BY test_name
),
ranked_tests AS (
  SELECT
    *,
    RANK() OVER (ORDER BY avg_turnaround_hours DESC) AS turnaround_rank FROM test_summary
)
SELECT *
FROM ranked_tests
ORDER BY turnaround_rank;


