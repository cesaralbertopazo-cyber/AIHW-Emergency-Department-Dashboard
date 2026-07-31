-- =====================================================================
-- 01_staging_and_unpivot.sql
-- AIHW Emergency Department Care 2024-25 | ETL Pipeline
-- Engine: SQLite (DBeaver Community Edition)
-- =====================================================================
-- PREREQUISITE (manual step, not scriptable in SQLite):
-- Table 4.4, Table 5.3, and Table 4.12 were exported from the source
-- AIHW workbook (Emergency-department-care-2024-25.xlsx) to individual
-- CSV files, with the report title row removed so row 1 = real header.
-- Each CSV was then imported into this database via DBeaver's
-- "Import Data" wizard into the following staging tables:
--   stg_table_4_4   (Time of presentation, Measure, Sunday..Saturday, Total)
--   stg_table_5_3   (Peer group, Triage category, NSW..NT, Total)
--   stg_table_4_12  (Episode end status, Measure, Resuscitation..Non-urgent, Total(a))
-- =====================================================================


-- ---------------------------------------------------------------------
-- FACT TABLE 1: fact_presentations_by_hour
-- Grain: time_of_presentation x day_of_week x measure
-- Despivots the 7 day-of-week columns into rows.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS fact_presentations_by_hour;

CREATE TABLE fact_presentations_by_hour AS
SELECT "Time of presentation" AS time_of_presentation, "Measure" AS measure, 'Sunday' AS day_of_week,
       CAST(REPLACE(Sunday, ',', '') AS REAL) AS value
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Monday', CAST(REPLACE(Monday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Tuesday', CAST(REPLACE(Tuesday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Wednesday', CAST(REPLACE(Wednesday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Thursday', CAST(REPLACE(Thursday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Friday', CAST(REPLACE(Friday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm')
UNION ALL
SELECT "Time of presentation", "Measure", 'Saturday', CAST(REPLACE(Saturday, ',', '') AS REAL)
FROM stg_table_4_4
WHERE "Time of presentation" IN ('Midnight to 1:59 am','2 am to 3:59 am','4 am to 5:59 am','6 am to 7:59 am',
    '8 am to 9:59 am','10 am to 11:59 am','Midday to 1:59 pm','2 pm to 3:59 pm','4 pm to 5:59 pm',
    '6 pm to 7:59 pm','8 pm to 9:59 pm','10 pm to 11:59 pm');


-- ---------------------------------------------------------------------
-- FACT TABLE 2: fact_seen_on_time
-- Grain: peer_group x triage_category x state
-- Despivots the 8 state/territory columns into rows.
-- NULL is preserved (not forced to 0) where the source cell held a
-- non-numeric placeholder such as 'n.p.' (not published) or '. .' (n/a).
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS fact_seen_on_time;

CREATE TABLE fact_seen_on_time AS
SELECT "Peer group" AS peer_group, "Triage category" AS triage_category, 'NSW' AS state,
       CASE WHEN NSW GLOB '*[0-9]*' THEN CAST(REPLACE(NSW, ',', '') AS REAL) ELSE NULL END AS pct_seen_on_time
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'Vic',
       CASE WHEN Vic GLOB '*[0-9]*' THEN CAST(REPLACE(Vic, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'Qld',
       CASE WHEN Qld GLOB '*[0-9]*' THEN CAST(REPLACE(Qld, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'WA',
       CASE WHEN WA GLOB '*[0-9]*' THEN CAST(REPLACE(WA, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'SA',
       CASE WHEN SA GLOB '*[0-9]*' THEN CAST(REPLACE(SA, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'Tas',
       CASE WHEN Tas GLOB '*[0-9]*' THEN CAST(REPLACE(Tas, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'ACT',
       CASE WHEN ACT GLOB '*[0-9]*' THEN CAST(REPLACE(ACT, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent')
UNION ALL
SELECT "Peer group", "Triage category", 'NT',
       CASE WHEN NT GLOB '*[0-9]*' THEN CAST(REPLACE(NT, ',', '') AS REAL) ELSE NULL END
FROM stg_table_5_3 WHERE "Triage category" IN ('Resuscitation','Emergency','Urgent','Semi-urgent','Non-urgent');


-- ---------------------------------------------------------------------
-- FACT TABLE 3: fact_episode_end_status
-- Grain: episode_end_status x measure x triage_category
-- Despivots the 5 triage-category columns into rows.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS fact_episode_end_status;

CREATE TABLE fact_episode_end_status AS
SELECT "Episode end status" AS episode_end_status, "Measure" AS measure, 'Resuscitation' AS triage_category,
       CAST(REPLACE(Resuscitation, ',', '') AS REAL) AS value
FROM stg_table_4_12
WHERE "Episode end status" IN ('Admitted to this hospital','Departed without being admitted or referred',
    'Referred to another hospital for admission','Did not wait','Left at own risk',
    'Died in emergency department','Dead on arrival',
    'Registered, advised of another health care service and left without being attended to','Not reported')
UNION ALL
SELECT "Episode end status", "Measure", 'Emergency', CAST(REPLACE(Emergency, ',', '') AS REAL)
FROM stg_table_4_12
WHERE "Episode end status" IN ('Admitted to this hospital','Departed without being admitted or referred',
    'Referred to another hospital for admission','Did not wait','Left at own risk',
    'Died in emergency department','Dead on arrival',
    'Registered, advised of another health care service and left without being attended to','Not reported')
UNION ALL
SELECT "Episode end status", "Measure", 'Urgent', CAST(REPLACE(Urgent, ',', '') AS REAL)
FROM stg_table_4_12
WHERE "Episode end status" IN ('Admitted to this hospital','Departed without being admitted or referred',
    'Referred to another hospital for admission','Did not wait','Left at own risk',
    'Died in emergency department','Dead on arrival',
    'Registered, advised of another health care service and left without being attended to','Not reported')
UNION ALL
SELECT "Episode end status", "Measure", 'Semi-urgent', CAST(REPLACE("Semi-urgent", ',', '') AS REAL)
FROM stg_table_4_12
WHERE "Episode end status" IN ('Admitted to this hospital','Departed without being admitted or referred',
    'Referred to another hospital for admission','Did not wait','Left at own risk',
    'Died in emergency department','Dead on arrival',
    'Registered, advised of another health care service and left without being attended to','Not reported')
UNION ALL
SELECT "Episode end status", "Measure", 'Non-urgent', CAST(REPLACE("Non-urgent", ',', '') AS REAL)
FROM stg_table_4_12
WHERE "Episode end status" IN ('Admitted to this hospital','Departed without being admitted or referred',
    'Referred to another hospital for admission','Did not wait','Left at own risk',
    'Died in emergency department','Dead on arrival',
    'Registered, advised of another health care service and left without being attended to','Not reported');
