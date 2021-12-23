--    purpose : To get hidden param values
--    Source : https://exadatadba.blog/2019/05/10/underscoring-the-magical-world-of-oracle-database-hidden-parameters/
--    example : @pvalid2 optimizer
--    Run FROM : SYS user
-- ------------------------------------------


col hparam format a50;
col hparamval format a50;

PROMPT Display valid values for multioption parameters matching "&1"...

select
  ksppinm hparam,
  ksppstvl hparamval
from
  x$ksppi 
     join x$ksppsv
        using(indx)
where substr(ksppinm,1,1) = '_'
  and LOWER(ksppinm ) LIKE LOWER('%&1%')
ORDER BY ksppinm ;
