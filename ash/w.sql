-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

DEF filter=&1

PROMPT What's going on? Showing top timed events of last minute from ASH...
@ashtop event2 &filter sysdate-1/24/60 sysdate

PROMPT Showing top SQL and wait classes of last minute from ASH...
@ashtop INST_ID,sql_id,session_id,session_state,BLOCKING_SESSION,wait_class &filter sysdate-1/24/60 sysdate

