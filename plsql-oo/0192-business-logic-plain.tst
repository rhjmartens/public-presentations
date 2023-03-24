PL/SQL Developer Test script 3.0
61
declare

  l_empno emp.empno%type := 9999;

  cursor c_emp(cp_empno in emp.empno%type) is
    select * 
    from   emp e 
    where  e.empno = cp_empno;
  r_emp c_emp%rowtype;
  
  cursor c_dept(cp_dname in dept.dname%Type)
  is     select *
         from   dept d
         where  d.dname = cp_dname;
  r_dept c_dept%rowtype;
  
  l_recordfound boolean;
  
begin

  -- fetch a record from the database
  open c_emp(cp_empno => l_empno);
  fetch c_emp
    into r_emp;
  l_recordfound := c_emp%found;
  close c_emp;
  
  open c_dept(cp_dname => 'RESEARCH');
  fetch c_dept into r_dept;
  close c_dept;

  if not l_recordfound
  then
    -- insert the new record
    insert into emp
      (empno
      ,ename
      ,job
      ,mgr
      ,hiredate
      ,sal
      ,comm
      ,deptno)
    values
      (l_empno
      ,'MARTENS'
      ,'DEVELOPER'
      ,7839
      ,current_date
      ,3000
      ,null
      ,r_dept.deptno
      ) returning empno into l_empno;
  
  end if;
  
  update emp e
  set    e.sal = e.sal * 1.1
  where  e.empno = l_empno;
  
end;
0
0
