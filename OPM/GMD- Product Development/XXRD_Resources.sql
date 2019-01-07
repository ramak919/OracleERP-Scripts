/* Formatted on 1/23/2015 11:04:54 AM (QP5 v5.256.13226.35510) */
--%Resources%
--create or replace view xxrd_GMD_rsrc_mst_V as

SELECT
       crm.resources
      ,crm.resource_desc
      ,crm.std_usage_uom || ' (' || crm.std_usage_um || ')' Usage_UOM
      ,CRM.RESOURCE_CLASS
      --      ,crm.resource_class ||' '|| CRC.RESOURCE_CLASS_DESC resource_class
      --      ,crm.cost_cmpntcls_id
           ,ccm.COST_CMPNTCLS_CODE 
--       GMF_MIGRATION.GET_COST_CMPNTCLS_CODE (crm.cost_cmpntcls_id)cost_cmpntcls
      /*Capacity*/
      ,crm.min_capacity
      ,crm.max_capacity
      ,crm.capacity_um
      ,crm.capacity_uom
      ,crm.CAPACITY_CONSTRAINT "Cal Charges" /*Yes or No Flag*/
      ,crm.capacity_tolerance
      ,crm.utilization
      ,crm.efficiency
      ,crm.DELETE_MARK
      ,CRM.CREATED_BY
      ,CRM.CREATION_DATE
      ,CRM.LAST_UPDATE_DATE
      ,CRM.LAST_UPDATED_BY
FROM
       apps.cr_rsrc_mst_vl crm, apps.CR_RSRC_CLS crc
	   ,  apps.cm_cmpt_mst ccm
WHERE
       1 = 1
/*Standard Joins*/
and ccm.cost_cmpntcls_id (+) =crm.cost_cmpntcls_id
AND    CRM.RESOURCE_CLASS = CRC.RESOURCE_CLASS(+)
/*and not exists ( 
select 1 from   apps.cr_rsrc_dtl crd
where 1=1
and crm.resources=crd.resources)*/
;


/* Formatted on 1/23/2015 11:06:09 AM (QP5 v5.256.13226.35510) */
/*Plant Resources*/
--create or replace view xxrd_GMD_rsrc_plnt_V as

SELECT
 ood.organization_code org_code 
       --INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE (crm.ORGANIZATION_ID) org_code
      ,crm.resources
      ,cr.RESOURCE_DESC
      --      ,crm.
      ,crm.group_resource
--      ,crm
      ,crm.assigned_qty rsrc_count
      ,crm.nominal_cost planning_cost
      ,DECODE (crm.schedule_ind, 1, 'Schedule', crm.SCHEDULE_IND) Schedule_Ind
      --      ,crm.usage_uom
      ,crm.USAGE_UM
      ,crm.idle_time_tolerence
      ,crm.sds_window
      ,crm.calendar_code
      ,crm.min_capacity
      ,crm.max_capacity
      ,crm.ideal_capacity
      --      ,crm.capacity_um
      ,crm.capacity_uom
      ,crm.capacity_constraint "Cal Charges"
      ,crm.capacity_tolerance
      ,crm.utilization
      ,crm.efficiency
      ,crm.planning_exception_set
      ,crm.batchable_flag
      ,crm.batch_window Pull_forward_window
      ,crm.DELETE_MARK
      ,CRM.INACTIVE_IND
      ,CRM.CREATED_BY
      ,CRM.CREATION_DATE
      ,CRM.LAST_UPDATE_DATE
      ,CRM.LAST_UPDATED_BY
      ,CRM.ORGANIZATION_ID
FROM
       apps.cr_rsrc_dtl crm, apps.cr_rsrc_mst_vl cr
	   ,  apps.ORG_ORGANIZATION_DEFINITIONS ood 
WHERE
       1 = 1
--       and CRM.RESOURCES='IL-1 OUT TEST'
       /*Standard Joins*/
	   and ood.organization_id=crm.organization_id
AND    crm.RESOURCES = cr.RESOURCES
--And    crm.resources = 'IL-1 OUT TEST'
 order by 1 ,2
;