PL/SQL Developer Test script 3.0
14
declare

  l_empno number := 7839;
  l_emp   o_emp;

begin

  l_emp := new o_emp(p_empno => l_empno);

  dbms_output.put_line(l_empno || ' is ' || l_emp.ename);

  l_emp := null;

end;
0
0
