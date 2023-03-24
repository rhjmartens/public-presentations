create or replace view srs_dept_vw as
select d.deptno
      ,d.dname
      ,d.loc
from   dept d;
