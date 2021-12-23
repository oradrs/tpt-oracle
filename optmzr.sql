-- Purpose : to generate 
--              cmd like ALTER SESSION SET optimizer_features_enable = '11.2.0.3';
--              hint /*+ optimizer_features_enable('9.2.0') */
--          Sometimes SQL do not perform in current version of Oracle but perform better in older releases of Oracle.
--          try generated SQL using generated cmd / hint
--
-- execute : @optmzr.sql
--
-- Steps once executed this script:
--      set echo on; spool run.log append;
--      run ALTER SESSION SET optimizer_features_enable cmd
--          or add as sql_hint in SQL
--      set timing on; and any other session level sql to run
--      run identified SQL
--      generate xplan using @xall
--      spool off
--
-- Ref : https://tanelpoder.com/2008/08/13/script-display-valid-values-for-multioption-parameters-including-hidden-parameters/  
--      https://tanelpoder.com/posts/scripts-for-drilling-down-into-unknown-optimizer-changes/
--
-- exising ref script : @pvalid optimizer_features_enable
--                      pathfinder
--
-- ------------------------------------------

col ordinal format 999;
col isdefault format a10;
col value format a20;
col cmd format a80;
col sql_hint format a80;


select ordinal,
    isdefault, 
    value, 
    'ALTER SESSION SET optimizer_features_enable = ''' || value || ''';' cmd,
    '/*+ optimizer_features_enable(''' || value || ''') */' sql_hint
from v$parameter_valid_values
where name = 'optimizer_features_enable'
order by isdefault desc, ordinal
/

-- ------------------------------------------

-- readymade cmd
--
--     CMD                                                                              SQL_HINT
--     -------------------------------------------------------------------------------- ---------------------------------------------
--     ALTER SESSION SET optimizer_features_enable = '19.1.0';                          /*+ optimizer_features_enable('19.1.0') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.0';                           /*+ optimizer_features_enable('8.0.0') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.3';                           /*+ optimizer_features_enable('8.0.3') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.4';                           /*+ optimizer_features_enable('8.0.4') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.5';                           /*+ optimizer_features_enable('8.0.5') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.6';                           /*+ optimizer_features_enable('8.0.6') */
--     ALTER SESSION SET optimizer_features_enable = '8.0.7';                           /*+ optimizer_features_enable('8.0.7') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.0';                           /*+ optimizer_features_enable('8.1.0') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.3';                           /*+ optimizer_features_enable('8.1.3') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.4';                           /*+ optimizer_features_enable('8.1.4') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.5';                           /*+ optimizer_features_enable('8.1.5') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.6';                           /*+ optimizer_features_enable('8.1.6') */
--     ALTER SESSION SET optimizer_features_enable = '8.1.7';                           /*+ optimizer_features_enable('8.1.7') */
--     ALTER SESSION SET optimizer_features_enable = '9.0.0';                           /*+ optimizer_features_enable('9.0.0') */
--     ALTER SESSION SET optimizer_features_enable = '9.0.1';                           /*+ optimizer_features_enable('9.0.1') */
--     ALTER SESSION SET optimizer_features_enable = '9.2.0';                           /*+ optimizer_features_enable('9.2.0') */
--     ALTER SESSION SET optimizer_features_enable = '9.2.0.8';                         /*+ optimizer_features_enable('9.2.0.8') */
--     ALTER SESSION SET optimizer_features_enable = '10.1.0';                          /*+ optimizer_features_enable('10.1.0') */
--     ALTER SESSION SET optimizer_features_enable = '10.1.0.3';                        /*+ optimizer_features_enable('10.1.0.3') */
--     ALTER SESSION SET optimizer_features_enable = '10.1.0.4';                        /*+ optimizer_features_enable('10.1.0.4') */
--     ALTER SESSION SET optimizer_features_enable = '10.1.0.5';                        /*+ optimizer_features_enable('10.1.0.5') */
--     ALTER SESSION SET optimizer_features_enable = '10.2.0.1';                        /*+ optimizer_features_enable('10.2.0.1') */
--     ALTER SESSION SET optimizer_features_enable = '10.2.0.2';                        /*+ optimizer_features_enable('10.2.0.2') */
--     ALTER SESSION SET optimizer_features_enable = '10.2.0.3';                        /*+ optimizer_features_enable('10.2.0.3') */
--     ALTER SESSION SET optimizer_features_enable = '10.2.0.4';                        /*+ optimizer_features_enable('10.2.0.4') */
--     ALTER SESSION SET optimizer_features_enable = '10.2.0.5';                        /*+ optimizer_features_enable('10.2.0.5') */
--     ALTER SESSION SET optimizer_features_enable = '11.1.0.6';                        /*+ optimizer_features_enable('11.1.0.6') */
--     ALTER SESSION SET optimizer_features_enable = '11.1.0.7';                        /*+ optimizer_features_enable('11.1.0.7') */
--     ALTER SESSION SET optimizer_features_enable = '11.2.0.1';                        /*+ optimizer_features_enable('11.2.0.1') */
--     ALTER SESSION SET optimizer_features_enable = '11.2.0.2';                        /*+ optimizer_features_enable('11.2.0.2') */
--     ALTER SESSION SET optimizer_features_enable = '11.2.0.3';                        /*+ optimizer_features_enable('11.2.0.3') */
--     ALTER SESSION SET optimizer_features_enable = '11.2.0.4';                        /*+ optimizer_features_enable('11.2.0.4') */
--     ALTER SESSION SET optimizer_features_enable = '12.1.0.1';                        /*+ optimizer_features_enable('12.1.0.1') */
--     ALTER SESSION SET optimizer_features_enable = '12.1.0.2';                        /*+ optimizer_features_enable('12.1.0.2') */
--     ALTER SESSION SET optimizer_features_enable = '12.2.0.1';                        /*+ optimizer_features_enable('12.2.0.1') */
--     ALTER SESSION SET optimizer_features_enable = '18.1.0';                          /*+ optimizer_features_enable('18.1.0') */
--     ALTER SESSION SET optimizer_features_enable = '19.1.0.1';                        /*+ optimizer_features_enable('19.1.0.1') */
