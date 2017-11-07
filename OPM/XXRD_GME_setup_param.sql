/* Formatted on 12/11/2014 3:48:37 PM (QP5 v5.256.13226.35510) */
SELECT
       OOD.ORGANIZATION_CODE org
      /*Batch Setup*/
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.DISPLAY_UNCONSUMED_MATERIAL, 'GME_YES_NO') Display_unused_Mater
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.DELETE_MATERIAL_IND, 'GME_ALLOW_MATERIAL_DELETION') Allow_material_deletion
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.VALIDATE_PLAN_DATES_IND, 'GME_VALIDATE_PLAN_DATES') Validate_Plan_dates
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.IB_FACTOR_IND, 'GME_IB_FACTOR') Incremental_backflush_factor
      ,GP.RULE_BASED_RESV_HORIZON
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.INGR_SUB_DATE, 'GME_INGR_SUB_DATE') ingr_sub_date
      /*End of Batch Setup */
      /*Create Batch*/
      ,'Create Batch-->'
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.CHECK_SHORTAGES_IND, 'GME_YES_NO') CHECK_SHORTAGES
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.COPY_FORMULA_TEXT_IND, 'GME_YES_NO') COPY_FORMULA_txt
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.COPY_ROUTING_TEXT_IND, 'GME_YES_NO') COPY_ROUTING_txt
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.CREATE_HIGH_LEVEL_RESV_IND, 'GME_YES_NO') CREATE_HIGH_LEVEL_RESV
      ,GP.RULE_BASED_RESV_HORIZON Reservation_time_fence                                                                                         /*days*/
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.CREATE_MOVE_ORDERS_IND, 'GME_YES_NO') CREATE_MOVE_ORDERS_IND
      ,GP.MOVE_ORDER_TIMEFENCE
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.FIXED_PROCESS_LOSS_IND, 'GME_APPLY_FIXED_PROCESS_LOSS') Apply_fixed_process_Loss
      /*End of Create Batc */
      /*Batch steps*/
      ,'Batch Steps-->'
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.STEP_CONTROLS_BATCH_STS_IND, 'GME_YES_NO') STEP_CONTROLS_BATCH_STS
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.BACKFLUSH_RSRC_USG_IND, 'GME_YES_NO') BACKFLUSH_RSRC_USG
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.DEF_ACTUAL_RSRC_USG_IND, 'GME_YES_NO') DEFault_ACTUAL_RSRC_USG
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.CALC_INTERIM_RSRC_USG_IND, 'GME_YES_NO') CALC_INTERIM_RSRC_USG
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.ALLOW_QTY_BELOW_MIN_IND, 'GME_YES_NO') ALLOW_QTY_BELOW_MIN_capacity
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.DISPLAY_NON_WORK_DAYS_IND, 'GME_YES_NO') DISPLAY_NON_WORK_DAYS
      /*End ofBatch Setps */
      /*Doc Numbering*/
      ,'Doc Numbering-->'
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.BATCH_DOC_NUMBERING, 'GME_DOCUMENT_ASSIGNMENT_TYPE') batch_numbering
      ,GP.BATCH_NO_LAST_ASSIGNED
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.FPO_DOC_NUMBERING, 'GME_DOCUMENT_ASSIGNMENT_TYPE') FPO_numbering
      ,GP.FPO_NO_LAST_ASSIGNED
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.GROUP_DOC_NUMBERING, 'GME_DOCUMENT_ASSIGNMENT_TYPE') Group_numbering
      ,GP.GROUP_LAST_ASSIGNED
      /*End of Document Numbering */
      /*Inventory Transactions*/
      ,'Inv Trx-->'
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.AUTO_CONSUME_SUPPLY_SUB_ONLY, 'GME_YES_NO') AUTO_CONSUME_SUPPLY_SUB_ONLY
      ,Inv_meaning_sel.C_fnd_lookup_vl (GP.SUBINV_LOC_IND, 'GME_YES_NO') Show_Onhand_sub_lcat_only
      ,GP.SUPPLY_SUBINVENTORY
      ,Inv_kanban_pkg.Getlocatorname (gp.Organization_id, GP.SUPPLY_LOCATOR_ID) Supply_locator
      --      ,GP.YIELD_LOCATOR_ID
      ,GP.YIELD_SUBINVENTORY
      ,Inv_kanban_pkg.Getlocatorname (gp.Organization_id, GP.YIELD_LOCATOR_ID) Yield_Locator
      /*End of Inventory Transactons */
      ,gp.Last_update_date
      ,Fnd_user_ap_pkg.Get_user_name (gp.Last_updated_by) Last_updated_by
      ,gp.Creation_date
      ,Fnd_user_ap_pkg.Get_user_name (gp.Created_by) Created_by
--      ,GP.SUPPLY_LOCATOR_ID
--      ,GP.YIELD_LOCATOR_ID
      ,GP.ORGANIZATION_ID
FROM
       gme_parameters gp, apps.ORG_ORGANIZATION_DEFINITIONS ood
WHERE
       1 = 1
and (OOD.DISABLE_DATE is null or OOD.DISABLE_DATE>sysdate)
AND    GP.ORGANIZATION_ID = OOD.ORGANIZATION_ID
ORDER BY
       1;
       