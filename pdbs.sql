-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

-- SELECT * FROM v$pdbs;

Prompt
Prompt * CDB Instance name :
Prompt ~~~~~~~~~~~~~~~~~~~~~
SELECT NAME, CDB, CON_ID FROM V$DATABASE;

Prompt
Prompt * PDB db List :
Prompt ~~~~~~~~~~~~~~~~~~~~~
COL NAME FORMAT A15;
SELECT NAME, CON_ID, DBID, CON_UID, GUID FROM V$CONTAINERS ORDER BY CON_ID;

Prompt
Prompt * Current PDB :
Prompt ~~~~~~~~~~~~~~~~~~~~~
column where format a30
SELECT             'USER:         '||SYS_CONTEXT('USERENV','CURRENT_USER') 
       ||chr(10) ||'SCHEMA:       '||SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
       ||chr(10) ||'Current PDB:  '||SYS_CONTEXT('USERENV','CON_NAME')
       ||chr(10) ||'CONTAINER:    '||SYS_CONTEXT('USERENV','CDB_NAME')
      "WHERE" 
  FROM DUAL;
