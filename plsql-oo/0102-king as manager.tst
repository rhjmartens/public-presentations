PL/SQL Developer Test script 3.0
16
declare 

  l_king o_mgr;
  
begin
  
  l_king := new o_mgr(p_empno => 7839);
  
  dbms_output.put_line( l_king.to_json );
  
  dbms_output.put_line('');
  dbms_output.put_line('');
  
  l_king.list_employees;
  
end;
0
0
