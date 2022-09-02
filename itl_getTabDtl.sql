-- get current value for INITRAN for table
-- for ITL waits / ITL deadlock / enq: TX - allocate ITL entry
-- 29-Sep-2021 
-- ------------------------------------------

DEF schemaName = '&1';
UNDEF 1;
DEF tabname = '&2';
UNDEF 2;

col table_name format a30;
col index_name format a30;

select table_name, INI_TRANS 
from all_tables 
where 
owner = upper('&&schemaName')
AND table_name= upper('&&tabName');

PROMPT

select table_name, index_name, INI_TRANS
from all_indexes
where 
owner = upper('&&schemaName')
AND table_name= upper('&&tabName');


undefine schemaName;
undefine tabname;
