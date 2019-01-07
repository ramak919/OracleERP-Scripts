/* Formatted on 2010/05/13 11:07 (Formatter Plus v4.8.8) */
DECLARE
   row_id                                       ROWID;
   l_resource_class                             VARCHAR2 (200);
   l_trans_cnt                                  NUMBER := 0;
   l_delete_mark                                NUMBER := 0;
   l_text_code                                  VARCHAR2 (200);
   l_resource_class_desc                        VARCHAR2 (200);
   l_created_by                                 NUMBER := 3399;
   l_last_updated_by                            NUMBER := 3399;
   l_last_update_login                          NUMBER := -1;

   CURSOR rsrc_class_list
   IS
      SELECT DISTINCT drs.resource_class
      FROM            di_resources_staging drs
      WHERE           1 = 1
      AND             drs.process_flag = 4
      AND             drs.status_msg LIKE '%lass%';
BEGIN
   FOR c_rsr_cl IN rsrc_class_list
   LOOP
      l_resource_class           := c_rsr_cl.resource_class;

      BEGIN
         cr_rsrc_cls_pkg.insert_row (x_rowid                       => row_id
                                    ,x_resource_class              => l_resource_class
                                    ,x_trans_cnt                   => l_trans_cnt
                                    ,x_delete_mark                 => l_delete_mark
                                    ,x_text_code                   => l_text_code
                                    ,x_resource_class_desc         => l_resource_class
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