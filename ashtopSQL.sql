-- to get TOP sql_id since last 1 hour using ASH / HIST tables ( AWR )

PRO
PRO executing - @ash/ashtop sql_id,SQL_CHILD_NUMBER,username,event2 1=1 sysdate-1/24 sysdate
@ash/ashtop sql_id,SQL_CHILD_NUMBER,username,event2 1=1 sysdate-1/24 sysdate

-- with sid details
-- @ash/ashtop sql_id,SQL_CHILD_NUMBER,username,SESSION_ID||chr(32)||SESSION_SERIAL#,event2 1=1 sysdate-1/24 sysdate


PRO
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO NOTE :
PRO Once get sql_id ...
PRO 1) use @sqlid.sql <sql_id> %   - to get SQL details
PRO 2) use @sqlf.sql <sql_id>      - to get actual SQL text
PRO 3) use @xi <sql_id> <child#>   - to get SQL execution plan from library cache
PRO
PRO If SQL were executed in past ( e.g. before 1 day ), then details might not be in ASH
PRO In such case use dashtop
PRO @ash/dashtop sql_id,SQL_CHILD_NUMBER,username,event2 1=1 sysdate-1/24 sysdate
PRO
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO
