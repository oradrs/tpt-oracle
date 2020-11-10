column tablespace_name format a20;
column FILE_NAME format a100;

select file_id, tablespace_name, FILE_NAME, AUTOEXTENSIBLE
from dba_data_files
order by file_id
/

select file_id, tablespace_name, FILE_NAME, AUTOEXTENSIBLE
from dba_temp_files
order by file_id
/
