-- EM Express; OEM port
-- run from system user

select dbms_xdb.getHttpPort() from dual;
select dbms_xdb_config.getHttpsPort() from dual;

Prompt -- To set port if above return 0
Prompt -- https : exec dbms_xdb_config.sethttpsport(5500);
Prompt -- http : exec dbms_xdb_config.sethttpport(8080);
