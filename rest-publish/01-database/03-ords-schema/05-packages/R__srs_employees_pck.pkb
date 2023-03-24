create or replace package body srs_employees_pck is

   procedure search(p_search    in varchar2
                   ,p_employees out sys_refcursor)
   
    is
   begin
   
      open p_employees for
         select *
         from   srs_emp_vw e
         where  (p_search is null)
         or     (e.empno = p_search --
               or upper(e.ename) like '%' || upper(p_search) || '%' --
               or e.job = p_search --
               or e.deptno = p_search);
   
   end search;

   function search2(p_search in varchar2) return clob is
      c_employees sys_refcursor;
   begin
   
      open c_employees for
         select *
         from   srs_emp_vw e
         where  (p_search is null)
         or     (e.empno = p_search --
               or upper(e.ename) like '%' || upper(p_search) || '%' --
               or e.job = p_search --
               or e.deptno = p_search);
   
      apex_json.initialize_clob_output;
      apex_json.write(p_name => 'employees', p_cursor => c_employees);
   
      return apex_json.get_clob_output;
   
   end search2;

   procedure search2(p_search in varchar2) is
      c_employees sys_refcursor;
   begin
   
      open c_employees for
         select *
         from   srs_emp_vw e
         where  (p_search is null)
         or     (e.empno = p_search --
               or upper(e.ename) like '%' || upper(p_search) || '%' --
               or e.job = p_search --
               or e.deptno = p_search);
   
      apex_json.open_object();
      apex_json.write(p_name => 'employees', p_cursor => c_employees);
      apex_json.close_all;
   
   end search2;

end srs_employees_pck;
/
