-- Purpose : generate DDL to change INITRANS for table & its indexes due to ITL waits / ITL deadlock / enq: TX - allocate ITL entry
-- Run from app schema
-- 29-Sep-2021
-- ------------------------------------------


select 'ALTER TABLE ' || table_name || ' INITRANS 50;' stmt_1
from user_tables
where table_name = '&tabname';

select 'ALTER TABLE ' || table_name || ' MOVE;' stmt_2
from user_tables
where table_name = '&tabname';

select 'ALTER TABLE ' || index_name || ' rebuild INITRANS 50;' stmt_3
from user_indexes
where table_name = '&tabname';

-- sample to gather stats
-- exec dbms_stats.gather_table_stats(ownname => 'schemaName', tabname => 'tabName', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO', degree => DBMS_STATS.AUTO_DEGREE, cascade => TRUE);

-- ------------------------------------------

-- SAMPLE :
--    alter table EMP INITRANS 50;
--    alter table EMP move;
--
--    alter index IDX1  rebuild INITRANS 50;
--    alter index IDX1  rebuild INITRANS 50;
--
--    exec dbms_stats.gather_table_stats(ownname => 'SCOTT', tabname => 'EMP', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE AUTO', degree => DBMS_STATS.AUTO_DEGREE, cascade => TRUE);
