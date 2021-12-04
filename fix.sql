-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

col bugno                           format 999999999
col VALUE                           format 999
col sql_feature                     format a40
col optimizer_feature_enable        format a10 heading 'Opt|features'

SELECT
    *
FROM
    v$session_fix_control
WHERE
    session_id = SYS_CONTEXT('userenv', 'sid')
AND (
        LOWER(description)            LIKE LOWER('%&1%')
    OR  LOWER(sql_feature)            LIKE LOWER('%&1%')
    OR  TO_CHAR(bugno)                LIKE LOWER('%&1%')
    OR  optimizer_feature_enable LIKE LOWER('%&1%')
    )
/

prompt 
prompt *** SAMPLE - to disable at session level : alter session set "_fix_control" = '21183079:0';
prompt 
