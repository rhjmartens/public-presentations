PL/SQL Developer Test script 3.0
30
declare

  l_empno emp.empno%type := 9999;

  l_emp  o_emp_api;
  l_dept o_dept_api;
  
begin
  
  l_dept := new o_dept_api(p_dname => 'RESEARCH');
  
  l_emp  := new o_emp_api(p_empno => l_empno);
  
  if l_emp.empno is null then
    -- create a new record
    l_emp.empno    := l_empno;
    l_emp.ename    := 'MARTENS';
    l_emp.job      := 'DEVELOPER';
    l_emp.mgr      := 7839;
    l_emp.hiredate := current_date;
    l_emp.sal      := 3000;
    l_emp.deptno   := l_dept.deptno;
  end if;
  
  l_emp.sal := l_emp.sal * 1.1;
  
  -- don't worry about inserting or updating
  l_emp.save_to_db;
  
end;
0
0
