-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

col long_opname head OPNAME for a30
col long_target head TARGET for a40
col long_units  head UNITS  for a10

prompt Show session long operations from v$session_longops for sid &1

select
	sid,
	serial#,
	opname long_opname,
	target long_target,
	sofar,
	totalwork,
	units long_units,
	time_remaining,
    ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE",
	start_time,
	elapsed_seconds,
    sql_id
/*, target_desc, last_update_time, username, sql_address, sql_hash_value */
from
	gv$session_longops
where
	sid in (select sid from gv$session where &1)
and sofar != totalwork
/


