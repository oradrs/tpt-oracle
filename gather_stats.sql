---------------------------------------------------------------------------
-- Purpose : Gather statistics for db objects in Oracle db
---------------------------------------------------------------------------

set serveroutput on size unlimited;
set timing on;

Prompt 
Prompt INFO : START - Gather table statistics

DECLARE
	v_stats VARCHAR2(1000);
    v_sample_size_pct varchar2(100) := 100;
    v_degree varchar2(100) := 4;
BEGIN

    $IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
    -- dbms_output.put_line('Oracle 10G_R2 ...');
        v_sample_size_pct := '100';
    $ELSIF DBMS_DB_VERSION.VER_LE_11 $THEN
    -- dbms_output.put_line('Oracle 11G ...');
        v_sample_size_pct := 'DBMS_STATS.AUTO_SAMPLE_SIZE';
    $ELSIF DBMS_DB_VERSION.VER_LE_12 $THEN
    -- dbms_output.put_line('Oracle 12c ...');
        v_sample_size_pct := 'DBMS_STATS.AUTO_SAMPLE_SIZE';
    $ELSIF DBMS_DB_VERSION.VER_LE_19 $THEN
     -- dbms_output.put_line('Oracle 19c ...');
        v_sample_size_pct := 'DBMS_STATS.AUTO_SAMPLE_SIZE';
        v_degree := 'DBMS_STATS.AUTO_DEGREE';
    $ELSE
        v_sample_size_pct := '100';
    $END

 	for st_row in (select owner, table_name 
                    from all_tables 
                    where OWNER IN (UPPER('&SCHEMA_NAME'))
                    AND NOT REGEXP_LIKE (table_name, '^BIN\$.*')
                    ORDER by owner, table_name)
	loop
		v_stats := 'begin 
				dbms_stats.gather_table_stats(ownname=>'||''''||st_row.owner||''''||','||
				'tabname=>'||''''||st_row.table_name||''''||','||
				'estimate_percent=>'|| v_sample_size_pct ||','||
				'method_opt=>'||''''||'FOR ALL COLUMNS SIZE AUTO'||''''||','||
				'degree=>'|| v_degree ||','||
				'cascade=>true);
			    end;'; 
		-- dbms_output.put_line('ownname=>'||''''||st_row.owner||''''||','||'tabname=>'||''''||st_row.table_name);
        -- dbms_output.put_line(v_stats);
		execute immediate v_stats; 
	end loop; 

end; 
/

Prompt INFO : END - Gather table statistics
Prompt

set serveroutput off;