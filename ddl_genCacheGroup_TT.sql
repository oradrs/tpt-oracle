-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

--------------------------------------------------------------------------------
--
-- File name:   ddl.sql
-- Purpose:     Extracts DDL statements for specified objects
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @ddl [schema.]<object_name_pattern>
-- 	        @ddl mytable
--	        @ddl system.table
--              @ddl sys%.%tab%
--
--------------------------------------------------------------------------------
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;

SET timing off;

spool ddl_tab_&1..sql;

exec dbms_metadata.set_transform_param( dbms_metadata.session_transform,'SQLTERMINATOR', TRUE);

EXEC DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
EXEC DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
EXEC DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'STORAGE', false);

select 'CREATE SYNCHRONOUS WRITETHROUGH CACHE GROUP SWT_CG_' || '&1' || 
	REPLACE(replace(replace(dbms_metadata.get_ddl( object_type, object_name, owner ) , '"'), 
                            'CREATE TABLE', 'FROM'), 
                            ' ENABLE,', ',')
from 
	all_objects 
where 
    object_type NOT LIKE '%PARTITION' AND object_type NOT LIKE '%BODY'
AND	upper(object_name) LIKE 
				upper(CASE 
					WHEN INSTR('&1','.') > 0 THEN 
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     )
AND	owner LIKE
		CASE WHEN INSTR('&1','.') > 0 THEN
			UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
		ELSE
			user
		END
/

Prompt -- *** Unique Index ***
SELECT '-- ' || UNIQUENESS || 
        REPLACE(REPLACE(DBMS_METADATA.get_ddl ('INDEX', index_name, owner),
                '  CREATE UNIQUE INDEX', '-- CREATE UNIQUE INDEX'),
                '  ;', '--   ;')
FROM   all_indexes
where 
	upper(table_name) LIKE 
				upper(CASE 
					WHEN INSTR('&1','.') > 0 THEN 
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     )
AND	owner LIKE
		CASE WHEN INSTR('&1','.') > 0 THEN
			UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
		ELSE
			user
		END
AND UNIQUENESS = 'UNIQUE'

-- WHERE  owner      = UPPER('&OWNER')
-- AND    table_name = DECODE(UPPER('&TABNAME'), 'ALL', table_name, UPPER('&&TABNAME'));
/


--    Prompt -- *** Cache Group ***
--
--    SELECT 'LOAD CACHE GROUP SWT_CG_' || '&1' || ' COMMIT EVERY 256 ROWS;'
--    FROM DUAL;

--    prompt;
--
--    Prompt -- *** VIEW ***
--
--    SELECT 'CREATE VIEW ' || REPLACE(table_name , 'TLS_', 'VLS_') || ' AS SELECT * FROM '|| table_name || ';'
--    FROM all_tables
--    where 
--        upper(table_name) LIKE 
--                    upper(CASE 
--                        WHEN INSTR('&1','.') > 0 THEN 
--                            SUBSTR('&1',INSTR('&1','.')+1)
--                        ELSE
--                            '&1'
--                        END
--                         )
--    AND	owner LIKE
--            CASE WHEN INSTR('&1','.') > 0 THEN
--                UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
--            ELSE
--                user
--            END
--    /

prompt;

spool off;

SET timing on;
