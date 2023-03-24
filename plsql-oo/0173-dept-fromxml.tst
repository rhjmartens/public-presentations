PL/SQL Developer Test script 3.0
45
declare

  l_dept    o_dept;
  l_deptxml xmltype;

  type tp_t_xml is table of xmltype index by pls_integer;
  t_xml tp_t_xml;

  l_do_bulk constant boolean := true;

begin

  if l_do_bulk
  then 
    
    dbms_output.put_line('Using bulk collect' || chr(13));
  
    select d.dept
    bulk   collect
    into   t_xml
    from   deptxml d;
  
    for ii in 1 .. t_xml.count
    loop
      t_xml(ii).toobject(l_dept);
      l_dept.print;
    end loop;
  
  else
    
    dbms_output.put_line('Using single fetch' || chr(13));
  
    select dx.dept
    into   l_deptxml
    from   deptxml dx
    where  1 = 1
      and  rownum = 1;
  
    l_deptxml.toObject(l_dept);
  
    l_dept.print;
  
  end if;

end;
0
0
