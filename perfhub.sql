-- Purpose : Generate Performance Hub report - Active ; for last one hour
-- Run from : DBA user
-- Ref : https://hemantoracledba.blogspot.com/2021/05/
-- Alternate : can use @?/rdbms/admin/perfhubrpt.sql

-- ------------------------------------------


set pages 0 linesize 32767 trimspool on trim on long 1000000 longchunksize 10000000

-- get current time
COL current_time NEW_V current_time FOR A15;
SELECT 'current_time: ' x, TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS') current_time FROM DUAL;

spool dbms_perf_report_&&current_time..html
select dbms_perf.report_perfhub(is_realtime=>1, type=>'active') from dual;
spool off;

-- is_realtime 1 and active shows the report for the last 1hour
-- for more options see the documentation on DBMS_PERF
