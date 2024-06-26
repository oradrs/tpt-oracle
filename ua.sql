-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

col u_username head USERNAME for a20
col u_sid head SID for a14
col u_audsid head AUDSID for 9999999999
col u_osuser head OSUSER for a16   truncate
col u_machine head MACHINE for a18 truncate
col u_program head PROGRAM for a20 truncate

select s.username u_username, ' ''' || s.sid || ',' || s.serial# || '''' u_sid,
		S.INST_ID,
       s.audsid u_audsid,
       s.osuser u_osuser,
       substr(s.machine,instr(s.machine,'\')) u_machine,
       substr(s.program,1,20) u_program,
       p.spid,
       s.SQL_ID,
       -- s.sql_address,
       s.sql_hash_value,
       s.last_call_et lastcall,
       s.status
       --, s.logon_time
       , (current_date - s.logon_time) * 24 logon_age_hours
from
    gv$session s,
    gv$process p
where
    s.paddr=p.addr
and s.type!='BACKGROUND'
and s.status='ACTIVE'
ORDER BY logon_age_hours desc, INST_ID
/

