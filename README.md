# Healthcare Operations Analytics using BigQuery SQL and Looker Studio

## Project Overview

This project analyzes healthcare operations data for a multi-department hospital network using advanced SQL in Google BigQuery. The goal is to identify operational bottlenecks, patient flow issues, financial leakage, claim denial patterns, and readmission trends.

The project focuses on SQL-based analytics, with Looker Studio used as the reporting and dashboard layer.

## Business Problem

Hospitals manage large volumes of appointments, admissions, clinical encounters, billing records, insurance claims, lab tests, and procedures. Without structured analysis, it becomes difficult to answer key operational questions:

- Which departments handle the highest patient volume?
- Where are patients experiencing the longest wait times?
- Which doctors have the highest monthly workload?
- Which diagnosis groups have higher readmission patterns?
- Which insurance companies contribute most to denied claims?
- How much revenue is at risk due to denied claims?
- Which lab tests have the longest turnaround times?
- How are monthly charges and payments changing over time?

This project solves these problems using SQL queries, CTEs, joins, window functions, conditional aggregation, ranking, and date-based analysis.

## Tools Used

- Google BigQuery
- BigQuery SQL
- Looker Studio
- Synthetic healthcare operations dataset

## Dataset Description

The dataset is synthetic and designed for portfolio-level SQL analysis. It simulates a healthcare operations environment with patient visits, doctor activity, admissions, billing, insurance claims, procedures, prescriptions, and lab testing.

Main tables:

- `appointments`
- `admission`
- `ent` - encounters
- `pat` - patients
- `doc` - doctors
- `bill` - billing
- `claims` - insurance claims
- `dept_clean` - departments
- `diagnose_clean` - diagnoses
- `comp_clean` - insurance companies
- `med_clean` - medications
- `catalog` - procedure catalog
- `proc_performed`
- `pres`
- `test`

Some lookup tables were cleaned after upload because BigQuery assigned generic column names during CSV import. Cleaned versions were created using SQL.

## Project Workflow

1. Uploaded healthcare CSV files into BigQuery.
2. Validated table row counts and schema structure.
3. Fixed header issues by creating clean lookup tables.
4. Wrote advanced SQL queries for operational and financial analysis.
5. Designed dashboard sections for Looker Studio.
6. Kept BigQuery ML readmission prediction as an optional extension.

## Key Business Questions and SQL Solutions

### 1. Department Patient Volume and Wait-Time Analysis

**Business question:**  
Which departments receive the highest appointment volume, and which departments have the longest average wait times?

**SQL approach:**  
Used joins, CTEs, conditional aggregation, and `RANK()` to calculate appointment volume, completion count, cancellation count, no-show count, and average wait time by department.

**Business value:**  
Helps hospital operations teams identify overloaded departments and areas where patient wait times may require process improvement.

### 2. Doctor Workload Ranking by Department and Month

**Business question:**  
Which doctors handle the highest number of patient encounters each month within their departments?

**SQL approach:**  
Used monthly aggregation with `DATE_TRUNC()` and `RANK()` partitioned by month and department.

**Business value:**  
Supports workload balancing, staffing decisions, and department-level performance monitoring.

### 3. 30-Day Readmission Analysis

**Business question:**  
Which diagnosis groups are associated with higher 30-day readmission rates?

**SQL approach:**  
Used `LEAD()` to sequence patient admissions and identify whether a patient was admitted again within 30 days after discharge.

**Business value:**  
Helps identify clinical areas where follow-up care, discharge planning, or care coordination may need improvement.

### 4. Monthly Claim Denial Trend

**Business question:**  
Are insurance claim denials increasing or decreasing over time?

**SQL approach:**  
Used monthly aggregation, `COUNTIF()`, `SAFE_DIVIDE()`, and `LAG()` to calculate denial rates and month-over-month changes.

**Business value:**  
Helps revenue cycle teams monitor payer performance and detect worsening denial trends.

### 5. Revenue Leakage from Denied Claims

**Business question:**  
Which insurance companies create the highest potential revenue loss from denied claims?

**SQL approach:**  
Joined claims, billing, and insurance company tables to calculate denied claim counts, total payer responsibility at risk, and average denied claim value.

**Business value:**  
Highlights where billing teams should prioritize denial management and payer follow-up.

### 6. High-Cost Encounter Analysis

**Business question:**  
Which patient encounters fall into the highest-cost segment?

**SQL approach:**  
Used `NTILE()` and `PERCENT_RANK()` to segment encounters by total charge and identify the top-cost decile.

**Business value:**  
Supports cost monitoring and helps identify patterns in high-cost care delivery.

### 7. Lab Turnaround Time Analysis

**Business question:**  
Which lab tests take the longest time to return results?

**SQL approach:**  
Used `TIMESTAMP_DIFF()`, grouped test-level metrics, and ranked tests by average turnaround time.

**Business value:**  
Helps diagnostic teams identify bottlenecks in lab processing and improve clinical response time.

### 8. Patient Journey Analysis

**Business question:**  
How does a patient move from appointment to encounter, diagnosis, billing, and insurance claim?

**SQL approach:**  
Used multiple `LEFT JOIN`s to build a patient journey view across appointment, encounter, diagnosis, billing, and claim tables.

**Business value:**  
Provides a full operational view of the patient lifecycle and helps connect clinical operations with financial outcomes.

### 9. Length of Stay Analysis

**Business question:**  
How does patient length of stay vary by diagnosis group, admission type, and room type?

**SQL approach:**  
Used `TIMESTAMP_DIFF()` and grouped admission metrics with average and 90th percentile length of stay.

**Business value:**  
Supports capacity planning, room utilization analysis, and discharge workflow improvement.

### 10. Patient Visit Frequency Trend

**Business question:**  
Which patients show increasing visit frequency over time?

**SQL approach:**  
Used monthly patient-level encounter aggregation and `LAG()` to compare current visit count with previous-month visit count.

**Business value:**  
Helps identify patients with rising utilization patterns who may need proactive care management.

## Dashboard Plan

The Looker Studio dashboard can be structured into four pages:

### Page 1: Executive Overview

Recommended KPIs:

- Total appointments
- Completed appointments
- Total admissions
- Average wait time
- Total charges
- Total paid amount
- Claim denial rate
- 30-day readmission rate

### Page 2: Operations

Recommended visuals:

- Appointments by department
- Average wait time by department
- Cancellation and no-show rates
- Top doctors by monthly workload
- Length of stay by diagnosis group

### Page 3: Finance and Claims

Recommended visuals:

- Monthly total charges
- Monthly paid amount
- Claim denial rate by insurance company
- Revenue at risk from denied claims
- Top denial reasons

### Page 4: Readmissions and Patient Flow

Recommended visuals:

- Readmission rate by diagnosis group
- Admissions by department
- Patient journey summary
- Rising patient visit frequency

## Optional BigQuery ML Extension

An optional extension is included for 30-day readmission prediction using BigQuery ML.

Model objective:

```text
Predict whether a patient admission is likely to result in a readmission within 30 days.
```

Possible features:

- Patient age
- Gender
- Region
- Insurance type
- Department
- Diagnosis group
- Severity level
- Admission type
- Room type
- Length of stay
- Wait time
- Billing values

This section is optional and can be included as a bonus if the model results are explainable and well understood.

```text
healthcare-operations-analytics/
│
├── README.md
│
├── data/
│   ├── admissions.csv
│   ├── appointments.csv
│   ├── billing.csv
│   ├── encounters.csv
│   ├── insurance_claims.csv
│   └── ...
│
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_schema_cleaning.sql
│   ├── 03_department_volume_wait_time.sql
│   ├── 04_doctor_workload_ranking.sql
│   ├── 05_readmission_analysis.sql
│   ├── 06_claim_denial_trends.sql
│   ├── 07_revenue_leakage.sql
│   ├── 08_high_cost_encounters.sql
│   ├── 09_lab_turnaround_time.sql
│   ├── 10_patient_journey.sql
│   └── 11_length_of_stay_analysis.sql
│
├── dashboard/
│   ├── dashboard_screenshots/
│   └── looker_studio_link.md
│
└── docs/
    ├── data_dictionary.md
    └── business_insights.md
```

## This project demonstrates practical analytics skills across a realistic healthcare operations scenario:

- Advanced SQL with multiple CTEs
- Window functions such as `RANK()`, `LAG()`, `LEAD()`, `NTILE()`, and `PERCENT_RANK()`
- Conditional aggregation with `COUNTIF()`
- Date and timestamp analysis
- Healthcare operations KPIs
- Financial claim denial analysis
- Patient flow and readmission analysis
- BigQuery-based data modeling
- Dashboard-ready business reporting

## Final Summary

This project uses BigQuery SQL to analyze healthcare operations data and Looker Studio to communicate insights through an interactive dashboard. The analysis focuses on patient flow, wait times, doctor workload, readmission patterns, claim denials, revenue leakage, and lab turnaround performance.

The final output is a SQL-driven healthcare analytics case study suitable for a data analyst portfolio.

