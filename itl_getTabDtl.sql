-- get current value for INITRAN for table
-- for ITL waits / ITL deadlock / enq: TX - allocate ITL entry
-- 29-Sep-2021 
-- ------------------------------------------

col table_name format a30;
col index_name format a30;

select table_name, INI_TRANS 
from user_tables 
where table_name= upper('&tabName');

PROMPT

select table_name, index_name, INI_TRANS
from user_indexes
where table_name = upper('&tabname')
ORDER BY index_name;
