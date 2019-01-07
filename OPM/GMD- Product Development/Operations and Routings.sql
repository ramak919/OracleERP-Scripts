/* Formatted on 2/27/2015 3:09:15 PM (QP5 v5.149.1003.31008) */
/*Operations */
--create or replace view xxrd_GMD_oprn_V as

SELECT   ood.organization_code own_org
       --INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE(  o.OWNER_ORGANIZATION_ID) own_org
       , o.OPRN_CLASS
       , o.oprn_no || ' Vers(' || o.oprn_vers || ')' OPRN
       , o.oprn_desc
       --        ,gmd_api_grp.get_status_desc ( o.OPERATION_STATUS) Oprn_status
       , o.EFFECTIVE_START_DATe || ' to ' || o.EFFECTIVE_END_DATE
            oprn_effectivity
       , o.MINIMUM_TRANSFER_QTY OPRN_MIN_Transfer_qty
       , o.PROCESS_QTY_UM
       , a.activity
       , a.ACTIVITY_FACTOR
       --        ,a.SEQUENCE_DEPENDENT_IND,a.OFFSET_INTERVAL,a.BREAK_IND,a.MAX_BREAK ,a.MATERIAL_IND
       , res.resources
       , m.RESOURCE_DESC
       ,    res.PROCESS_QTY
         || ' ('
         || res.RESOURCE_PROCESS_UOM
         || ')  Per '
         || res.RESOURCE_USAGE
         || ' ('
         || res.RESOURCE_USAGE_UOM
         || ')'
            rsrc_throughput
       --        ,res.process_qty
       --        ,res.RESOURCE_PROCESS_UOM
       --        ,res.resource_usage
       --        ,res.resource_usage_uom
       , res.resource_count
       , res.offset_interval
       , DECODE (res.prim_rsrc_ind
               , 1, 'Primary'
               , 0, 'Secondary'
               , 2, 'Auxillary'
               , res.PRIM_RSRC_IND)
            plan_type
       --, res.scale_type
	   , decode (res.scale_type,1,'Proportional',0,'Fixed') scale_type
       , res.cost_analysis_code
       --        , GMF_MIGRATION.GET_COST_CMPNTCLS_CODE (res.cost_cmpntcls_id) cost_cmpntcls
       , ccm.COST_CMPNTCLS_CODE
       , m.min_capacity min_capacity
       , m.max_capacity max_capacity
       , m.capacity_um capacity_uom
       , res.resource_process_uom process_uom
       --        , r.recipe_id || '$' || d.routingstep_id || '$' || res.oprn_line_id || '$' || res.resources
       , res.oprn_line_id oprnline_id
       , o.OPERATION_STATUS
FROM     apps.gmd_operations_vl o
       , apps.gmd_operation_activities a
       , apps.gmd_operation_resources res
       , apps.cr_rsrc_mst_vl m
       , apps.ORG_ORGANIZATION_DEFINITIONS ood
       , apps.cm_cmpt_mst ccm
WHERE        1 = 1
and o.OPRN_NO='BAK1200-0556-007'
         --And      d.oprn_id = o.oprn_id
         --and res.resources='CYCLE-TIME'
         --and (res.prim_rsrc_ind =1 or res.SCALE_TYPE!=0)
         --And      d.oprn_id = o.oprn_id
         AND ccm.cost_cmpntcls_id(+) = res.cost_cmpntcls_id
         AND ood.organization_id = o.OWNER_ORGANIZATION_ID
         AND o.oprn_id = a.oprn_id
         AND a.oprn_line_id = res.oprn_line_id
         AND m.resources = res.resources
ORDER BY oprnline_id, resources;

		/*Routing */
		
		/* Formatted on 2013/04/17 15:27 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
--        create or replace view xxrd_GMD_routing_V as
Select   gr.routing_no || ' (Vers ' || gr.routing_vers || ')' routing
,gmd_api_grp.get_status_desc ( gr.ROUTING_STATUS) rout_status
        ,gr.routing_desc
        ,gr.routing_class
        ,gr.effective_start_date || ' to '||gr.effective_end_date Routing_effective_date
        ,gr.routing_qty
        ,gr.item_um
        ,gr.process_loss planned_loss
        ,gr.fixed_process_loss theoritical_loss
        ,gr.fixed_process_loss_uom        
         ,fnd_user_ap_pkg.get_user_name (gr.OWNER_ID )Routing_owner
        ,INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE(  gr.owner_organization_id) Rout_own_org
        ,d.routingstep_no routing_step_no
--        ,o.oprn_id
        , o.oprn_no || o.oprn_vers Operation        
        ,d.STEP_QTY routing_step_qty
        ,d.MINIMUM_TRANSFER_QTY
        ,        apps.inv_meaning_sel.c_fnd_lookup_vl (d.STEPRELEASE_TYPE, 'STEPRELEASE_TYPE') Step_release_type
          , o.oprn_no ||' Vers(' ||o.oprn_vers ||')' OPRN
        ,o.oprn_desc
        ,gmd_api_grp.get_status_desc ( o.OPERATION_STATUS) Oprn_status
        , o.EFFECTIVE_START_DATe ||' to '||o.EFFECTIVE_END_DATE oprn_effectivity
        , o.MINIMUM_TRANSFER_QTY OPRN_MIN_Transfer_qty, o.PROCESS_QTY_UM
        ,a.activity
        ,a.ACTIVITY_FACTOR
--        ,a.SEQUENCE_DEPENDENT_IND,a.OFFSET_INTERVAL,a.BREAK_IND,a.MAX_BREAK ,a.MATERIAL_IND
        ,res.resources
        , m.RESOURCE_DESC
        , res.PROCESS_QTY|| ' ('|| res.RESOURCE_PROCESS_UOM ||')  Per '|| res.RESOURCE_USAGE||' ('|| res.RESOURCE_USAGE_UOM ||')' rsrc_throughput
--        ,res.process_qty        
--        ,res.RESOURCE_PROCESS_UOM        
--        ,res.resource_usage        
--        ,res.resource_usage_uom 
        ,res.resource_count                
        ,res.offset_interval
        ,Decode (res.prim_rsrc_ind,1,'Primary',0,'Secondary', res.PRIM_RSRC_IND) plan_type
        ,res.scale_type
        ,res.cost_analysis_code           
        , GMF_MIGRATION.GET_COST_CMPNTCLS_CODE (res.cost_cmpntcls_id) cost_cmpntcls     
        ,m.min_capacity min_capacity
        ,m.max_capacity max_capacity        
        ,m.capacity_um capacity_uom
        ,res.resource_process_uom process_uom
       -- , r.recipe_id || '$' || d.routingstep_id || '$' || res.oprn_line_id || '$' || res.resources
                ,res.oprn_line_id oprnline_id
From     fm_rout_dtl d
        ,gmd_routings_vl gr
        ,gmd_operations_b o
        ,gmd_operation_activities a
        ,gmd_operation_resources res
        ,cr_rsrc_mst_vl m
Where    1 = 1
And      gr.routing_id = d.routing_id
And      d.oprn_id = o.oprn_id
And      o.oprn_id = a.oprn_id
And      a.oprn_line_id = res.oprn_line_id
And      m.resources = res.resources
Order By routing_step_no
        ,oprnline_id
        ,resources;
 
 /*Recipe*/       
/* Formatted on 2013/04/17 15:27 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Select  INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE(  r.OWNER_ORGANIZATION_ID) own_org
,INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE(r.CREATION_ORGANIZATION_ID) Create_org
,  r.recipe_no || ' (Vers ' || r.recipe_version || ')' recipe
,gmd_api_grp.get_status_desc (r.RECIPE_STATUS) recipe_status
--           ,d.routingstep_id
,        gr.routing_no || ' (Vers ' || gr.routing_vers || ')' routing
,gmd_api_grp.get_status_desc ( gr.ROUTING_STATUS) rout_status
        ,gr.routing_desc
        ,gr.routing_class
        ,gr.effective_start_date || ' to '||gr.effective_end_date Routing_effective_date
        ,gr.routing_qty
        ,gr.item_um
        ,gr.process_loss planned_loss
        ,gr.fixed_process_loss theoritical_loss
        ,gr.fixed_process_loss_uom        
         ,fnd_user_ap_pkg.get_user_name (gr.OWNER_ID )Routing_owner
        ,gr.owner_organization_id Routing_owner_org
        ,d.routingstep_no routing_step_no
--        ,o.oprn_id
        , o.oprn_no || o.oprn_vers Operation        
        ,d.STEP_QTY routing_step_qty
        ,d.MINIMUM_TRANSFER_QTY
        ,        apps.inv_meaning_sel.c_fnd_lookup_vl (d.STEPRELEASE_TYPE, 'STEPRELEASE_TYPE') Step_release_type
          , o.oprn_no ||' Vers(' ||o.oprn_vers ||')' OPRN
        ,o.oprn_desc
        ,gmd_api_grp.get_status_desc ( o.OPERATION_STATUS) Oprn_status
        , o.EFFECTIVE_START_DATe ||' to '||o.EFFECTIVE_END_DATE oprn_effectivity
        , o.MINIMUM_TRANSFER_QTY OPRN_MIN_Transfer_qty, o.PROCESS_QTY_UM
        ,a.activity
        ,a.ACTIVITY_FACTOR
--        ,a.SEQUENCE_DEPENDENT_IND,a.OFFSET_INTERVAL,a.BREAK_IND,a.MAX_BREAK ,a.MATERIAL_IND
        ,res.resources
        , m.RESOURCE_DESC
        , res.PROCESS_QTY|| ' ('|| res.RESOURCE_PROCESS_UOM ||')  Per '|| res.RESOURCE_USAGE||' ('|| res.RESOURCE_USAGE_UOM ||')' rsrc_throughput
--        ,res.process_qty        
--        ,res.RESOURCE_PROCESS_UOM        
--        ,res.resource_usage        
--        ,res.resource_usage_uom 
        ,res.resource_count                
        ,res.offset_interval
        ,Decode (res.prim_rsrc_ind,1,'Primary',0,'Secondary', res.PRIM_RSRC_IND) plan_type
        ,res.scale_type
        ,res.cost_analysis_code           
        , GMF_MIGRATION.GET_COST_CMPNTCLS_CODE (res.cost_cmpntcls_id) cost_cmpntcls     
        ,m.min_capacity min_capacity
        ,m.max_capacity max_capacity        
        ,m.capacity_um capacity_uom
        ,res.resource_process_uom process_uom
        , r.recipe_id || '$' || d.routingstep_id || '$' || res.oprn_line_id || '$' || res.resources
                ,res.oprn_line_id oprnline_id
From     gmd_recipes_b r
        ,fm_rout_dtl d
        ,gmd_routings_vl gr
        ,gmd_operations_b o
        ,gmd_operation_activities a
        ,gmd_operation_resources res
        ,cr_rsrc_mst_vl m
Where    1 = 1
And      r.recipe_no Like '80859 MR1301 PA5%'
And      r.routing_id = gr.routing_id
And      gr.routing_id = d.routing_id
And      d.routing_id = r.routing_id
And      d.oprn_id = o.oprn_id
And      o.oprn_id = a.oprn_id
And      a.oprn_line_id = res.oprn_line_id
And      m.resources = res.resources
Order By routing_step_no
        ,oprnline_id
        ,resources;
        
        
GMD_MBR_OPRN_ACTIVITIY_V1

--GMD_MBR_STEP_OPRN_V1

--GMD_OPERATION_RESOURCES_DFV

Select  * 
from gmd_mbr_recipe_rsrc_v1 t1
where  1=1
;

--fm_oprn_dtl_vw1




inv_meaning_sel.c_fnd_lookup_vl (f.release_type, 'GMD_MATERIAL_RELEASE_TYPE')

select  t1.LOOKUP_CODE, t1.LOOKUP_TYPE ,t1.MEANING,t1.DESCRIPTION
        from fnd_lookup_values_vl t1
        where 1=1
--        and t1.LOOKUP_CODE ='1'
--        and t1.LOOKUP_COD
        and t1.VIEW_APPLICATION_ID=552
--        and t1.MEANING like '%D%Pla%'
--        and t1.MEANING like '%S%'
--        and lookup_code like '%1%'
        and lookup_type  LIKE '%RELEASE%';



                
                
                


552

fnd_application_vl

 CR_RSRC_DTL_vw1
 CR_RSRC_DTL_VW2
 
 CR_RSRC_CLS_VL
 
 GMD_ROUTINGS_VL
 
 
--GMD_MBR_OPRN_ACTIVITIY_V1

--GMD_MBR_STEP_OPRN_V1

--GMD_OPERATION_RESOURCES_DFV

Select  * 
from gmd_mbr_recipe_rsrc_v1 t1
where  1=1
;

--fm_oprn_dtl_vw1


/* Formatted on 2013/04/17 15:21 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
