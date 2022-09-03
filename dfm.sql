-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

-------------------------------------------------------------------------------------------
-- SCRIPT:      DF.SQL
-- PURPOSE:     Show Oracle tablespace free space in Unix df style
-- AUTHOR:      Tanel Poder [ http://www.tanelpoder.com ]
-- DATE:        2003-05-01
-- USAGE : @dfm tablespaceName
-- Example :
    -- for all TS :      @dfm %
    -- for specific TS : @dfm sys
-------------------------------------------------------------------------------------------

BREAK ON REPORT
COMPUTE SUM LABEL "TOTAL =========>" OF TotalMB ON REPORT
COMPUTE SUM LABEL "TOTAL =========>" OF UsedMB ON REPORT
COMPUTE SUM LABEL "TOTAL =========>" OF FreeMB ON REPORT

col TotalMB for 999,999,999,999
col UsedMB for 999,999,999,999
col FreeMB for 999,999,999,999
col "% Used" for a6
col "Used" for a22

PRO
PRO Usage :
PRO -- for all TS :      @dfm %
PRO -- for specific TS : @dfm sys
PRO

select t.tablespace_name,t.mb "TotalMB", t.mb - nvl(f.mb,0) "UsedMB", nvl(f.mb,0) "FreeMB"
       ,lpad(ceil((1-nvl(f.mb,0)/decode(t.mb,0,1,t.mb))*100)||'%', 6) "% Used", t.ext "Ext", 
       '|'||rpad(nvl(lpad('#',ceil((1-nvl(f.mb,0)/decode(t.mb,0,1,t.mb))*20),'#'),' '),20,' ')||'|' "Used"
from (
  select tablespace_name, trunc(sum(bytes)/1048576) MB
  from dba_free_space
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes_free)/1048576) MB
  from v$temp_space_header
  group by tablespace_name
) f, (
  select tablespace_name, trunc(sum(bytes)/1048576) MB, max(autoextensible) ext
  from dba_data_files
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes)/1048576) MB, max(autoextensible) ext
  from dba_temp_files
  group by tablespace_name
) t
where t.tablespace_name = f.tablespace_name (+)
AND t.tablespace_name LIKE (upper('%&&1%'))
order by t.tablespace_name;

undefine 1
