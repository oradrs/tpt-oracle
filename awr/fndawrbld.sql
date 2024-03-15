
-- fndawrbld.sql
-- example script for building script to run AWR for all snapshots on the local DB
-- between two times
-- it then runs the script that was built !

-- depend on fndawrrpt.sql

set echo off heading off feedback off verify off

PROMPT When entering start and end times choose:
PROMPT    A start time just before the begin time of the first report required.
PROMPT    A finish time just before the end time of the last report required.
PROMPT Otherwise the first report may be missed or an extra report included at the end
-- Note that the snap id identifies when a snapshot ends (not when it starts)

ACCEPT START_TIME CHAR FORMAT 'A20' -
PROMPT 'Please enter the date/time to start from (in format YYYY/MM/DD HH24:MI) : '

ACCEPT END_TIME CHAR FORMAT 'A20' -
PROMPT 'Please enter the date/time to end at (in format YYYY/MM/DD HH24:MI) : '

set pages 0 termout off

spool fndawrbatch.sql

SELECT '@@fndawrrpt '
       ||s.snap_id
       ||' '
       ||(s.snap_id+1)
       ||' '
       ||s.dbid
       ||' '
       ||s.instance_number
       ||' 0' -- argument5/report_name. 0 = use awrrpti/awrgrpi defaults
       -- To include the date/time of the (start of the) period in the report name use the following instead
       -- ||' awrrpt_'||s.instance_number||'_'||TO_CHAR(s.end_interval_time,'DD_MON_YYYY_HH24MI')||'.html'
FROM dba_hist_snapshot s,
     v$database d,
     v$instance i
WHERE s.dbid = d.dbid
AND s.instance_number = i.instance_number
AND s.end_interval_time>=to_date('&&START_TIME','YYYY/MM/DD HH24:MI')
AND s.end_interval_time<=to_date('&&END_TIME','YYYY/MM/DD HH24:MI')
ORDER BY s.snap_id;

spool off

set termout on echo on verify on heading on feedback on

-- Now run the script that has been built above
@@fndawrbatch
