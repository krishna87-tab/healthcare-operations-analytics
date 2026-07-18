/*
Department Appointment Analysis with Ranking by Volume and Wait Time.

Problem Statement: Hospitals and clinics need to monitor appointment performance across departments. 
Key questions include:

Which departments handle the highest appointment volumes?
How do wait times vary across departments?
What proportion of appointments are completed, cancelled, or marked as no‑shows?

The challenge: Provide a ranked view of departments by appointment volume and average wait time.
*/

WITH department_appointments AS (
  SELECT
    d.department_name,
    d.department_group,
    COUNT(a.appointment_id) AS total_appointments,
    COUNTIF(a.appointment_status = 'Completed') AS completed_appointments,
    COUNTIF(a.appointment_status = 'Cancelled') AS cancelled_appointments,
    COUNTIF(a.appointment_status = 'No-Show') AS no_show_appointments,
    ROUND(AVG(a.wait_minutes), 2) AS avg_wait_minutes

  FROM `healthcare-project-502404.gjs.appointments` a
  JOIN `healthcare-project-502404.gjs.dept_clean` d

    ON a.department_id = d.department_id
  
  GROUP BY
    d.department_name,
    d.department_group
),

ranked_departments AS (
  SELECT
    *,
    RANK() OVER (ORDER BY total_appointments DESC) AS volume_rank,
    RANK() OVER (ORDER BY avg_wait_minutes DESC) AS wait_time_rank
  FROM department_appointments
)

SELECT *
FROM ranked_departments
ORDER BY total_appointments DESC;

