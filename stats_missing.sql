-- Tablelist for Missing stats
-- Usage : stats_missing.sql
-- Input : schema name ; will be asked
-- ------------------------------------------

COL TABLE_NAME FOR A30;

SELECT OWNER, TABLE_NAME 
FROM ALL_TABLES 
WHERE NUM_ROWS IS NULL 
AND OWNER = UPPER('&SCHEMANAME');
