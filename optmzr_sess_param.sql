-- get optimizer parameters for current session
-- Usage : optmzr_sess_param.sql
-- ------------------------------------------

SELECT SID CURR_SID, ID, NAME, ISDEFAULT, VALUE
FROM v$ses_optimizer_env
WHERE SID = (select sid from v$mystat where rownum = 1)
Order BY name;
