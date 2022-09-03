-- USAGE : @dataFiles.sql tablespaceName
-- Example :
    -- for all TS :      @dataFiles.sql %
    -- for specific TS : @dataFiles.sql sys

PRO
PRO Usage :
PRO -- for all TS :      @dataFiles.sql %
PRO -- for specific TS : @dataFiles.sql sys
PRO

show parameter db_block_size;

column tablespace_name format a20;
column FILE_NAME format a100;

select file_id, tablespace_name, FILE_NAME, AUTOEXTENSIBLE, (INCREMENT_BY) INC_BY_BLK
from dba_data_files
WHERE tablespace_name LIKE (upper('%&1%'))
order by file_id
/

select file_id, tablespace_name, FILE_NAME, AUTOEXTENSIBLE, (INCREMENT_BY) INC_BY_BLK
from dba_temp_files
order by file_id
/

undefine 1