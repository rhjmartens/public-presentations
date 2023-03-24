PL/SQL Developer Test script 3.0
7

begin
  -- Test statements here
  apex_instance_admin.set_parameter(p_parameter => 'APEX_BUILDER_AUTHENTICATION'
                                   ,p_value     => 'APEX');
  commit;
end;
0
0
