-- gather stats for MODIFIED tables only

set serveroutput on size unlimited;
set timing on;

DECLARE
  lt_obj_list dbms_stats.ObjectTab;
  CURSOR cu1 IS
  SELECT DISTINCT owner
  FROM   dba_tables
  WHERE OWNER IN (UPPER('&SCHEMA_NAME'));
BEGIN
  dbms_output.put_line('Stats Start time - '||to_char(sysdate,'dd-mon-yyyy hh:mi:ss am'));
  -- Get Schema with Tables
  FOR cr1 IN cu1 LOOP
    dbms_stats.gather_schema_stats(ownname => cr1.owner, objlist => lt_obj_list, options => 'LIST STALE'); --LIST STALE/LIST AUTO
    -- Check to see if the schema has any eligible tables
    IF lt_obj_list.count > 0 THEN
      FOR i IN lt_obj_list.FIRST .. lt_obj_list.LAST LOOP
        dbms_output.put_line(lt_obj_list(i).ownname || '.' || lt_obj_list(i).ObjName || ' ' || lt_obj_list(i).ObjType || ' ' || lt_obj_list(i).partname||to_char(sysdate,'dd-mon-yyyy hh:mi:ss am'));
        IF lt_obj_list(i).ObjType = 'TABLE' THEN
          DBMS_STATS.GATHER_TABLE_STATS(ownname          => lt_obj_list(i).ownname,
                                        tabname          => lt_obj_list(i).ObjName,
                                        estimate_percent => dbms_stats.AUTO_SAMPLE_SIZE,
                                        degree           => 5,
                                        --granularity      => dbms_stats.GET_PARAM('GRANULARITY'),
                                        cascade          => TRUE);
        END IF;
      END LOOP;
    END IF;
  END LOOP;
  dbms_output.put_line('Stats End time - '||to_char(sysdate,'dd-mon-yyyy hh:mi:ss am'));
END;
/
