/* 
  Patient Journey from Appointment to Billing and Claim
  Business question:
  How does a patient visit move from appointment to clinical encounter to billing and insurance claim?
*/

WITH patient_journey AS (
  SELECT
    a.appointment_id,
    a.patient_id,
    p.patient_name,
    d.department_name,
    doc.doctor_name,
    a.scheduled_at,
    a.appointment_status,
    a.visit_type,
    e.encounter_id,
    e.encounter_started_at,
    e.encounter_ended_at,
    dx.diagnosis_description,
    b.billing_id,
    b.bill_date,
    b.total_charge,
    b.payment_status,
    c.claim_id,
    c.claim_submitted_at,
    c.claim_status,
    c.denial_reason,
    c.paid_amount

  FROM `healthcare-project-502404.gjs.appointments` a
  LEFT JOIN `healthcare-project-502404.gjs.ent` e

    ON a.appointment_id = e.appointment_id
  LEFT JOIN `healthcare-project-502404.gjs.pat` p
    ON a.patient_id = p.patient_id

  LEFT JOIN `healthcare-project-502404.gjs.dept_clean` d
    ON a.department_id = d.department_id

  LEFT JOIN `healthcare-project-502404.gjs.doc` doc
    ON a.doctor_id = doc.doctor_id

  LEFT JOIN `healthcare-project-502404.gjs.diagnose_clean` dx
    ON e.diagnosis_code = dx.diagnosis_code

  LEFT JOIN `healthcare-project-502404.gjs.bill` b
    ON e.encounter_id = b.encounter_id
    
  LEFT JOIN `healthcare-project-502404.gjs.claims` c
    ON b.billing_id = c.billing_id
)
SELECT *
FROM patient_journey
WHERE appointment_status = 'Completed'
ORDER BY scheduled_at
LIMIT 100;

