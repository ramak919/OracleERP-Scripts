/* Formatted on 7/14/2015 12:14:51 PM (QP5 v5.149.1003.31008) */
SELECT   grt.doc_id Batch_id
        ,GBS.BATCHSTEP_NO
        ,gbs.step_status_meaning step_status
        ,grt.resources
        ,gbsr.actual_rsrc_usage
        ,gbsr.actual_rsrc_qty
        ,gbsr.usage_UM
        ,grt.resource_usage
        ,grt.trans_qty_UM
        ,--       grt.trans_UM,
         grt.trans_Date
        ,grt.completed_Ind
         ,GRT.POSTED_IND
         , grt.OVERRIDED_PROTECTED_IND protect
        ,grt.organization_id
        ,grt.line_id GME_BATCH_STEP_RESOURCE_id
        ,grt.reason_id
        ,grt.POC_TRANS_ID
        ,grt.doc_type
        ,gbs.OPERATION_NO
        ,gbs.oprn_id
FROM     apps.GME_RESOURCE_TXNS grt
        ,apps.MTL_TRANSACTION_REASONS MTR
        ,apps.GME_BATCH_STEP_RESOURCES gbsr
        ,apps.GME_BATCH_STEP_ACTIVITIES gbsa
        ,apps.gme_batch_steps_V gbs
WHERE    1 = 1
--AND      grt.creation_date > TRUNC (SYSDATE - 30)
   AND grt.doc_id = 228776
AND      grt.resources != 'CYCLE-TIME'
--   and gbs.oprn_id =10659
--and grt.completed_ind =0
/*Standard Joins */
AND      gbsr.batchstep_resource_id = grt.line_id
AND      gbsa.BATCHSTEP_ACTIVITY_ID = gbsr.BATCHSTEP_ACTIVITY_ID
AND      MTR.REASON_ID(+) = grt.REASON_ID
AND      gbs.BATCHSTEP_ID = gbsr.BATCHSTEP_ID
ORDER BY grt.doc_id
        ,GBS.BATCHSTEP_NO
        ,grt.resources
        ,grt.trans_date DESC;