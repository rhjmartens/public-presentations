PL/SQL Developer Test script 3.0
10
begin
   ords.enable_object(p_enabled      => true -- Default  { TRUE | FALSE }
                     ,p_schema       => 'RESTDEMO_ORDS_DEV'
                     ,p_object       => 'EMP_VW'
                     ,p_object_type  => 'VIEW' -- Default  { TABLE | VIEW }
                     ,p_object_alias => 'employees');

   commit;
end;
/
0
0
