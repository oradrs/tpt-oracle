-- same as tab.sql
-- it can be run in non-DBA schema/user
-- it uses USER_TABLES instead of DBA_TABLES

select
	table_name			tab_table_name,
	case
		when cluster_name is not null then 'CLU'
		when partitioned = 'NO'  and iot_name is not null then 'IOT'
		when partitioned = 'YES' and iot_name is not null then 'PIOT'
		when partitioned = 'NO' and iot_name is null then 'TAB'
		when partitioned = 'YES' and iot_name is null then 'PTAB'
		when temporary = 'Y' then 'TEMP'
		else 'OTHR'
	end 				tab_type,
	num_rows			tab_num_rows,
	blocks				tab_blocks,
	empty_blocks			tab_empty_blocks,
	avg_space			tab_avg_space,
--	chain_cnt			tab_chain_cnt,
	avg_row_len			tab_avg_row_len,
--	avg_space_freelist_blocks 	tab_avg_space_freelist_blocks,
--	num_freelist_blocks		tab_num_freelist_blocks,
--	sample_size			tab_sample_size,
	last_analyzed			tab_last_analyzed,
    degree,
    compression
--  , compress_for  -- 11.2
from
	user_tables
where
	upper(table_name) LIKE
				upper(CASE
					WHEN INSTR('&1','.') > 0 THEN
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     ) ESCAPE '\'
ORDER BY table_name
/
