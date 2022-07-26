-- 13-Jun-2022 
-- Drop the entire SQL PLAN MANAGEMENT Repository for SQLs
-- run from SYS user
-- SCHEMA_NAME parameter value
-- ------------------------------------------

-- replace value
define SCHEMA_NAME='CHANGE_HERE';

select count(*) from dba_sql_plan_baselines where PARSING_SCHEMA_NAME = '&&SCHENA_NAME';

-- ------------------------------------------

declare
    pgn number;
    sqlhdl varchar2(30);
    cursor hdl_cur is
    select distinct sql_handle from dba_sql_plan_baselines where PARSING_SCHEMA_NAME = '&&SCHENA_NAME';
begin
    open hdl_cur;

    loop
        fetch hdl_cur into sqlhdl;
        exit when hdl_cur%NOTFOUND;

        pgn := dbms_spm.drop_sql_plan_baseline(sql_handle=>sqlhdl);
    end loop;

    close hdl_cur;
    commit;
end;
/

-- ------------------------------------------

select count(*) from dba_sql_plan_baselines where PARSING_SCHEMA_NAME = '&&SCHENA_NAME';
