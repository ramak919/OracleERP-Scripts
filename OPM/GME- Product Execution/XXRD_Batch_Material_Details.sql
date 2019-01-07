/*Known views GME_MATERIAL_DETAILS_V*/

/* Formatted on 1/21/2015 3:03:54 PM (QP5 v5.256.13226.35510) */
SELECT
       INV_detail_util_pvt.get_organization_code (GMD.ORGANIZATION_ID) ORG
      ,GBH.BATCH_NO
      ,Inv_meaning_sel.C_fnd_lookup_vl (GBH.Batch_status, 'GME_BATCH_STATUS') || ' - ' || GBH.Batch_status BAtCh_statUS
      ,GMD.LINE_NO
      ,apps.inv_meaning_sel.c_fnd_lookup_vl (gmd.line_type, 'LINE_TYPE') || ' (' || GMD.LINE_TYPE || ')' line_type
      ,MSI.CONCATENATED_SEGMENTS ITEM
      ,GMD.REVISION item_rev
      ,GMD.DTL_UM
      ,GMD.ORIGINAL_QTY
      ,GMD.PLAN_QTY
      ,GMD.WIP_PLAN_QTY
      ,GMD.ACTUAL_QTY
      ,GMD.BACKORDERED_QTY
      ,GMD.SUBINVENTORY || ' /' || Inv_kanban_pkg.Getlocatorname (gmd.Organization_id, gmd.Locator_id) SUB_locator
      ,GMD.MATERIAL_REQUIREMENT_DATE
      --     , fnd_date.date_to_displayDT (GMD.MATERIAL_REQUIREMENT_DATE
      --                                 , FND_TIMEZONES.GET_SERVER_TIMEZONE_CODE)
      --          MATERIAL_REQUIREMENT_DSPLY_DT
      ,MSI.DESCRIPTION ITEM_DESC
      ,apps.inv_meaning_sel.c_fnd_lookup_vl (GMD.BY_PRODUCT_TYPE, 'GMD_BY_PRODUCT_TYPE') || '-' || GMD.BY_PRODUCT_TYPE by_product_type
      ,GMD.SCRAP_FACTOR
      ,apps.inv_meaning_sel.c_fnd_lookup_vl (gmd.release_type, 'GMD_MATERIAL_RELEASE_TYPE') || '-' || GMD.RELEASE_TYPE release_or_yield_type
      ,apps.inv_meaning_sel.c_fnd_lookup_vl (gmd.scale_type, 'SCALE_TYPE') || '-' || GMD.SCALE_TYPE scale_type
      ,GMD.SCALE_MULTIPLE
      ,GMD.SCALE_ROUNDING_VARIANCE
      ,GMD.ROUNDING_DIRECTION
      ,apps.inv_meaning_sel.c_fnd_lookup_vl (GMD.PHANTOM_TYPE, 'PHANTOM_TYPE') Phantom_type
      ,GBHP.BATCH_NO PHANTOM_BATCH_NO
      ,GMD.COST_ALLOC
      ,GMD.CONTRIBUTE_YIELD_IND
      ,GMD.CONTRIBUTE_STEP_QTY_IND
      ,GMD.TEXT_CODE
      ,GMD.ALLOC_IND
      ,GMD.DISPENSE_IND
      ,GMD.LOCATOR_ID
      ,GMD.PHANTOM_ID
      ,GMD.PHANTOM_LINE_ID
      ,GMD.ORGANIZATION_ID
      ,GMD.BATCH_ID
      ,GMD.MATERIAL_DETAIL_ID
      ,GMD.FORMULALINE_ID
      ,GMD.INVENTORY_ITEM_ID
      ,gmd_api_grp.GET_OBJECT_NAME_VERSION ('FORMULA', GBH.FORMULA_ID) formula
FROM
       apps.GME_MATERIAL_DETAILS GMD
      ,MTL_SYSTEM_ITEMS_VL MSI
      ,GME_BATCH_HEADER GBHp
      ,gme_batch_header gbh
	  ,apps.GME_MATERIAL_DETAILS_DFV dgmd
WHERE
       1 = 1
AND    GBH.BATCH_NO LIKE '%1156700042%'
--AND    GMD.BATCH_ID = 850538
--and MSI.CONCATENATED_SEGMENTS like  ''
--and GBH.BATCH_STATUS in(1,2,3,4)/*1 pending, 2 WIP,3 completed, 4 closed*/
--AND    GMD.LAST_UPDATE_DATE > TRUNC (SYSDATE - 10)
/*Standard Joins */
         AND dgmd.row_id(+) = gmd.ROWID
AND    MSI.INVENTORY_ITEM_ID = GMD.INVENTORY_ITEM_ID
AND    MSI.ORGANIZATION_ID = GMD.ORGANIZATION_ID
AND    GBHp.batch_id(+) = GMD.PHANTOM_ID
AND    GBH.BATCH_ID = GMD.BATCH_ID
ORDER BY
       GMD.ORGANIZATION_ID
      ,GMD.BATCH_ID
      ,GMD.LINE_TYPE
      ,GMD.LINE_NO;