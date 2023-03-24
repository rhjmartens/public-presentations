PL/SQL Developer Test script 3.0
32
declare
  l_ddl varchar2(32767);
begin
  
  for o in (select urot.object_type
            ,      urot.object_name
            from   user_objects urot
            where  urot.object_type not in ('INDEX', 'SEQUENCE', 'TRIGGER', 'LOB', 'PACKAGE BODY', 'TYPE BODY')
              and  urot.object_name in ('EMP_PCK', 'O_EMP', 'O_EMP_T', 'O_DEPT', 'EMPLOYEES', 'DEMO_CUSTOMER_API', 'DEPTXML'))
  loop
    l_ddl := 'drop ' || o.object_type || ' ' || o.object_name 
          || case
               when o.object_type not in ('PACKAGE') then ' force'
               else ''
             end;
    dbms_output.put_line(l_ddl);
    
    execute immediate l_ddl;
    
  end loop;
  
  delete emp e where lower(e.ename) like '%martens%'
                  or lower(e.ename) like '%krütten%'
                  or lower(e.ename) like '%rvleenders%'
                  or lower(e.ename) like '%smartens%';
  
  dbms_output.put_line(sql%rowcount || ' records deleted');
  
  commit;
  
end;
/
0
0
