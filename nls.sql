-- Copyright 2018 Tanel Poder. All rights reserved. More info at http://tanelpoder.com
-- Licensed under the Apache License, Version 2.0. See LICENSE.txt for terms & conditions.

col nls_parameter head PARAMETER for a30
col nls_value head VALUE for a50

select
    parameter nls_parameter
  , value     nls_value
from v$nls_parameters -- nls_session_parameters 
order by 
    parameter
/

-- DS - Added

col DBPARAMETER head DBPARAMETER for a30
col INSPARAMETER head INSPARAMETER for a30
col SESSIONPARAMETER head SESSIONPARAMETER for a30
col VALUE head VALUE for a50

SELECT D.PARAMETER DBPARAMETER,
       D.VALUE,
       I.PARAMETER INSPARAMETER,
       I.VALUE,
       S.PARAMETER SESSIONPARAMETER,
       S.VALUE
FROM NLS_DATABASE_PARAMETERS D,
     NLS_INSTANCE_PARAMETERS I,
     NLS_SESSION_PARAMETERS S
WHERE D.PARAMETER = I.PARAMETER (+)
AND   D.PARAMETER = S.PARAMETER (+)
ORDER BY 1;