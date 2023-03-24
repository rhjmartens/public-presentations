PL/SQL Developer Test script 3.0
40
declare
   t_params  apex_exec.t_parameters;
   r_par     apex_exec.t_parameter;
   l_clob    clob;
   l_context apex_exec.t_context;
   t_ix      wwv_flow.num_assoc_arr;
begin
   apex_session.create_session(p_app_id                   => 187
                              ,p_page_id                  => 1
                              ,p_username                 => 'rhjmartens'
                              ,p_call_post_authentication => false);

   l_context := apex_exec.open_rest_source_query(p_static_id  => 'emp_20' --
                                                ,p_parameters => t_params
                                                ,p_max_rows   => 1000);
                                                
   t_ix('EMPNO')    := apex_exec.get_column_position(l_context, 'EMPNO');
   t_ix('JOB')      := apex_exec.get_column_position(l_context, 'JOB');
   t_ix('MGR')      := apex_exec.get_column_position(l_context, 'MGR');
   t_ix('SAL')      := apex_exec.get_column_position(l_context, 'SAL');
   t_ix('COMM')     := apex_exec.get_column_position(l_context, 'COMM');
   t_ix('ENAME')    := apex_exec.get_column_position(l_context, 'ENAME');
   t_ix('DEPTNO')   := apex_exec.get_column_position(l_context, 'DEPTNO');
   t_ix('HIREDATE') := apex_exec.get_column_position(l_context, 'HIREDATE');

   while apex_exec.next_row(l_context)
   loop
      dbms_output.put_line('');
      dbms_output.put_line( apex_exec.get_number(l_context      , t_ix('EMPNO')    ) );
      dbms_output.put_line( apex_exec.get_varchar2(l_context    , t_ix('JOB')      ) );
      dbms_output.put_line( apex_exec.get_number(l_context      , t_ix('MGR')      ) );
      dbms_output.put_line( apex_exec.get_number(l_context      , t_ix('SAL')      ) );
      dbms_output.put_line( apex_exec.get_number(l_context      , t_ix('COMM')     ) );
      dbms_output.put_line( apex_exec.get_varchar2(l_context    , t_ix('ENAME')    ) );
      dbms_output.put_line( apex_exec.get_number(l_context      , t_ix('DEPTNO')   ) );
      dbms_output.put_line( apex_exec.get_timestamp_tz(l_context, t_ix('HIREDATE') ) );
   end loop;

   apex_exec.close(l_context);
end;
0
0
