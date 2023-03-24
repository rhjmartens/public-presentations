PL/SQL Developer Test script 3.0
76
declare
  l_emp o_emp;
  l_empid employees.empid%Type;
begin
  
  insert into employees(empid, emp)
  select e.empno
  ,      o_emp(empno    => e.empno,
               ename    => e.ename,
               job      => e.job,
               mgr      => e.mgr,
               hiredate => e.hiredate,
               sal      => e.sal,
               comm     => e.comm,
               deptno   => e.deptno)
  from   emp e;
  
  l_empid := emp_seq.nextval;
  
  insert into employees
    ( empid
    , emp )
  values
    ( l_empid
    , new o_emp(empno    => l_empid
               ,ename    => 'RMARTENS'
               ,job      => 'APEXDEV'
               ,mgr      => 7839
               ,hiredate => sysdate
               ,sal      => 2500
               ,comm     => null
               ,deptno   => 10));
  
  insert into employees
    ( empid
    , emp )
  values
    ( emp_seq.nextval
    , new o_emp(empno    => emp_seq.currval
               ,ename    => 'SMARTENS'
               ,job      => 'APEXDEV'
               ,mgr      => 7839
               ,hiredate => sysdate
               ,sal      => 2500
               ,comm     => null
               ,deptno   => 10));

  l_emp := new o_emp(empno    => emp_seq.nextval,
                     ename    => 'RVLEENDERS',
                     job      => 'APEXDEV',
                     mgr      => 7839,
                     hiredate => sysdate,
                     sal      => 2500,
                     comm     => null,
                     deptno   => 10);


  insert into employees(empid, emp)
    values(l_emp.empno, l_emp);
    
  l_emp := new o_emp(p_empno => 0);
  --l_emp.empno := emp_seq.nextval;
  l_emp.ename := 'KRÜTTEN';
  l_emp.job   := 'APEXDEV';
  l_emp.mgr   := 7839;
  l_emp.hiredate := sysdate;
  l_emp.sal      := 2000;
  l_emp.comm     := null;
  l_emp.deptno   := 10;
  
  l_emp.save2db;
  
  
  commit;
  
end;
0
0
