PL/SQL Developer Test script 3.0
29
declare
   l_response clob;
   l_vals     apex_json.t_values;
   l_reccount integer;
   l_val    apex_json.t_value;
   l_kind   apex_json.t_kind;
begin

   l_response := apex_web_service.make_rest_request(p_url         => 'https://dapex18.smart4solutions.nl/ords/pres_rest/noauth/emp' --
                                                   ,p_http_method => 'GET');

   apex_json.parse(p_source => l_response);

   l_reccount := apex_json.get_count(p_path => 'items');

   <<items>>
   for ii in 1 .. l_reccount
   loop
      
      l_val  := apex_json.get_value( 'items[%d].ename', ii);
      l_kind := l_val.kind;
      dbms_output.put_line(  apex_json.get_varchar2(p_path => 'items[%d].ename', p0 => ii)  );
      dbms_output.put_line(  apex_json.get_varchar2(p_path => 'items[%d].job', p0 => ii)  );
      dbms_output.put_line(  apex_json.get_date(p_path => 'items[%d].hiredate', p0 => ii)  );
      dbms_output.put_line('  ');
      
   end loop items;

end;
0
0
