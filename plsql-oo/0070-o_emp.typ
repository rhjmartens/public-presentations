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

  member procedure save2db

)
;
/
create or replace type body o_emp as

  constructor function o_emp return self as result is
  begin
    return;
  end o_emp;

  member procedure save2db is
  begin
  
    if self.empno is null
    then
      self.empno := emp_seq.nextval;
    end if;
  
    merge into emp trg
    using dual
    on (trg.empno = self.empno)
    when matched then
      update
      set    trg.ename    = self.ename
            ,trg.job      = self.job
            ,trg.mgr      = self.mgr
            ,trg.hiredate = self.hiredate
            ,trg.sal      = self.sal
            ,trg.comm     = self.comm
            ,trg.deptno   = self.deptno
    when not matched then
      insert
        (empno
        ,ename
        ,job
        ,mgr
        ,hiredate
        ,sal
        ,comm
        ,deptno)
      values
        (self.empno
        ,self.ename
        ,self.job
        ,self.mgr
        ,self.hiredate
        ,self.sal
        ,self.comm
        ,self.deptno);
  
  end save2db;

end;
/
