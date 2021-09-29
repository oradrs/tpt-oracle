-- Purpose : to know When My Oracle Database Instance was Last Restarted
-- 29-Sep-2021 
-- ------------------------------------------

select instance_name,
-- to_char(startup_time,'mm/dd/yyyy hh24:mi:ss') as startup_time
    startup_time,
    floor((sysdate - startup_time) * 24) uptime_hr,
    floor(sysdate - startup_time) uptime_days
from v$instance;
