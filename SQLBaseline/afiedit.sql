SELECT CHILD_NUMBER, b.sql_handle, b.sql_text, b.plan_name, b.enabled, b.accepted
 FROM   dba_sql_plan_baselines b, v$sql s
 WHERE  
 s.exact_matching_signature = b.signature
/
