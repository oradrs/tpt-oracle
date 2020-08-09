-- Purpose : To check imp Oracle parameter's settings/value
-- Run from DBA user  or having READ right on v$parameter

-- Recommendations :
    -- AMM should be enabled
    -- SPM/Baseline should be disabled unless reported issue during regression
    -- Adaptive feature should be disabled
    -- statistics_level=ALL at session level

-- Output : will show [WARN] for action and cmd

-- Sample Output :
    --    [INFO] sga_max_size = 6048M
    --    [INFO] pga_aggregate_limit = 4500M
    --    [INFO] sga_target = 0
    --    [INFO] AMM is enabled.
    --    [INFO] memory_target = 6048M
    --    [INFO] AMM is enabled.
    --    [INFO] memory_max_target = 6048M
    --    [INFO] compatible = 12.1.0.2.0
    --    [INFO] optimizer_features_enable = 12.1.0.2
    --    [INFO] optimizer_mode = ALL_ROWS
    --    [INFO] pga_aggregate_target = 0
    --    [WARN] statistics_level = TYPICAL; preferred -> ALL at session level using db trigger
    --    => [CMD] : ALTER SESSION SET statistics_level='ALL'; OR add session level db trigger
    --    [INFO] optimizer_capture_sql_plan_baselines = FALSE
    --    [INFO] optimizer_use_sql_plan_baselines = TRUE
    --    [INFO] optimizer_adaptive_reporting_only = FALSE
    --    [WARN] optimizer_adaptive_features = TRUE; preferred -> FALSE
    --    => [CMD] : ALTER SYSTEM SET optimizer_adaptive_features=FALSE scope=spfile;

-- Note : cmd to Enable AMM
    --    ALTER SYSTEM reSET pga_aggregate_limit SCOPE= SPFILE;
    --    ALTER SYSTEM reSET pga_aggregate_target SCOPE = SPFILE;
    --    ALTER SYSTEM reSET sga_max_size SCOPE= SPFILE;
    --    ALTER SYSTEM reSET sga_target SCOPE= SPFILE;
    --
    --    -- ALTER SYSTEM SET memory_max_target = 30581M SCOPE = SPFILE;
    --    ALTER SYSTEM SET MEMORY_TARGET = 8000M SCOPE = SPFILE;
    --      once set AMM, restart Oracle Instance

-- ------------------------------------------

SET SERVEROUTPUT ON SIZE UNLIMITED;
prompt
prompt *** Take backup of SPfile / init.ora file before making change.

BEGIN
   FOR param_rec IN (SELECT name, value, display_value
                       FROM v$parameter
                       WHERE name IN ('compatible', 'optimizer_features_enable', 'statistics_level', 'optimizer_mode',
                                        'optimizer_adaptive_features','optimizer_adaptive_plans', 'optimizer_adaptive_statistics', 'optimizer_adaptive_reporting_only',
                                        'optimizer_capture_sql_plan_baselines', 'optimizer_use_sql_plan_baselines',
                                        'memory_target', 'memory_max_target',
                                        'sga_max_size', 'sga_target',
                                        'pga_aggregate_target', 'pga_aggregate_limit')
                       )
    LOOP
-- Other
      IF (param_rec.NAME IN ('compatible', 'optimizer_features_enable', 'optimizer_mode') ) THEN
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );

      ELSIF (param_rec.NAME = 'statistics_level') THEN
        IF (param_rec.value = 'TYPICAL') THEN
            dbms_output.put_line('[WARN] ' || param_rec.NAME || ' = ' || param_rec.value || '; preferred -> ALL at session level using db trigger');
            dbms_output.put_line('=> [CMD] : ALTER SESSION SET statistics_level=''ALL''; OR add session level db trigger');
        ELSE
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
        END IF;

-- adaptive
      ELSIF (param_rec.NAME = 'optimizer_adaptive_features') THEN
        IF (param_rec.value = 'TRUE') THEN
            dbms_output.put_line('[WARN] ' || param_rec.NAME || ' = ' || param_rec.value || '; preferred -> FALSE');
            dbms_output.put_line('=> [CMD] : ALTER SYSTEM SET optimizer_adaptive_features=FALSE scope=spfile;');
        ELSE
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
        END IF;

      ELSIF (param_rec.NAME = 'optimizer_adaptive_plans') THEN
        IF (param_rec.value = 'TRUE') THEN
          dbms_output.put_line('[WARN] ' || param_rec.NAME || ' = ' || param_rec.value || '; preferred -> FALSE');
          dbms_output.put_line('=> [CMD] : ALTER SYSTEM SET optimizer_adaptive_plans=FALSE scope=spfile;');
        ELSE
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
        END IF;

      ELSIF (param_rec.NAME = 'optimizer_adaptive_statistics') THEN
        IF (param_rec.value = 'TRUE') THEN
          dbms_output.put_line('[WARN] ' || param_rec.NAME || ' = ' || param_rec.value || '; preferred -> FALSE');
          dbms_output.put_line('=> [CMD] : ALTER SYSTEM SET optimizer_adaptive_statistics=FALSE scope=spfile;');
        ELSE
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
        END IF;

      ELSIF (param_rec.NAME = 'optimizer_adaptive_reporting_only') THEN
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
          -- dbms_output.put_line('[CMD] : ALTER SYSTEM SET optimizer_adaptive_statistics=FALSE scope=spfile;');

-- baselines
      ELSIF (param_rec.NAME IN ('optimizer_capture_sql_plan_baselines', 'optimizer_use_sql_plan_baselines') ) THEN
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.value );
          -- dbms_output.put_line('[CMD] : ALTER SYSTEM SET optimizer_adaptive_statistics=FALSE scope=spfile;');

-- memory
      ELSIF (param_rec.NAME IN ('memory_target', 'memory_max_target') ) THEN
        IF (param_rec.value = 0) THEN
          dbms_output.put_line('[WARN] AMM is disabled.' );
          dbms_output.put_line('[WARN] ' || param_rec.NAME || ' = ' || param_rec.display_value );
        ELSE
          dbms_output.put_line('[INFO] AMM is enabled.' );
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.display_value );
        END IF;

      ELSIF (param_rec.NAME IN ('sga_max_size', 'sga_target', 'pga_aggregate_target', 'pga_aggregate_limit') ) THEN
          dbms_output.put_line('[INFO] ' || param_rec.NAME || ' = ' || param_rec.display_value );

-- Missed to add IF code
      ELSE
          dbms_output.put_line('[ERROR] ' || param_rec.NAME || ' = ' || param_rec.value || '; missing block in code' );
      END IF;
   END LOOP;
END;
/
prompt
prompt *** Take backup of SPfile / init.ora file before making change.;

