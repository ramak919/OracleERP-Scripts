/* Formatted on 2013/09/27 22:52 (Formatter Plus v4.8.8) */
Create or replace view xx_rama as 
SELECT ffm.formula_id , ffm.FORMULA_NO,gmd_api_grp.get_status_desc (ffm.formula_status) form_status
,INV_DETAIL_UTIL_PVT.GET_ORGANIZATION_CODE(  ffm.OWNER_ORGANIZATION_ID ) org,
(SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) tot_ing_lines,
       (SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
           AND fmd.contribute_yield_ind = 'N'
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) cont_yield_no_cnt,
           (SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
           AND fmd.contribute_yield_ind = 'Y'
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) cont_yield_Yes_cnt,
            (SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
       and  apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.scale_type, 'SCALE_TYPE')='Fixed'
--           AND fmd.contribute_yield_ind = 'N'
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) Fixed_cnt
           ,
            (SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
       and  apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.scale_type, 'SCALE_TYPE')='Proportional'
--           AND fmd.contribute_yield_ind = 'N'
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) Propor_cnt
            ,
            (SELECT COUNT (*)
          FROM fm_matl_dtl fmd
         WHERE 1 = 1
       and  apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.scale_type, 'SCALE_TYPE')='Proportional'
           AND fmd.contribute_yield_ind = 'Y'
           AND fmd.line_type = -1
           AND fmd.formula_id = ffm.formula_id) Propor_CNT_yld
  FROM fm_form_mst_vl ffm
  where 1=1
  and ffm.FORMULA_STATUS <>1000
  
  
  \\80413 MR1432 PA5
  
  11275 BS687 SSF2135 PA5
  
  select  * from xx_rama t1
  where 1=1
--  and t1.ORG='PA5'
  and t1.PROPOR_CNT_YLD=0
  
/* Formatted on 2013/09/27 22:44 (Formatter Plus v4.8.8) */
SELECT   DISTINCT fmd.FORMULA_ID,
         apps.inv_meaning_sel.c_fnd_lookup_vl
                                           (fmd.line_type,
                                            'GMD_FORMULA_ITEM_TYPE'
                                           ) line_type,
         apps.inv_meaning_sel.c_fnd_lookup_vl (fmd.scale_type,
                                               'SCALE_TYPE'
                                              ) scale_type,
         apps.inv_meaning_sel.c_fnd_lookup_vl
                              (fmd.contribute_yield_ind,
                               'GME_YES'
                              ) contribute_yield_ind
                              
    FROM fm_matl_dtl fmd,
         mtl_system_items_kfv msi,
         fm_form_mst_vl ffm,
         org_organization_definitions ood
   WHERE 1 = 1
   AND FMD.LINE_TYPE=-1
--And      ffm.formula_no = '80076 MR814'
     AND ffm.owner_organization_id = ood.organization_id
     AND ffm.formula_status <> 1000
--and ffm.FORMULA_NO like '%70052%'
     AND ffm.formula_id = fmd.formula_id
     AND fmd.inventory_item_id = msi.inventory_item_id
     AND fmd.organization_id = msi.organization_id
