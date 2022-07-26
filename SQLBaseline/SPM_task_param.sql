-- SPM : maintenance task & param
-- ------------------------------------------

-- 1. Display the SPM Evolve Task:
-- sqlplus / as sysdba
COLUMN client_name FORMAT A35
COLUMN task_name FORMAT a30
SELECT client_name, task_name
FROM dba_autotask_task
-- where task_name='AUTO_SQL_TUNING_PROG'
/

SELECT client_name, status, WINDOW_DURATION_LAST_7_DAYS
FROM dba_autotask_client
-- where client_name = 'sql tuning advisor'
/

-- 2. Display the parameters set for the SPM Evolve Task:
-- sqlplus / as sysdba
COLUMN parameter_name FORMAT A35
COLUMN parameter_value FORMAT a30

SELECT parameter_name, parameter_value
FROM dba_advisor_parameters
WHERE task_name = 'SYS_AUTO_SPM_EVOLVE_TASK'
AND parameter_value != 'UNUSED'
ORDER BY parameter_name;

-- 3. Turn off Automatic Evolving of Baselines:
-- 	-- sqlplus / as sysdba
-- 	BEGIN
-- 	DBMS_SPM.set_evolve_task_parameter(
-- 	task_name => 'SYS_AUTO_SPM_EVOLVE_TASK',
-- 	parameter => 'ACCEPT_PLANS',
-- 	value => 'FALSE');
-- 	END;
/

-- 4. Turn on the Automatic Evolving of Baselines:
-- sqlplus / as sysdba
-- 	BEGIN
-- 	DBMS_SPM.set_evolve_task_parameter(
-- 	task_name => 'SYS_AUTO_SPM_EVOLVE_TASK',
-- 	parameter => 'ACCEPT_PLANS',
-- 	value => 'TRUE');
-- 	END;
-- 	/
