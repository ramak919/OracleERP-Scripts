/* Formatted on 2009/12/09 06:46 (Formatter Plus v4.8.8) */
SELECT gish.substitution_id ID
      ,gish.substitution_name
      ,gish.substitution_status status
      ,gish.substitution_version VERSION
      ,gish.start_date
      ,gish.end_date
      ,gish.original_inventory_item_id
      ,gish.owner_organization_id org
      ,gisd.inventory_item_id
      ,msi.item_type
FROM   gmd_item_substitution_hdr_b gish
      ,gmd_item_substitution_dtl gisd
      ,mtl_system_items_b msi
WHERE  1 = 1
--and gish.SUBSTITUTION_VERSION>1
--and gish.SUBSTITUTION_NAME='37C846'
AND    msi.inventory_item_id = gish.original_inventory_item_id
AND    msi.organization_id = gish.owner_organization_id
AND    msi.item_type NOT LIKE '%FG%'
AND    SYSDATE BETWEEN gish.start_date AND NVL (gish.end_date, SYSDATE + 1)
AND    gisd.substitution_id = gish.substitution_id;


/*Formulas that have the Substitutions*/
SELECT   *
FROM     gmd_formula_substitution gfs