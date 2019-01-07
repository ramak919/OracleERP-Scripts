SELECT                                                /* Created by Rama */
          ood.organization_code
        , gbh.batch_no                                        -- , gmd.LINE_NO
        , msi.segment1 item_no
        , msi.description item_descriptions
        , mtln.lot_number
        , mmt.subinventory_code
        , (mmt.transaction_date) trans_date
        , (NVL (mtln.primary_quantity, mmt.primary_quantity))
             primary_quantity
        , msi.primary_uom_code prim_uom
        , (mmt.secondary_transaction_quantity)
        , mmt.secondary_uom_code
        , (NVL (mtln.transaction_quantity, mmt.transaction_quantity)) trx_qty
        , mmt.transaction_uom
        , mtt.transaction_type_name
        , mmt.creation_date
        , mmt.last_update_date
        , mmt.transaction_id
        , mmt.transaction_source_id
        , mmt.trx_source_line_id
        , mmt.locator_id
        , mmt.transaction_type_id
        , mmt.transaction_source_type_id
        , msi.inventory_item_id
        , mmt.organization_id
        , 'R12' data_source
   FROM
          apps.mtl_material_transactions mmt
        , apps.mtl_txn_source_types mtst
        , apps.mtl_transaction_types mtt
        , apps.mtl_system_items_kfv msi
        , apps.mtl_transaction_lot_numbers mtln
        , apps.org_organization_definitions ood
        , apps.gme_batch_header gbh
   WHERE
          1 = 1                                          /* Created by Rama */
   AND    mmt.transaction_source_type_id = 5
   -- AND gbh.batch_no = '8022600014'
   --AND mmt.creation_date > TRUNC (SYSDATE - 5)
   AND    mmt.transaction_source_id = gbh.batch_id
   AND    mtln.transaction_id(+) = mmt.transaction_id
   AND    mtst.transaction_source_type_id = mmt.transaction_source_type_id
   AND    mtt.transaction_type_id = mmt.transaction_type_id
   AND    mmt.inventory_item_id = msi.inventory_item_id
   AND    mmt.organization_id = msi.organization_id
   AND    mmt.organization_id = ood.organization_id
   UNION ALL
   SELECT
          itp.orgn_code organization_code
        , gbh.batch_no
        , iim.item_no
        , iim.item_desc1 || ' ' || iim.item_desc2 item_description
        , ilm.lot_no lot_number
        , itp.whse_code subinventory_code              -- ,itp.Location locatr
        , itp.trans_date trans_date
        , itp.trans_qty primary_quantity
        , itp.trans_um prim_uom
        , itp.trans_qty2 secondary_transaction_quantity
        , itp.trans_um2 secondary_uom_code
        , itp.trans_qty trx_qty
        , itp.trans_um transaction_uom
        , NULL transaction_type_name
        , itp.creation_date
        , itp.last_update_date                            /*Created by Rama */
        , itp.trans_id transaction_id
        , itp.doc_id transaction_source_id
        , NULL transaction_source_line_id
        , NULL locator_id
        , NULL transaction_type_id
        , NULL transaction_source_type_id
        , itp.item_id inventory_item_id
        , NULL organization_id
        , 'R11' data_source
   FROM
          ic_tran_pnd itp
        , ic_item_mst iim
        , ic_lots_mst ilm
        , gme_batch_header gbh
   WHERE
          1 = 1                                           /*Created by Rama */
   AND    gbh.batch_id = itp.doc_id
   AND    itp.lot_id <> 0
   AND    itp.trans_qty != 0
   -- and iim.LOT_CTL =1
   AND    itp.delete_mark = 0
   AND    itp.lot_id = ilm.lot_id
   AND    itp.item_id = ilm.item_id
   AND    itp.item_id = iim.item_id
   --AND itp.line_type = 1
   AND    itp.doc_type = 'PROD';