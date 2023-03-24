PL/SQL Developer Test script 3.0
293
declare

  l_tablename   constant varchar2(255) := lower('dept');
  l_api_suffix  constant varchar2(10)  := '_api';
  l_api_prefix  constant varchar2(10)  := 'o_';
  l_create_type constant boolean       := false; -- TRUE will create the type, false will do dbms_output
  l_sequence             varchar2(30)  := l_tablename || '_seq';

  cursor c_cols is
    with iv as
     (select c.column_id          as rownr
            ,lower(c.column_name) as column_name
            ,upper(c.data_type)   as data_type
            ,c.data_length        as data_length
            ,max(length(c.column_name)) over(partition by c.table_name) as maxlen
      from   cols c
      where  c.table_name = upper(l_tablename))
    select rownr
          ,column_name
          ,data_type
          ,data_length
          ,maxlen
          ,(select max(rownr)
            from   iv) as lastrow
    from   iv
    order  by rownr asc;

  cursor c_pk_cols is
    select lower(ic.column_name) as col_name
    from   user_constraints uc
      join user_indexes     ix on ix.index_name = uc.index_name
      join user_ind_columns ic on ic.index_name = uc.index_name
    where  uc.table_name = upper(l_tablename)
    and    uc.constraint_type = 'P';

  l_pk_column_name       varchar2(100);
  l_typename    constant varchar2(30) := trim(trailing 's' from lower(l_tablename));
  l_spec                 clob;
  l_bdy                  clob;
  l_tblprefix   constant varchar2(100) := '#TABLEPREFIX#';
  l_col_list             varchar2(32767);
  l_mrg_cols             varchar2(32767);
  l_rcrd_has_version_col boolean;
  g_crlf       constant varchar2(2) := chr(10);

begin

  open c_pk_cols;
  fetch c_pk_cols
    into l_pk_column_name;
  close c_pk_cols;

  if l_sequence is null then
    l_sequence := 'pn_' || l_pk_column_name || '_seq';
  end if;

  l_spec := 'create or replace type ' || l_api_prefix || l_typename || l_api_suffix || ' force as object' || g_crlf;
  l_spec := l_spec || '  /*                           __           ' || g_crlf;
  l_spec := l_spec || '                           _.-~  )        ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗██╗  ██╗' || g_crlf;
  l_spec := l_spec || '                _..--~~~~,''   ,-/     _   ██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██║  ██║' || g_crlf;
  l_spec := l_spec || '             .-''. . . .''   ,-'',''    ,'' )  ███████╗██╔████╔██║███████║██████╔╝   ██║   ███████║' || g_crlf;
  l_spec := l_spec || '           ,''. . . _   ,--~,-''__..-''  ,''  ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ╚════██║' || g_crlf;
  l_spec := l_spec || '         ,''. . .  (@)'' ---~~~~      ,''    ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║        ██║' || g_crlf;
  l_spec := l_spec || '        /. . . . ''~~             ,-''      ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═╝' || g_crlf;
  l_spec := l_spec || '       /. . . . .             ,-''         ███████╗ ██████╗ ██╗     ██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗███████╗' || g_crlf;
  l_spec := l_spec || '      ; . . . .  - .        ,''            ██╔════╝██╔═══██╗██║     ██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝' || g_crlf;
  l_spec := l_spec || '     : . . . .       _     /              ███████╗██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║███████╗' || g_crlf;
  l_spec := l_spec || '    . . . . .          `-.:               ╚════██║██║   ██║██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║' || g_crlf;
  l_spec := l_spec || '   . . . ./  - .          )               ███████║╚██████╔╝███████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║███████║' || g_crlf;
  l_spec := l_spec || '  .  . . |  _____..---.._/                ╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝' || g_crlf;
  l_spec := l_spec || '  -~~----~~~~             ~---~~~~--~~~--~~~---~~~~~---~~~~----~~~~~---~~~--~~~---' || g_crlf;
  l_spec := l_spec || '  -- ' || g_crlf;
  l_spec := l_spec || '  --    NAME' || g_crlf;
  l_spec := l_spec || '  --      ' || l_api_prefix || l_typename || l_api_suffix || g_crlf;
  l_spec := l_spec || '  --' || g_crlf;
  l_spec := l_spec || '  --    DESCRIPTION' || g_crlf;
  l_spec := l_spec || '  --      table API for ' || upper(l_tablename) || g_crlf;
  l_spec := l_spec || '  --' || g_crlf;
  l_spec := l_spec || '  --    MODIFIED   (MM/DD/YYYY)' || g_crlf;
  l_spec := l_spec || '  --    ' || sys_context('USERENV'
                                               ,'OS_USER') || '   ' || to_char(sysdate
                                                                              ,'DD-MON-YYYY HH24:MI:SS') || ' - Created' || g_crlf;
  l_spec := l_spec || '  --------------------------------------------------------------------------------' || g_crlf;
  l_spec := l_spec || '  */' || g_crlf;
  l_spec := l_spec || '(-- Attributes' || g_crlf;
  l_spec := l_spec || '' || g_crlf;

  l_rcrd_has_version_col := false;

  for c in c_cols
  loop
  
    if c.column_name in ('row_version')
    then
      l_rcrd_has_version_col := true;
    end if;
  
    l_spec := lower(l_spec || '  ' || rpad(c.column_name
                                          ,c.maxlen) || ' ' || c.data_type || case
                      when c.data_type not in ('DATE') then
                       '(' || c.data_length || ')'
                      else
                       ''
                    end || ',') || g_crlf;
  end loop;

  for c in c_cols
  loop
    l_col_list := l_col_list || l_tblprefix || lower(c.column_name) || ',' || g_crlf;
  end loop;

  l_spec := l_spec || g_crlf;
  l_spec := l_spec || '  -- Member functions and procedures,' || g_crlf;
  l_spec := l_spec || '  constructor function ' || l_api_prefix || l_typename || l_api_suffix || '(p_' || l_pk_column_name || ' in number default null) return self as result,' || g_crlf;
  l_spec := l_spec || '' || g_crlf;

  if l_rcrd_has_version_col
  then
    l_spec := l_spec || '  member procedure save_to_db(i_current_row_version in pls_integer default null),' || g_crlf;
  else
    l_spec := l_spec || '  member procedure save_to_db,' || g_crlf;
  end if;

  l_spec := l_spec || '' || g_crlf;
  l_spec := l_spec || '  member procedure delete_from_db,' || g_crlf;
  l_spec := l_spec || '' || g_crlf;
  l_spec := l_spec || '  static procedure delete_from_db(p_' || l_pk_column_name || ' in number)' || g_crlf;
  l_spec := l_spec || '' || g_crlf;
  l_spec := l_spec || ') not final;';

  l_bdy := 'create or replace type body ' || l_api_prefix || l_typename || l_api_suffix || ' is' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  /********************************************************************************' || g_crlf;
  l_bdy := l_bdy || '  ** constructor function' || g_crlf;
  l_bdy := l_bdy || '  ** usage: <var> := new <object>();     -- for a new empty object' || g_crlf;
  l_bdy := l_bdy || '  **        <var> := new <object>(1234); -- retreive record 1234 from table' || g_crlf;
  l_bdy := l_bdy || '  **                                        and store in object' || g_crlf;
  l_bdy := l_bdy || '  ********************************************************************************/' || g_crlf;
  l_bdy := l_bdy || '  constructor function ' || l_api_prefix || l_typename || l_api_suffix || '(p_' || l_pk_column_name || ' in number default null) return self as result is' || g_crlf;
  l_bdy := l_bdy || '    cursor c_record is' || g_crlf;
  l_bdy := l_bdy || '    select ';

  l_bdy := l_bdy || trim(leading ' ' from replace(trim(trailing ',' from trim(trailing g_crlf from l_col_list))
                                ,l_tblprefix
                                ,'           t.')) || g_crlf;
  l_bdy := l_bdy || '    from   ' || l_tablename || ' t' || g_crlf;
  l_bdy := l_bdy || '    where  t.' || l_pk_column_name || ' = p_' || l_pk_column_name || ';' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  begin' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '    if p_' || l_pk_column_name || ' is not null' || g_crlf;
  l_bdy := l_bdy || '      then' || g_crlf;
  l_bdy := l_bdy || '        open c_record;' || g_crlf;
  l_bdy := l_bdy || '        fetch c_record into' || g_crlf;

  l_bdy := l_bdy || trim(trailing ',' from trim(trailing g_crlf from replace(l_col_list
                                     ,l_tblprefix
                                     ,'               self.'))) || ';' || g_crlf;

  l_bdy := l_bdy || '        close c_record;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '    end if;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '    return;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  end ' || l_api_prefix || l_typename || l_api_suffix ||  ';' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  /********************************************************************************' || g_crlf;
  l_bdy := l_bdy || '  ** member procedure save_to_db' || g_crlf;
  l_bdy := l_bdy || '  ** usage: <object>.save -- saves the record into the table' || g_crlf;
  l_bdy := l_bdy || '  **                       the primary key will be stored in self.<id_column> after ' || g_crlf;
  l_bdy := l_bdy || '  **                       insert' || g_crlf;
  l_bdy := l_bdy || '  ********************************************************************************/' || g_crlf;

  if l_rcrd_has_version_col
  then
    l_bdy := l_bdy || '  member procedure save_to_db(i_current_row_version in pls_integer default null) is' || g_crlf;
    l_bdy := l_bdy || '  begin' || g_crlf;
    l_bdy := l_bdy || '    ' || g_crlf;
    l_bdy := l_bdy || '    if i_current_row_version is not null and i_current_row_version != coalesce(self.row_version, 1) then' || g_crlf;
    l_bdy := l_bdy || '      raise_application_error(-20000, ''Data in database was changed since your last fetch.'');' || g_crlf;
    l_bdy := l_bdy || '    end if;' || g_crlf;
  
  else
    l_bdy := l_bdy || '  member procedure save_to_db is' || g_crlf;
    l_bdy := l_bdy || '  begin' || g_crlf;
  
  end if;

  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '    if self.' || l_pk_column_name || ' is null then' || g_crlf;
  l_bdy := l_bdy || '      self.' || l_pk_column_name || ' := ' || l_sequence || '.nextval;' || g_crlf;
  l_bdy := l_bdy || '    end if;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;

  l_bdy := l_bdy || '    merge into ' || l_tablename || ' trg' || g_crlf;
  l_bdy := l_bdy || '    using dual' || g_crlf;
  l_bdy := l_bdy || '    on (trg.' || l_pk_column_name || ' = self.' || l_pk_column_name || ')' || g_crlf;
  l_bdy := l_bdy || '    when matched then' || g_crlf;
  l_bdy := l_bdy || '    update' || g_crlf;
  l_bdy := l_bdy || '      set ';

  for c in c_cols
  loop
    if c.column_name != l_pk_column_name
    then
      l_mrg_cols := l_mrg_cols || '          trg.' || rpad(c.column_name
                                                          ,c.maxlen) || ' = self.' || c.column_name || case c.column_name
                      when 'row_version' then
                       ' + 1 '
                      else
                       null
                    end || ',' || g_crlf;
    end if;
  end loop;

  l_bdy := l_bdy || trim(l_mrg_cols) || g_crlf;

  l_bdy := trim(trailing ',' from trim(trailing g_crlf from l_bdy)) || g_crlf;

  l_bdy := l_bdy || '    when not matched then' || g_crlf;
  l_bdy := l_bdy || '      insert' || g_crlf;
  l_bdy := l_bdy || '        (';

  --NoFormat Start
  for c in c_cols
  loop
    l_bdy := l_bdy || case c.rownr when 1 then '' else '        ,' end || c.column_name;
    l_bdy := l_bdy || case when c.rownr = c.lastrow then ')' else '' end || g_crlf;
  end loop;
  l_bdy := l_bdy || '        values' || g_crlf;
  
  for c in c_cols
  loop
    if c.column_name = 'row_version' then
      l_bdy := l_bdy || '        ' || case c.rownr when 1 then '(' else ',' end || 'coalesce(self.' || c.column_name || ', 1)';
    else
      l_bdy := l_bdy || '        ' || case c.rownr when 1 then '(' else ',' end || 'self.' || c.column_name;
    end if;
    l_bdy := l_bdy || case when c.rownr = c.lastrow then ');' else '' end || g_crlf;
  end loop;
  --NoFormat End

  --l_bdy := l_bdy || replace(trim(trailing ',' from trim(trailing g_crlf from l_col_list)), l_tblprefix, '         self.') || g_crlf;

  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  end save_to_db;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  /********************************************************************************' || g_crlf;
  l_bdy := l_bdy || '  ** member procedure delete_from db' || g_crlf;
  l_bdy := l_bdy || '  ** usage: <object>.delete_from_db -- remove the record from the table' || g_crlf;
  l_bdy := l_bdy || '  ********************************************************************************/' || g_crlf;
  l_bdy := l_bdy || '  member procedure delete_from_db is' || g_crlf;
  l_bdy := l_bdy || '  begin' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '    delete ' || l_tablename || ' t' || g_crlf;
  l_bdy := l_bdy || '    where  t.' || l_pk_column_name || ' = self.' || l_pk_column_name || ';' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  l_bdy := l_bdy || '  end delete_from_db;' || g_crlf;
  l_bdy := l_bdy || '' || g_crlf;
  
  
  l_bdy := l_bdy || '  /********************************************************************************' || g_crlf;
  l_bdy := l_bdy || '  ** static procedure delete_from db' || g_crlf;
  l_bdy := l_bdy || '  ** usage: <object>.delete_from_db(1234) -- remove record 1234 from the table' || g_crlf;
  l_bdy := l_bdy || '  **        the object should not be instantiated' || g_crlf;
  l_bdy := l_bdy || '  ********************************************************************************/' || g_crlf;
  l_bdy := l_bdy || '  static procedure delete_from_db(p_' || l_pk_column_name || ' in number) is' || g_crlf;
  l_bdy := l_bdy || '  begin' || g_crlf;
  l_bdy := l_bdy || '  ' || g_crlf;
  l_bdy := l_bdy || '    delete ' || l_tablename || ' t' || g_crlf;
  l_bdy := l_bdy || '    where  t.' || l_pk_column_name || ' = p_' || l_pk_column_name || ';' || g_crlf;
  l_bdy := l_bdy || '  ' || g_crlf;
  l_bdy := l_bdy || '  end delete_from_db;' || g_crlf;
  l_bdy := l_bdy || '  ' || g_crlf;
  l_bdy := l_bdy || 'end;';
  
  if l_create_type then

    execute immediate l_spec;

    execute immediate l_bdy;

  else
    
    dbms_output.put_line( l_spec );
    
    dbms_output.put_line( '/' );
    
    dbms_output.put_line( l_bdy );
    
  end if;
end;
0
0
