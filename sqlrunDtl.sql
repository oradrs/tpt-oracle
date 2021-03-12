-- Purpose : to analyze long-running batch SQL, and this query useful for getting an estimated start/end time, as well as comparing prior runs, the plan used on each run, etc:

undef sql_id;

Prompt
Prompt *** Below will help to know past executed SQL details.

column program format a30;
column username format a30;
COLUMN duration_hrs format 9999.99;
COLUMN duration_minutes format 9999.99;

SELECT query_runs.*,
                ROUND ( (end_time - start_time) * 24, 2) AS duration_hrs,
                ROUND ( (end_time - start_time) * 24 * 60, 2) AS duration_minutes
           FROM (  SELECT u.username,
                          ash.program,
                          ash.sql_id,
                          ASH.SQL_PLAN_HASH_VALUE as plan_hash_value,
                          ASH.SESSION_ID as sess#,
                          ASH.SESSION_SERIAL# as sess_ser,
                          CAST (MIN (ASH.SAMPLE_TIME) AS DATE) AS start_time,
                          CAST (MAX (ash.sample_time) AS DATE) AS end_time
                     FROM dba_hist_active_sess_history ash, dba_users u
                    WHERE u.user_id = ASH.USER_ID AND ash.sql_id = lower(trim('&sql_id'))
                 GROUP BY u.username,
                          ash.program,
                          ash.sql_id,
                          ASH.SQL_PLAN_HASH_VALUE,
                          ASH.SESSION_ID,
                          ASH.SESSION_SERIAL#) query_runs
ORDER BY sql_id, start_time;


Prompt
Prompt *** Below will help to know SQL was available in which AWR snap id.

col sql_profile for a32;
col BEGIN_INTERVAL_TIME for a32;
col BEGIN_INTERVAL_TIME for a32;

select sql_id, a.snap_id, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME, plan_hash_value, sql_profile, executions_total,
trunc(decode(executions_total, 0, 0, rows_processed_total/executions_total)) rows_avg,
trunc(decode(executions_total, 0, 0, fetches_total/executions_total)) fetches_avg,
trunc(decode(executions_total, 0, 0, disk_reads_total/executions_total)) disk_reads_avg,
trunc(decode(executions_total, 0, 0, buffer_gets_total/executions_total)) buffer_gets_avg,
trunc(decode(executions_total, 0, 0, cpu_time_total/executions_total)) cpu_time_avg,
trunc(decode(executions_total, 0, 0, elapsed_time_total/executions_total)) elapsed_time_avg,
trunc(decode(executions_total, 0, 0, iowait_total/executions_total)) iowait_time_avg,
trunc(decode(executions_total, 0, 0, clwait_total/executions_total)) clwait_time_avg,
trunc(decode(executions_total, 0, 0, apwait_total/executions_total)) apwait_time_avg,
trunc(decode(executions_total, 0, 0, ccwait_total/executions_total)) ccwait_time_avg,
trunc(decode(executions_total, 0, 0, plsexec_time_total/executions_total)) plsexec_time_avg,
trunc(decode(executions_total, 0, 0, javexec_time_total/executions_total)) javexec_time_avg
from dba_hist_sqlstat a, dba_hist_snapshot b
where sql_id = '&&sql_id'
AND a.snap_id = b.snap_id
order by sql_id, snap_id;

undef sql_id;