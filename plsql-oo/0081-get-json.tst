PL/SQL Developer Test script 3.0
11
declare 

  l_emp o_emp;
  
begin
  
  l_emp := new o_emp(p_empno => 7839);
  
  dbms_output.put_line(l_emp.to_json);
  
end;
0
0
