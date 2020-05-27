-- find sql_id based on SQL_TEXT search

column SQL_TEXT format a100 word_wrap;
set long 30000;

-- undefine 1;

SELECT 'DBA_HIST_SQLTEXT' src,
        s.sql_id,
        s.plan_hash_value,
        -- CAST(t.sql_text AS VARCHAR (1000)) sql_text,
        t.sql_text sql_text_hist,
        s.snap_id
FROM dba_hist_sqlstat   s,
    dba_hist_sqltext   t
WHERE s.dbid = t.dbid
AND   s.sql_id = t.sql_id
AND   lower(T.sql_text) like lower('%&1%');

--  UNION
SELECT 'V$SQL' src,
       sql_id,
       plan_hash_value,
       sql_text
FROM v$sql
WHERE lower(sql_text) like lower('%&&1%')
;

undefine 1;
