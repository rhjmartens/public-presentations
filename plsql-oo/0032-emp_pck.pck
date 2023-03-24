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
  
    for r_emp in (select *
                  from   emp e
                  where  e.deptno = coalesce(p_deptno
                                            ,e.deptno))
    loop
    
      l_emp := new o_emp(empno    => r_emp.empno
                        ,ename    => r_emp.ename
                        ,job      => r_emp.job
                        ,mgr      => r_emp.mgr
                        ,hiredate => r_emp.hiredate
                        ,sal      => r_emp.sal
                        ,comm     => r_emp.comm
                        ,deptno   => r_emp.deptno
                        );
    
      pipe row(l_emp);
    
      l_emp := null;
    
    end loop;
  
  end emp_by_dept;

end emp_pck;
/
