create or replace type o_mgr under o_emp
(
-- Author  : RMARTENS
-- Created : 08-03-19 01:46:39
-- Purpose : 

-- Attributes
  employees o_emp_t,

  constructor function o_mgr(p_empno in number) return self as result,

  member procedure list_employees

)
/
create or replace type body o_mgr is

  constructor function o_mgr(p_empno in number) return self as result is
  begin
  
    select e.empno
          ,e.ename
          ,e.job
          ,e.mgr
          ,e.hiredate
          ,e.sal
          ,e.comm
          ,e.deptno
    into   empno
          ,ename
          ,job
          ,mgr
          ,hiredate
          ,sal
          ,comm
          ,deptno
    from   emp e
    where  e.empno = p_empno
    and    exists (select 1
            from   emp s
            where  s.mgr = p_empno);
            
    employees := new o_emp_t();
  
    for r_emp in (select e.empno
                  from   emp e
                  where  e.mgr = p_empno)
    loop
      employees.extend(1);
      employees(employees.count) := new o_emp(p_empno => r_emp.empno);
    end loop;
  
    return;
  
  end o_mgr;

  member procedure list_employees is
  begin
    
    -- NOTE that I don't prefix with "self." here. prefixing is optional, but advisable for self-documenting code
  
    for ii in 1 .. employees.count 
    loop
      dbms_output.put_line('employee ' || ii || ' ' || employees(ii).ename);
    end loop;
  
  end list_employees;

end;
/
