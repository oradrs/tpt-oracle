-- Purpose : generate DDL to change INITRANS for table & its indexes due to ITL waits / ITL deadlock / enq: TX - allocate ITL entry
-- Run from app schema
-- 29-Sep-2021
-- ------------------------------------------

DEF schemaName = '&1';
UNDEF 1;
DEF tabname = '&2';
UNDEF 2;

-- ------------------------------------------
SET head on;
spool itl_getTabDtl.log append;
pro -- Table : &&tabname

@itl_getTabDtl.sql 

spool off;

-- ------------------------------------------

SET head off;
SET TIMING off;

spool itl_genDDL.log append;
pro -- Table : &&tabname

select 'ALTER TABLE ' || table_name || ' INITRANS 50;' stmt_1
from user_tables
where table_name = upper('&&tabname');

select 'ALTER TABLE ' || table_name || ' MOVE;' stmt_2
from user_tables
where table_name = upper('&&tabname');

select 'ALTER INDEX ' || index_name || ' rebuild INITRANS 50;' stmt_3
from user_indexes
where table_name = upper('&&tabname')
ORDER BY index_name;

-- sample to gather stats
Prompt 
Prompt exec dbms_stats.gather_table_stats(ownname => upper('&&schemaName'), tabname => upper('&&tabname'), estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO', degree => DBMS_STATS.AUTO_DEGREE, cascade => TRUE);;

-- ------------------------------------------

-- SAMPLE :
--    alter table EMP INITRANS 50;
--    alter table EMP move;
--
--    alter index IDX1  rebuild INITRANS 50;
--    alter index IDX1  rebuild INITRANS 50;
--
--    exec dbms_stats.gather_table_stats(ownname => 'SCOTT', tabname => 'EMP', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO', degree => DBMS_STATS.AUTO_DEGREE, cascade => TRUE);

pro -------------------------------------------;
spool off;

undefine schemaName;
undefine tabname;
