create or replace public synonym dbms_rls for sys.dbms_rls;

grant execute on sys.dbms_rls to presrest_ords_dev;

grant execute on sys.dbms_session to presrest_ords_dev;

grant execute on dbms_rls to presrest_core_dev ;
