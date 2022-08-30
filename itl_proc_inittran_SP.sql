-- PURPOSE : To change inittran for single / ALL tables, rebuild indexes, gather stats
--
-- SAMPLE :
--    set serveroutput on size unlimited;
--
--    SET timing on;
--    SET echo on;

    --* change inittran to 10 for specific table
    -- exec proc_inittran(P_SCHEMANAME => 'SCOTT', P_TABLENAME =>'EMP', P_CHANGE_INITRANS_VAL => 10, P_GATHER_STATS => 'N' );

    --* change inittran to 10 for ALL tables
    -- exec proc_inittran(P_SCHEMANAME => 'SCOTT', P_TABLENAME => NULL, P_CHANGE_INITRANS_VAL => 10, P_GATHER_STATS => 'N' );

    --* Just Print current inittran for ALL tables
    -- exec proc_inittran(P_SCHEMANAME => 'SCOTT', P_TABLENAME => NULL, P_CHANGE_INITRANS_VAL => -1);
-- ------------------------------------------

CREATE OR REPLACE PROCEDURE proc_inittran (P_SCHEMANAME IN  VARCHAR,
                                            P_TABLENAME IN  VARCHAR DEFAULT NULL,
                                            P_CHANGE_INITRANS_VAL IN SMALLINT DEFAULT -1,
                                            P_GATHER_STATS IN VARCHAR DEFAULT 'N')
IS
    CURSOR cur_tablist IS
        SELECT TABLE_NAME
               , INI_TRANS
               , ROW_NUMBER() OVER (ORDER BY TABLE_NAME) rn
               , COUNT(*) OVER (ORDER BY NULL) cnt
        FROM ALL_TABLES
        WHERE OWNER = UPPER(P_SCHEMANAME)
        AND   TABLE_NAME = NVL(UPPER(P_TABLENAME), TABLE_NAME)
        AND   PARTITIONED = 'NO'
        AND   ROWNUM < 10
        ORDER BY TABLE_NAME;

    CURSOR cur_idxlist(v_tab_name VARCHAR) IS
        SELECT TABLE_NAME
               , INDEX_NAME
               , INI_TRANS
        FROM ALL_INDEXES
        WHERE OWNER = UPPER(P_SCHEMANAME)
        AND   TABLE_NAME = v_tab_name
        ORDER BY INDEX_NAME;

    l_schemacnt PLS_INTEGER;
    l_sql       VARCHAR2(4000);
BEGIN

    -- Verify schema name
    BEGIN
       SELECT count(*)
        INTO l_schemacnt
       FROM all_users
       WHERE USERNAME = UPPER(P_SCHEMANAME);
       IF (l_schemacnt = 0) THEN
            RAISE_APPLICATION_ERROR(-20000, '[ ERROR ] Please verify schema name. P_SCHEMANAME = ' || P_SCHEMANAME);
       END IF;
    END;

    -- TABLE : Change INI_TRANS
    << tablist >>
    FOR rec_tablist IN cur_tablist
    LOOP
        DBMS_OUTPUT.PUT_LINE('------------------------------------' || CHR(10));

        DBMS_OUTPUT.PUT_LINE('[ BEFORE ] TABLE : ' || rec_tablist.TABLE_NAME || ', INI_TRANS : ' || rec_tablist.INI_TRANS);

        IF (P_CHANGE_INITRANS_VAL > 0 AND P_CHANGE_INITRANS_VAL <= 50) THEN

            l_sql := 'ALTER TABLE /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_tablist.TABLE_NAME || ' INITRANS '|| rec_tablist.INI_TRANS;
            DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
            -- EXECUTE IMMEDIATE l_sql;

            l_sql := 'ALTER TABLE /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_tablist.TABLE_NAME || ' MOVE PARALLEL';
            DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
            -- EXECUTE IMMEDIATE l_sql;

            l_sql := 'ALTER TABLE /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_tablist.TABLE_NAME || ' NOPARALLEL';
            DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
            -- EXECUTE IMMEDIATE l_sql;

            DBMS_OUTPUT.PUT_LINE('[ AFTER ] TABLE : ' || rec_tablist.TABLE_NAME || ', INI_TRANS : ' || P_CHANGE_INITRANS_VAL);

            DBMS_OUTPUT.PUT_LINE(CHR(10));

            -- Index : Rebuild
            << idxlist >>
            FOR rec_idxlist IN cur_idxlist(rec_tablist.TABLE_NAME)
            LOOP 

                -- DBMS_OUTPUT.PUT_LINE('[ BEFORE ] TABLE : ' || rec_tablist.TABLE_NAME || ', Index : ' || rec_idxlist.INDEX_NAME || ', INI_TRANS : ' || rec_tablist.INI_TRANS);

                -- l_sql := 'ALTER INDEX /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_idxlist.INDEX_NAME || ' INITRANS '|| rec_tablist.INI_TRANS;
                -- DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
                -- EXECUTE IMMEDIATE l_sql;

                l_sql := 'ALTER INDEX /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_idxlist.INDEX_NAME || ' REBUILD PARALLEL';
                DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
                -- EXECUTE IMMEDIATE l_sql;

                l_sql := 'ALTER INDEX /* tab# ' || rec_tablist.rn || ' of ' || rec_tablist.cnt || ' */ ' || rec_idxlist.INDEX_NAME || ' NOPARALLEL';
                DBMS_OUTPUT.PUT_LINE('[ INFO ] DDL = ' || l_sql);
                -- EXECUTE IMMEDIATE l_sql;

                -- DBMS_OUTPUT.PUT_LINE('[ AFTER ] TABLE : ' || rec_tablist.TABLE_NAME || ', Index : ' || rec_idxlist.INDEX_NAME || ', INI_TRANS : ' || P_CHANGE_INITRANS_VAL);

                DBMS_OUTPUT.PUT_LINE(CHR(10));

            END LOOP idxlist;
            
            IF (UPPER(P_GATHER_STATS) = 'Y') THEN
                DBMS_STATS.GATHER_TABLE_STATS(  ownname             => UPPER(P_SCHEMANAME),
                                                tabname             => rec_tablist.TABLE_NAME,
                                                estimate_percent    => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                                method_opt          => 'FOR ALL COLUMNS SIZE AUTO',
                                                degree              => DBMS_STATS.AUTO_DEGREE,
                                                cascade             => TRUE);
            END IF;
--        ELSE
--            DBMS_OUTPUT.PUT_LINE('[ WARNING ] Please verify P_CHANGE_INITRANS_VAL value. It has to be between 1 to 50 only.');
        END IF;
    END LOOP tablist;

END proc_inittran;
/

show error
/

-- list
