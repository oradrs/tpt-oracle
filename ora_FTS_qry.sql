-- RDBMS : Oracle
-- 18-Feb-2022 

-- Manually, identify FULL TABLE SCAN for query after testcase execution

-- Parameter substitutions required: [SCHEMA] -> table ower

-- STEPS :
-- Using SQLPlus, connect as DBA user
-- from SQLPlus Prompt, invoke this script
--    @ora_FTS_qry.sql

-- output : ora_FTS_qry.log

-- ------------------------------------------

SET echo on;
set linesize 999;
-- set pagesize 5000;

set long 10000000;
set longchunksize 10000000;

set trimspool on;
set trimout on;

spool ora_FTS_qry.log;

SELECT current_timestamp FROM dual;

-- ------------------------------------------

With FTS_QRY as
(
	select sp.SQL_ID, sp.PLAN_HASH_VALUE, sp.object_owner,sp.object_name,
	(select SQL_FULLTEXT from v$sqlarea sa
	where sa.address = sp.address
	and sa.hash_value =sp.hash_value) sqltext,
	(select executions from v$sqlarea sa
	where sa.address = sp.address
	and sa.hash_value =sp.hash_value) no_of_full_scans,
	(select lpad(nvl(trim(to_char(num_rows)),' '),15,' ')||' | '||lpad(nvl(trim(to_char(blocks)),' '),15,' ')
	from dba_tables where table_name = sp.object_name
	and owner = sp.object_owner) "rows|blocks"
	from v$sql_plan sp
	where operation='TABLE ACCESS'
	and options = 'FULL'
	and object_owner IN ('[SCHEMA]')
	and SUBSTR(sp.object_name,1,3) IN ('VLS','VRP','VRC','VH0','TLS','TRP','TRC','TH0') 
	order by sp.object_owner,sp.object_name
)
select * 
from FTS_QRY 
where SQLTEXT not like '/* SQL Analyze%'
    -- AND ROWNUM < 20
;

-- ------------------------------------------

spool off;
