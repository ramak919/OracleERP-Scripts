/*know views 
GME_BATCH_HEADER_VW
*/
/* Formatted on 12/8/2014 9:42:07 AM (QP5 v5.256.13226.35510) */
SELECT
       Mp.Organization_code Org
      ,GBH.Batch_no
      /*
      ,DECODE (GBH.BATCH_TYPE
              ,0, Inv_meaning_sel.C_fnd_lookup_vl (GBH.Batch_status, 'GME_BATCH_STATUS')
              ,10, Inv_meaning_sel.C_fnd_lookup_vl (GBH.Batch_status, 'GME_FPO_STATUS')) || ' - ' || GBH.Batch_status
          Batch_status
		  DECODE (gbh.batch_status,1,'Pending','2','WIP',3,'Completed',4,'Closed', gbh.batch_status) Status
*/
      , (SELECT flv.meaning
                 FROM   apps.fnd_lookup_values_vl flv
                 WHERE      1 = 1
                        AND flv.lookup_code = GBH.Batch_status
                        AND (flv.lookup_type = 'GME_BATCH_STATUS'
                             AND gbh.batch_type = 0)
                        OR (flv.lookup_type = 'GME_FPO_STATUS'
                            AND gbh.batch_type = 10))Batch_status_txt
--       , Gmf_cbom_rep_pkg.Get_item_name (rvr.INVENTORY_ITEM_ID) Product
      ,Rec.Recipe_no
      ,Rec.Recipe_version
      --      , Rec.Recipe_description
      ,GBH.Plan_start_date
      ,GBH.Actual_start_date
      ,GBH.Plan_cmplt_date
      ,GBH.Actual_cmplt_date
      ,GBH.Due_date
      ,GBH.Batch_close_date
      --     , GBH.Fmcontrol_class
      ,GBH.Terminated_ind
--      ,Wms_rules_workbench_pvt.Get_reason_name (GBH.Terminate_reason_id) Terminate_reason
      ,GBH.Laboratory_ind
      ,GBH.Update_inventory_ind
      ,GBH.Automatic_step_calculation
      ,GBH.Enforce_step_dependency
      ,GBH.Firmed_ind
      ,GBH.Finite_scheduled_ind
      --         'GME_LABORATORY_IND'
      ,F.Formula_no
      ,F.Formula_vers
      ,F.Formula_desc1
      ,R.Routing_no
      ,R.Routing_vers
      ,R.Routing_desc
      ,GBH.Order_priority
      , (SELECT
                Fpo.Batch_no
         FROM
                Gme_batch_header Fpo
         WHERE
                1 = 1
         AND    Fpo.Organization_id = GBH.Organization_id
         AND    Fpo.Batch_id = GBH.Fpo_id
         AND    Fpo.Batch_type = 10)
          Fpo_no
      ,GBH.Parentline_id                                                                                                       /*Phantom Parent Line Id*/
      --      , GBH.Priority_value
      --     , GBH.Priority_code
      --,      GBH.Prod_id
      --     , GBH.Prod_sequence
      ,GBH.Poc_ind
      ,GBH.Actual_cost_ind
      ,GBH.Gl_posted_ind
      ,GBH.Fixed_process_loss_applied
      --     , Fnd_date.Date_to_displaydt (GBH.Plan_start_date) Plan_start_date_dt
      --     , Fnd_date.Date_to_displaydt (GBH.Actual_start_date) Actual_start_date_dt
      --     , Fnd_date.Date_to_displaydt (GBH.Actual_cmplt_date) Actual_cmplt_date_dt
      --     , GBH.Batch_close_date
      --     , Fnd_date.Date_to_displaydt (GBH.Batch_close_date) Batch_close_date_dt
      --     , GBH.Plan_cmplt_date
      --     , Fnd_date.Date_to_displaydt (GBH.Plan_cmplt_date) Plan_cmplt_date_dt
      --          , Fnd_date.Date_to_displaydt (GBH.Due_date) Due_date_dt
      /*additonal Information*/
      /*End of additonal Information*/
      ,GBH.Migrated_batch_ind
      --        , Mtr.Reason_name Terminate_reason
      --        , Flv2.Meaning Laboratory
      ,GBH.Enhanced_pi_ind
      ,GBH.Print_count
      --     ,GBH.LAST_UPDATE_LOGIN
      ,gbh.Last_update_date
      , (select/* fu.user_name*/ FU.DESCRIPTION from fnd_user fu 
       where fu.user_id = GBH.LAST_UPDATED_BY   )LAST_UPDATED_BY
  --,Fnd_user_ap_pkg.Get_user_name (gbh.Last_updated_by) || '-' || GBH.LAST_UPDATED_BY Last_updated_by
      ,gbh.Creation_date
       , (select  FU.DESCRIPTION/* fu.user_name */  from fnd_user fu 
       where fu.user_id = GBH.CREATED_BY   )created_by
--      ,Fnd_user_ap_pkg.Get_user_name (gbh.Created_by) || '-' || GBH.CREATED_BY Created_by
      ,GBH.Delete_mark
      ,GBH.Move_order_header_id
      ,GBH.Organization_id
      ,GBH.Batch_id
      ,GBH.Fpo_id
      ,GBH.Parentline_id Phantom_parent_line_id
      ,GBH.Recipe_validity_rule_id
      ,GBH.Formula_id
      ,GBH.Routing_id
      ,RVR.INVENTORY_ITEM_ID
      ,gbh.batch_status
        ,DECODE (GBH.Batch_type,  10, 'FPO',  0, 'Batch',  GBH.Batch_type) || ' -' || GBH.Batch_type Batch_type
    FROM
       apps.Gme_batch_header gbh
      ,apps.Fm_form_mst F
      ,apps.Fm_rout_hdr R
      ,apps.Gmd_recipes Rec
      ,apps.Gmd_recipe_validity_rules rvr
      ,apps.Mtl_parameters Mp
--      , mtl_system_items_kfv msi 
--      ,gme_batch_header gbhp
--        , Mtl_transaction_reasons Mtr
WHERE
       1 = 1
--AND    GBH.CREATED_BY = 16691
--AND    GBH.ORDER_PRIORITY IS NOT NULL
AND    GBH.BATCH_TYPE = 0
--       and rvr.INVENTORY_ITEM_ID=314259
--AND    GBH.BATCH_NO LIKE '70063%1'
--And    GBH.Batch_type != 10 /*10 -- FPO  0 -- Batch*/
--And    GBH.Creation_date > Trunc (Sysdate )
/*standard Joins*/
--AND    GBHp.batch_id(+) = GBH.FPO_ID  gb
/*Standard Joins*/
AND    GBH.Formula_id = F.Formula_id(+)
AND    (GBH.Formula_id IS NULL
OR      GBH.Formula_id = F.Formula_id)
AND    GBH.Routing_id = R.Routing_id(+)
AND    GBH.Recipe_validity_rule_id = rvr.Recipe_validity_rule_id(+)
AND    rvr.Recipe_id = Rec.Recipe_id(+)
AND    Mp.Organization_id = GBH.Organization_id
--   And    Mtr.Reason_id(+) = GBH.Terminate_reason_id
;