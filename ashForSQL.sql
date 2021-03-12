-- 11-Mar-2021 
-- Purpose : To get SQL details from ASH and AWR

-- Output : 3 files will be generated; 2 CSV and 1 TXT file will be spooled

-- NOTE : REPLACE sql_id list with appropriate sql_id; 
--        sql_id list should be in single quotes and comma separated if there are multiple sql_id 
--          e.g. '8nvjq9r2yzv4f', 'b6b097zk2brp4'    

-- Run from SQLPLUS; connect as SYS or SYSTEM or user having DBA privilege
--  @ashForSQL.sql

-- ------------------------------------------

SET ARRAYSIZE 100;
SET PAGESIZE 50000;
SET ROWPREFETCH 2;
SET STATEMENTCACHE 20;


-- ------------------------------------------

set markup csv on;

spool vash.csv;

SELECT 'v$active_session_history' src
FROM dual;

select * 
from v$active_session_history
where sql_id IN ('8nvjq9r2yzv4f', 'b6b097zk2brp4')          -- replace list with valid values
AND sample_time between
    to_date('01-JAN-2021','DD-MON-YYYY') AND current_timestamp
order by sample_id;

list;

spool off;

-- ------------------------------------------

set markup csv on;

spool dash.csv;

SELECT 'dba_hist_active_sess_history' src
FROM dual;

select * 
from dba_hist_active_sess_history
where sql_id IN ('8nvjq9r2yzv4f', 'b6b097zk2brp4')          -- replace list with valid values
AND sample_time between
    to_date('01-JAN-2021','DD-MON-YYYY') AND current_timestamp
order by sample_id;

list;

spool off;

-- ------------------------------------------

set markup csv off;

-- ------------------------------------------


spool sqlText.sql;

col sqll_sql_text head SQL_TEXT word_wrap
set long 2000000000;
BREAK ON sql_id skip 1;

prompt From : v$sqltext;

select sql_id, sql_text sqll_sql_text
from v$sqltext 
where sql_id IN ('8nvjq9r2yzv4f', 'b6b097zk2brp4')          -- replace list with valid values
order by sql_id, piece
;

list;

prompt ======================================
prompt
prompt From : dba_hist_sqltext;

SELECT
    SQL_ID, SQL_TEXT sqll_sql_text
FROM
    dba_hist_sqltext
where sql_id IN ('8nvjq9r2yzv4f', 'b6b097zk2brp4')          -- replace list with valid values
ORDER BY sql_id
;

list;

spool off;
