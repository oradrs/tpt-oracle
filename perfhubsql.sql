-- Purpose : Generate Performance Hub report - Active - for sql_id
-- Run from : DBA user
-- Ref : https://hemantoracledba.blogspot.com/2021/05/
-- Alternate ? : can use @?/rdbms/admin/perfhubrpt.sql

-- ------------------------------------------


set pages 0 linesize 32767 trimspool on trim on long 1000000 longchunksize 10000000

-- get current time
COL current_time NEW_V current_time FOR A15;
SELECT 'current_time: ' x, TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS') current_time FROM DUAL;

spool dbms_perf_report_sql_&&sql_id._&&current_time..html
select dbms_perf.REPORT_SQL(sql_id => '&&sql_id', is_realtime=> &is_realtime, type=>'active') from dual;
spool off;

-- is_realtime 1 and active report
-- for more options see the documentation on DBMS_PERF

undef sql_id
