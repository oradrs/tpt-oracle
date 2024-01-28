-- fndawrrpt.sql 
-- Generic script used to automate AWR Reports 
-- Call this script with the following arguments 
-- &1 begin snap 
-- &2 end snap 
-- &3 dbid - use 0 for current instance connected-to 
-- &4 inst_num use 0 for current instance connected-to 
-- (Use ALL or comma separated list of instances (no spaces) if calling awrgrpti.sql) 
-- &5 report name - include extension (if 0 then awrrpti/awrgrpti defaults are used) 
-- The following variables can be set in this script. 
-- and can be changed here - they are likely to be the same for all invocations 

-- sample : @@fndawrrpt 3030 3034 1447007017 1 0 

define num_days = 0; 
define report_type = 'html'; -- could be 'text'; 
define report_name = ''; 

-- Populate begin_snap, end_snap, dbid, inst_num and report_name substitution variables 
-- Populate dbid and inst_num with current DB and instance if not already specified 
-- if running awrgrpti.sql - then the subst var is instance_numbers_or_ALL and not inst_num 
-- Populate report_name with NULL (it will then default) if not already specified 

column begin_snap new_value begin_snap 
column end_snap new_value end_snap 
column dbid new_value dbid 
column inst_num new_value inst_num 
column instance_numbers_or_ALL new_value instance_numbers_or_ALL 
column report_name new_value report_name 

SELECT &&1 begin_snap,
       &&2 end_snap,
       DECODE(&&3,0,d.dbid,&&3) dbid,
       DECODE('&&4','0',TO_CHAR(i.instance_number),'&&4') inst_num,
       DECODE('&&4','0',TO_CHAR(i.instance_number),'&&4') instance_numbers_or_ALL,
       DECODE('&&5','0',NULL,'&&5') report_name
       -- It is also possible to define a non-default report name combining text and subst variables 1-4 
       -- e.g. 'awrrpt_'||'&&4'||'_'||&&1||'_'||&&2||'.html' report_name 
FROM   v$database d, 
       v$instance i; 

-- It is possible to include date and time of the begin and end snapshots in the report name. 
-- as follows 
-- column report_name new_value report_name 
-- SELECT 
--    'awrrpt_'||'&&4'||'_'||TO_CHAR(sb.end_interval_time,'DD_MON_YYYY_HH24MI') 
--    ||'_to_'||TO_CHAR(se.end_interval_time,'DD_MON_YYYY_HH24MI') 
--    ||'.html' report_name  
-- FROM dba_hist_snapshot sb, 
--      dba_hist_snapshot se, 
--      v$database d,  
--      v$instance i  
-- WHERE sb.dbid = d.dbid  
-- AND sb.instance_number = i.instance_number 
-- AND sb.snap_id = &&1 
-- AND se.dbid = d.dbid 
-- AND se.instance_number = i.instance_number 
-- AND se.snap_id = &&2;

-- Note that an automated script is only needed for awrgrpti.sql and awrrpti.sql 
-- As awrgrpt.sql calls awrgrpti.sql for ALL instances of the current database. 
-- awrrpt.sql calls awrrpti.sql for the current database and instance. 

WHENEVER SQLERROR CONTINUE;
WHENEVER OSERROR CONTINUE;

@@?/rdbms/admin/awrrpti 
-- @@?/rdbms/admin/awrgrpti -- if running the RAC global report 

WHENEVER SQLERROR EXIT;
WHENEVER OSERROR EXIT;

undefine 1 
undefine 2 
undefine 3 
undefine 4 
undefine 5
