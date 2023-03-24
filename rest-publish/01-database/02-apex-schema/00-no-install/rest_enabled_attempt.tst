PL/SQL Developer Test script 3.0
16

declare
   l_response clob;

begin
   apex_web_service.g_request_headers(1).name := 'Content-Type';
   apex_web_service.g_request_headers(1).value := 'application/sql';

   :l_response := apex_web_service.make_rest_request(p_url         => 'https://dapex18.smart4solutions.nl/ords/pres_rest/_/sql' --
                                                   ,p_username    => 'PRESREST_CORE_DEV' -- not client_id
                                                   ,p_password    => 'nNtrHh3bJpxzD6kDCTK6' -- not client-secret!
                                                   ,p_http_method => 'POST'
                                                   ,p_body_blob   => utl_raw.cast_to_raw('select * from emp;'));

end;
/
1
l_response
1
<CLOB>
4208
0
