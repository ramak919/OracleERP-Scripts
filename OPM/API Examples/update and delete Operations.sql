/*Delete operations */
DECLARE
   p_api_version                                NUMBER DEFAULT 1;
   p_init_msg_list                              BOOLEAN DEFAULT TRUE;
   p_commit                                     BOOLEAN DEFAULT FALSE;
   p_oprn_id                                    gmd_operations.oprn_id%TYPE;
   p_oprn_no                                    gmd_operations.oprn_no%TYPE;
   p_oprn_vers                                  gmd_operations.oprn_vers%TYPE;
   x_message_count                              NUMBER;
   x_message_list                               VARCHAR2;
   x_return_status                              VARCHAR2;

   CURSOR cur_oprn
   IS
      SELECT *
      FROM   gmd_operations gmo
      WHERE  1 = 1;
BEGIN
   FOR c_rs IN cur_oprn
   LOOP
      p_oprn_id                  := c_rs.oprn_id;
      gmd_operations_pub.delete_operation (p_api_version                 => p_api_version
                                          ,p_init_msg_list               => p_init_msg_list
                                          ,p_commit                      => p_commit
                                          ,p_oprn_id                     => p_oprn_id
                                          ,p_oprn_no                     => p_oprn_no
                                          ,p_oprn_vers                   => p_oprn_vers
                                          ,x_message_count               => x_message_count
                                          ,x_message_list                => x_message_list
                                          ,x_return_status               => x_return_status
                                          );

      IF x_return_status = fnd_api.g_ret_sts_success
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;

      NULL;
   END LOOP;
END;








/* Formatted on 2010/06/11 14:17 (Formatter Plus v4.8.8) */
BEGIN
   xxdi_gmd_load_batch_comp.gmd_opera_pre_proc_val_stg;
xxdi_gmd_load_batch_comp.gmd_create_operations;
END;
/

/* Formatted on 2010/06/10 16:08 (Formatter Plus v4.8.8) */
SELECT dos.process_flag
      ,dos.status_msg
      ,doas.process_flag
      ,doas.status_msg
      ,dors.process_flag
      ,dors.status_msg
      ,dos.oprn_no
      ,dors.*
      ,dos.oprn_no
      ,dos.oprn_vers
FROM   di_operations_stage dos
      ,di_operations_activities_stage doas
      ,di_operations_resources_stage dors
WHERE  1 = 1
and dos.PROCESS_FLAG=-1
--AND    dos.process_flag in(2,3,4) 
--AND    dos.process_flag != 0
AND    dos.oprn_no = 'PRESS WR ORION'
AND    dos.oprn_no = doas.oprn_no
AND    dos.oprn_vers = doas.oprn_vers
AND    dos.oprn_no = dors.oprn_no
AND    dos.oprn_vers = dors.oprn_vers;

Select  * from q$log ql  where 1=1
 --and ql.CONTEXT like upper('%%') 
   order by ql.ID desc ;   
   

Select distinct drs.COST_CMPNTCLS_CODE
from di_operations_resources_stage  drs
where 1=1
;
   /*updating staging operation tables */
/* Formatted on 2010/06/10 16:27 (Formatter Plus v4.8.8) */
DECLARE
   l_oprn_no                                    VARCHAR2 (200);
   l_oprn_vers                                  NUMBER;
   l_process_flag                               NUMBER := 0;

   PROCEDURE update_oprn (
      p_oprn_no                           VARCHAR2
     ,p_oprn_vers                         NUMBER
     ,P_process_flag number
   )
   AS
   BEGIN
      UPDATE di_operations_stage dos
         SET dos.process_flag = p_process_flag
       WHERE 1 = 1
      AND    dos.oprn_no = p_oprn_no
      AND    dos.oprn_vers = p_oprn_vers;

      UPDATE di_operations_activities_stage doas
         SET dos.process_flag = p_process_flag
       WHERE 1 = 1
      AND    dos.oprn_no = p_oprn_no
      AND    dos.oprn_vers = p_oprn_vers;

      UPDATE di_operations_resources_stage dors
         SET dos.process_flag = p_process_flag
       WHERE 1 = 1
      AND    dos.oprn_no = p_oprn_no
      AND    dos.oprn_vers = p_oprn_vers;

      COMMIT;
   END;
BEGIN
   update_oprn(


END;

/*insert only operation_resources */

DECLARE
   p_api_version                                NUMBER := 1;
   p_init_msg_list                              BOOLEAN := TRUE;
   p_commit                                     BOOLEAN := FALSE;
   p_oprn_line_id                               gmd_operation_activities.oprn_line_id%TYPE;
   p_oprn_rsrc_tbl                              gmd_operation_resources_pub.gmd_oprn_resources_tbl_type;
   x_message_count                              NUMBER (10);
   x_message_list                               VARCHAR2 (200);
   x_return_status                              VARCHAR2 (10);
   l_oprn_no                                    VARCHAR2 (200) := 'ULC CLEAN';   /*'ALLOCATE_RCC_CBN';*/
   l_oprn_vers                                  NUMBER := 0;
   l_row_count                                  NUMBER;
   l_context                                    VARCHAR2 (200) := 'Ram';

   CURSOR resource_cur (
      v_oprn_no                  IN       VARCHAR2
     ,c_oprn_vers                IN       NUMBER
   )
   IS
      SELECT oprn_line_id
            ,resources
            ,resource_usage
            ,resource_count
            ,usage_um
            ,process_qty
            ,process_uom
            ,prim_rsrc_ind
            ,scale_type
            ,cost_analysis_code
            ,cost_cmpntcls_id
            ,offset_interval
            ,delete_mark
            ,text_code
            ,min_capacity
            ,max_capacity
            ,capacity_uom
            ,attribute_category
            ,attribute1
            ,attribute2
            ,attribute3
            ,attribute4
            ,attribute5
            ,attribute6
            ,attribute7
            ,attribute8
            ,attribute9
            ,attribute10
            ,attribute11
            ,attribute12
            ,attribute13
            ,attribute14
            ,attribute15
            ,attribute16
            ,attribute17
            ,attribute18
            ,attribute19
            ,attribute20
            ,attribute21
            ,attribute22
            ,attribute23
            ,attribute24
            ,attribute25
            ,attribute26
            ,attribute27
            ,attribute28
            ,attribute29
            ,attribute30
            ,creation_date
            ,created_by
            ,last_update_date
            ,last_updated_by
            ,last_update_login
            ,process_parameter_1
            ,process_parameter_2
            ,process_parameter_3
            ,process_parameter_4
            ,process_parameter_5
            ,oprn_no
            ,activity
      FROM   diamond.di_operations_resources_stage dors
      WHERE  1 = 1
      AND    oprn_no = v_oprn_no
--         and dors.OPRN_VERS
--         AND    dors.process_flag = g_ready_to_load
   ;

   PROCEDURE trace_oracle_msg_list (
      p_context                           VARCHAR2
     ,p_message_count                     NUMBER
     ,p_return_status                     VARCHAR2
     ,p_line_seperator                    VARCHAR2
     ,x_msg                      OUT      VARCHAR2
   )
   AS
      l_msg                                        VARCHAR2 (200);
   BEGIN
      IF p_message_count > 0
      THEN
         FOR i IN 1 .. p_message_count
         LOOP
            l_msg                      := fnd_msg_pub.get (i, p_encoded                  => fnd_api.g_false);
            x_msg                      := x_msg || CHR (13) || l_msg;
            xxdi$errmgr.TRACE (p_context, l_msg);
         END LOOP;
      END IF;
   END;
BEGIN
   xxdi$errmgr.trace_on (l_context);
   xxdi$errmgr.TRACE (l_context, 'begin resources loading');
   xxdi_gmd_load_batch_comp.set_context ('OPM Product Development');

--need to set the context
   SELECT goa.oprn_line_id
   INTO   p_oprn_line_id
   FROM   gmd_operations_b gob
         ,gmd_operation_activities goa
   WHERE  1 = 1
   AND    gob.oprn_id = goa.oprn_id
   AND    gob.oprn_no = l_oprn_no
   AND    gob.oprn_vers = l_oprn_vers;

   xxdi$errmgr.TRACE (l_context, p_oprn_line_id);

   FOR c_oper_rscr IN resource_cur (l_oprn_no, l_oprn_vers)
   LOOP
      xxdi$errmgr.TRACE (l_context, 'resource' || c_oper_rscr.resources);
      l_row_count                := p_oprn_rsrc_tbl.COUNT + 1;
      p_oprn_rsrc_tbl (l_row_count).oprn_line_id := c_oper_rscr.oprn_line_id;
      p_oprn_rsrc_tbl (l_row_count).resources := c_oper_rscr.resources;
      p_oprn_rsrc_tbl (l_row_count).resource_usage := c_oper_rscr.resource_usage;
      p_oprn_rsrc_tbl (l_row_count).resource_count := c_oper_rscr.resource_count;
      p_oprn_rsrc_tbl (l_row_count).usage_um := c_oper_rscr.usage_um;
      p_oprn_rsrc_tbl (l_row_count).process_qty := c_oper_rscr.process_qty;
      p_oprn_rsrc_tbl (l_row_count).process_uom := c_oper_rscr.process_uom;
      p_oprn_rsrc_tbl (l_row_count).prim_rsrc_ind := c_oper_rscr.prim_rsrc_ind;
      p_oprn_rsrc_tbl (l_row_count).scale_type := c_oper_rscr.scale_type;
      p_oprn_rsrc_tbl (l_row_count).cost_analysis_code := c_oper_rscr.cost_analysis_code;
      p_oprn_rsrc_tbl (l_row_count).cost_cmpntcls_id := c_oper_rscr.cost_cmpntcls_id;
      p_oprn_rsrc_tbl (l_row_count).offset_interval := nvl(c_oper_rscr.offset_interval,0);
      p_oprn_rsrc_tbl (l_row_count).min_capacity := c_oper_rscr.min_capacity;
      p_oprn_rsrc_tbl (l_row_count).max_capacity := c_oper_rscr.max_capacity;
      p_oprn_rsrc_tbl (l_row_count).capacity_uom := c_oper_rscr.capacity_uom;
      p_oprn_rsrc_tbl (l_row_count).attribute_category := c_oper_rscr.attribute_category;
      p_oprn_rsrc_tbl (l_row_count).attribute1 := c_oper_rscr.attribute1;
      p_oprn_rsrc_tbl (l_row_count).attribute2 := c_oper_rscr.attribute2;
      p_oprn_rsrc_tbl (l_row_count).attribute3 := c_oper_rscr.attribute3;
      p_oprn_rsrc_tbl (l_row_count).attribute4 := c_oper_rscr.attribute4;
      p_oprn_rsrc_tbl (l_row_count).attribute5 := c_oper_rscr.attribute5;
      p_oprn_rsrc_tbl (l_row_count).attribute6 := c_oper_rscr.attribute6;
      p_oprn_rsrc_tbl (l_row_count).attribute7 := c_oper_rscr.attribute7;
      p_oprn_rsrc_tbl (l_row_count).attribute8 := c_oper_rscr.attribute8;
      p_oprn_rsrc_tbl (l_row_count).attribute9 := c_oper_rscr.attribute9;
      p_oprn_rsrc_tbl (l_row_count).attribute10 := c_oper_rscr.attribute10;
      p_oprn_rsrc_tbl (l_row_count).attribute11 := c_oper_rscr.attribute11;
      p_oprn_rsrc_tbl (l_row_count).attribute12 := c_oper_rscr.attribute12;
      p_oprn_rsrc_tbl (l_row_count).attribute13 := c_oper_rscr.attribute13;
      p_oprn_rsrc_tbl (l_row_count).attribute14 := c_oper_rscr.attribute14;
      p_oprn_rsrc_tbl (l_row_count).attribute15 := c_oper_rscr.attribute15;
      p_oprn_rsrc_tbl (l_row_count).attribute16 := c_oper_rscr.attribute16;
      p_oprn_rsrc_tbl (l_row_count).attribute17 := c_oper_rscr.attribute17;
      p_oprn_rsrc_tbl (l_row_count).attribute18 := c_oper_rscr.attribute18;
      p_oprn_rsrc_tbl (l_row_count).attribute19 := c_oper_rscr.attribute19;
      p_oprn_rsrc_tbl (l_row_count).attribute20 := c_oper_rscr.attribute20;
      p_oprn_rsrc_tbl (l_row_count).attribute21 := c_oper_rscr.attribute21;
      p_oprn_rsrc_tbl (l_row_count).attribute22 := c_oper_rscr.attribute22;
      p_oprn_rsrc_tbl (l_row_count).attribute23 := c_oper_rscr.attribute23;
      p_oprn_rsrc_tbl (l_row_count).attribute24 := c_oper_rscr.attribute24;
      p_oprn_rsrc_tbl (l_row_count).attribute25 := c_oper_rscr.attribute25;
      p_oprn_rsrc_tbl (l_row_count).attribute26 := c_oper_rscr.attribute26;
      p_oprn_rsrc_tbl (l_row_count).attribute27 := c_oper_rscr.attribute27;
      p_oprn_rsrc_tbl (l_row_count).attribute28 := c_oper_rscr.attribute28;
      p_oprn_rsrc_tbl (l_row_count).attribute29 := c_oper_rscr.attribute29;
      p_oprn_rsrc_tbl (l_row_count).attribute30 := c_oper_rscr.attribute30;
      p_oprn_rsrc_tbl (l_row_count).process_parameter_1 := c_oper_rscr.process_parameter_1;
      p_oprn_rsrc_tbl (l_row_count).process_parameter_2 := c_oper_rscr.process_parameter_2;
      p_oprn_rsrc_tbl (l_row_count).process_parameter_3 := c_oper_rscr.process_parameter_3;
      p_oprn_rsrc_tbl (l_row_count).process_parameter_4 := c_oper_rscr.process_parameter_4;
      p_oprn_rsrc_tbl (l_row_count).process_parameter_5 := c_oper_rscr.process_parameter_5;
      p_oprn_rsrc_tbl (l_row_count).activity := c_oper_rscr.activity;
   END LOOP;

   gmd_operation_resources_pub.insert_operation_resources (p_api_version                 => p_api_version
                                                          ,p_init_msg_list               => p_init_msg_list
                                                          ,p_commit                      => p_commit
                                                          ,p_oprn_line_id                => p_oprn_line_id
                                                          ,p_oprn_rsrc_tbl               => p_oprn_rsrc_tbl
                                                          ,x_message_count               => x_message_count
                                                          ,x_message_list                => x_message_list
                                                          ,x_return_status               => x_return_status
                                                          );
   xxdi$errmgr.TRACE (l_context, x_return_status || x_message_list);

   IF x_return_status = fnd_api.g_ret_sts_success
   THEN
      COMMIT;
   ELSE
      ROLLBACK;
      trace_oracle_msg_list (p_context                     => l_context
                            ,p_message_count               => x_message_count
                            ,p_return_status               => x_return_status
                            ,p_line_seperator              => CHR (13)
                            ,x_msg                         => x_message_list
                            );
   END IF;
END;

