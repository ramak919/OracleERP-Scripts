/* Formatted on 2014/12/26 02:29 (Formatter Plus v4.8.8) rama.koganti*/
/*How To List E-Business Suite Profile Option Values For All Levels Using SQLPlus [ID 201945.1]*/

Select   Fpo.Profile_option_name Short_name
       , Fpo.User_profile_option_name Name
       , Decode (Fpv.Level_id
               , 10001, 'Site'
               , 10002, 'Application'
               , 10003, 'Responsibility'
               , 10004, 'User'
               , 10005, 'Server'
               , 10006, 'Org'
               , 10007, Decode (To_char (Fpv.Level_value2)
                              , '-1', 'Responsibility'
                              , Decode (To_char (Fpv.Level_value)
                                      , '-1', 'Server'
                                      , 'Server+Resp'
                                       )
                               )
               , 'UnDef'
                ) Level_set
       , Decode (To_char (Fpv.Level_id)
               , '10001', ''
               , '10002', App.Application_short_name
               , '10003', Rsp.Responsibility_key
               , '10004', Usr.User_name
               , '10005', Svr.Node_name
               , '10006', Org.Name
               , '10007', Decode (To_char (Fpv.Level_value2)
                                , '-1', Rsp.Responsibility_key
                                , Decode (To_char (Fpv.Level_value)
                                        , '-1', (Select Node_name
                                                 From   Fnd_nodes
                                                 Where  Node_id = Fpv.Level_value2)
                                        ,    (Select Node_name
                                              From   Fnd_nodes
                                              Where  Node_id = Fpv.Level_value2)
                                          || '-'
                                          || Rsp.Responsibility_key
                                         )
                                 )
               , 'UnDef'
                ) "CONTEXT"
       , Fpv.Profile_option_value Profile_value
       , Xxrd_get_profile_val (Fpo.Sql_validation
                             , Fpv.Profile_option_value
                             , Fpo.Profile_option_name
                              ) Valu
--       , Fpo.Application_id
,        App2.Application_short_name
       , App2.Application_name
--       ,app2.PRODUCT_CODE
,        Fpo.Description
       , Fpo.User_changeable_flag
       , Fpo.User_visible_flag
--       ,fpo.USER_UPDATE_ALLOWED_FLAG
--       ,fpo.*
From     Fnd_profile_options_vl Fpo
       , Fnd_profile_option_values Fpv
       , Fnd_user Usr
       , Fnd_application App
       , Fnd_responsibility Rsp
       , Fnd_nodes Svr
       , Hr_operating_units Org
       , Fnd_application_vl App2
Where    1 = 1
--and app2.APPLICATION_SHORT_NAME  in ('GME')
--And      App2.Application_short_name Like 'GM%'
--And      Fpo.Profile_option_name = 'GME_BATCH_PREFIX'
And      App2.Application_short_name In ('GMD', 'GME', 'GML', 'GMI', 'GMO', 'GMF', 'GMP', 'GMA')
And      (   Fpo.User_changeable_flag = 'Y'
          Or Fpo.User_visible_flag = 'Y')
And      (   Fpo.End_date_active Is Null
          Or Fpo.End_date_active > Sysdate)
/*Standard*/
And      Fpo.Profile_option_id = Fpv.Profile_option_id(+)
And      Usr.User_id(+) = Fpv.Level_value
And      Rsp.Application_id(+) = Fpv.Level_value_application_id
And      Rsp.Responsibility_id(+) = Fpv.Level_value
And      App.Application_id(+) = Fpv.Level_value
And      Svr.Node_id(+) = Fpv.Level_value
And      Org.Organization_id(+) = Fpv.Level_value
And      Fpo.Application_id = App2.Application_id
Order By App2.Application_short_name
       , Short_name
       , User_profile_option_name
       , Level_id
       , Level_set;
       
       
       
       
       
       CREATE OR REPLACE FUNCTION xxrd_GET_PROFILE_VAL (p_qry IN VARCHAR2, p_val IN VARCHAR2, p_name VARCHAR2)
   RETURN VARCHAR2
IS
   lv_qry   VARCHAR2 (4000) := p_qry;
   lv1      VARCHAR2 (2000);
   sql1     VARCHAR2 (4000);
   sql2     VARCHAR2 (4000);
   lv2      VARCHAR2 (2000);
   lv3      VARCHAR2 (2000);
   lp1      VARCHAR2 (100) := 'INT';
BEGIN
   IF (p_name LIKE 'HR%MENU'
       OR p_name = 'IBU_HOME_QMENU_NAME')
   THEN
      SELECT
             user_menu_name
      INTO
             lv2
      FROM
             fnd_menus_vl fmv
      WHERE
             fmv.menu_name = p_val;
   ELSIF (p_name = 'PER_SECURITY_PROFILE_ID')
   THEN
      SELECT
             S.SECURITY_PROFILE_NAME
      INTO
             lv2
      FROM
             PER_SECURITY_PROFILES S, PER_BUSINESS_GROUPS O
      WHERE
             O.BUSINESS_GROUP_ID(+) = S.BUSINESS_GROUP_ID
      AND    s.security_profile_id = p_val;
   ELSIF (p_name = 'OM_UI_REFRESH_METHOD')
   THEN
      SELECT
             MEANING
      INTO
             lv2
      FROM
             OE_LOOKUPS
      WHERE
             LOOKUP_TYPE = 'UI_REFRESH_METHOD'
      AND    lookup_code = p_val;
   ELSE
      -- DBMS_OUTPUT.put_line(replace(substr(lv_qry,instr(lv_qry,'SQL=',1,1)+1,instr(lv_qry,'INTO',1,1)-1)||substr(lv_qry,instr(lv_qry,'FROM',1,1)-1),'"',null)||' AND '||substr(lv_qry,instr(lv_qry,',',1,1)+1,(instr(lv_qry,'INTO',1,1) -instr(lv_qry,',',1,1))-1)||' = ');
      lv1 :=
         SUBSTR (lv_qry
                ,1
                ,  INSTR (lv_qry
                         ,'\'
                         ,1
                         ,1)
         - 1) || SUBSTR (lv_qry
                        ,  INSTR (lv_qry
                                 ,'\'
                                 ,1
                                 ,2)
         + 1);
      lv1 := REPLACE (UPPER (lv1), 'COLUMN = ', 'COLUMN=');
      lv1 :=
         SUBSTR (lv1
                ,1
                ,CASE
                    WHEN INSTR (UPPER (lv1)
                               ,'COLUMN='
                               ,1
                               ,1) = 0
                    THEN
                       LENGTH (lv1)
                    ELSE
                         INSTR (UPPER (lv1)
                               ,'COLUMN='
                               ,1
                               ,1)
                       - 1
                 END);
      lv1 := REPLACE (REPLACE (lv1, 'SQL=', NULL), 'SQL = ', NULL);
      lv1 := REPLACE (lv1, '"', NULL);
      lv1 :=
         SUBSTR (lv1
                ,1
                ,  INSTR (UPPER (lv1)
                         ,'INTO'
                         ,1
                         ,1)
         - 1) || SUBSTR (lv1
                        ,INSTR (UPPER (lv1)
                               ,'FROM'
                               ,1
                               ,1));

      SELECT
             SUBSTR (lv1
                    ,1
                    ,DECODE (INSTR (UPPER (lv1)
                                   ,'ORDER BY'
                                   ,1
                                   ,1)
                            ,0, LENGTH (lv1)
                            , (  INSTR (UPPER (lv1)
                                       ,'ORDER BY'
                                       ,1
                                       ,1)
                               - 1)))
      INTO
             lv1
      FROM
             DUAL;

      sql1 :=
         lv1 || CASE
            WHEN INSTR (UPPER (lv1)
                       ,'WHERE'
                       ,1
                       ,1) = 0
         THEN
            ' WHERE '
            ELSE
            ' AND '
         END || SUBSTR (lv1
                       ,  INSTR (lv1
                                ,','
                                ,1
                                ,1)
         + 1
                       ,  (  INSTR (UPPER (lv1)
                                   ,'FROM'
                                   ,1
                                   ,1)
         - INSTR           (lv1
                           ,','
                           ,1
                           ,1))
         - 1) || ' = ''' || p_val || '''';

      BEGIN
         EXECUTE IMMEDIATE sql1
            INTO
            lv2, lv3;
      EXCEPTION
         WHEN OTHERS
         THEN
            lv2 := NULL;
      END;

      IF (lv2 IS NULL)
      THEN
         sql2 :=
            lv1 || CASE
               WHEN INSTR (UPPER (lv1)
                          ,'WHERE'
                          ,1
                          ,1) = 0
            THEN
               ' WHERE '
               ELSE
               ' AND '
            END || SUBSTR (lv1
                          ,  INSTR (UPPER (lv1)
                                   ,'SELECT'
                                   ,1
                                   ,1)
            + 6
                          , (  INSTR (lv1
                                     ,','
                                     ,1
                                     ,1)
            - INSTR          (UPPER (lv1)
                             ,'SELECT'
                             ,1
                             ,1)
            - 6)) || ' = ''' || p_val || '''';

         EXECUTE IMMEDIATE sql2
            INTO
            lv3, lv2;
      END IF;
   END IF;

   RETURN lv2;
EXCEPTION
   WHEN OTHERS
   THEN
      -- return (Sql1);
      RETURN NULL;
END