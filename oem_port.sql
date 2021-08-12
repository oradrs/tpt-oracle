-- EM Express; OEM port
-- run from system user
-- $Id$
-- #ident  "@(#)PROJECTNAME:FILENAME:$Format:%D:%ci:%cN:%h$"
-- 15-Oct-2020 

select dbms_xdb.getHttpPort() from dual;
select dbms_xdb_config.getHttpsPort() from dual;

Prompt -- To set port if above return 0
Prompt -- https : exec dbms_xdb_config.sethttpsport(5500);
Prompt -- http : exec dbms_xdb_config.sethttpport(8080);

col url_str format a100;
Prompt
SELECT 'https://'||SYS_CONTEXT('USERENV','SERVER_HOST')||'.'||SYS_CONTEXT('USERENV','DB_DOMAIN')||':'||dbms_xdb_config.gethttpsport()||'/em/' url_str
FROM dual;

set serveroutput on size unlimited;

Prompt

DECLARE
    v1 VARCHAR2(100);
    v2 VARCHAR2(100);
BEGIN
    dbms_utility.Db_version (v1, v2);
        IF (substr(v1, 1, 2) <= 12) THEN
            dbms_output.put_line('[ INFO ] : Oracle Version is ' || v1);
            dbms_output.put_line('[ ALERT ] : Flash is not supported in browser as Oracle ver is NOT 19c or onwards. Use "SQL Developer" to monitor current Oracle DB.');
    END IF;
end;
/
