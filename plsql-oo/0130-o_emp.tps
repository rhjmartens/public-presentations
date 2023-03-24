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

--constructor function o_emp return self as result,

  constructor function o_emp(p_empno in number) return self as result,

  member function to_json return clob,

  member procedure save2db

)
not final;
/
