
  select jt.*
  from   json_table(q'~{ "name": "Geeta",
                         "skills": [{
                           "skill": "testing",
                           "proficiency": 30
                         }, {
                           "skill": "java",
                           "proficiency": 85
                         }, {
                           "skill": "c",
                           "proficiency": 90
                         }]
                       }~'
                   ,'$' columns(
                          "name" varchar2(30) path '$.name'
                          ,nested             path '$.skills[*]' 
                             columns("skill_name"  varchar2(20) path '$.skill'
                                    ,"proficiency" number       path '$.proficiency')
                                )
                   ) jt








