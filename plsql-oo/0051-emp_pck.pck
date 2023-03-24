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
  --      emp3_pck
  --
  --    DESCRIPTION
  --
  --
  --    MODIFIED   (MM/DD/YYYY)
  --    RMARTENS   05-03-19 00:10:41 - Created
  --------------------------------------------------------------------------------
  */

  function emp_by_dept(p_deptno in emp.deptno%type) return o_emp_t
    pipelined;

end emp_pck;
/
create or replace package body emp_pck is

  function emp_by_dept(p_deptno in emp.deptno%type) return o_emp_t
    pipelined is
  
    l_emp o_emp;
  
  begin
  
    <<emp>>
    for r_emp in (select *
                  from   emp e
                  where  e.deptno = p_deptno)
    loop
      l_emp          := new o_emp;
      l_emp.empno    := r_emp.empno;
      l_emp.ename    := r_emp.ename;
      l_emp.job      := r_emp.job;
      l_emp.mgr      := r_emp.mgr;
      l_emp.hiredate := r_emp.hiredate;
      l_emp.sal      := r_emp.sal;
      l_emp.comm     := r_emp.comm;
      l_emp.deptno   := r_emp.deptno;
    
      pipe row(l_emp);
    
    end loop emp;
  
  end emp_by_dept;

end emp_pck;
/
