PL/SQL Developer Test script 3.0
18
declare
   l_response clob;
begin

   l_response := apex_web_service.make_rest_request(p_url         => 'https://dapex18.smart4solutions.nl/ords/pres_rest/noauth/dept' --
                                                   ,p_http_method => 'GET');

   for d in (select *
             from   json_table(l_response
                              ,'$.items[*]' --
                               columns(deptno varchar2 path '$.deptno'
                                      ,dname varchar2 path '$.dname'
                                      ,loc varchar2 path '$.loc')))
   loop
      dbms_output.put_line(rpad(d.deptno, 5) || rpad(d.dname, 20)|| rpad(d.loc, 20));
   end loop;

end;
1
l_url
0
0
1
l_url
