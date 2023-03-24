PL/SQL Developer Test script 3.0
19
declare
  l_emp o_emp;

begin

  l_emp          := new o_emp;
  l_emp.ename    := 'MARTENS';
  l_emp.job      := 'APEXDEV';
  l_emp.mgr      := 7839;
  l_emp.hiredate := sysdate;
  l_emp.sal      := 2500;
  l_emp.comm     := null;
  l_emp.deptno   := 10;

  l_emp.save2db;

  null;

end;
0
0
