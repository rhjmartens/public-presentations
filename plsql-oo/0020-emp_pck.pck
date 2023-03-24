create or replace package emp_pck is
  /*                           __
                           _.-~  )        ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗██╗  ██╗
                _..--~~~~,'   ,-/     _   ██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██║  ██║
             .-'. . . .'   ,-','    ,' )  ███████╗██╔████╔██║███████║██████╔╝   ██║   ███████║
           ,'. . . _   ,--~,-'__..-'  ,'  ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ╚════██║
         ,'. . .  (@)' ---~~~~      ,'    ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║        ██║
        /. . . . '~~             ,-'      ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═╝
       /. . . . .             ,-'         ███████╗ ██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
      ; . . . .  - .        ,'            ██╔════╝██╔═══██╗██║     ██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
     : . . . .       _     /              ███████╗██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
    . . . . .          `-.:               ╚════██║██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
   . . . ./  - .          )               ███████║╚██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║███████║
  .  . . |  _____..---.._/                ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
  -~~----~~~~             ~---~~~~--~~~--~~~---~~~~~---~~~~----~~~~~---~~~--~~~---
  --
  --    NAME
  --      emp_pck
  --
  --    DESCRIPTION
  --
  --
  --    MODIFIED   (MM/DD/YYYY)
  --    RMARTENS   04-03-19 23:57:04 - Created
  --------------------------------------------------------------------------------
  */
  -- Public type declarations

  type t_emp is record(
     empno    number(4)
    ,ename    varchar2(10)
    ,job      varchar2(9)
    ,mgr      number(4)
    ,hiredate date
    ,sal      number(7)
    ,comm     number(7)
    ,deptno   number(2));
    
  type tt_emp is table of t_emp;


  function emp_by_dept(p_deptno in emp.deptno%type) return tt_emp
    pipelined;

end emp_pck;
/
create or replace package body emp_pck is

  function emp_by_dept(p_deptno in emp.deptno%type) return tt_emp
    pipelined is
  
     cursor c_emp is
      select e.empno
            ,e.ename
            ,e.job
            ,e.mgr
            ,e.hiredate
            ,e.sal
            ,e.comm
            ,e.deptno
      from   emp e
      where  e.deptno = p_deptno;
    l_emp t_emp;
  begin
  
    open c_emp;
  
    <<employees>>
    loop
    
      fetch c_emp
        into l_emp.empno
            ,l_emp.ename
            ,l_emp.job
            ,l_emp.mgr
            ,l_emp.hiredate
            ,l_emp.sal
            ,l_emp.comm
            ,l_emp.deptno;
    
      exit employees when c_emp%notfound;
    
      pipe row(l_emp);
    
    end loop employees;
  
    close c_emp;
  
  end emp_by_dept;

end emp_pck;
/
