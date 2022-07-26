REM srdc_spmb.sql - collect SQL Plan Management Baseline information.
define SRDCNAME='spmb'
SET MARKUP HTML ON PREFORMAT ON
set TERMOUT off FEEDBACK off VERIFY off TRIMSPOOL on HEADING off
COLUMN SRDCSPOOLNAME NOPRINT NEW_VALUE SRDCSPOOLNAME
select 'SRDC_'||upper('&&SRDCNAME')||'_'||upper(instance_name)||'_'||
     to_char(sysdate,'YYYYMMDD_HH24MISS') SRDCSPOOLNAME from v$instance;
set TERMOUT on MARKUP html preformat on
REM
spool &&SRDCSPOOLNAME..htm
select '+----------------------------------------------------+' from dual
union all
select '| Diagnostic-Name: '||'&&SRDCNAME' from dual
union all
select '| Timestamp:       '||
     to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS TZH:TZM') from dual
union all
select '| Machine:         '||host_name from v$instance
union all
select '| Version:         '||version from v$instance
union all
select '| DBName:          '||name from v$database
union all
select '| Instance:        '||instance_name from v$instance
union all
select '+----------------------------------------------------+' from dual
/
set pagesize 50000;
set echo on;
set feedback on;
Column sql_handle format a20
Column plan_name format a30

SELECT sql_handle, plan_name, enabled, accepted ,reproduced
FROM dba_sql_plan_baselines
where sql_text like '%&&Part_of_my_query%';

SET LINESIZE 150
SET PAGESIZE 2000

SELECT t.*
FROM (SELECT DISTINCT sql_handle
      FROM dba_sql_plan_baselines
      WHERE sql_text like '%&Part_of_my_query%') pb,
      TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(pb.sql_handle, NULL , 'TYPICAL'
)) t;

spool off
set markup html off preformat off
