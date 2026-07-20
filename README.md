# Healthcare Operations Analytics using Advanced SQL in BigQuery

## Project Overview

This project analyzes healthcare operations data for a multi-department hospital network using advanced SQL in Google BigQuery.

The goal is to identify operational bottlenecks, patient flow issues, readmission patterns, insurance claim denial trends, revenue leakage, and clinical process delays using SQL-only analysis.

This project is designed as a portfolio case study focused on:

- Advanced SQL querying
- Multi-table joins
- Common Table Expressions (CTEs)
- Window functions
- Healthcare operations metrics
- Financial and claims analysis
- Patient journey analysis

## Business Problem

Hospitals generate large volumes of operational, clinical, and financial data across appointments, admissions, encounters, doctors, departments, billing, insurance claims, lab tests, and procedures.

Without structured analysis, hospital leadership may struggle to answer important questions such as:

- Which departments experience the highest patient volume?
- Where are patients waiting the longest?
- Which doctors have the highest monthly workload?
- Which diagnosis groups show higher 30-day readmission patterns?
- Which insurance companies contribute most to denied claims?
- How much potential revenue is at risk due to claim denials?
- Which encounters fall into the highest-cost segment?
- Which lab tests have the longest turnaround times?
- How does a patient move from appointment to billing and claim submission?

This project answers these questions using BigQuery SQL.

## Tools Used

- Google BigQuery
- BigQuery SQL
- Synthetic healthcare operations dataset

## Dataset Description

The dataset is synthetic and designed for SQL portfolio work. It simulates a healthcare operations environment with patient visits, doctor activity, admissions, billing, insurance claims, procedures, prescriptions, and lab testing.

Main tables used:

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
- `proc_performed` - procedures performed
- `pres` - prescriptions
- `test` - lab tests

Some lookup tables were cleaned after upload because BigQuery assigned generic column names during CSV import. Cleaned versions were created using SQL.

## Project Workflow

1. Uploaded healthcare CSV files into BigQuery.
2. Validated table row counts and schema structure.
3. Fixed schema/header issues using SQL-based clean tables.
4. Created analytical SQL queries for healthcare operations and finance.
5. Used CTEs, joins, conditional aggregation, date functions, and window functions.
6. Documented business problems, SQL methods, and business value for each analysis.

## Key Business Questions and SQL Solutions

### 1. Department Patient Volume and Wait-Time Analysis

**Business question:**  
Which departments receive the highest appointment volume, and which departments have the longest average wait times?

**SQL approach:**  
Used joins, CTEs, conditional aggregation, and `RANK()` to calculate appointment volume, completed appointments, cancellations, no-shows, and average wait time by department.

**Business value:**  
Helps hospital operations teams identify overloaded departments and areas where patient wait times may require process improvement.

### 2. Doctor Workload Ranking by Department and Month

**Business question:**  
Which doctors handle the highest number of patient encounters each month within their departments?

**SQL approach:**  
Used `DATE_TRUNC()` to aggregate encounters by month and `RANK()` to rank doctors within each department and month.

**Business value:**  
Supports workload balancing, staffing decisions, and department-level performance monitoring.

### 3. 30-Day Readmission Analysis

**Business question:**  
Which diagnosis groups are associated with higher 30-day readmission rates?

**SQL approach:**  
Used `LEAD()` to sequence patient admissions and identify whether a patient was admitted again within 30 days after discharge.

**Business value:**  
Helps identify diagnosis groups where follow-up care, discharge planning, or care coordination may need improvement.

### 4. Monthly Claim Denial Trend

**Business question:**  
Are insurance claim denials increasing or decreasing over time?

**SQL approach:**  
Used monthly aggregation, `COUNTIF()`, `SAFE_DIVIDE()`, and `LAG()` to calculate denial rates and month-over-month changes.

**Business value:**  
Helps revenue cycle teams monitor payer performance and detect worsening claim denial trends.

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
Used `TIMESTAMP_DIFF()` to calculate turnaround time and ranked lab tests by average result delay.

**Business value:**  
Helps diagnostic teams identify bottlenecks in lab processing and improve clinical response time.

### 8. Patient Journey Analysis

**Business question:**  
How does a patient move from appointment to encounter, diagnosis, billing, and insurance claim?

**SQL approach:**  
Used multiple `LEFT JOIN`s to build a patient journey view across appointment, encounter, diagnosis, billing, and claim tables.

**Business value:**  
Provides a full operational view of the patient lifecycle and connects clinical operations with financial outcomes.

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

## SQL Techniques Demonstrated

- Multi-table joins
- Common Table Expressions
- Window functions:
  - `RANK()`
  - `LAG()`
  - `LEAD()`
  - `NTILE()`
  - `PERCENT_RANK()`
- Conditional aggregation with `COUNTIF()`
- Date and timestamp analysis
- Month-over-month trend analysis
- Percentile-based segmentation
- Readmission logic
- Revenue leakage analysis
- Patient journey analysis

## Recommended Repository Structure

```text
healthcare-operations-analytics/
|
|-- README.md
|
|-- data/
|   |-- admissions.csv
|   |-- appointments.csv
|   |-- billing.csv
|   |-- encounters.csv
|   |-- insurance_claims.csv
|   |-- patients.csv
|   |-- doctors.csv
|   |-- departments.csv
|   |-- diagnoses.csv
|   |-- lab_tests.csv
|   |-- procedures_performed.csv
|   |-- prescriptions.csv
|   |-- medications.csv
|   |-- insurance_companies.csv
|   |-- procedure_catalog.csv
|
|-- sql/
|   |-- Doctor_workload_ranking.sql
|   |-- Doctors with wait times above Dept Avg.sql
|   |-- HIgh-Cost encounter analysis with Percentile Ranking.sql
|   |-- Monthly revenue analysis.sql
|   |-- Patients visit activity.sql
|   |-- Revenue leakage.sql
|   |-- Claim denial trends.sql
|   |-- Dept vol wait time.sql
|   |-- Lab turnaround time.sql
|   |-- Length of stay.sql
|   |-- Monthly claim denial analysis.sql
|   |-- Patient Journey.sql
|   |-- Readmission_analysis.sql
|
|-- docs/
|   |-- data_dictionary.md
|   |-- business_insights.md
|   |-- project_summary.md
```

# This project demonstrates practical analytics skills across a realistic healthcare operations scenario:

- Advanced SQL with multiple CTEs
- Window functions for ranking, sequencing, and trend analysis
- Healthcare operations KPIs
- Financial claim denial analysis
- Revenue leakage analysis
- Patient flow and readmission analysis
- BigQuery-based SQL workflow
- Business problem framing and solution documentation

The project is intentionally SQL-focused, making it suitable for data analyst roles where strong querying, business reasoning, and analytical storytelling are important.

## Final Summary

This project uses BigQuery SQL to analyze healthcare operations data across appointments, admissions, encounters, billing, insurance claims, lab tests, and procedures.

The analysis focuses on patient flow, wait times, doctor workload, readmission patterns, claim denials, revenue leakage, high-cost encounters, lab turnaround time, and length of stay.

The final output is a SQL-driven healthcare analytics case study suitable for a data analyst portfolio.
