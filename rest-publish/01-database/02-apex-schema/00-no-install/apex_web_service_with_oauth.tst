PL/SQL Developer Test script 3.0
23
declare
   l_response clob;
begin
   apex_web_service.oauth_authenticate(p_token_url     => 'https://dapex18.smart4solutions.nl/ords/pres_rest/oauth/token'
                                      ,p_client_id     => '1FRBjoDbJMFGK_bp-sLrTw..'
                                      ,p_client_secret => 'i4CB6goMVoh7xdE6o-dv7Q..');
                                      
   APEX_WEB_SERVICE.G_REQUEST_HEADERS(1).name := 'Authorization';
   apex_web_service.g_request_headers(1).value := 'Bearer ' || apex_web_service.g_oauth_token.token;

   l_response := apex_web_service.make_rest_request(p_url         => 'https://dapex18.smart4solutions.nl/ords/pres_rest/pres_rest_tmpl/search?dname=SALES'
                                                   ,p_http_method => 'GET');
                                                   
   for d in (select *
             from   json_table(l_response, '$.departments.employees[*]'
                      columns ename path '$.ename'))
   loop
     
     dbms_output.put_line( d.ename );
   
   end loop;
   
end;
0
0
