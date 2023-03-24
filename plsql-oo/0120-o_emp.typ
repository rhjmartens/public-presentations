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

  member procedure print,

  member function giveraise(p_percentage in number) return o_emp,

  member function transfer(p_new_deptno in number) return o_emp

)
not final;
/
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

  /********************************************************************************
  ********************************************************************************/
  member function to_json return clob is
    l_retval clob;
  begin
  
    apex_json.initialize_clob_output;
  
    apex_json.open_object; -- {
  
    apex_json.open_object('employee'); -- department {
  
    apex_json.write(p_name       => 'empno'
                   ,p_value      => self.empno
                   ,p_write_null => false);
    apex_json.write(p_name       => 'ename'
                   ,p_value      => self.ename
                   ,p_write_null => false);
    apex_json.write(p_name       => 'job'
                   ,p_value      => self.job
                   ,p_write_null => false);
    apex_json.write(p_name       => 'mgr'
                   ,p_value      => self.mgr
                   ,p_write_null => true);
    apex_json.write(p_name       => 'hiredate'
                   ,p_value      => self.hiredate
                   ,p_write_null => false);
    apex_json.write(p_name       => 'sal'
                   ,p_value      => self.sal
                   ,p_write_null => false);
    apex_json.write(p_name       => 'comm'
                   ,p_value      => self.comm
                   ,p_write_null => true);
    apex_json.write(p_name       => 'deptno'
                   ,p_value      => self.deptno
                   ,p_write_null => false);
  
    apex_json.close_object;
    apex_json.close_object;
  
    l_retval := apex_json.get_clob_output;
  
    apex_json.free_output;
  
    return l_retval;
  
  end to_json;

  /********************************************************************************
  ********************************************************************************/
  member procedure print is
  begin
  
    dbms_output.put_line('empno   : ' || self.empno);
    dbms_output.put_line('ename   : ' || ename);
    dbms_output.put_line('job     : ' || job);
    dbms_output.put_line('mgr     : ' || mgr);
    dbms_output.put_line('hiredate: ' || hiredate);
    dbms_output.put_line('sal     : ' || sal);
    dbms_output.put_line('comm    : ' || comm);
    dbms_output.put_line('deptno  : ' || deptno);
  
  end print;

  /********************************************************************************
  ********************************************************************************/
  member function giveraise(p_percentage in number) return o_emp is
  
    l_retobj o_emp := self;
    
  begin
  
    l_retobj.sal := (1 + p_percentage) * l_retobj.sal;
  
    return l_retobj;
  
  end giveraise;

  /********************************************************************************
  ********************************************************************************/
  member function transfer(p_new_deptno in number) return o_emp is
  
    l_reccount pls_integer;
    l_retobj   o_emp := self;
    
  begin
  
    select count(*)
    into   l_reccount
    from   dept d
    where  d.deptno = p_new_deptno;
  
    if l_reccount > 0
    then
    
      l_retobj.deptno := p_new_deptno;
    
    else
    
      raise_application_error(-20000
                             ,'Parent dept for ' || p_new_deptno || ' not found');
    
    end if;
  
    return l_retobj;
  
  end transfer;

end;
/
