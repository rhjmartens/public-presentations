create or replace type body o_emp as

  /********************************************************************************
  ********************************************************************************
  constructor function o_emp return self as result is
  begin
    return;
  end o_emp;
  /**/

  /********************************************************************************
  ********************************************************************************/
  constructor function o_emp(p_empno in number) return self as result is
  begin
  
    if p_empno != -1
    then
    
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
    
    end if;
  
    return;
    
  exception when no_data_found
    then return;
  
  end o_emp;

  /********************************************************************************
  ********************************************************************************/
  member function to_json return clob is
    l_retval clob;
  begin
  
    apex_json.initialize_clob_output;
  
    apex_json.open_object; -- {
  
    apex_json.open_object('employee'); -- department {
  
    apex_json.write(p_name => 'empno'   , p_value => self.empno   , p_write_null => false);
    apex_json.write(p_name => 'ename'   , p_value => self.ename   , p_write_null => false);
    apex_json.write(p_name => 'job'     , p_value => self.job     , p_write_null => false);
    apex_json.write(p_name => 'mgr'     , p_value => self.mgr     , p_write_null => true);
    apex_json.write(p_name => 'hiredate', p_value => self.hiredate, p_write_null => false);
    apex_json.write(p_name => 'sal'     , p_value => self.sal     , p_write_null => false);
    apex_json.write(p_name => 'comm'    , p_value => self.comm    , p_write_null => true);
    apex_json.write(p_name => 'deptno'  , p_value => self.deptno  , p_write_null => false);
  
    apex_json.close_object;
    apex_json.close_object;
  
    l_retval := apex_json.get_clob_output;
  
    apex_json.free_output;
  
    return l_retval;
  
  end to_json;

  /********************************************************************************
  ********************************************************************************/
  member procedure save2db is
  
    l_reccount pls_integer;
    
  begin
    
    if self.empno is null then
      self.empno := emp_seq.8nextval;
    end if;
    
    select count(*)
    into   l_reccount
    from   employees e
    where  e.emp.empno = self.empno;
    
    if l_reccount = 0 then
      
      insert into employees
        (empid, emp)
      values
        (self.empno, self);
        
    else
      
      update employees e
      set e.emp = self
      where e.emp.empno = self.empno;
      
    end if;
  
  end save2db;

end;
/
