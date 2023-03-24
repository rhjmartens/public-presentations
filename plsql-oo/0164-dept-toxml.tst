PL/SQL Developer Test script 3.0
46
-- Created on 08-03-19 by RMARTENS 
declare
  -- Local variables here
  l_dept o_dept;
  l_xml  xmltype;
  l_xml_clob clob;

  procedure beautify(xmlout in out nocopy clob) is
    xml xmltype := new xmltype(xmlout);
    xsl xmltype := new xmltype('<?xml version="1.0" encoding="iso-8859-1"?><O_DEPT></O_DEPT>');
    tmp xmltype;
  begin
    tmp    := xml.transform(xsl, null);
    xmlout := xml.getclobval();
  
    if tmp is null
    then
      null;
    end if;
  end;

begin

  l_dept := new o_dept(20);

  select sys_xmlgen(l_dept
                   ,xmlformat(encltag => 'O_DEPT'))
  into   l_xml
  from   dual;

  dbms_output.put_line(l_xml.getstringval);

  dbms_output.put_line(null);
  dbms_output.put_line('=======================================================================================');
  dbms_output.put_line('= Above is generated using SQL function "sys_xmlgen" below by PLSQL function "xmltype"=');
  dbms_output.put_line('=======================================================================================');
  dbms_output.put_line(null);

  l_dept := new o_dept(30);

  l_xml_clob := xmltype(l_dept).getClobVal();
  beautify(l_xml_clob);

  dbms_output.put_line(l_xml_clob);

end;
0
0
