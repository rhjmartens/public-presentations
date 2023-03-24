prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.05.24'
,p_release=>'18.2.0.00.12'
,p_default_workspace_id=>1590845117325089
,p_default_application_id=>114
,p_default_owner=>'PRESENTATIONS'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/nl_smart4solutions_rowclick
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(68541149913511001220)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'NL.SMART4SOLUTIONS.ROWCLICK'
,p_display_name=>'SMART4Solutions Rowclick'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render_rowclick',
'   ( p_dynamic_action in apex_plugin.t_dynamic_action',
'   , p_plugin         in apex_plugin.t_plugin',
'   ) return apex_plugin.t_dynamic_action_render_result ',
'is',
'  l_render_result apex_plugin.t_dynamic_action_render_result;',
'  l_init_js       varchar2(32767);',
'  l_ir_class      apex_appl_plugins.attribute_01%type := p_plugin.attribute_01;',
'  l_cr_class      apex_appl_plugins.attribute_02%type := p_plugin.attribute_02;',
'  l_event         apex_appl_plugins.attribute_03%type := p_plugin.attribute_03;',
'begin',
'',
'  l_init_js := ''function set_rowclick() {',
'    $(''''div[data-rowclick]'''')',
'    .unbind(''''apexafterrefresh'''')',
'    .on(''''apexafterrefresh'''', function(){ set_rowclick(); })',
'    .each( function() {',
'        // what is the regions ID?',
'        var id = $(this).attr(''''id'''');',
'        // are we IR or classic ?',
'        var cls = ($(this).has(''''table.'' || l_ir_class || '''''').length > 0) ? '''''' || l_ir_class || '''''' : '''''' || l_cr_class || '''''';',
'        // the data-rowclick attribute holds the column which has the "link"',
'        var column = $(this).attr(''''data-rowclick'''');',
'        // start composing the selector for the TD''''s',
'        var selector = ''''table.'''' + cls + '''' tbody td:not([headers="'''' + column + ''''"])'''';',
'        // exclude the columns in the "rowclick-exclude" attribute',
'        var excl = $(this).attr(''''data-rowclick-exclude'''');',
'        var evt  = $(this).attr(''''data-rowclick-event'''');',
'            evt  = (evt=='''''''' || evt==undefined) ? '''''' || l_event || '''''' : evt;',
'        var exclar = (excl===undefined) ? '''''''': excl.split('''','''');',
'        var arrayLength = exclar.length;',
'        for (var ii = 0; ii < arrayLength; ii++) {',
'            selector = selector + '''':not([headers="'''' + exclar[ii].trim() + ''''"])'''';',
'        }',
'        // end compising the selctor for the TD''''s',
'        void(''''showselector'''');',
'        // add CSS, unbind any previous click bindings and rebind to the click event.',
'        //console.log(evt);',
'        $(this).find(selector)',
'        .css(''''cursor'''', ''''pointer'''')',
'        .unbind(evt)',
'        .on(evt, function(e){',
'            e.preventDefault();',
'            var a = $(this).parent(''''tr'''').find(''''td[headers="'''' + column + ''''"] a'''');',
'            var h = $(a).attr(''''href'''');',
'            switch (1==1) {',
'                case (h===undefined):',
'                    alert(''''undefined'''');',
'                    break;',
'                case (h.startsWith(''''javascript'''')):',
'                    eval(h);',
'                    break;',
'                default:',
'                    document.location = h;',
'            }',
'        });',
'    });',
'}'';',
'  ',
'  if apex_application.g_debug then',
'    apex_javascript.add_inline_code(p_code => ''console.log("l_ir_class = '''''' || l_ir_class || ''''''");'');',
'    apex_javascript.add_inline_code(p_code => ''console.log("l_cr_class = '''''' || l_cr_class || ''''''");'');',
'    l_init_js := replace(l_init_js, ''void(''''showselector'''');'', ''console.log("selector = ''''" + selector + "''''");'');',
'  end if;',
'',
'  apex_javascript.add_inline_code(p_code => l_init_js, p_key => null);',
'  ',
'  ',
'  l_render_result.javascript_function   := ''set_rowclick("'' || l_ir_class || ''", "'' || l_cr_class || ''")'';',
'  ',
'  return(l_render_result);',
'  ',
'end render_rowclick;'))
,p_api_version=>1
,p_render_function=>'render_rowclick'
,p_standard_attributes=>'ONLOAD'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The rowclick plugin should be utilized as an on-load dynamic action on any page on which you want a rowclick behavior,',
'of course you can utilise the plugin on the global page (0).',
'',
'The plugin requires two settings which are depending on the theme you are using in your application:',
'- the class with which the table within an interactive report can be recognized (in the universal theme this is "a-IRR-table")',
'- the class with which the table within a classic report can be recognized (in the universal theme this is "t_Report-report")',
'',
'The plugin also requires a setting that defines the event on which it should react, by default this is "click", but you can also choose',
'to use "right-click" or "double-click", this is called the "default-event". it can be overruled on each individual report on which you ',
'use the rowclick plugin.',
'',
'Once you have created the dynamic action you now need to tell APEX where to add the behavior.',
'This is done by adding a attributes to the region:',
'- data-rowclick="LINK" tells apex that rowclick should be added and the link is to be found in the "LINK" column',
'- data-rowclick-exclude="URI" tells APEX to exclude the "URI" column (this is a comma separated list of columns that should not have rowclick behavior).',
'- data-rowclick-event="click" tells the plugin to overrule the default setting (at application-level) and use the "click" event instead.',
'  You can use all jquery event-names, but the "click", "dblclick" and "contextmenu" events (the latter to be used as right-click) seem to be ',
'  the most logical choices.',
'',
'For Interactive Reports the column references can be set at the column-level of your region by providing a static ID .',
'For Classic Reports the column reference is the column name in your query.'))
,p_version_identifier=>'1.2'
,p_about_url=>'http://apex.oracle.com/pls/apex/f?p=64237:30'
,p_files_version=>4
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(40644887970131652762)
,p_plugin_id=>wwv_flow_api.id(68541149913511001220)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Interactive report table class'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'a-IRR-table'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>provide the class with which the table within an interactive report is provided.</p>',
'<p>In the universal theme this is "a-IRR-table"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(40644889163792656147)
,p_plugin_id=>wwv_flow_api.id(68541149913511001220)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'classic report table class'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'t-Report-report'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>provide the class with which the table within an classic report is provided.</p>',
'<p>In the universal theme this is "t-Report-report"</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3665637244098329158)
,p_plugin_id=>wwv_flow_api.id(68541149913511001220)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'default-event'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'click'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3665638935250330189)
,p_plugin_attribute_id=>wwv_flow_api.id(3665637244098329158)
,p_display_sequence=>10
,p_display_value=>'left-click'
,p_return_value=>'click'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3665639289419331063)
,p_plugin_attribute_id=>wwv_flow_api.id(3665637244098329158)
,p_display_sequence=>20
,p_display_value=>'right-click'
,p_return_value=>'contextmenu'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3665640133360332115)
,p_plugin_attribute_id=>wwv_flow_api.id(3665637244098329158)
,p_display_sequence=>30
,p_display_value=>'double-click'
,p_return_value=>'dblclick'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E207365745F726F77636C69636B28705F69725F636C6173732C20705F63725F636C61737329207B0A202020202428276469765B726F77636C69636B5D27290A202020202E756E62696E64282761706578616674657272656672657368';
wwv_flow_api.g_varchar2_table(2) := '27290A202020202E6F6E282761706578616674657272656672657368272C2066756E6374696F6E28297B207365745F726F77636C69636B28293B207D290A202020202E65616368282066756E6374696F6E2829207B0A20202020202020202F2F20617265';
wwv_flow_api.g_varchar2_table(3) := '207765204952206F7220636C6173736963203F0A202020202020202076617220636C73203D2028242874686973292E68617328277461626C652E27202B20705F69725F636C617373292E6C656E677468203E203029203F20705F69725F636C617373203A';
wwv_flow_api.g_varchar2_table(4) := '20705F63725F636C6173733B0A20202020202020202F2F2074686520726F77636C69636B2061747472696275746520686F6C64732074686520636F6C756D6E207768696368206861732074686520226C696E6B220A202020202020202076617220636F6C';
wwv_flow_api.g_varchar2_table(5) := '756D6E203D20242874686973292E617474722827726F77636C69636B27293B0A20202020202020202F2F20737461727420636F6D706F73696E67207468652073656C6563746F7220666F722074686520544427730A20202020202020207661722073656C';
wwv_flow_api.g_varchar2_table(6) := '6563746F72203D20277461626C652E27202B20636C73202B20272074626F64792074643A6E6F74285B686561646572733D2227202B20636F6C756D6E202B2027225D29273B0A20202020202020202F2F206578636C7564652074686520636F6C756D6E73';
wwv_flow_api.g_varchar2_table(7) := '20696E207468652022726F77636C69636B2D6578636C75646522206174747269627574650A2020202020202020766172206578636C203D20242874686973292E617474722827726F77636C69636B2D6578636C75646527293B0A20202020202020207661';
wwv_flow_api.g_varchar2_table(8) := '72206578636C6172203D20286578636C3D3D3D756E646566696E656429203F2027273A206578636C2E73706C697428272C27293B0A20202020202020207661722061727261794C656E677468203D206578636C61722E6C656E6774683B0A202020202020';
wwv_flow_api.g_varchar2_table(9) := '2020666F722028766172206969203D20303B206969203C2061727261794C656E6774683B2069692B2B29207B0A20202020202020202020202073656C6563746F72203D2073656C6563746F72202B20273A6E6F74285B686561646572733D2227202B2065';
wwv_flow_api.g_varchar2_table(10) := '78636C61725B69695D2E7472696D2829202B2027225D29273B0A20202020202020207D0A20202020202020202F2F20656E6420636F6D706973696E67207468652073656C63746F7220666F722074686520544427730A20202020202020202F2F20616464';
wwv_flow_api.g_varchar2_table(11) := '204353532C20756E62696E6420616E792070726576696F757320636C69636B2062696E64696E677320616E6420726562696E6420746F2074686520636C69636B206576656E742E0A2020202020202020242874686973292E66696E642873656C6563746F';
wwv_flow_api.g_varchar2_table(12) := '72290A20202020202020202E6373732827637572736F72272C2027706F696E74657227290A20202020202020202E756E62696E642827636C69636B27290A20202020202020202E6F6E2827636C69636B272C2066756E6374696F6E28297B0A2020202020';
wwv_flow_api.g_varchar2_table(13) := '202020202020207661722061203D20242874686973292E706172656E742827747227292E66696E64282774645B686561646572733D2227202B20636F6C756D6E202B2027225D206127293B0A2020202020202020202020207661722068203D2024286129';
wwv_flow_api.g_varchar2_table(14) := '2E6174747228276872656627293B0A2020202020202020202020207377697463682028313D3D3129207B0A20202020202020202020202020202020636173652028683D3D3D756E646566696E6564293A0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '20616C6572742827756E646566696E656427293B0A2020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020636173652028682E7374617274735769746828276A6176617363726970742729293A0A20';
wwv_flow_api.g_varchar2_table(16) := '202020202020202020202020202020202020206576616C2868293B0A2020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202064656661756C743A0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(17) := '646F63756D656E742E6C6F636174696F6E203D20683B0A2020202020202020202020207D0A20202020202020207D293B0A202020207D293B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(40644887276212600754)
,p_plugin_id=>wwv_flow_api.id(68541149913511001220)
,p_file_name=>'s4s-rowclick.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
