-- -------------------------------------------------------------------------
-- Purpose : Changing columns' length semantics from BYTE to CHAR (More detail on NLS_LENGTH_SEMANTICS )
-- Target db : ORACLE
-- replace [SCHEMA] with list of schemas 
-- Revision : $Id: change_charLen_semantics_ORA.sql 18034 2013-05-27 06:18:06Z $
-- -------------------------------------------------------------------------

spool change_charLen_semantics_ORA.log append;

SELECT CURRENT_timestamp START_DTTM FROM dual;

-- ------------------------------------------
-- Few indexes might cause failure of pl/sql block during initial run.
    -- DROP INDEX required index and will be recreated after conversion using pl/sql block.
-- ------------------------------------------

set serveroutput on size unlimited;

Prompt 
Prompt INFO : START - Changing columns to CHAR length semantics

DECLARE 
	v_sql VARCHAR2(8000);
    i     PLS_INTEGER := 0;
    err_num NUMBER;
    err_msg VARCHAR2(1000);

BEGIN
 	for st_row in (
                    SELECT 'ALTER TABLE ' || c.OWNER || '.' || c.TABLE_NAME || ' MODIFY ' || c.COLUMN_NAME || ' ' || c.DATA_TYPE || '(' || c.CHAR_LENGTH || ' CHAR)' alter_ddl
                    FROM all_tab_columns c
                    WHERE c.owner IN ('[SCHEMA]')
                        AND   c.DATA_TYPE IN ('VARCHAR2','CHAR')
                        AND C.CHAR_USED = 'B'
                        AND NOT REGEXP_LIKE (c.table_name, '^BIN\$.*')
                        AND EXISTS (SELECT NULL FROM all_tables t WHERE t.table_name = c.table_name AND t.owner = c.owner)
                    ORDER by c.owner, c.table_name
                    )
	loop
		v_sql := st_row.alter_ddl;
		-- dbms_output.put_line(v_sql);
		execute immediate v_sql; 
        i := i + 1;
    end loop;

    dbms_output.put_line(' ');
    dbms_output.put_line('*** Number of columns modified = ' || i);

EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line(' ');
    dbms_output.put_line('*** Number of columns modified = ' || i);
    dbms_output.put_line(' ');
    dbms_output.put_line('Failed DDL : ' || v_sql);
    dbms_output.put_line(' ');

    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 1000);
    RAISE_APPLICATION_ERROR(-20000, err_msg);

end; 
/

Prompt INFO : END - Changing columns to CHAR length semantics
Prompt

-- ------------------------------------------

-- recreate dropped indexes (alongwith tablespace attached to them)

-- ------------------------------------------
Prompt INFO : Validating dependent objects

EXECUTE UTL_RECOMP.RECOMP_PARALLEL(4);

-- ------------------------------------------
Prompt INFO : Checking for invalid objects

Select owner, object_name, object_type, status
from dba_objects 
where status ='INVALID'; 

-- ------------------------------------------
SELECT CURRENT_timestamp END_DTTM FROM dual;

set serveroutput off;

spool off;
