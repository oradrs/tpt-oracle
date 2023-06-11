-- to ALL drop objects from current schema
-- 
-- ---------------------------------------------------

set serveroutput on;

COLUMN date_time NEW_VAL filename
SELECT to_char(systimestamp,'yyyy-mm-dd_hh24-mi-ssxff') date_time FROM DUAL;
spool dropAllObj&filename..log

@date

declare
    cursor c_get_objects is
    select object_type,'"'||object_name||'"'||decode(object_type,'TABLE' ,' cascade constraints purge',null) obj_name from user_objects
    where object_type in ('TABLE','VIEW','PROCEDURE','FUNCTION', 'PACKAGE', 'SYNONYM')
    order by object_type;

    cursor c_get_objects_type is select object_type, '"'||object_name||'"' obj_name from user_objects where object_type in ('TYPE');

  cursor c_get_seq is
    select object_type,'"'||object_name||'"' obj_name from user_objects
    where object_type in ('SEQUENCE');

 begin
	-- for manjor objects
    for object_rec in c_get_objects loop
        DBMS_OUTPUT.PUT_LINE('drop '||object_rec.object_type||' ' ||object_rec.obj_name);
        execute immediate ('drop '||object_rec.object_type||' ' ||object_rec.obj_name);
    end loop;
  
  -- ORA-32794: cannot drop a system-generated sequence; hence this loop
    for object_rec in c_get_seq loop
        DBMS_OUTPUT.PUT_LINE('drop '||object_rec.object_type||' ' ||object_rec.obj_name);
        execute immediate ('drop '||object_rec.object_type||' ' ||object_rec.obj_name);
    end loop;

	-- for TYPE
	-- for i in 1..3 loop
		for object_rec in c_get_objects_type loop
			DBMS_OUTPUT.PUT_LINE('drop '||object_rec.object_type||' ' ||object_rec.obj_name || ' force');
			begin 
			execute immediate ('drop '||object_rec.object_type||' ' ||object_rec.obj_name || ' force');
		  -- exception
			-- when others then
				-- null;
		  end;
		end loop;
	-- end loop;	  

end;
/

purge recyclebin;

-- COUNT after dropping all objects; if its not zero then add object_type in above code
select count(*) After_Drop_Count
from user_objects;

@date
spool off
