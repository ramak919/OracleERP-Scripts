DROP VIEW APPS.XXRD_GMD_OPRN_V;

/* Formatted on 2013/05/01 16:32 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Create Or Replace Force View apps.xxrd_gmd_oprn_v (own_org
                                                  ,oprn
                                                  ,oprn_desc
                                                  ,oprn_status
                                                  ,oprn_effectivity
                                                  ,oprn_min_transfer_qty
                                                  ,process_qty_um
                                                  ,activity
                                                  ,activity_factor
                                                  ,resources
                                                  ,resource_desc
                                                  ,rsrc_throughput
                                                  ,resource_count
                                                  ,offset_interval
                                                  ,plan_type
                                                  ,scale_type
                                                  ,cost_analysis_code
                                                  ,cost_cmpntcls
                                                  ,min_capacity
                                                  ,max_capacity
                                                  ,capacity_uom
                                                  ,process_uom
                                                  ,oprnline_id
                                                  )
As
   Select   inv_detail_util_pvt.get_organization_code (o.owner_organization_id) own_org
           , o.oprn_no || ' Vers(' || o.oprn_vers || ')' oprn
           ,o.oprn_desc
           ,gmd_api_grp.get_status_desc (o.operation_status) oprn_status
           , o.effective_start_date || ' to ' || o.effective_end_date oprn_effectivity
           ,o.minimum_transfer_qty oprn_min_transfer_qty
           ,o.process_qty_um
           ,a.activity
           ,a.activity_factor
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
				   , decode( res. scale_type  ,1,'Proportional',0,'Fixed') scale_type
           --,res.scale_type
           ,res.cost_analysis_code
           ,gmf_migration.get_cost_cmpntcls_code (res.cost_cmpntcls_id) cost_cmpntcls
           ,m.min_capacity min_capacity
           ,m.max_capacity max_capacity
           ,m.capacity_um capacity_uom
           ,res.resource_process_uom process_uom
--        , r.recipe_id || '$' || d.routingstep_id || '$' || res.oprn_line_id || '$' || res.resources
   ,        res.oprn_line_id oprnline_id
   From     apps.gmd_operations_b o
           , apps.gmd_operation_activities a
           , apps.gmd_operation_resources res
           , apps.cr_rsrc_mst_vl m
   Where    1 = 1
--And      d.oprn_id = o.oprn_id
   And      o.oprn_id = a.oprn_id
   And      a.oprn_line_id = res.oprn_line_id
   And      m.resources = res.resources
   Order By oprnline_id
           ,resources;


