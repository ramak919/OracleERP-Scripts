Select A.Batch_id
        , C.Batch_no
        , A.Batchstep_id
        , A.Batchstep_no
        , A.Oprn_id
        , A.Plan_step_qty
        , A.Actual_step_qty
        , Null
        , A.Plan_start_date
        , A.Actual_start_date
        , A.Due_date
        , A.Plan_cmplt_date
        , A.Actual_cmplt_date
        , A.Step_close_date
        , A.Step_status
        , A.Steprelease_type
        , A.Max_step_capacity
        , Null
        , A.Plan_charges
        , A.Actual_charges
        , A.Quality_status
        , A.Minimum_transfer_qty
        , A.Terminated_ind
        , B.Oprn_no
        , B.Oprn_vers
        , B.Oprn_desc
        , B.Oprn_no || '-' || B.Oprn_vers
   From   Gme_batch_steps A
        , Gmd_operations_vl B
        , Gme_batch_header C
   Where  A.Oprn_id = B.Oprn_id
   And    A.Batch_id = C.Batch_id;

SELECT   a.batch_no, a.batch_id, a.plant_code, a.routing_id,
                  a.wip_whse_code, c.recipe_id, a.formula_id, a.routing_id,
                  f.item_id, TO_NUMBER (NULL) batchstep_id,
                  TO_NUMBER (NULL) batchstep_no, TO_NUMBER (NULL) oprn_id,
                  c.recipe_no || ' / ' || c.recipe_version,
                  h.formula_no || ' / ' || formula_vers, i.item_no,
                  i.item_desc1, a.last_updated_by, i.item_um
             FROM gme_batch_header a,
                  gmd_recipe_validity_rules b,
                  gmd_recipes c,
                  gme_material_details f,
                  fm_form_mst h,
                  ic_item_mst i
            WHERE a.batch_id = x_batch_id
              AND a.batch_id = f.batch_id
              AND a.recipe_validity_rule_id = b.recipe_validity_rule_id
              AND b.recipe_id = c.recipe_id
              AND NVL (x_batch_step_id, 1) = 1
              AND f.item_id = i.item_id
              AND h.formula_id = a.formula_id
         UNION
         SELECT   a.batch_no, a.batch_id, a.plant_code, a.routing_id,
                  a.wip_whse_code, c.recipe_id, a.formula_id, a.routing_id,
                  f.item_id, d.batchstep_id, d.batchstep_no batchstep_no,
                  d.oprn_id, c.recipe_no || ' / ' || c.recipe_version,
                  h.formula_no || ' / ' || formula_vers, i.item_no,
                  i.item_desc1, a.last_updated_by, i.item_um
             FROM gme_batch_header a,
                  gmd_recipe_validity_rules b,
                  gmd_recipes c,
                  gme_batch_steps d,
                  gme_material_details f,
                  fm_form_mst h,
                  ic_item_mst i
            WHERE a.batch_id = x_batch_id
              AND a.batch_id = f.batch_id
              AND a.batch_id = d.batch_id
              AND a.recipe_validity_rule_id = b.recipe_validity_rule_id
              AND b.recipe_id = c.recipe_id
--              AND d.batchstep_id = NVL (x_batch_step_id, d.batchstep_id) Arvind Bug 4604305
              AND d.batchstep_id = x_batch_step_id -- Arvind Bug 4604305 For batch creation, do not select steps
              AND f.item_id = i.item_id
              AND h.formula_id = a.formula_id
              AND f.line_type IN (1, 2)
         ORDER BY batchstep_no DESC;
		 
		 /*query 2*/
		  SELECT btchhdr.plant_code
         ,orgnmst.co_code
         ,btchhdr.wip_whse_code
         ,btchhdr.batch_id
         ,btchhdr.batch_no
         ,btchhdr.plan_start_date
         ,btchhdr.actual_start_date
         ,btchhdr.plan_cmplt_date
         ,btchhdr.actual_cmplt_date
         ,btchhdr.batch_status
         ,btchdtl.item_id
         ,itemmst.item_no
         ,itemmst.item_desc1
         ,itemmst.planning_class
         ,btchsteps.batchstep_no
         ,oprndtl.resources
         ,rsrcmst.resource_desc
         ,rsrcmst.resource_class
         ,btchacts.activity
         ,oprndtl.prim_rsrc_ind
         ,oprndtl.scale_type
         ,oprndtl.plan_rsrc_count
         ,oprndtl.actual_rsrc_count
         ,NVL (oprndtl.plan_rsrc_qty, 0)
         ,NVL (oprndtl.actual_rsrc_qty, 0)
         ,NVL (oprndtl.plan_rsrc_usage, 0)
         ,NVL (oprndtl.actual_rsrc_usage, 0)
         ,oprndtl.usage_uom
         ,oprndtl.plan_start_date
         ,oprndtl.actual_start_date
         ,oprndtl.plan_cmplt_date
         ,oprndtl.actual_cmplt_date
         ,calendr.period_year
         ,calendr.period_num
         ,calendr.period_name
   FROM   gme_batch_header btchhdr
         ,gme_material_details btchdtl
         ,gme_batch_steps btchsteps
         ,gme_batch_step_activities btchacts
         ,ic_item_mst itemmst
         ,gme_batch_step_resources oprndtl
         ,sy_orgn_mst orgnmst
         ,cr_rsrc_mst rsrcmst
         ,pmi_gl_calendar_v calendr
   WHERE  btchhdr.batch_id = btchsteps.batch_id(+)
   AND    btchhdr.batch_id = btchdtl.batch_id
   AND    btchhdr.plant_code = orgnmst.orgn_code
   AND    btchdtl.item_id = itemmst.item_id
   AND    oprndtl.resources = rsrcmst.resources(+)
   AND    btchsteps.batch_id = btchacts.batch_id(+)
   AND    btchsteps.batchstep_id = btchacts.batchstep_id(+)
   AND    btchacts.batch_id = oprndtl.batch_id(+)
   AND    btchacts.batchstep_id = oprndtl.batchstep_id(+)
   AND    btchacts.batchstep_activity_id = oprndtl.batchstep_activity_id(+)
   AND    btchhdr.batch_status IN (3, 4)
   AND    btchdtl.line_type = 1
   AND    orgnmst.co_code = calendr.co_code
   AND    TRUNC (btchhdr.actual_cmplt_date) BETWEEN calendr.start_date AND calendr.end_date
   AND    (btchhdr.plant_code IN (SELECT secorg.orgn_code
                                  FROM   sy_orgn_mst secorg
                                  WHERE  pmi_security_pkg.show_record (secorg.orgn_code) = 'TRUE'))
          
		  
		  
		   SELECT  btchhdr.batch_id
         ,btchhdr.batch_no,grt.RESOURCE_USAGE,  btchhdr.plant_code
         ,orgnmst.co_code
         ,NVL (oprndtl.plan_rsrc_qty, 0)plan_rsrc_qty
         ,NVL (oprndtl.plan_rsrc_usage, 0) plan_rsrc_usage
             ,NVL (oprndtl.actual_rsrc_usage, 0)act_rsrc_usg
             ,NVL (oprndtl.actual_rsrc_qty, 0) act_rsrc_qty
         ,btchhdr.wip_whse_code         
--         ,btchhdr.plan_start_date
--         ,btchhdr.actual_start_date
--         ,btchhdr.plan_cmplt_date
--         ,btchhdr.actual_cmplt_date
--         ,btchhdr.batch_status
--         ,btchdtl.item_id
         ,itemmst.item_no
--         ,itemmst.item_desc1
--         ,itemmst.planning_class
         ,btchsteps.batchstep_no
         ,oprndtl.resources
         ,rsrcmst.resource_desc
         ,rsrcmst.resource_class
         ,btchacts.activity
         ,oprndtl.prim_rsrc_ind
         ,oprndtl.scale_type
         ,oprndtl.plan_rsrc_count
         ,oprndtl.actual_rsrc_count         
--         ,NVL (oprndtl.actual_rsrc_qty, 0)         
--         ,NVL (oprndtl.actual_rsrc_usage, 0)
         ,oprndtl.usage_uom
         ,oprndtl.plan_start_date
         ,oprndtl.actual_start_date
         ,oprndtl.plan_cmplt_date
         ,oprndtl.actual_cmplt_date
         ,calendr.period_year
         ,calendr.period_num
         ,calendr.period_name
   FROM   gme_batch_header btchhdr
         ,gme_material_details btchdtl
         ,gme_batch_steps btchsteps
         ,gme_batch_step_activities btchacts
         ,ic_item_mst itemmst
         ,gme_batch_step_resources oprndtl
         ,sy_orgn_mst orgnmst
         ,cr_rsrc_mst rsrcmst
         ,pmi_gl_calendar_v calendr
         ,gme_resource_txns grt 
   WHERE  1=1
   and grt.LINE_ID(+)=oprndtl.BATCHSTEP_RESOURCE_ID
   and oprndtl.PLAN_RSRC_QTY=oprndtl.ACTUAL_RSRC_QTY
   and btchhdr.BATCH_ID in(1060,749)
   and btchhdr.batch_id = btchsteps.batch_id(+)
   AND    btchhdr.batch_id = btchdtl.batch_id
   AND    btchhdr.plant_code = orgnmst.orgn_code
   AND    btchdtl.item_id = itemmst.item_id
   AND    oprndtl.resources = rsrcmst.resources(+)
   AND    btchsteps.batch_id = btchacts.batch_id(+)
   AND    btchsteps.batchstep_id = btchacts.batchstep_id(+)
   AND    btchacts.batch_id = oprndtl.batch_id(+)
   AND    btchacts.batchstep_id = oprndtl.batchstep_id(+)
   AND    btchacts.batchstep_activity_id = oprndtl.batchstep_activity_id(+)
   AND    btchhdr.batch_status IN (3, 4)
   AND    btchdtl.line_type = 1
   AND    orgnmst.co_code = calendr.co_code
   AND    TRUNC (btchhdr.actual_cmplt_date) BETWEEN calendr.start_date AND calendr.end_date
   AND    (btchhdr.plant_code IN (SELECT secorg.orgn_code
                                  FROM   sy_orgn_mst secorg
                                  WHERE  pmi_security_pkg.show_record (secorg.orgn_code) = 'TRUE'))
		 