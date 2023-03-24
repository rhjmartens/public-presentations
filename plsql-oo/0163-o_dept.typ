create or replace type o_dept as object
(
-- Author  : RMARTENS
-- Created : 08-03-19 00:51:57
-- Purpose : 

-- Attributes
  deptno    number(2),
  dname     varchar2(14),
  loc       varchar2(13),
  employees o_emp_t,

  constructor function o_dept(p_deptno in number) return self as result,

  member function to_json return clob,
  
  member procedure print
)
/
create or replace type body o_dept is

  constructor function o_dept(p_deptno in number) return self as result is
    t_empnos    apex_t_number;
    t_employees o_emp_t := new o_emp_t();
  begin
  
    -- first populate the dept itself
    select d.deptno
          ,d.dname
          ,d.loc
    into   self.deptno
          ,self.dname
          ,self.loc
    from   dept d
    where  d.deptno = p_deptno;
  
    -- now let sinitiate the employees
    select e.empno
    bulk   collect
    into   t_empnos
    from   emp e
    where  e.deptno = self.deptno;
  
    for ii in 1 .. t_empnos.count
    loop
      t_employees.extend(1);
      t_employees(ii) := new o_emp(p_empno => t_empnos(ii));
    end loop;
  
    self.employees := t_employees;
  
    return;
  
  end;

  member function to_json return clob is
    
    l_retval   clob;
    
  begin
  
    apex_json.initialize_clob_output;
  
    apex_json.open_object; -- {
  
    apex_json.open_object('department'); -- department {
  
    apex_json.write(p_name       => 'deptno'
                   ,p_value      => self.deptno
                   ,p_write_null => false);
    apex_json.write(p_name       => 'dname'
                   ,p_value      => self.dname
                   ,p_write_null => false);
    apex_json.write(p_name       => 'loc'
                   ,p_value      => self.loc
                   ,p_write_null => false);
  
    apex_json.open_array('employees'); -- employees: [
  
    for ii in 1 .. self.employees.count
    loop
      apex_json.open_object; -- {
      --apex_json.write_raw(self.employees(ii).to_json);
      APEX_JSON.write('employee_name', self.employees(ii).ename);
      APEX_JSON.write('employee_job', self.employees(ii).job);
      apex_json.close_object; -- } employee
    end loop;
  
    apex_json.close_array;
  
    apex_json.close_object;
    apex_json.close_object;
  
    l_retval := apex_json.get_clob_output;
  
    apex_json.free_output;
  
    return l_retval;
  
  end to_json;
  
  member procedure print
  is
    l_emp o_emp;
  begin
    
    dbms_output.put_line('Department');
    dbms_output.put_line('==============================');
    dbms_output.put_line('deptno    : ' || self.deptno);
    dbms_output.put_line('dname     : ' || self.dname);
    dbms_output.put_line('loc       : ' || self.loc);
    dbms_output.put_line('------------------------------');
    dbms_output.put_line('Employees:');
    
    for ii in 1..self.employees.count loop
      l_emp := self.employees(ii);
      dbms_output.put_line(rpad('  ' || ii || ' name : ' || l_emp.ename, 20) || ' job : ' || l_emp.job);
    end loop;
    
    dbms_output.put_line( Null );
    dbms_output.put_line( Null );
    
  end print;

end;
/
