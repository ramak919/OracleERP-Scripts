/* Formatted on 2014/01/16 09:41 (Formatter Plus v4.8.8) */
--/* Formatted on 2014/01/16 09:35 (Formatter Plus v4.8.8) */
Select   ood.organization_code own_org
--, ood.ORGANIZATION_NAME
        , ffm.formula_no || ' Vers(' || ffm.formula_vers || ')' formula
        ,ffm.formula_class || ', '||ffc.FORMULA_CLASS_DESC formula_class 
        , ffm.formula_desc1 || ' ' || ffm.formula_desc2 formula_desc
        ,ffm.attribute1 batch_record
        ,ffm.attribute3 form#
        ,gmd_api_grp.get_status_desc (ffm.formula_status) form_status
        ,fmd.line_no
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.line_type, 'GMD_FORMULA_ITEM_TYPE') line_type
        ,msi.concatenated_segments item
        ,msi.description item_desc        
        ,fmd.qty
        ,fmd.detail_uom
        ,inv_meaning_sel.c_fndcommon (msi.item_type, 'ITEM_TYPE') item_type
        ,inv_meaning_sel.c_mfg_lookup (msi.planning_make_buy_code, 'MTL_PLANNING_MAKE_BUY') make_or_buy
        , (Select mic.category_concat_segs
           From   apps.mtl_item_categories_v mic
           Where  1 = 1
           And    mic.category_set_name = 'REGN Planning'
           And    mic.inventory_item_id = msi.inventory_item_id
           And    mic.organization_id = msi.organization_id) "REGN Planning"
        , (Select mic.category_concat_segs
           From   apps.mtl_item_categories_v mic
           Where  1 = 1
           And    mic.category_set_name = 'Inventory Class'
           And    mic.inventory_item_id = msi.inventory_item_id
           And    mic.organization_id = msi.organization_id) "Inventory Class"
        , (Select mic.category_concat_segs
           From   apps.mtl_item_categories_v mic
           Where  1 = 1
           And    mic.category_set_name = 'Storage Class'
           And    mic.inventory_item_id = msi.inventory_item_id
           And    mic.organization_id = msi.organization_id) "Storage Class"
        ,fmd.ingredient_end_date substituiton_effective_date
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.scale_type, 'SCALE_TYPE') scale_type
        ,fmd.scale_multiple
        , fmd.scale_rounding_variance * 100 scale_rounding_variance
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.rounding_direction, 'GMD_ROUNDING_DIRECTION') rounding_direction
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.release_type, 'GMD_MATERIAL_RELEASE_TYPE') release_or_yield_type
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.contribute_yield_ind, 'GME_YES') contribute_yield_ind
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.contribute_step_qty_ind, 'GME_YES') contribute_step_qty_ind
        ,apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.phantom_type, 'PHANTOM_TYPE') phantom_type
        ,fmd.buffer_ind
        ,fmd.cost_alloc
        ,fmd.scrap_factor
        ,msi.recipe_enabled_flag
        ,msi.inventory_item_status_code
        ,ffm.scale_type scaling_allowed
        ,ffm.formula_type packaging
        ,ffm.auto_product_calc
--        ,ffm.formula_class
--        ,ffm.formula_desc1
--        ,ffm.formula_desc2
,        fnd_user_ap_pkg.get_user_name (ffm.owner_id) owner
        ,fmd.inventory_item_id
        ,ffm.formula_type
        ,fmd.formula_id
        ,fmd.formulaline_id
        ,inv_convert.inv_um_convert (fmd.inventory_item_id
                                    ,Null
                                    ,fmd.organization_id
                                    ,Null
                                    ,fmd.qty
                                    ,fmd.detail_uom
                                    ,msi.primary_uom_code
                                    ,Null
                                    ,Null
                                    ) to_prim
        ,msi.primary_uom_code
        ,inv_convert.inv_um_convert (fmd.inventory_item_id
                                    ,Null
                                    ,fmd.organization_id
                                    ,Null
                                    ,fmd.qty
                                    ,fmd.detail_uom
                                    ,msi.secondary_uom_code
                                    ,Null
                                    ,Null
                                    ) to_sec
        ,msi.secondary_uom_code
        ,inv_convert.inv_um_convert (fmd.inventory_item_id
                                    ,Null
                                    ,fmd.organization_id
                                    ,Null
                                    ,1
                                    ,msi.primary_uom_code
                                    ,msi.secondary_uom_code
                                    ,Null
                                    ,Null
                                    ) prim_to_sec
        ,ffm.formula_status
From     fm_matl_dtl fmd
        ,mtl_system_items_kfv msi
        ,fm_form_mst_vl ffm
        ,org_organization_definitions ood
         ,fm_form_cls ffc
Where    1 = 1
--AND OOD.ORGANIZATION_CODE ='PA5'
--and msi.SEGMENT1='70025'
And      (ffm.formula_no Like '%70060%%'
--or       ffm.formula_no Like '%70025%%'
)
--And msi.SEGMENT1='11032'
/*Standard Joins*/
and ffm.FORMULA_CLASS =ffc.FORMULA_CLASS (+)
And      ffm.owner_organization_id = ood.organization_id
And      ffm.formula_status <> 1000
--and ffm.FORMULA_NO like '%70052%'
And      ffm.formula_id = fmd.formula_id
And      fmd.inventory_item_id = msi.inventory_item_id
And      fmd.organization_id = msi.organization_id
Order By fmd.formula_id
        ,fmd.line_type
        ,fmd.line_no