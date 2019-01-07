/*Batch Steps */
SELECT GBH.BATCH_NO
      ,GBS.BATCHSTEP_NO step_no
      ,GBS.OPERATION_NO || ' Ver (' || GBS.OPERATION_VERS || ' )' Operation
      ,gop.OPRN_DESC
      --      ,GBS.STEP_STATUS
      ,GBS.STEP_STATUS_MEANING step_status
      /*Dates*/
      ,GBS.PLAN_START_DATE
      ,GBS.PLAN_CMPLT_DATE
      ,GBS.DUE_DATE
      ,GBS.ACTUAL_START_DATE
      ,GBS.ACTUAL_CMPLT_DATE
      ,GBS.STEP_CLOSE_DATE
      /*End of Dates*/
      /*Step Quantities*/
      ,GBS.PLAN_STEP_QTY
      ,GBS.ACTUAL_STEP_QTY
      ,GBS.STEP_QTY_UM
      --      ,GBS.PLAN_VOLUME_QTY
      --      ,GBS.ACTUAL_VOLUME_QTY
      --      ,GBS.ACTUAL_MASS_QTY
      /*Charges*/
      ,GBS.MAX_STEP_CAPACITY
      ,GBS.MAX_STEP_CAPACITY_UM
      ,GBS.PLAN_CHARGES
      ,GBS.ACTUAL_CHARGES
      /*Others*/
      --      ,Inv_meaning_sel.C_fnd_lookup_vl (gBS.STEPRELEASE_TYPE, 'STEPRELEASE_TYPE') step_release_type
      --      ,Inv_meaning_sel.C_fnd_lookup_vl (GBS.QUALITY_STATUS, 'GMD_QC_BATCH_STEP_STATUS') Quality_status
      ,GBS.TERMINATED_IND
      ,GBS.DELETE_MARK
      ,GBH.BATCH_ID
      ,GBS.BATCHSTEP_ID
FROM   apps.GME_BATCH_STEPS_V gbs, apps.gme_batch_header gbh, apps.gmd_operations_vl gop
WHERE  1 = 1
--and gbs.batch_id=71069
--AND    GBH.BATCH_NO = '1156700042'
--AND    GBH.BATCH_STATUS = 3
/*Standard Joins*/
AND    GBH.BATCH_ID = Gbs.BATCH_ID
AND    Gbs.oprn_id = gop.oprn_id
ORDER BY
       GBH.BATCH_NO DESC, GBS.BATCHSTEP_NO ASC;
	   
	   
	   /* Formatted on 7/27/2015 2:03:54 PM (QP5 v5.149.1003.31008) */
SELECT   GBH.BATCH_NO
        ,GBS.BATCHSTEP_NO step_no
        ,gop.OPRN_NO || ' Ver (' || gop.OPRN_VERS || ' )' Operation
        ,gop.OPRN_DESC
        ,gbsd.alv_OPM_RVT_item
        ,gbsd.alv_OPM_RVT_PCTG
        --      ,GBS.STEP_STATUS
        --      ,GBS.STEP_STATUS_MEANING step_status
        /*Dates*/
        ,GBS.PLAN_START_DATE
        ,GBS.PLAN_CMPLT_DATE
        ,GBS.DUE_DATE
        ,GBS.ACTUAL_START_DATE
        ,GBS.ACTUAL_CMPLT_DATE
        ,GBS.STEP_CLOSE_DATE
        /*End of Dates*/
        /*Step Quantities*/
        ,GBS.PLAN_STEP_QTY
        ,GBS.ACTUAL_STEP_QTY
        ,GBS.STEP_QTY_UM
        --      ,GBS.PLAN_VOLUME_QTY
        --      ,GBS.ACTUAL_VOLUME_QTY
        --      ,GBS.ACTUAL_MASS_QTY
        /*Charges*/
        ,GBS.MAX_STEP_CAPACITY
        ,GBS.MAX_STEP_CAPACITY_UM
        ,GBS.PLAN_CHARGES
        ,GBS.ACTUAL_CHARGES
        /*Others*/
        --      ,Inv_meaning_sel.C_fnd_lookup_vl (gBS.STEPRELEASE_TYPE, 'STEPRELEASE_TYPE') step_release_type
        --      ,Inv_meaning_sel.C_fnd_lookup_vl (GBS.QUALITY_STATUS, 'GMD_QC_BATCH_STEP_STATUS') Quality_status
        ,GBS.TERMINATED_IND
        ,GBS.DELETE_MARK
        ,GBH.BATCH_ID
        ,GBS.BATCHSTEP_ID
        ,gbsd.*
FROM     apps.GME_BATCH_STEPS gbs
        ,apps.gme_batch_header gbh
        ,apps.gmd_operations_vl gop
        ,apps.gme_batch_steps_DFV gbsd
WHERE    1 = 1
AND      gbs.ROWID = gbsd.ROWID
AND      gbs.batch_id = 71069
--AND    GBH.BATCH_NO = '1156700042'
--AND    GBH.BATCH_STATUS = 3
/*Standard Joins*/
AND      GBH.BATCH_ID = Gbs.BATCH_ID
AND      Gbs.oprn_id = gop.oprn_id
ORDER BY GBH.BATCH_NO DESC, GBS.BATCHSTEP_NO ASC;