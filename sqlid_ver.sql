-- Purpose : To print versions / multiple child cursor details and reasons for multiple child cursor for input SQLid
--             Show why existing SQL child cursors were not reused
-- Usage : @sqlid_ver.sql <sql_id>
    -- Sample : @sqlid_ver.sql 4x1duubfw6fsq
-- Run from SYS
-- Dependent scripts 
    -- (one time) : version_rpt3_25.sql; source (Doc ID 438755.1); for version_rpt function
    -- nonshared.sql from tpt-oracle
-- ------------------------------------------


DEF sql_id = '&1';
UNDEF 1;

-- sample sqlid : 4x1duubfw6fsq

pro 
pro ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- details for each child cursor
select sql_id, child_number, sql_text
from v$sql
where sql_id = '&sql_id'
/

pro 
pro ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- details for each child cursor
select sql_id,child_number,executions,optimizer_env_hash_value
from v$sql
where sql_id = '&sql_id'
/

--    select *
--    from v$sql
--    where sql_id = '&sql_id'
--    /

pro 
pro ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- version count
select sql_id, hash_value, version_count from gv$sqlarea where sql_id = '&sql_id';

pro 
pro ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- tpt-oracle
-- Display reasons for non-shared child cursors from v$shared_cursor
@nonshared.sql &sql_id

pro 
pro ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- High SQL Version Counts - Script to determine reason(s) (Doc ID 438755.1)
select * from table(version_rpt('&sql_id'));


pro 
undefine sql_id;
