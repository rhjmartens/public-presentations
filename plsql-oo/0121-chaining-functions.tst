PL/SQL Developer Test script 3.0
19
declare 
  l_emp o_emp := new o_emp(7839);
begin
  

  dbms_output.put_line('Before:');
  dbms_output.put_line('====================');
  
  l_emp.print;
  
  l_emp := l_emp.transfer(p_new_deptno => 20).giveraise(p_percentage => 0.07);
  
  dbms_output.put_line('');
  dbms_output.put_line('After:');
  dbms_output.put_line('====================');
  
  l_emp.print;
  
end;
0
0
