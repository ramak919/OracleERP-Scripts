DROP VIEW APPS.XXRD_GMD_RECIPE_VALIDITY_V;

/* Formatted on 2013/05/01 16:33 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Create Or Replace Force View apps.xxrd_gmd_recipe_validity_v (org_code
                                                             ,validity_rule_use
                                                             ,item_no
                                                             ,pref
                                                             ,"Start-End Date"
                                                             ,"min/max"
                                                             ,std_qty
                                                             ,detail_uom
                                                             ,"INV min/max"
                                                             ,rvr_status
                                                             ,planned_process_loss
                                                             ,fixed_process_loss
                                                             ,fixed_process_loss_uom
                                                             ,delete_mark
                                                             ,recipe_vers
                                                             ,formula_vers
                                                             ,routing_vers
                                                             ,item_desc
                                                             ,recipe_validity_rule_id
                                                             ,recipe_id
                                                             ,formula_id
                                                             ,routing_id
                                                             ,inventory_item_id
                                                             ,organization_id
                                                             ,last_update_date
                                                             ,last_updated_by
                                                             ,validity_rule_status
                                                             )
As
   Select inv_detail_util_pvt.get_organization_code (rvr.organization_id) org_code
         ,apps.inv_meaning_sel.c_fnd_lookup_vl (rvr.recipe_use, 'GMD_FORMULA_USE')|| ' - '|| RVR.RECIPE_USE validity_rule_use
		 --,decode ( grvr.RECIPE_USE,0,'Prod',1,'Plan',2,'Cost',3,'Regu',4,'Tech') recipe_use
         ,msi.concatenated_segments item_no
         ,rvr.preference pref
         , rvr.start_date || ' to ' || rvr.end_date "Start-End Date"
         , rvr.min_qty || ' to ' || rvr.max_qty "min/max"
         ,rvr.std_qty
         ,rvr.detail_uom
         , rvr.inv_min_qty || ' to ' || rvr.inv_max_qty "INV min/max"
         ,gmd_api_grp.get_status_desc (rvr.validity_rule_status) rvr_status
         ,rvr.planned_process_loss
         ,rvr.fixed_process_loss
         ,rvr.fixed_process_loss_uom
--      ,rvr.text_code
   ,      rvr.delete_mark
--      ,rvr.lab_type
   ,      rc.recipe_no || ' ( Ver :' || rc.recipe_version || ')' recipe_vers
         , fm.formula_no || ' ( Ver :' || fm.formula_vers || ')' formula_vers
         , rt.routing_no || ' ( Ver :' || rt.routing_vers || ')' routing_vers
         ,msi.description item_desc
         ,rvr.recipe_validity_rule_id
         ,rvr.recipe_id
         ,rc.formula_id
         ,rc.routing_id
         ,msi.inventory_item_id
         ,rvr.organization_id
         ,rvr.last_update_date
         ,rvr.last_updated_by
         ,rvr.validity_rule_status
   From   apps.gmd_recipe_validity_rules rvr
         ,apps.gmd_recipes_vl rc
         ,apps.mtl_system_items_vl msi
         ,apps.fm_form_mst fm
         ,apps.fm_rout_hdr rt
   Where  1 = 1
      AND rvr.delete_mark <> 1
       AND rc.delete_mark <> 1
       AND fm.delete_mark <> 1
       AND rc.recipe_status <> 1000
       AND rvr.validity_rule_status <> 1000
       and (rvr.end_date is null or rvr.end_date > sysdate)
   And    rvr.recipe_id = rc.recipe_id
   And    rc.formula_id = fm.formula_id
   And    rc.routing_id = rt.routing_id(+)
   And    rvr.inventory_item_id = msi.inventory_item_id
   And    rc.owner_organization_id = msi.organization_id;


