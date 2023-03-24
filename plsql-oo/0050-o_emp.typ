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

  constructor function o_emp return self as result

)
;
/
create or replace type body o_emp as

  constructor function o_emp return self as result is
  begin
    
    return;
    
  end o_emp;

end;
/
