-- fndashbld.sql
-- example script for building script to run ASH for the top sql_ids on the local DB
-- it then runs the script that was built ! 
-- you can add criteria to alter the time period reported etc. 

-- depend on : fndashrpt.sql

set echo off heading off feedback off verify off 

set pages 0 termout off  
set linesize 150 

spool fndashbatch.sql 

SELECT '@@fndashrpt ' 
       ||ts.sql_id 
       ||' ' 
       ||TO_CHAR(bs.begin_interval_time,'MM/DD/YY*HH24:MI:SS') 
       ||' ' 
       ||To_CHAR(ROUND(TO_NUMBER(TO_DATE(TO_CHAR(es.end_interval_time,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS')-TO_DATE(TO_CHAR(bs.begin_interval_time,'DD/MM/YYYY HH24:MI:SS'),'DD/MM/YYYY HH24:MI:SS'))*60*24,0)+1) 
       ||' 60 ' -- slot_width use 60 seconds 
       ||ts.dbid 
       ||' ' 
       ||ts.instance_number 
       ||' ' 
       ||'ashrpt_'||ts.sql_id||'_'||TO_CHAR(bs.begin_interval_time,'YYYYMMDD_HH24MISS')||'.html' 
FROM 
   (SELECT sql_id, 
           dbid, 
           instance_number, 
           begin_snap, 
           end_snap 
    FROM 
       (SELECT dhs.sql_id, 
               dhs.dbid, 
               dhs.instance_number, 
               ROUND(SUM(dhs.elapsed_time_delta/1000000),0) elapsed_time_secs, 
               MIN(dhs.snap_id) begin_snap, 
               MAX(dhs.snap_id) end_snap 
        FROM dba_hist_sqlstat dhs, 
             v$database d, 
             v$instance i 
        WHERE dhs.dbid = d.dbid 
        AND   dhs.instance_number = i.instance_number  
        AND   dhs.con_dbid = d.con_dbid -- From DB 12.1 onwards
        AND dhs.snap_id >= <begin_snap> AND dhs.snap_id <= <end_snap> 
        GROUP BY dhs.sql_id, dhs.dbid, dhs.instance_number   
        ORDER BY 4 DESC) 
    WHERE rownum <= 100) ts, 
    dba_hist_snapshot bs, 
    dba_hist_snapshot es 
WHERE ts.begin_snap = bs.snap_id 
AND ts.end_snap = es.snap_id;

spool off 

set termout on echo on verify on heading on feedback on 

-- Now run the script that has been built above 
@@fndashbatch