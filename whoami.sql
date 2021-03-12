-- whoami.sql
-- Purpose : To get current db connection details (Multitenant support)
-- Ref : https://uhesse.com/2014/01/08/oracle-database-whoami-for-multitenant/
-- ------------------------------------------

 
set serveroutput on
begin
dbms_output.put_line('USER:             '||sys_context('userenv','session_user'));
dbms_output.put_line('SESSION ID:       '||sys_context('userenv','sid'));
dbms_output.put_line('CURRENT_SCHEMA:   '||sys_context('userenv','current_schema'));
dbms_output.put_line('INSTANCE NAME:    '||sys_context('userenv','instance_name'));
dbms_output.put_line('CDB NAME:         '||sys_context('userenv','cdb_name'));
dbms_output.put_line('CONTAINER NAME:   '||sys_context('userenv','con_name'));
dbms_output.put_line('DATABASE ROLE:    '||sys_context('userenv','database_role'));
dbms_output.put_line('OS USER:          '||sys_context('userenv','os_user'));
dbms_output.put_line('CLIENT IP ADDRESS: '||sys_context('userenv','ip_address'));
dbms_output.put_line('SERVER HOSTNAME:  '||sys_context('userenv','server_host'));
dbms_output.put_line('CLIENT HOSTNAME:  '||sys_context('userenv','host'));
end;
/
