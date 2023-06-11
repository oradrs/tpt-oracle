-- connection count

col username FORMAT a15;
col machine FORMAT a30;

SELECT COALESCE(username, 'TOTAL ==> ') username,
       machine,
       program,
       COUNT(*)
FROM gv$session
WHERE username like UPPER('%&username%')
GROUP BY GROUPING SETS( (username,
         machine,
         program), ())
ORDER BY COUNT(*) DESC, machine, program
/
