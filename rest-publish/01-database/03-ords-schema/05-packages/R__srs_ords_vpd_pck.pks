create or replace package srs_ords_vpd_pck authid definer as
   /*                                                                           888       d8888
                                                                                888      d8P888
                                                                                888     d8P 888
                                 __     .d8888b  88888b.d88b.   8888b.  888d888 888888 d8P  888
                            _.-~  )     88K      888 "888 "88b     "88b 888P"   888   d88   888
                 _..--~~~~,'   ,-/     _"Y8888b. 888  888  888 .d888888 888     888   8888888888
              .-'. . . .'   ,-','    ,' )    X88 888  888  888 888  888 888     Y88b.       888
            ,'. . . _   ,--~,-'__..-'  ,'88888P' 888  888  888 "Y888888 888      "Y888      888
          ,'. . .  (@)' ---~~~~      ,'              888          888    d8b
         /. . . . '~~             ,-'                888          888    Y8P
        /. . . . .             ,-'                   888          888
       ; . . . .  - .        ,'    .d8888b   .d88b.  888 888  888 888888 888  .d88b.  88888b.  .d8888b
      : . . . .       _     /      88K      d88""88b 888 888  888 888    888 d88""88b 888 "88b 88K
     . . . . .          `-.:       "Y8888b. 888  888 888 888  888 888    888 888  888 888  888 "Y8888b.
    . . . ./  - .          )            X88 Y88..88P 888 Y88b 888 Y88b.  888 Y88..88P 888  888      X88
   .  . . |  _____..---.._/         88888P'  "Y88P"  888  "Y88888  "Y888 888  "Y88P"  888  888  88888P'
   -~~----~~~~             ~---~~~~--~~~--~~~---~~~~~---~~~~----~~~~~---~~~--~~~---
   --    NAME
   --      srs_context_api
   --
   --    DESCRIPTION
   --      restdemo context package for VPD
   --
   --    MODIFIED   (MM/DD/YYYY)
   --    RIM        10/09/2022 15:00 - Created
   --    RIM        10/10/2022 14:33 - include setters for client_id
                                                           policy
   --------------------------------------------------------------------------------
   */

   function emp_role_10(p_schema varchar2
                       ,p_obj    varchar2) return varchar2;

   function emp_role_all(p_schema varchar2
                        ,p_obj    varchar2) return varchar2;

   procedure set_policy(p_object_owner in varchar2
                       ,p_object_name  in varchar2
                       ,p_hide_columns in varchar2
                       ,p_policy_name  in varchar2
                       ,p_role         in varchar2);

   procedure drop_policy(p_object_owner in all_policies.object_owner%type
                        ,p_object_name  in all_policies.object_name%type
                        ,p_policy_name  in all_policies.policy_name%type);

end srs_ords_vpd_pck;
/
