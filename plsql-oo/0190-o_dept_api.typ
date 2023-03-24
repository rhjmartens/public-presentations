create or replace type o_dept_api force as object
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
  --    name
  --      o_dept_api
  --
  --    description
  --      table api for dept
  --
  --    modified   (mm/dd/yyyy)
  --    rmartens   20-nov-2019 12:48:51 - created
  --------------------------------------------------------------------------------
  */
(-- attributes

  deptno number(22),
  dname  varchar2(50),
  loc    varchar2(50),

  -- Member functions and procedures,
  constructor function o_dept_api(p_deptno in number default null) return self as result,
  
  constructor function o_dept_api(p_dname in varchar2 default null) return self as result,

  member procedure save_to_db,

  member procedure delete_from_db,

  static procedure delete_from_db(p_deptno in number)

) not final;
/
create or replace type body o_dept_api is

  /********************************************************************************
  ** constructor function
  ** usage: <var> := new <object>();     -- for a new empty object
  **        <var> := new <object>(1234); -- retreive record 1234 from table
  **                                        and store in object
  ********************************************************************************/
  constructor function o_dept_api(p_deptno in number default null) return self as result is
    cursor c_record is
    select t.deptno,
           t.dname,
           t.loc
    from   dept t
    where  t.deptno = p_deptno;

  begin

    if p_deptno is not null
      then
        open c_record;
        fetch c_record into
               self.deptno,
               self.dname,
               self.loc;
        close c_record;

    end if;

    return;

  end o_dept_api;
  
  
  constructor function o_dept_api(p_dname in varchar2 default null) return self as result
  is
    cursor c_record is
    select t.deptno,
           t.dname,
           t.loc
    from   dept t
    where  t.dname = p_dname;
  begin
    
    open c_record;
    fetch c_record into
      self.deptno,
      self.dname,
      self.loc;
    close c_record;
    
    return;
  
  end o_dept_api;

  /********************************************************************************
  ** member procedure save_to_db
  ** usage: <object>.save -- saves the record into the table
  **                       the primary key will be stored in self.<id_column> after 
  **                       insert
  ********************************************************************************/
  member procedure save_to_db is
  begin

    if self.deptno is null then
      self.deptno := dept_seq.nextval;
    end if;

    merge into dept trg
    using dual
    on (trg.deptno = self.deptno)
    when matched then
    update
      set trg.dname  = self.dname,
          trg.loc    = self.loc
    when not matched then
      insert
        (deptno
        ,dname
        ,loc)
        values
        (self.deptno
        ,self.dname
        ,self.loc);

  end save_to_db;

  /********************************************************************************
  ** member procedure delete_from db
  ** usage: <object>.delete_from_db -- remove the record from the table
  ********************************************************************************/
  member procedure delete_from_db is
  begin

    delete dept t
    where  t.deptno = self.deptno;

  end delete_from_db;

  /********************************************************************************
  ** static procedure delete_from db
  ** usage: <object>.delete_from_db(1234) -- remove record 1234 from the table
  **        the object should not be instantiated
  ********************************************************************************/
  static procedure delete_from_db(p_deptno in number) is
  begin
  
    delete dept t
    where  t.deptno = p_deptno;
  
  end delete_from_db;
  
end;
/
