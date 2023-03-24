create or replace package body srs_department_pck is

   procedure dsearch(p_deptno in varchar2
                    ,p_dname  in varchar2
                    ,p_items  out sys_refcursor) is
      lgr logger_oo := new logger_oo(p_scope => $$plsql_unit || '.search');
   begin
   
      lgr.add_param(p_name => 'client_identifier', p_value => sys_context('userenv', 'client_identifier'));
      lgr.add_param(p_name => 'p_deptno', p_value => p_deptno);
      lgr.add_param(p_name => 'p_dname', p_value => p_dname);
   
      lgr.log_start;
   
      open dsearch.p_items for
         select d.deptno
               ,d.dname
               ,d.loc
               ,cursor (select e.empno
                             ,e.ename
                             ,e.job
                             ,e.mgr
                             ,e.hiredate
                             ,e.sal
                             ,e.comm
                             ,e.deptno
                       from   srs_emp_vw e
                       where  e.deptno = d.deptno) as employees
         from   srs_dept_vw d
         where  1 = 1
         and    (d.deptno = p_deptno or p_deptno is null)
         and    (upper(d.dname) like upper('%' || p_dname || '%') or p_dname is null);
   
      lgr.log_end;
   
   end dsearch;

end srs_department_pck;
/
