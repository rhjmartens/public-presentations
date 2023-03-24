PL/SQL Developer Test script 3.0
33
declare 

  l_emp o_emp;
  
begin
  
  --l_emp := new o_emp(p_empno => 7839);
  
  if l_emp is null then
    dbms_output.put_line('l_emp is null');
  end if;
  
  if l_emp.ename is null then
    dbms_output.put_line ('l_emp.ename is null');
  end if;
  
  l_emp := new o_emp(p_empno => 7839);
  
  l_emp := null;
  
  if l_emp is null then
    dbms_output.put_line('l_emp is null');
  end if;
  
  l_emp.empno := 7839;
  
  dbms_output.put_line('This line never gets executed');  
  
  exception
    when access_into_null then
      dbms_output.put_line('ACCESS_INTO_NULL');
      
end;
0
0
