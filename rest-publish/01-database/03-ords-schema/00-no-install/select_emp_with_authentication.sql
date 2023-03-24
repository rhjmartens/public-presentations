select *
from   srs_emp_vw e
where  exists (select 1
               from   user_ords_client_roles ctrl
                 join user_ords_clients clnt on clnt.id = ctrl.client_id
                 where  clnt.client_id = :current_user
                   and  (ctrl.role_name = 'emp-role-' || e.deptno or ctrl.role_name = 'emp-role-all'));
                   
select *
from   srs_emp_vw
where  exists (select 1
               from   user_ords_clients clnt
                 join user_ords_client_roles clrl on clrl.client_id = clnt.id
                 join role_departments       rldp on rldp.role_name = clrl.role_name
               where  clnt.client_id = :current_user);


begin
  ords.drop_rest_for_object(p_object => 'OEHR_COUNTRIES_VW');
end;
/
select * from logger_logs_vw;

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'PRESREST_ORDS_DEV',
                       p_object => 'SRS_DEPARTMENT_PCK',
                       p_object_type => 'PACKAGE',
                       p_object_alias => 'srs_department_pck',
                       p_auto_rest_auth => FALSE);

    commit;

END;
/
