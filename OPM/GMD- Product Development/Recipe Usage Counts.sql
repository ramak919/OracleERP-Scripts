/* Formatted on 2014/01/28 15:29 (Formatter Plus v4.8.8) */
create or replace view  xx_temp as 
Select   Rc.Recipe_no || ' ( Ver :' || Rc.Recipe_version || ')' Recipe_vers
       , Gmd_api_grp.Get_status_desc (Rc.Recipe_status) Recipe_status
       , Fm.Formula_no || ' ( Ver :' || Fm.Formula_vers || ')' Formula_vers
       , Gmd_api_grp.Get_status_desc (Fm.Formula_status) Formula_status
       , Rt.Routing_no || ' ( Ver :' || Rt.Routing_vers || ')' Routing_vers
       , Gmd_api_grp.Get_status_desc (Rt.Routing_status) Routing_status
       , Inv_detail_util_pvt.Get_organization_code (Rc.Owner_organization_id)
                                                                     Org_code
       , Msi.Concatenated_segments Item_no
       , Sum (  Decode (Sign (Nvl (Rvr.End_date, Sysdate + 1) - Sysdate)
                      , +1, 1
                      , 0
                       )
              * Decode (Rvr.Validity_rule_status
                      , 700, 1
                      , 900, 1
                      , 0
                       )
              * Decode (Rvr.Recipe_use
                      , 0, 1
                      , 0
                       )) Active_prod
       , Sum (  Decode (Sign (Nvl (Rvr.End_date, Sysdate + 1) - Sysdate)
                      , +1, 1
                      , 0
                       )
              * Decode (Rvr.Validity_rule_status
                      , 700, 1
                      , 900, 1
                      , 0
                       )
              * Decode (Rvr.Recipe_use
                      , 2, 1
                      , 0
                       )) Active_cost
       , Rc.Recipe_id
--         , rvr.min_qty || ' to ' || rvr.max_qty "min/max"
--         ,rvr.std_qty
--         ,rvr.detail_uom
--         , rvr.inv_min_qty || ' to ' || rvr.inv_max_qty "INV min/max"
--,      Gmd_api_grp.Get_status_desc (Rvr.Validity_rule_status) Rvr_status
--      ,rvr.text_code
--,      Rvr.Delete_mark
--      ,rvr.lab_type
--     , Apps.Inv_meaning_sel.C_fnd_lookup_vl (Rvr.Recipe_use
--                                           , 'GMD_FORMULA_USE')
--                                                            Validity_rule_use
--         ,rvr.preference pref
--,      Rvr.Start_date || ' to ' || Rvr.End_date "Start-End Date"
--     ,  decode (Sign (Nvl (Rvr.End_date, Sysdate + 1) - Sysdate) ,+1, 1
--                     ,0) dt
--      ,decode (rvr.VALIDITY_RULE_STATUS,700,1,900,1,0) status
From     Gmd_recipe_validity_rules Rvr
       , Gmd_recipes_vl Rc
       , Mtl_system_items_vl Msi
       , Fm_form_mst Fm
       , Fm_rout_hdr Rt
Where    1 = 1
And      Rc.Recipe_status <> 1000
And      Rvr.Delete_mark = 0
And      Rvr.Recipe_id = Rc.Recipe_id
And      Rc.Formula_id = Fm.Formula_id
And      Rc.Routing_id = Rt.Routing_id(+)
And      Rvr.Inventory_item_id = Msi.Inventory_item_id
And      Rc.Owner_organization_id = Msi.Organization_id
Group By Rc.Recipe_no || ' ( Ver :' || Rc.Recipe_version || ')'
       , Gmd_api_grp.Get_status_desc (Rc.Recipe_status)
       , Fm.Formula_no || ' ( Ver :' || Fm.Formula_vers || ')'
       , Gmd_api_grp.Get_status_desc (Fm.Formula_status)
       , Rt.Routing_no || ' ( Ver :' || Rt.Routing_vers || ')'
       , Gmd_api_grp.Get_status_desc (Rt.Routing_status)
       , Inv_detail_util_pvt.Get_organization_code (Rc.Owner_organization_id)
--     , Apps.Inv_meaning_sel.C_fnd_lookup_vl (Rvr.Recipe_use
--                                           , 'GMD_FORMULA_USE')
--                                                            Validity_rule_use
,        Msi.Concatenated_segments
       , Rc.Recipe_id





/* Formatted on 1/16/2015 9:15:23 AM (QP5 v5.256.13226.35510) */
SELECT
       gr.ACTIVE_COST
      ,gr.ACTIVE_PROD
      ,gr.FORMULA_STATUS
      ,gr.FORMULA_VERS
      ,gr.ITEM_NO
      ,gr.ORG_CODE
      ,gr.RECIPE_ID
      ,gr.RECIPE_STATUS
      ,gr.RECIPE_VERS
      ,gr.ROUTING_STATUS
      ,gr.ROUTING_VERS
      ,LISTAGG (batc.BATCH_no, '; ') WITHIN GROUP (ORDER BY batc.BATCH_NO DESC) Batches
      ,MAX (batc.creation_date) last_batch_created_date
      ,SUM (DECODE (NVL (batc.BATCH_STATUS, -1),  4, 0, -3,0, -1, 0,  1)) total_active_batches
FROM
       Xx_temp gr
      ,(SELECT
               rvr.RECIPE_ID
              ,Inv_detail_util_pvt.Get_organization_code (gbh.ORGANIZATION_ID) || '/' || gbh.BATCH_NO batch_NO
              ,gbh.CREATION_DATE
              ,gbh.BATCH_STATUS
        FROM
               Gme_batch_header Gbh, Gmd_recipe_validity_rules Rvr
        WHERE
               1 = 1
        AND    gbh.BATCH_STATUS NOT IN (4, -1,-3)
        AND    Rvr.Recipe_validity_rule_id = Gbh.Recipe_validity_rule_id) batc
WHERE
       1 = 1
AND    batc.Recipe_id(+) = gr.Recipe_id
--and gr.ACTIVE_COST!=0
--and gr.ACTIVE_PROD!=0
GROUP BY
       gr.ACTIVE_COST
      ,gr.ACTIVE_PROD
      ,gr.FORMULA_STATUS
      ,gr.FORMULA_VERS
      ,gr.ITEM_NO
      ,gr.ORG_CODE
      ,gr.RECIPE_ID
      ,gr.RECIPE_STATUS
      ,gr.RECIPE_VERS
      ,gr.ROUTING_STATUS
      ,gr.ROUTING_VERS;
