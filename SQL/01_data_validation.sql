
SELECT 'admission' AS table_name, COUNT(*) AS row_count FROM `healthcare-project-502404.gjs.admission`
UNION ALL
SELECT 'appointments', COUNT(*) FROM `healthcare-project-502404.gjs.appointments`
UNION ALL
SELECT 'pat', COUNT(*) FROM `healthcare-project-502404.gjs.pat`
UNION ALL
SELECT 'doc', COUNT(*) FROM `healthcare-project-502404.gjs.doc`
UNION ALL
SELECT 'ent', COUNT(*) FROM `healthcare-project-502404.gjs.ent`
UNION ALL
SELECT 'bill', COUNT(*) FROM `healthcare-project-502404.gjs.bill`
UNION ALL
SELECT 'claims', COUNT(*) FROM `healthcare-project-502404.gjs.claims`
UNION ALL
SELECT 'dept', COUNT(*) FROM `healthcare-project-502404.gjs.dept`;
