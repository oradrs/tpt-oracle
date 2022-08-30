-- Purpose : To know how much work is completed by expdp / impdp - data pump

SELECT OPNAME
       , SID
       , SERIAL#
       , CONTEXT
       , SOFAR
       , TOTALWORK
       , ROUND(SOFAR / TOTALWORK*100,2) "%_COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME IN (SELECT d.job_name
                 FROM v$session s
                      , v$process p
                      , dba_datapump_sessions d
                 WHERE p.addr = s.paddr
                 AND   s.saddr = d.saddr)
AND   OPNAME NOT LIKE '%aggregate%'
AND   TOTALWORK != 0
AND   SOFAR <> TOTALWORK
/
