PL/SQL Developer Test script 3.0
89
declare
   t_roles       owa.vc_arr;
   t_patterns    owa.vc_arr;
   t_modules     owa.vc_arr;
   l_client_name user_ords_clients.name%type := 'emp-client';
   l_client_role user_ords_roles.name%type := 'emp-role';
   l_client_priv user_ords_privileges.name%type := 'emp-priv';
begin
   /* cleanup */
   begin
      /* Remove existing roles */
      for r_role in (select *
                     from   user_ords_roles uor
                     where  uor.name like l_client_role || '%')
      loop
         ords.delete_role(p_role_name => r_role.name);
      end loop;
      /* delete existing privileges */
      for r_priv in (select *
                     from   user_ords_privileges uop
                     where  uop.name = l_client_priv)
      loop
         ords.delete_privilege(p_name => r_priv.name);
      end loop;
      /* delete existing clients */
      for r_client in (select *
                       from   user_ords_clients uoc
                       where  uoc.name like l_client_name || '%')
      loop
         oauth.delete_client(p_name => r_client.name);
      end loop;
   end;

   /* create new roles */
   for r_dept in (with iv_data as
                      (select rownum as rownumber
                            ,l_client_role || '-' || to_char(deptno) as client_role
                      from   srs_dept_vw
                      union all
                      select 999
                            ,l_client_role || '-all'
                      from   dual)
                     select rownum
                           ,client_role
                     from   iv_data
                     order  by rownumber)
   loop
      ORDS.CREATE_ROLE(P_ROLE_NAME => R_DEPT.CLIENT_ROLE);
      t_roles(r_dept.rownum) := r_dept.client_role;
   end loop;

   /* set patterns /*/
   t_patterns(1) := '/pres_rest_tmpl';
   t_patterns(2) := '/pres_rest_tmpl/*';

   /* create new privilege */
   ords.define_privilege(p_privilege_name => l_client_priv
                        ,p_roles          => t_roles
                        ,p_patterns       => t_patterns
                        ,p_modules        => t_modules
                        ,p_label          => 'EMP_VW data'
                        ,p_description    => 'Allow access to the EMP data');

   /* create a client for each department */
   for r_dept in (select l_client_name || '-' || deptno as client_name
                        ,l_client_role || '-' || deptno as client_role
                  from   srs_dept_vw
                  union
                  select l_client_name || '-all' as client_name
                        ,l_client_role || '-all' as client_role
                  from   dual)
   loop
     
      oauth.create_client(p_name            => r_dept.client_name
                         ,p_grant_type      => 'client_credentials'
                         ,p_owner           => 'SMART4Solutions'
                         ,p_description     => 'A client for restdemo'
                         ,p_support_email   => 'r.martens@smart4solutions.nl'
                         ,p_privilege_names => null--l_client_priv
                         );
      /* grant the role to the client */
      oauth.grant_client_role(p_client_name => r_dept.client_name, p_role_name => r_dept.client_role);
   
   end loop;

   commit;

end;
/
0
0
