-- ------------------------------------------
-- this script will set sqlplus env. / oracle param, get xplan once SQL executed, spool output
-- use this script to run actual SQL.
--
-- NOTE : put actual SQL in qry.sql
-- 
-- ------------------------------------------

Spool runSQL.log APPEND;

PROMPT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

define _I_CONN;
define _I_USER;

@date

Set echo on;

-- if ON then will not get execution plan
SET serveroutput OFF;

alter session set statistics_level = all;

alter session set optimizer_capture_sql_plan_baselines = false;
alter session set optimizer_use_sql_plan_baselines = false;

-- 12c R1
ALTER session SET optimizer_adaptive_features=FALSE;

-- 12c R2 onwards
ALTER session SET optimizer_adaptive_plans=FALSE;
ALTER session SET optimizer_adaptive_statistics=FALSE;

set timing on;
set feedback ON SQL_ID;

-- ------------------------------------------
-- put actual SQL in qry.sql OR change file name below
@qry.sql;
-- ------------------------------------------

set feedback on;
Set echo off;

@x       -- from tpt-oracle repos

Spool off;

Prompt 
Prompt Generate ACTIVE (SQL monitor) report using    @xpia.sql <sql_id>
Prompt 