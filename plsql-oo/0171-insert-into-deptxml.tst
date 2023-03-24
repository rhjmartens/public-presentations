PL/SQL Developer Test script 3.0
25
declare
  l_dept o_dept;
  l_xml xmltype;
  type tp_dept is table of o_dept index by pls_integer;
  t_dept tp_dept;
begin
  
  -- bulk collect all departments into the plsql collection
  select o_dept(p_deptno => d.deptno)
  bulk collect into t_dept
  from dept d
  order by d.deptno;
  
  -- bulk insert all xmlvalues
  forall ii in 1.. t_dept.count
  insert into deptxml
    (dept)
  values
    (sys_xmlgen(t_dept(ii)
                   ,xmlformat(encltag => 'DEPARTMENT')));
    
  commit;
  
end;
/
0
0
