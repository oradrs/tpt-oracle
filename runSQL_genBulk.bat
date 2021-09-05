@ECHO OFF
setlocal enabledelayedexpansion

REM ==============================================
REM Purpose : To generate wrapper script to run multiple files available in same dir.
REM		wrapper script need to invoke fron SQLPLUS
REM dependent on : tpt-oracle scripts to generate xplan after execution of each SQLs
REM set SQLPATH points to tpt-oracle scripts due to dependency
REM ==============================================

REM wrapper script name
SET wrapperScriptName=runScript_ORA.txt

REM remove existing file 1st
DEL /F /Q %wrapperScriptName%

REM PAUSE

ECHO -- Generated on : %date% %TIME% >> %wrapperScriptName%
ECHO. >> %wrapperScriptName%

REM initial settings for performance best practise & for SQLPLUS
ECHO SET serverout OFF; >> %wrapperScriptName%

ECHO. >> %wrapperScriptName%
ECHO alter session set statistics_level = all;  >> %wrapperScriptName%
REM disable baseline generation
ECHO alter session set optimizer_capture_sql_plan_baselines = false;  >> %wrapperScriptName%
ECHO alter session set optimizer_use_sql_plan_baselines = false;  >> %wrapperScriptName%
ECHO. >> %wrapperScriptName%
REM disable adaptive settings
ECHO ALTER session SET optimizer_adaptive_plans=FALSE;  >> %wrapperScriptName%
ECHO ALTER session SET optimizer_adaptive_statistics=FALSE;  >> %wrapperScriptName%

echo set timing on; >> %wrapperScriptName%
ECHO. >> %wrapperScriptName%
ECHO ----------------------------------- >> %wrapperScriptName%
ECHO. >> %wrapperScriptName%

for %%f in (.\*.sql) do (
	ECHO spool %%~nf.log APPEND; >> %wrapperScriptName%
	ECHO PROMPT >> %wrapperScriptName%
	ECHO PROMPT ~~~~~~~~~~~~~~~~~~~~~ >> %wrapperScriptName%
	ECHO @date; >> %wrapperScriptName%
	ECHO Set echo on; >> %wrapperScriptName%
	ECHO set feedback ON SQL_ID; >> %wrapperScriptName%

	ECHO -- invoke script to run >> %wrapperScriptName%
	ECHO @%%~nf.sql >> %wrapperScriptName%

	ECHO set feedback on; >> %wrapperScriptName%
	ECHO Set echo off; >> %wrapperScriptName%
	ECHO -- capture execution plan for last executed SQL >> %wrapperScriptName%
	ECHO @x; >> %wrapperScriptName%
	ECHO @date; >> %wrapperScriptName%
	ECHO spool off; >> %wrapperScriptName%
	ECHO. >> %wrapperScriptName%
)

ECHO.
ECHO *** generated file = %wrapperScriptName%
ECHO.

GOTO :EOF

REM ==============================================
REM sample generated file content
REM ==============================================
REM 	SET serverout OFF; 
REM 	 
REM 	alter session set statistics_level = all;  
REM 	alter session set optimizer_capture_sql_plan_baselines = false;  
REM 	alter session set optimizer_use_sql_plan_baselines = false;  
REM 	 
REM 	ALTER session SET optimizer_adaptive_plans=FALSE;  
REM 	ALTER session SET optimizer_adaptive_statistics=FALSE;  
REM 	set timing on; 
REM 	 
REM 	spool 20920.log APPEND; 
REM 	PROMPT 
REM 	PROMPT ~~~~~~~~~~~~~~~~~~~~~ 
REM 	@date; 
REM 	Set echo on; 
REM 	set feedback ON SQL_ID; 
REM 	@20920.sql 
REM 	set feedback on; 
REM 	Set echo off; 
REM 	@x; 
REM 	@date; 
REM 	spool off; 
REM 	 
REM 	spool 20921.log APPEND; 
REM 	PROMPT 
REM 	PROMPT ~~~~~~~~~~~~~~~~~~~~~ 
REM 	@date; 
REM 	Set echo on; 
REM 	set feedback ON SQL_ID; 
REM 	@20921.sql 
REM 	set feedback on; 
REM 	Set echo off; 
REM 	@x; 
REM 	@date; 
REM 	spool off; 
