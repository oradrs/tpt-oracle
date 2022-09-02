-- Purpose : to get object, snap ( from AWR ) etc for ITL waits / ITL deadlock / enq: TX - allocate ITL entry
-- Note: change date range
-- run from system / sys user
-- 29-Sep-2021 
-- ------------------------------------------


col owner format a10;
col object_name format a20;

with qry as(
select 
	s.begin_interval_time, s.snap_id, d.OBJ#
	--, d.instance_number
	, sum(itl_waits_delta) itl_waits_delta
	, sum(row_lock_waits_delta) row_lock_waits_delta
from dba_hist_seg_stat d
join dba_hist_snapshot s on s.snap_id = d.snap_id
	and s.instance_number = d.instance_number
	and s.begin_interval_time between '22-SEP-2021' and '24-SEP-2021'
group by s.begin_interval_time, s.snap_id, d.OBJ#
order by s.begin_interval_time
)
select BEGIN_INTERVAL_TIME, SNAP_ID, o.owner, o.OBJ#, o.object_name, ITL_WAITS_DELTA, ROW_LOCK_WAITS_DELTA 
from qry 
	join DBA_HIST_SEG_STAT_OBJ o on qry.obj# = o.obj#
where itl_waits_delta > 0
ORDER BY BEGIN_INTERVAL_TIME
/
