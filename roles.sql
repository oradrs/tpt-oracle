-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

col ROLE format a40;
col EXTERNAL_NAME format a40;

select * from dba_roles where upper(role) like upper('%&1%');
