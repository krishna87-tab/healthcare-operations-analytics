/* 
The Doctors which may have busier schedule than the others.
*/

WITH doctor_waits AS (
  SELECT
    d.department_name,
    a.doctor_id,
    doc.doctor_name,
    ROUND(AVG(a.wait_minutes), 2) AS doctor_avg_wait
  FROM `healthcare-project-502404.gjs.appointments` a
  JOIN `healthcare-project-502404.gjs.doc` doc
    ON a.doctor_id = doc.doctor_id
  JOIN `healthcare-project-502404.gjs.dept_clean` d
    ON a.department_id = d.department_id
  WHERE a.appointment_status = 'Completed'
  GROUP BY d.department_name, a.doctor_id, doc.doctor_name
),

department_waits AS (
  SELECT
    department_name,
    ROUND(AVG(doctor_avg_wait), 2) AS department_avg_wait
  FROM doctor_waits
  GROUP BY department_name
)

SELECT
  dw.department_name,
  dw.doctor_id,
  dw.doctor_name,
  dw.doctor_avg_wait,
  dept.department_avg_wait,
  ROUND(dw.doctor_avg_wait - dept.department_avg_wait, 2) AS wait_gap
FROM doctor_waits dw
JOIN department_waits dept
  ON dw.department_name = dept.department_name
WHERE dw.doctor_avg_wait > dept.department_avg_wait
ORDER BY wait_gap DESC;
