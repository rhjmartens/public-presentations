select * from USER_ORDS_ROLES;              -- shows roles

select * from USER_ORDS_PRIVILEGES;         -- shows privileges

select * from USER_ORDS_PRIVILEGE_ROLES;    -- Relationship between privs and roles

select * from USER_ORDS_PRIVILEGE_MAPPINGS; -- What patterns are protected by what privilege

select * from USER_ORDS_CLIENTS;            -- Client info

select * from USER_ORDS_CLIENT_PRIVILEGES;  -- Client to priv mapping

select * from USER_ORDS_CLIENT_ROLES ctrl;  -- Client to role mapping

select ocl.client_id
      ,ocl.client_secret
      ,listagg(ocr.role_name, ':') as role_names
from   user_ords_clients ocl
  left join user_ords_client_roles ocr on ocr.client_id = ocl.id
group by ocl.client_id, ocl.client_secret
order by role_names;
logger
select * from logger_logs l
where 1=1
--  and l.user_name != 'S4SBO_CORE_DEV'
  and l.module not like 'S4SBO%'
  and l.scope not like 's4s_exact%'
order by l.id desc;
