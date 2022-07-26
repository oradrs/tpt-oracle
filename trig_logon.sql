-- Purpose : To set parameters for db connections
-- Run from App schema
-- ------------------------------------------

CREATE OR REPLACE TRIGGER &schemaName.AFTER_LOGON_TRG
   AFTER LOGON
   ON &&schemaName.SCHEMA
BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = ALL';
   COMMIT;
END;
/

