-- to get curren Oracle version

set serveroutput on size unlimited;

PRO;
PRO 1. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

DECLARE
    v1 VARCHAR2(100);
    v2 VARCHAR2(100);
BEGIN
 dbms_utility.Db_version (v1, v2);
 dbms_output.Put_line('Oracle Version ' || v1);
 dbms_output.Put_line('Compatability ' || v2);
END;
/

-- ------------------------------------------
PRO;
PRO 2. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

col VERSION format a20;
col VERSION_FULL format a20;
SELECT 
    VERSION,
    VERSION_FULL
FROM PRODUCT_COMPONENT_VERSION;

-- ------------------------------------------
PRO;
PRO 3. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

DECLARE
  parnam VARCHAR2(256);
  intval BINARY_INTEGER;
  strval VARCHAR2(256);
  partyp BINARY_INTEGER;
BEGIN
  partyp := dbms_utility.get_parameter_value('optimizer_features_enable',
                                              intval, strval);
  dbms_output.put('OPTIMIZER_FEATURES_ENABLE parameter value is: ');
IF partyp = 1 THEN
  dbms_output.put_line(strval);
ELSE
  dbms_output.put_line(intval);
END IF;
End;
/
