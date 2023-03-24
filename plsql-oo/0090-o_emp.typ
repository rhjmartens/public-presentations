create or replace type o_emp force as object
(
-- Author  : RMARTENS
-- Created : 05-03-19 00:07:59
-- Purpose :

-- Attributes
  empno    number(4),
  ename    varchar2(10),
  job      varchar2(9),
  mgr      number(4),
  hiredate date,
  sal      number(7),
  comm     number(7),
  deptno   number(2),

  constructor function o_emp return self as result,

  constructor function o_emp(p_empno in number) return self as result

);
/
create or replace type body o_emp as

  constructor function o_emp return self as result is
  begin
    return;
  end o_emp;

  constructor function o_emp(p_empno in number) return self as result is
  begin
  
    select e.empno
          ,e.ename
          ,e.job
          ,e.mgr
          ,e.hiredate
          ,e.sal
          ,e.comm
          ,e.deptno
    into   self.empno
          ,self.ename
          ,self.job
          ,self.mgr
          ,self.hiredate
          ,self.sal
          ,self.comm
          ,self.deptno
    from   emp e
    where  e.empno = p_empno;
  
    return;
  
  end o_emp;

end;
/
