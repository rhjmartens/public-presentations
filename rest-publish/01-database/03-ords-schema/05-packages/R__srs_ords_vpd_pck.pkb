create or replace package body srs_ords_vpd_pck as

   g_logscope varchar2(50) := lower($$plsql_unit || '.');

   --################################################################################
   -- Name    : get_predicate#
   -- Purpose : centralized function te o determine if a policy should be active
   -- Author  : R.Martens
   -- Date          Author      Version   Description
   ---------------+-----------+---------+--------------------------------------------
   -- 10-10-2022   R.Martens   1.0       Initial version
   --################################################################################
   function get_predicate#(p_role_name in varchar2) return varchar2 is
      l_reccount  integer := 0;
      l_client_id varchar2(100) := sys_context('userenv', 'client_identifier');
      lggr        logger_oo := new logger_oo(p_scope => g_logscope || 'get_predicate');
      l_retval    varchar2(4000);
   begin
   
      lggr.add_param(p_name => 'p_role_name', p_value => p_role_name);
      lggr.log_start;
   
      if l_client_id is null
      then
         l_reccount := 0;
      
      else
         select count(*)
         into   l_reccount
         from   user_ords_clients ocl
         join   user_ords_client_roles crl on crl.client_id = ocl.id
         where  crl.role_name = p_role_name
         and    ocl.client_id = l_client_id;
      
      end if;
   
      --return null; -- policy is OFF
      --return '1=0'; -- policy is ON
      if l_reccount > 0
      then
         l_retval := 'deptno=' || substr(p_role_name, -2);
      else
         l_retval := null;
      end if;
   
      lggr.add_param(p_name => 'l_reccount', p_value => l_reccount);
      lggr.add_param(p_name => 'l_retval', p_value => l_retval);
      lggr.log_end;
   
      return l_retval;
   
   end get_predicate#;

   --################################################################################
   -- Name    : emp_role_10
   -- Purpose : policy-function for role emp-role-10
   -- Author  : R.Martens
   -- Date          Author      Version   Description
   ---------------+-----------+---------+--------------------------------------------
   -- 11-10-2022    R.Martens   1.0       Initial version
   --################################################################################   
   function emp_role_10(p_schema varchar2
                       ,p_obj    varchar2) return varchar2 as
   begin
   
      return get_predicate#('emp-role-10');
   
   end emp_role_10;

   --################################################################################
   -- Name    : emp_role_all
   -- Purpose : policy-function for role emp-role-all
   -- Author  : R.Martens
   -- Date          Author      Version   Description
   ---------------+-----------+---------+--------------------------------------------
   -- 11-10-2022    R.Martens   1.0       Initial version
   --################################################################################
   function emp_role_all(p_schema varchar2
                        ,p_obj    varchar2) return varchar2 as
   begin
   
      return get_predicate#('emp-role-all');
   
   end emp_role_all;

   --################################################################################
   -- Name    : set_policy
   -- Purpose : (re)create a policy
   -- Author  : R.Martens
   -- Date          Author      Version   Description
   ---------------+-----------+---------+--------------------------------------------
   -- 11-10-2022    R.Martens   1.0       Initial version
   --################################################################################   
   procedure set_policy(p_object_owner in varchar2
                       ,p_object_name  in varchar2
                       ,p_hide_columns in varchar2
                       ,p_policy_name  in varchar2
                       ,p_role         in varchar2) is
      l_object_name     varchar2(255) := upper(p_object_name);
      l_policy_name     user_policies.policy_name%type := replace(upper(p_policy_name), '-', '_');
      l_policy_function varchar2(255) := lower($$plsql_unit || '.' || replace(p_role, '-', '_'));
      l_hide_columns    varchar2(4000) := upper(p_hide_columns);
      l_action constant varchar2(20) := 'SELECT';
   begin
   
      <<drop_pols>>
      for r_pol in (select pol.object_owner
                          ,pol.object_name
                          ,pol.policy_name
                    from   all_policies pol
                    where  pol.object_name = p_object_name
                    and    pol.policy_name = l_policy_name
                    and    pol.object_owner = p_object_owner)
      loop
         dbms_rls.drop_policy(object_schema => r_pol.object_owner
                             ,object_name   => r_pol.object_name
                             ,policy_name   => r_pol.policy_name);
      end loop drop_pols;
   
      --NoFormat Start
        dbms_rls.add_policy(object_schema         => p_object_owner      -- specify the schema containing the object 
                           ,object_name           => p_object_name       -- specify the object name within the schema.
                           ,policy_name           => l_policy_name       -- specify the policy name. Policy name is unique for an object. 
                           ,function_schema       => 'PRESREST_ORDS_DEV' -- specify the schema in which the policy function is created
                           ,policy_function       => l_policy_function   -- specify the name of the policy function
                           ,statement_Types       => l_action            -- Operations when this policy applies. SELECT
                           ,sec_relevant_cols     => p_hide_columns      -- ALL relevant columns to be hidden from users
                           ,sec_relevant_cols_opt => dbms_rls.ALL_ROWS
                           );
      --NoFormat End
   end set_policy;

   --################################################################################
   -- Name    : drop_policy
   -- Purpose : drop a policy
   -- Author  : R.Martens
   -- Date          Author      Version   Description
   ---------------+-----------+---------+--------------------------------------------
   -- 11-10-2022    R.Martens   1.0       Initial version
   --################################################################################
   procedure drop_policy(p_object_owner in all_policies.object_owner%type
                        ,p_object_name  in all_policies.object_name%type
                        ,p_policy_name  in all_policies.policy_name%type) is
      l_reccount integer;
   begin
   
      select count(*)
      into   l_reccount
      from   user_policies pol
      where  pol.object_name = p_object_name
      and    pol.policy_name = p_policy_name;
   
      if l_reccount = 0
      then
         raise_application_error(-20000, 'Policy not found');
      end if;
   
      dbms_rls.drop_policy(object_schema => p_object_owner, object_name => p_object_name, policy_name => p_policy_name);
   
   end drop_policy;

end srs_ords_vpd_pck;
/
