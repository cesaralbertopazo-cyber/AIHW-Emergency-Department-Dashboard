-- =====================================================================
-- 02_data_sanitization.sql
-- AIHW Emergency Department Care 2024-25 | Verification & Data QA
-- Engine: SQLite (DBeaver Community Edition)
-- =====================================================================
-- These are the verification queries used to confirm each fact table
-- was despivoted and cleaned correctly, and the ones that surfaced the
-- data quality issues documented in the project README (Stage 1 & 3
-- audit log). Kept as a standing regression checklist for future
-- refreshes of the underlying AIHW workbook.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Row count sanity check
-- Confirms none of the three fact tables are empty or truncated.
-- ---------------------------------------------------------------------
SELECT 'fact_presentations_by_hour' AS table_name, COUNT(*) AS row_count FROM fact_presentations_by_hour
UNION ALL
SELECT 'fact_seen_on_time', COUNT(*) FROM fact_seen_on_time
UNION ALL
SELECT 'fact_episode_end_status', COUNT(*) FROM fact_episode_end_status;


-- ---------------------------------------------------------------------
-- 2. Dimension integrity check
-- Confirms the key dimension column in each table contains ONLY real
-- categories -- no "Total" subtotal rows, footnotes, reference links,
-- or navigation text ("Back to contents") leaked in from the source
-- workbook's crosstab layout.
-- ---------------------------------------------------------------------
SELECT DISTINCT time_of_presentation FROM fact_presentations_by_hour ORDER BY 1;
SELECT DISTINCT triage_category FROM fact_seen_on_time ORDER BY 1;
SELECT DISTINCT peer_group FROM fact_seen_on_time ORDER BY 1;
SELECT DISTINCT episode_end_status FROM fact_episode_end_status ORDER BY 1;


-- ---------------------------------------------------------------------
-- 3. Thousand-separator truncation check
-- Bug caught during development: SQLite's CAST(... AS REAL) silently
-- truncates a string at the first non-numeric character. A raw value
-- of '60,692' was being cast down to 60 before REPLACE(col, ',', '')
-- was added upstream. This check compares a known source cell against
-- its despivoted counterpart to confirm the fix holds.
-- ---------------------------------------------------------------------
SELECT * FROM fact_presentations_by_hour
WHERE time_of_presentation = 'Midnight to 1:59 am' AND day_of_week = 'Sunday';
-- Expected: value = 60692 (not 60)


-- ---------------------------------------------------------------------
-- 4. Non-numeric placeholder check ('n.p.' / '. .')
-- Confirms placeholders for "not published" / "not applicable" cells
-- in Table 5.3 were converted to true NULL, not forced to 0 (which
-- would have silently deflated state-level averages).
-- ---------------------------------------------------------------------
SELECT * FROM fact_seen_on_time WHERE pct_seen_on_time IS NULL;


-- ---------------------------------------------------------------------
-- 5. Point-in-time value verification against source workbook
-- Manual spot-check used to confirm the ETL pipeline reproduces the
-- AIHW source figures exactly, post-cleaning.
-- ---------------------------------------------------------------------
SELECT * FROM fact_episode_end_status
WHERE episode_end_status = 'Admitted to this hospital' AND triage_category = 'Resuscitation';
-- Expected: value = 62178 (measure = 'Presentations'), 71.6 (measure = 'Proportion of total (%)')
