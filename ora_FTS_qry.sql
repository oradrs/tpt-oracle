-- RDBMS : Oracle
-- 18-Feb-2022 

-- Manually, identify FULL TABLE SCAN for query after testcase execution

-- Parameter substitutions required: [SCHEMA] -> table ower

-- STEPS :
-- Using SQLPlus, connect as DBA user
-- from SQLPlus Prompt, invoke this script
--    @ora_FTS_qry.sql

-- output HTML file : ora_FTS_qry.html

-- ------------------------------------------

SET echo off;
set linesize 999;
-- set pagesize 5000;

set long 10000000;
set longchunksize 10000000;

set trimspool on;
set trimout on;

-- set markup html on spool on;
set markup HTML ON -
HEAD " <TITLE>Query used FTS</TITLE>" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP ON PREFORMAT OFF;

set verify off;

spool ora_FTS_qry.html;

SELECT current_timestamp, '&_CONNECT_IDENTIFIER' as db
FROM dual;

Select 'Query had performed Full Table Scan (FTS)' List FROM dual;

-- ------------------------------------------

With FTS_QRY as
(
	select sp.SQL_ID, sp.PLAN_HASH_VALUE, sp.CHILD_NUMBER, sp.object_owner,sp.object_name,
	(select SQL_FULLTEXT from v$sqlarea sa
	where sa.address = sp.address
	and sa.hash_value =sp.hash_value) sqltext,
	(select executions from v$sqlarea sa
	where sa.address = sp.address
	and sa.hash_value =sp.hash_value) no_of_full_scans,
	(select ELAPSED_TIME/1000 from v$sqlarea sa
	where sa.address = sp.address
	and sa.hash_value =sp.hash_value) ELAPSED_TIME_IN_SEC,
    (select lpad(nvl(trim(to_char(num_rows)),' '),15,' ')||' | '||lpad(nvl(trim(to_char(blocks)),' '),15,' ')
	from dba_tables where table_name = sp.object_name
	and owner = sp.object_owner) "rows|blocks"
	from v$sql_plan sp
	where operation='TABLE ACCESS'
	and options = 'FULL'
	and object_owner IN ('[SCHEMA]')
--	and object_owner IN ('LS2USER')
--	and SUBSTR(sp.object_name,1,3) IN ('VLS','VRP','VRC','VH0','TLS','TRP','TRC','TH0') 
--	order by sp.object_owner,sp.object_name
	order by ELAPSED_TIME_IN_SEC desc
)
select rownum AS num, q.* 
from FTS_QRY q
where 
       (SQLTEXT not like '/* SQL Analyze%'
        -- OR SQLTEXT not like '%DS_SVC%'
       )
--     AND ROWNUM < 20
;

-- ------------------------------------------

spool off;
set markup html off spool off;

Prompt
Prompt INFO : Generated output file ora_FTS_qry.html from &_CONNECT_IDENTIFIER  .
Prompt

SET echo on;
