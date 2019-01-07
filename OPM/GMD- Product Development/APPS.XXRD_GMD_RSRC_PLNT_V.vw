DROP VIEW APPS.XXRD_GMD_RSRC_PLNT_V;

/* Formatted on 2013/05/01 16:32 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Create Or Replace Force View apps.xxrd_gmd_rsrc_plnt_v (org_code
                                                       ,resources
                                                       ,resource_desc
                                                       ,group_resource
                                                       ,assigned_qty
                                                       ,nominal_cost
                                                       ,schedule_ind
                                                       ,usage_um
                                                       ,idle_time_tolerence
                                                       ,sds_window
                                                       ,calendar_code
                                                       ,min_capacity
                                                       ,max_capacity
                                                       ,ideal_capacity
                                                       ,capacity_uom
                                                       ,"Cal Charges"
                                                       ,capacity_tolerance
                                                       ,utilization
                                                       ,efficiency
                                                       ,planning_exception_set
                                                       ,batchable_flag
                                                       ,batch_window
                                                       ,delete_mark
                                                       )
As
   Select inv_detail_util_pvt.get_organization_code (crm.organization_id) org_code
         ,crm.resources
         ,cr.resource_desc
--      ,crm.
   ,      crm.group_resource
         ,crm.assigned_qty
         ,crm.nominal_cost
         ,DECODE (crm.schedule_ind
                 ,1, 'Schedule'
                 ,crm.schedule_ind
                 ) schedule_ind
--      ,crm.usage_uom
   ,      crm.usage_um
         ,crm.idle_time_tolerence
         ,crm.sds_window
         ,crm.calendar_code
         ,crm.min_capacity
         ,crm.max_capacity
         ,crm.ideal_capacity
--      ,crm.capacity_um
   ,      crm.capacity_uom
         ,crm.capacity_constraint "Cal Charges"
         ,crm.capacity_tolerance
         ,crm.utilization
         ,crm.efficiency
         ,crm.planning_exception_set
         ,crm.batchable_flag
         ,crm.batch_window
         ,crm.delete_mark
   From   cr_rsrc_dtl crm
         ,cr_rsrc_mst_vl cr
   Where  1 = 1
   And    crm.resources = cr.resources
--And    crm.resources = 'IL-1 OUT TEST';


