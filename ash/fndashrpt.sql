-- fndashrpt.sql
-- Generic script used to automate ASH Reports 

-- Call this script with the following arguments 
-- &1 target_sql_id 
-- &2 begin_time (MM/DD[/YY]*HH24:MI:[SS]) 
-- &3 duration - use 0 for default (up to SYSDATE) 
-- &4 slot_width - use 0 for default 
-- &5 dbid - use 0 for current instance connected-to 
-- &6 inst_num use 0 for current instance connected-to 
-- &7 report name - include extension (if 0 then ashrpti default is used)   

-- sample : @@fndashrpt <sql_id> <begin_time> <duration> <slot_width> <dbid> <inst_num> <report_name>

-- The following variables can be set in this script. 
-- and can be changed here - they are likely to be the same for all invocations 

define report_type = 'html'; -- could be 'text';
 
-- make sure all other variables used for input are defined and have a value

define target_session_id = ''; 
define target_wait_class = ''; 
define target_service_hash = ''; 
define target_module_name = ''; 
define target_action_name = ''; 
define target_client_id = ''; 
define target_plsql_entry = ''; 
define target_container = ''; 

-- Populate target_sql_id, begin_time, duration, slot_width, dbid, inst_num and report_name substitution variables 
-- Populate dbid and inst_num with current DB and instance if not already specified 
-- Populate report_name with NULL (it will then default) if not already specified 

column target_sql_id new_value target_sql_id 
column begin_time new_value begin_time 
column duration new_value duration 
column slot_width new_value slot_width 
column dbid new_value dbid 
column inst_num new_value inst_num 
column report_name new_value report_name 

SELECT '&&1' target_sql_id,
       REPLACE('&&2','*',' ') begin_time,
       DECODE(&&3,'0',NULL,&&3) duration, 
       DECODE('&&4','0',NULL,'&&4') slot_width, 
       DECODE(&&5,0,d.dbid,&&5) dbid, 
       DECODE('&&6','0',TO_CHAR(i.instance_number),'&&6') inst_num, 
       DECODE('&&7','0',NULL,'&&7') report_name 
       -- It is also possible to define a non-default report name combining text and subst variables 1-6 e.g. 
       -- 'awrrpt_'||'&&1'||'_'||&&2||'_'||&&3||'.html' report_name 
FROM   v$database d, 
       v$instance i; 

WHENEVER SQLERROR CONTINUE; 
WHENEVER OSERROR CONTINUE; 

@@?/rdbms/admin/ashrpti 

WHENEVER SQLERROR EXIT; 
WHENEVER OSERROR EXIT; 

undefine 1 
undefine 2 
undefine 3 
undefine 4 
undefine 5 
undefine 6 
undefine 7