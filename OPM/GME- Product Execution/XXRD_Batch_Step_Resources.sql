/*Step Activity Resources*/
SELECT
       GBSR.BATCH_ID
      ,GBSR.RESOURCES
      ,GBSR.RESOURCE_DESC
      ,GBSR.PLAN_RSRC_COUNT
      ,GBSR.PLAN_RSRC_QTY
      ,GBSR.RESOURCE_QTY_UM qty_UM
      ,GBSR.PLAN_RSRC_USAGE
      ,GBSR.USAGE_UM
      ,GBSR.PLAN_START_DATE
      ,GBSR.PLAN_CMPLT_DATE
      ,'Actuals->' actuals
      ,GBSR.ACTUAL_RSRC_COUNT
      ,GBSR.ACTUAL_RSRC_QTY
      ,GBSR.ACTUAL_RSRC_USAGE
      ,GBSR.ACTUAL_START_DATE
      ,GBSR.ACTUAL_CMPLT_DATE
      /*scheduling information*/
      ,'Scheduling ->' scheduling
      ,Inv_meaning_sel.C_fnd_lookup_vl (GBSR.SCALE_TYPE, 'GMD_RESOURCE_SCALE_TYPE') resource_scale_type
      ,Inv_meaning_sel.C_fnd_lookup_vl (GBSR.PRIM_RSRC_IND, 'GMD_PRIM_RSRC_IND') resource_type
      ,GBSR.OFFSET_INTERVAL
      ,GBSR.MIN_CAPACITY
      ,GBSR.MAX_CAPACITY
      ,GBSR.CAPACITY_UM      
      /*Costing Information*/
      ,GBSR.COST_ANALYSIS_CODE
--      ,CCM.COST_CMPNTCLS_CODE
      ,CCM.COST_CMPNTCLS_DESC
      ,GBSR.SEQUENCE_DEPENDENT_ID
      ,GBSR.SEQUENCE_DEPENDENT_USAGE
      ,GBSR.BATCHSTEP_ID
      ,GBSR.BATCHSTEP_ACTIVITY_ID
FROM
       apps.GME_BATCH_STEP_RESOURCES_V gbsr, apps.Cm_cmpt_mst_vl ccm
WHERE
       1 = 1
--AND    GBSR.BATCH_ID = 916528
AND    GBSR.COST_CMPNTCLS_ID = CCM.COST_CMPNTCLS_ID(+)
--ORDER BY
--       GBSR.BATCH_ID
;


/* Formatted on 3/27/2015 1:30:13 PM (QP5 v5.149.1003.31008) */
SELECT   gbh.organization_code org
       , gbh.batch_no
       , gbh.BATCH_STATUS_DESC
       ,gbh.ROUTING_NO  ,  gbh.ROUTING_VERS  
       , gbs.batchstep_NO
       , gop.oprn_No
       , gop.Oprn_vers
       , gop.OPRN_DESC
       , gbs.step_status_meaning
       , COUNT (*)
FROM     apps.GME_BATCH_STEP_RESOURCES_V gbsr
       , apps.GME_BATCH_STEPS_V gbs
       , apps.GME_BATCH_HEADER_VW gbh
       , apps.GMD_OPERATIONS_VL gop
	   , GME_BATCH_STEP_ACTIVITIES GBSA
WHERE        1 = 1
         --       and gbh.batch_status not in (4,-1)
         AND gbsr.resources != 'CYCLE-TIME'
		 AND GBSA.batchstep_id = gbs.batchstep_id
         AND GBSA.BATCHSTEP_ACTIVITY_ID = gbsr.BATCHSTEP_ACTIVITY_ID
         AND gop.oprn_id = gbs.oprn_id
         AND gbs.batch_id = gbsr.batch_id
         AND gbs.batchstep_id = gbsr.batchstep_id
         AND gbh.batch_id = gbsr.batch_id
GROUP BY gbh.organization_code
       , gbh.batch_no
       , gbh.BATCH_STATUS_DESC
       ,gbh.ROUTING_NO  ,  gbh.ROUTING_VERS
       , gbs.batchstep_NO
       , gop.oprn_No
       , gop.Oprn_vers
       , gop.OPRN_DESC
       , gbs.step_status_meaning
HAVING   COUNT (*) > 1;