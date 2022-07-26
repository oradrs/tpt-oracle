== How to Use SQL Plan Management (SPM) - Plan Stability Worked Example (Doc ID 456518.1)

The following is a script that you can run to demonstrate how SPM operates 
and then apply the base principles to your actual code. 
The script contains remarks to explain what is happening as it runs. The script was originally created and tested on 11.1.0.6.0 in the SH schema. 
Output may be slightly different on other versions.

SCRIPT spm.sql

---------CUT HERE START------------------------------------------------
set pages 10000 lines 140 long 100000
set echo on
spool spm.out

--Setting optimizer_capture_sql_plan_baselines=TRUE
--Automatically Captures the Plan for any
--Repeatable SQL statement.
--By Default optimizer_capture_sql_plan_baselines is False.
--A repeatable sql here means which is executed more then once.
--Now we will Capture various Optimizer plans in SPM Baseline.
--Plans are captured into the Baselines as New Plans are found.

pause

alter session set optimizer_capture_sql_plan_baselines = TRUE;
alter session set optimizer_use_sql_plan_baselines=FALSE;
alter session set optimizer_features_enable='11.1.0.6';

pause

set autotrace on

SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

pause

SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

select sql_handle,sql_text, plan_name,
origin, enabled, accepted
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause

--SYS_SQL_PLAN_0f3e54d254bc8843 is the Very First Plan that
--is inserted in the Plan baseline.
--Note the Very First Plan is ENABLED=YES AND ACCEPTED=YES
--Note the ORIGIN is AUTO-CAPTURE WHICH MEANS The plan was captured
--Automatically when optimizer_capture_sql_plan_baselines = TRUE.
--Note The Plan hash value: 3803407550

pause

alter session set optimizer_features_enable='10.2.0.3';
alter session set optimizer_index_cost_adj=1;

pause

set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause


select sql_handle,sql_text, plan_name,
origin, enabled, accepted
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause



---A New Plan SYS_SQL_PLAN_0f3e54d211df68d0 was Found here
---And inserted in the Plan Baseline.
---Note the ACCEPTED IS NO,as This is second plan added to the base line.
---Note The Plan hash value: 899219946


pause

alter session set optimizer_features_enable='9.2.0';
alter session set optimizer_index_cost_adj=50;
alter session set optimizer_index_caching=100;

pause

set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

select sql_handle,sql_text, plan_name,
origin, enabled, accepted
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause

--Note No Plan was added above because The plan found was not New,
--It was the same plan as found the First Time
--Note the Plan hash value: 3803407550


pause

alter session set optimizer_features_enable='9.2.0';
alter session set optimizer_mode = first_rows;

pause

set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

select sql_handle,sql_text, plan_name,
origin, enabled, accepted
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause

---Note No plan was added above because The Plan found was not New.
---Note the Plan hash value: 899219946

pause

--so the SPM Baseline is now populated with 2 different plans.
--Turning the auto Capture off


alter session set optimizer_capture_sql_plan_baselines = FALSE;

pause

--optimizer_capture_sql_plan_baselines needs to be set
--to TRUE only for Capture purpose.
--optimizer_capture_sql_plan_baselines =TRUE is not
--needed for USING AN existing SPM Baseline.

pause

--Now lets us see how the SPM uses the Plan.
--The Parameter optimizer_use_sql_plan_baselines
--must be true for plans from SPM to be used.
--by Default optimizer_use_sql_plan_baselines
--is set to TRUE only.
--if optimizer_use_sql_plan_baselines is set
--to FALSE than Plans will not be used
--from existing SPM Baseline,
--Even if they are populated.
--Note The Plan must be ENABLED=YES AND ACCEPTED=YES
--To be used by SPM.
--The Very First Plan for a particular sql that gets
--Loaded into an SPM Baseline Is ENABLED=YES
--AND ACCEPTED=YES.
--After that any Plan that gets loaded into the
--SPM Baseline is ENABLED=YES AND ACCEPTED=NO.
--These Plans needs to be ACCEPTED=YES before
--they can be used,
--The plans can be made ACCEPTED=YES by using the
--Plan verification Step.

pause

alter session set optimizer_use_sql_plan_baselines =TRUE;

pause

alter session set optimizer_features_enable='10.2.0.3';
alter session set optimizer_index_cost_adj=1;
set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

--Even though we have set
--alter session set optimizer_features_enable='10.2.0.3';
--alter session set optimizer_index_cost_adj=1
--we are still using the Plan with a Plan hash value: 3803407550
--This is because SQL PLAN baseline was used.
--Note the Line
--SQL plan baseline "SYS_SQL_PLAN_0f3e54d254bc8843" used for this statement
--This indicates SQL plan baseline was used.
--Note that SYS_SQL_PLAN_0f3e54d254bc8843 was used because it was enabled
--and accepted=YES as it was the very first Plan.

Pause

--Lets us disbale Plan SYS_SQL_PLAN_0f3e54d254bc8843
--We will use dbms_spm.alter_sql_plan_baseline

pause

var pbsts varchar2(30);
exec :pbsts := dbms_spm.alter_sql_plan_baseline('SYS_SQL_7de69bb90f3e54d2','SYS_SQL_PLAN_0f3e54d254bc8843','accepted','NO');

pause

select sql_handle,sql_text, plan_name,
origin, enabled, accepted, fixed, autopurge
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause

--Note that SQL WITH SQL HANDLE SYS_SQL_7de69bb90f3e54d2 AND
--Plan Name SYS_SQL_PLAN_0f3e54d254bc8843 is accepted=NO
--so This plan should not be used Now


pause

alter session set optimizer_features_enable='10.2.0.3';
alter session set optimizer_index_cost_adj=1;
set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

--You can see That NO Plans from SPM Baseline was used.

pause

--Now lets us enable the use of SPM for sql handle SYS_SQL_7de69bb90f3e54d2
--And Plan Name SYS_SQL_PLAN_0f3e54d211df68d0

pause

var pbsts varchar2(30);
exec :pbsts := dbms_spm.alter_sql_plan_baseline('SYS_SQL_7de69bb90f3e54d2','SYS_SQL_PLAN_0f3e54d211df68d0','accepted','YES');


pause

select sql_handle,sql_text, plan_name,
origin, enabled, accepted
from dba_sql_plan_baselines
where sql_text like 'SELECT%sh.sales%';

pause

--Note that SQL with SQL HANDLE SYS_SQL_7de69bb90f3e54d AND
--Plan Name SYS_SQL_PLAN_0f3e54d211df68d0 is accepted=YES
--and ENABLED=YES


pause

alter session set optimizer_features_enable='11.1.0.6';
alter session set optimizer_index_cost_adj=100;
alter session set optimizer_index_caching=0;
set autotrace on
SELECT *
from sh.sales
where quantity_sold > 30
order by prod_id;

set autotrace off

pause

--Note that
--SQL plan baseline "SYS_SQL_PLAN_0f3e54d211df68d0"  used for this statement
--The Plan hash value: 899219946

pause

--So This shows How the Sql plan baseline can used to get desired Plans.
--Please Note That we should be using only verified plans
--that is known to cause
--No performance degradation and regression.
--There is an important step to of Plan Verification after
--this, which is not discussed here.
--We can Load plans manually which are known to perform well.
--We can use DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE and Evolve Plans,
--The DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE does actually
--Execute each Plan from the SPM baseline and Verifies
--Which Plan is better as compared to The Base Plan.
spool off

---CUT HERE END--
