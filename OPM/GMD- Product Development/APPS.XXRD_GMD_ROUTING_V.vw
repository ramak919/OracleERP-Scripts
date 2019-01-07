DROP VIEW APPS.XXRD_GMD_ROUTING_V;

/* Formatted on 2013/05/01 16:33 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Create Or Replace Force View apps.xxrd_gmd_routing_v 
As
   Select   gr.routing_no || ' (Vers ' || gr.routing_vers || ')' routing
           ,gmd_api_grp.get_status_desc (gr.routing_status) rout_status
           ,gr.routing_desc
           ,gr.routing_class
           , gr.effective_start_date || ' to ' || gr.effective_end_date routing_effective_date
           ,gr.routing_qty
           ,gr.item_um
           ,gr.process_loss planned_loss
           ,gr.fixed_process_loss theoritical_loss
           ,gr.fixed_process_loss_uom
           ,fnd_user_ap_pkg.get_user_name (gr.owner_id) routing_owner
           ,inv_detail_util_pvt.get_organization_code (gr.owner_organization_id) rout_own_org
           ,d.routingstep_no routing_step_no
		      , '--Operation-->' Operation
--        ,o.oprn_id
   ,        o.oprn_no || o.oprn_vers operation
           ,d.step_qty routing_step_qty
           ,d.minimum_transfer_qty
           ,apps.inv_meaning_sel.c_fnd_lookup_vl (d.steprelease_type, 'STEPRELEASE_TYPE') step_release_type
           , o.oprn_no || ' Vers(' || o.oprn_vers || ')' oprn
           ,o.oprn_desc
           ,gmd_api_grp.get_status_desc (o.operation_status) oprn_status
           , o.effective_start_date || ' to ' || o.effective_end_date oprn_effectivity
           ,o.minimum_transfer_qty oprn_min_transfer_qty
           ,o.process_qty_um
           ,a.activity
           ,a.activity_factor
		    ,a.OFFSET_INTERVAL activity_OFFSET_INTERVAL
--        ,a.SEQUENCE_DEPENDENT_IND,a.OFFSET_INTERVAL,a.BREAK_IND,a.MAX_BREAK ,a.MATERIAL_IND
   ,        res.resources
           ,m.resource_desc
           , res.process_qty || ' (' || res.resource_process_uom || ')  Per ' || res.resource_usage || ' (' || res.resource_usage_uom || ')' rsrc_throughput
--        ,res.process_qty
--        ,res.RESOURCE_PROCESS_UOM
--        ,res.resource_usage
--        ,res.resource_usage_uom
   ,        res.resource_count
           ,res.offset_interval
           ,DECODE (res.prim_rsrc_ind
                   ,1, 'Primary'
                   ,0, 'Secondary'
				   ,2,'Auxillary'
                   ,res.prim_rsrc_ind
                   ) plan_type
				         ,apps.inv_meaning_sel.c_fnd_lookup_vl (res.scale_type, 'SCALE_TYPE') || ' - '|| res.SCALE_TYPE scale_type
          -- ,res.scale_type
           ,res.cost_analysis_code
           ,gmf_migration.get_cost_cmpntcls_code (res.cost_cmpntcls_id) cost_cmpntcls
           ,m.min_capacity min_capacity
           ,m.max_capacity max_capacity
           ,m.capacity_um capacity_uom
           ,res.resource_process_uom process_uom
           -- , r.recipe_id || '$' || d.routingstep_id || '$' || res.oprn_line_id || '$' || res.resources
   ,        res.oprn_line_id oprnline_id
   From     apps.fm_rout_dtl d
           ,apps.gmd_routings_vl gr
           ,apps.gmd_operations_b o
           ,apps.gmd_operation_activities a
           ,apps.gmd_operation_resources res
           ,apps.cr_rsrc_mst_vl m
   Where    1 = 1
   And      gr.routing_id = d.routing_id
   And      d.oprn_id = o.oprn_id
   And      o.oprn_id = a.oprn_id
   And      a.oprn_line_id = res.oprn_line_id
   And      m.resources = res.resources
   Order By routing_step_no
           ,oprnline_id
           ,resources;


