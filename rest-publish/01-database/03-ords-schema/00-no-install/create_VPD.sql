/* Package does not need to be present now, but "setting"
  something in this context is only allowed from inside this package
*/
;
create or replace context rest_ctx using srs_vpd_api;
drop context rest_ctx;

select * from all_context;
select * from all_policies;

begin
  for p in (select * 
            from   all_policies pol
            where  pol.object_owner like 'PRESREST%'
              or pol.pf_owner like 'PRESREST%')
  loop
    dbms_rls.drop_policy(object_schema => p.object_owner, object_name => p.object_name, policy_name => p.policy_name);
  end loop;
  commit;
end;
/

begin
  dbms_rls.add_policy(object_schema         => 'CORE_SCHEMA'
                     ,object_name           => 'TABLE_NAME'
                     ,policy_name           => 'name'
                     ,function_schema       => 'ORDS_SCHEMA'
                     ,policy_function       => 'package.function'
                     ,sec_relevant_cols     => 'HIDDEN,COLS'
                     ,sec_relevant_cols_opt => dbms_rls.all_rows
end;
/
  
begin
  
  srs_ords_vpd_pck.set_policy(p_object_owner => 'PRESREST_CORE_DEV'
                             ,p_object_name  => 'EMP'
                             ,p_hide_columns => 'SAL,COMM'
                             ,p_policy_name  => 'srs-emp10-ltd'
                             ,p_role         => 'emp-role-10');
end;
/

select ocl.client_id
      ,ocl.client_secret 
      ,ocr.role_name--, ':') within group (order by ocr.role_name) as client_roles
from   user_ords_clients ocl
  left join user_ords_client_roles ocr on ocr.client_id = ocl.id
order by ocr.role_name;

begin
  --srs_vpd_api.set_client_id(p_client_id => 'SZCmsqZ-DUeqDu1PyG97aQ..'); -- 10
  --srs_context_api.set_client_id(p_client_id => '1FRBjoDbJMFGK_bp-sLrTw..'); -- 20
  srs_vpd_api.set_client_id(p_client_id => null);
end;
/
select * from SRS_EMP_VW;
