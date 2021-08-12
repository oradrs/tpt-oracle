-- to get curren Oracle version

set serveroutput on size unlimited;

Prompt

DECLARE
    v1 VARCHAR2(100);
    v2 VARCHAR2(100);
BEGIN
 dbms_utility.Db_version (v1, v2);
 dbms_output.Put_line('Oracle Version ' || v1);
 dbms_output.Put_line('Compatability ' || v2);
END;
/
