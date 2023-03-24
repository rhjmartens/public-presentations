create or replace view srs_emp_vw as
select e.empno
      ,e.ename
      ,e.job
      ,e.mgr
      ,e.hiredate
      ,e.sal
      ,e.comm
      ,e.deptno
from   emp e;
