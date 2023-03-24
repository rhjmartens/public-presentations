select c.table_name
      ,c.column_name
      ,c.data_type
      ,c.column_id
      ,c.data_type_owner
      ,c.qualified_col_name
from user_tab_cols c
where c.table_name = 'EMPLOYEES'
  order by c.column_id, c.column_name;
