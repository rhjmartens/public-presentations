create or replace force view srs_user_ords_clients_vw as 
select uoc.id
      ,uoc.name
      ,uoc.description
      ,uoc.auth_flow
      ,uoc.apex_application_id
      ,uoc.response_type
      ,uoc.client_id
      ,uoc.client_secret
      ,uoc.redirect_uri
      ,uoc.support_email
      ,uoc.support_uri
      ,uoc.allowed_origins
      ,uoc.about_url
      ,uoc.logo_content_type
      ,uoc.logo_image
      ,uoc.schema_id
      ,uoc.created_by
      ,uoc.created_on
      ,uoc.updated_by
      ,uoc.updated_on
from   user_ords_clients uoc;
