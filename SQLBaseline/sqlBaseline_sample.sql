-- hands-on for - for SQL Basline
-- 26-Jun-2022 

drop table emp purge;
create table emp as select * from scott.emp;
alter table emp add constraint emp_pk primary key(empno);

variable x number
exec :x := 7499;
set serveroutput off;

select * from emp where empno = :x;
select * from table( dbms_xplan.display_cursor );

variable n number
begin 
 :n := dbms_spm.load_plans_from_cursor_cache( 
  sql_id =>'0cytxdnqq3h5w' ,
  plan_hash_value => 4024650034 );
end;
/

-- verify in dba_sql_plan_baselines using below block using dba_sql_plan_baselines

select * from emp where empno = :x; 
select * from table( dbms_xplan.display_cursor );
-- check NOTE section in above output for usage of SQL plan baseline

alter index emp_pk invisible;
select * from emp where empno = :x; 
select * from table( dbms_xplan.display_cursor );
-- check NOTE section in above output for usage of SQL plan baseline
--       "Failed to use SQL plan baseline for this statement" as index is not available after mark as invisible


SELECT *
FROM dbms_xplan.DISPLAY_SQL_PLAN_BASELINE ( sql_handle => 'SQL_399a8ad182404270', plan_name => 'SQL_PLAN_3m6nau6140hmh447b331a');

-- ------------------------------------------
-- view baseline

col sql_text format a100;
col plan_name format a50;

SELECT CHILD_NUMBER, b.sql_handle, b.sql_text, b.plan_name, b.enabled, b.accepted
 FROM   dba_sql_plan_baselines b, v$sql s
 WHERE  s.sql_id='0cytxdnqq3h5w'
 AND    s.exact_matching_signature = b.signature;


SQL_HANDLE                     SQL_TEXT                                                                                             PLAN_NAME                                          ENA ACC
------------------------------ ---------------------------------------------------------------------------------------------------- -------------------------------------------------- --- ---
SQL_399a8ad182404270           select * from emp where empno = :x                                                                   SQL_PLAN_3m6nau6140hmh695cc014                     YES YES
SQL_399a8ad182404270           select * from emp where empno = :x                                                                   SQL_PLAN_3m6nau6140hmhd8a279cc                     YES NO
SQL_399a8ad182404270           select * from emp where empno = :x                                                                   SQL_PLAN_3m6nau6140hmh695cc014                     YES YES
SQL_399a8ad182404270           select * from emp where empno = :x                                                                   SQL_PLAN_3m6nau6140hmhd8a279cc                     YES NO


-- drop baseline
SET serverout on;

DECLARE
   i pls_integer;
BEGIN
 i := DBMS_SPM.DROP_SQL_PLAN_BASELINE ( sql_handle => 'SQL_399a8ad182404270' );
 dbms_output.put_line('i = ' || i);
END;
/

