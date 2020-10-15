-- EM Express; OEM port
-- run from system user
-- $Id: 85b7b86f25cd29cded9766c5ac8399231818b577 $
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

