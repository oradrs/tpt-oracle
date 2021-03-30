--------------------------------------------------------------------------------
--
-- File name:   from killsql.sql
-- base : from kill.sql
-- Purpose:     Generates commands for killing running SQLs
--
--              
-- Usage:       @killsql
-- 	            from active session output, enter SID
--
-- Other:       This script doesnt actually kill any sessions       
--              it just generates the ALTER SYSTEM KILL CANCEL SQL
--              commands, the user can select and paste in the selected
--              commands manually
--
--------------------------------------------------------------------------------

-- get list of active sessions
@ua

-- generate SQLs to cancel running SQL
select 'alter system CANCEL SQL '''||sid||','||serial#||''' -- '
       ||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from v$session
where sid=&sid
and sid != (select sid from v$mystat where rownum = 1)
/ 
