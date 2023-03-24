PL/SQL Developer Test script 3.0
9
-- Created on 08-03-19 by RMARTENS 
declare 
  -- Local variables here
  l_dept o_dept := new o_dept(10);
begin
  
  dbms_output.put_line(l_dept.to_json);
  
end;
0
0
