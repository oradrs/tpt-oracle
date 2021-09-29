-- Purpose : Gather stats for single table
-- inputs (schema & table name ) will be asked
-- Usage : @gather_stats_oneTab.sql
-- Verified : in 19c
-- ------------------------------------------

set serveroutput on size unlimited;
set timing on;

Prompt 
Prompt INFO : START - Gather table statistics

BEGIN
    dbms_stats.gather_table_stats(ownname => UPPER('&SCHEMA'), 
                                    tabname => UPPER('&TABNAME'),
                                    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    method_opt => 'FOR ALL COLUMNS SIZE AUTO',
                                    degree => DBMS_STATS.AUTO_DEGREE,
                                    CASCADE => TRUE);
END;
/

Prompt INFO : END - Gather table statistics
Prompt

set serveroutput off;
