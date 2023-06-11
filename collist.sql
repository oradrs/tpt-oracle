-- To generate column list for a table for INSERT statement
-- usage : collist tablename
-- ---------------------------------------------------

SELECT '( ' || LISTAGG(COLUMN_NAME , ', '|| chr(10)  ) || ' ) ' col_list
FROM user_tab_columns c
WHERE c.TABLE_NAME = UPPER('&1');
