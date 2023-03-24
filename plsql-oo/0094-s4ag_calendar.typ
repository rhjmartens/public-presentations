create or replace type s4ag_calendar as object
(
/*                           __
                         _.-~  )
              _..--~~~~,'   ,-/     _
           .-'. . . .'   ,-','    ,' )
         ,'. . . _   ,--~,-'__..-'  ,'  _____ __  __          _____ _______
       ,'. . .  (@)' ---~~~~      ,'   / ____|  \/  |   /\   |  __ \__   __|
      /. . . . '~~             ,-'    | (___ | \  / |  /  \  | |__) | | |
     /. . . . .             ,-'   _  _ \___ \| |\/| | / /\ \ |  _  /  | |
    ; . . . .  - .        ,'     | || |____) | |  | |/ ____ \| | \ \  | |
   : . . . .       _     /       | || |_____/|_|__|_/_/_ _ \_\_|  \_\ |_|
  . . . . .          `-.:        |__   _/ _` | '_ \ / _ \ \/ /
 . . . ./  - .          )           | || (_| | |_) |  __/>  <
.  . . |  _____..---.._/            |_| \__,_| .__/ \___/_/\_\
-~~----~~~~             ~---~~~~--~~~--~~~---~| |~---~~~~----~~~~~---~~~--~~~---
--                                            |_|
--    NAME
--      s4ag_calendar
--
--    DESCRIPTION
--      
--
--    MODIFIED   (MM/DD/YYYY)
--    RICHARD   14-10-2013 09:17:30 - Created
--------------------------------------------------------------------------------
*/

-- Attributes
  kind        varchar2(512), --: "calendar#calendar",
  etag        varchar2(512), --
  id          varchar2(512), --
  summary     varchar2(512), --
  description varchar2(512), --
  location    varchar2(512), --
  timezone    varchar2(512), --

/*****************************************************************************/
  constructor function s4ag_calendar return self as result,
/*****************************************************************************/
  constructor function s4ag_calendar(p_calendarid in varchar2
                                    ,p_token      in varchar2
                                    ,p_wallet     in varchar2
                                    ,p_wallet_pw  in varchar2) return self as result,
/*****************************************************************************/
  member function get(p_calendarid in varchar2
                     ,p_token      in varchar2
                     ,p_wallet     in varchar2
                     ,p_wallet_pw  in varchar2) return s4ag_calendar,
/*****************************************************************************/
  member function del(p_token     in varchar2
                     ,p_wallet    in varchar2
                     ,p_wallet_pw in varchar2) return varchar2
)
/
create or replace type body s4ag_calendar is

  /*****************************************************************************/
  constructor function s4ag_calendar return self as result is
  begin
    self.kind := 'calendar#calendar';
    return;
  end;

  /*****************************************************************************/
  constructor function s4ag_calendar(p_calendarid in varchar2
                                    ,p_token      in varchar2
                                    ,p_wallet     in varchar2
                                    ,p_wallet_pw  in varchar2) return self as result is
    t_response clob;
    t_item     json;
  begin
    t_response       := s4ag_generic_pkg.do_get(p_api_url         => s4a_google_api.g_settings.api_prefix || 'www.googleapis.com/calendar/v3/calendars/' || p_calendarid || '?access_token='
                                               ,p_token           => p_token
                                               ,p_wallet_location => p_wallet
                                               ,p_wallet_password => p_wallet_pw);
    t_item           := json(t_response);
    self.kind        := s4ag_generic_pkg.jgetstring(t_item, 'kind');
    self.etag        := s4ag_generic_pkg.jgetstring(t_item, 'etag');
    self.id          := s4ag_generic_pkg.jgetstring(t_item, 'id');
    self.summary     := s4ag_generic_pkg.jgetstring(t_item, 'summary');
    self.description := s4ag_generic_pkg.jgetstring(t_item, 'description');
    self.location    := s4ag_generic_pkg.jgetstring(t_item, 'location');
    self.timezone    := s4ag_generic_pkg.jgetstring(t_item, 'timeZone');
    return;
  end;

  /*****************************************************************************/
  member function get(p_calendarid in varchar2
                     ,p_token      in varchar2
                     ,p_wallet     in varchar2
                     ,p_wallet_pw  in varchar2) return s4ag_calendar is
  begin
    return new s4ag_calendar(p_calendarid => p_calendarid
                            ,p_token      => p_token
                            ,p_wallet     => p_wallet
                            ,p_wallet_pw  => p_wallet_pw);
  end get;

  /*****************************************************************************/
  member function del(p_token     in varchar2
                     ,p_wallet    in varchar2
                     ,p_wallet_pw in varchar2) return varchar2 is
    t_params wwv_flow_global.vc_map;
  begin
    return s4ag_generic_pkg.do_http_request(p_url       => s4a_google_api.g_settings.api_prefix || 'www.googleapis.com/calendar/v3/calendars/' || self.id
                                           ,p_method    => 'DELETE'
                                           ,p_token     => p_token
                                           ,p_hdr_vars  => t_params
                                           ,p_wallet    => p_wallet
                                           ,p_wallet_pw => p_wallet_pw);
  end;

end;
/
