/* Formatted on 2010/05/14 14:51 (Formatter Plus v4.8.8) */
DECLARE
   row_id                                       ROWID;
   l_oprn_class                                 VARCHAR2 (200);
   l_trans_cnt                                  NUMBER := 0;
   l_delete_mark                                NUMBER := 0;
   l_text_code                                  VARCHAR2 (200);
   l_resource_class_desc                        VARCHAR2 (200);
   l_created_by                                 NUMBER := 3399;
   l_last_updated_by                            NUMBER := 3399;
   l_last_update_login                          NUMBER := -1;

   CURSOR oprn_class_list
   IS
      SELECT DISTINCT dos.oprn_class
      FROM            di_operations_stage dos
      WHERE           1 = 1
      AND             dos.status_msg LIKE '%Operation Class%';
BEGIN
   FOR c_oprn_cl IN oprn_class_list
   LOOP
      l_oprn_class               := c_oprn_cl.oprn_class;

      BEGIN
         gmd_operation_class_pkg.insert_row (x_rowid                       => row_id
                                            ,x_oprn_class                  => l_oprn_class
                                            ,x_trans_cnt                   => l_trans_cnt
                                            ,x_delete_mark                 => l_delete_mark
                                            ,x_text_code                   => l_text_code
                                            ,x_oprn_class_desc             => l_oprn_class
                                            ,x_creation_date               => SYSDATE
                                            ,x_created_by                  => l_created_by
                                            ,x_last_update_date            => SYSDATE
                                            ,x_last_updated_by             => l_last_updated_by
                                            ,x_last_update_login           => l_last_update_login
                                            );
         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK;
            NULL;
      END;
   END LOOP;
END;