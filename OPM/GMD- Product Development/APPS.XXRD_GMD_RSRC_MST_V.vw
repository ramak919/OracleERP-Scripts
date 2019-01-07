DROP VIEW APPS.XXRD_GMD_RSRC_MST_V;

/* Formatted on 2013/05/01 16:32 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Create Or Replace Force View apps.xxrd_gmd_rsrc_mst_v (resources
                                                      ,resource_desc
                                                      ,usage_uom
                                                      ,resource_class
                                                      ,cost_cmpntcls
                                                      ,min_capacity
                                                      ,max_capacity
                                                      ,capacity_um
                                                      ,capacity_uom
                                                      ,"Cal Charges"
                                                      ,capacity_tolerance
                                                      ,utilization
                                                      ,efficiency
                                                      ,delete_mark
                                                      )
As
   Select crm.resources
         ,crm.resource_desc
         , crm.std_usage_uom || ' (' || crm.std_usage_um || ')' usage_uom
         ,crm.resource_class
--      ,crm.cost_cmpntcls_id
   ,      gmf_migration.get_cost_cmpntcls_code (crm.cost_cmpntcls_id) cost_cmpntcls
         ,crm.min_capacity
         ,crm.max_capacity
         ,crm.capacity_um
         ,crm.capacity_uom
         ,crm.capacity_constraint "Cal Charges"
         ,crm.capacity_tolerance
         ,crm.utilization
         ,crm.efficiency
         ,crm.delete_mark
   From   cr_rsrc_mst_vl crm
   Where  1 = 1;


