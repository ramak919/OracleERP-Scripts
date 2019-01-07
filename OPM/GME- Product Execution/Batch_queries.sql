Please run these queries to gets from GME and INV tables that relate to a specific batch.. Replace the

number '138474' with the required batch number.

--1) Batch
select gbh.*
from gme_batch_header gbh
where gbh.batch_no = '138474' ---> Please include the required batch_no.

--2) Batch Material Details
select gbh.batch_no, gbh.batch_id
, gmd.*
from gme_material_details gmd
, gme_batch_header gbh
where gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.material_detail_id

--3) Batch Material Transactions Temp

select gbh.batch_no, gbh.batch_id, gmd.line_no, gmd.material_detail_id, gmd.line_type
, mmtt.* from mtl_material_transactions_temp mmtt
, gme_material_details gmd
, gme_batch_header gbh
where mmtt.transaction_source_type_id = 5
and mmtt.trx_source_line_id = gmd.material_detail_id
and mmtt.transaction_source_id = gbh.batch_id
and gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.line_type, gmd.material_detail_id, mmtt.transaction_temp_id

--4) Batch Material Transactions
select gbh.batch_no, gbh.batch_id, gmd.line_no, gmd.material_detail_id, gmd.line_type
, mmt.*
from mtl_material_transactions mmt
, gme_material_details gmd
, gme_batch_header gbh
where mmt.transaction_source_type_id = 5
and mmt.trx_source_line_id = gmd.material_detail_id
and mmt.transaction_source_id = gbh.batch_id
and gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.line_type, gmd.material_detail_id, mmt.transaction_id

--5) Lot Numbers
select gbh.batch_no, gbh.batch_id, gmd.line_no, gmd.material_detail_id, gmd.line_type
, mtln.*
from mtl_transaction_lot_numbers mtln
, mtl_material_transactions mmt
, gme_material_details gmd
, gme_batch_header gbh
where mtln.transaction_id= mmt.transaction_id
and mmt.transaction_source_type_id = 5
and mmt.trx_source_line_id = gmd.material_detail_id
and gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.line_type, gmd.material_detail_id, gmd.line_type, mmt.transaction_id

--6) Reservations
select gbh.batch_no, gbh.batch_id, gmd.line_no, gmd.material_detail_id, gmd.line_type
, mr.*
from mtl_reservations mr
, gme_material_details gmd
, gme_batch_header gbh
where mr.demand_source_type_id = 5
and mr.demand_source_line_id = gmd.material_detail_id
and gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.line_type, gmd.material_detail_id, gmd.line_type

--7) Pending Product Lots
select gbh.batch_no, gbh.batch_id, gmd.line_no, gmd.material_detail_id, gmd.line_type
, gppl.*
from gme_pending_product_lots gppl
, gme_material_details gmd
, gme_batch_header gbh
where gppl.material_detail_id = gmd.material_detail_id
and gmd.batch_id = gbh.batch_id
and gbh.batch_no = '138474'
order by gbh.batch_id, gmd.line_type, gmd.material_detail_id, gmd.line_type

--8) Requirements

select gbh.plant_code, gbh.batch_no, gbh.batch_id
, gbr.*
from gmf_batch_requirements gbr
, gme_batch_header gbh
where gbr.batch_id = gbh.batch_id
and gbh.plant_code = '&plant'
and gbh.batch_no = '138474'
order by gbr.requirement_id 

/*batch transactions */
/* Formatted on 2013/04/10 12:30 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Select batch_id
      ,batch_no
      ,bh.organization_id
      ,organization_code
      ,batch_type
      ,recipe_validity_rule_id
      ,formula_id
      ,routing_id
      ,plan_start_date
      ,actual_start_date
      ,due_date
      ,plan_cmplt_date
      ,actual_cmplt_date
      ,batch_status
      ,batch_close_date
      ,actual_cost_ind
      ,update_inventory_ind
      ,bh.last_update_date
      ,bh.last_updated_by
      ,bh.creation_date
      ,bh.last_update_login
      ,bh.delete_mark
      ,text_code
      ,parentline_id
      ,fpo_id
      ,automatic_step_calculation
      ,gl_posted_ind
      ,firmed_ind
      ,finite_scheduled_ind
      ,order_priority
      ,migrated_batch_ind
      ,enforce_step_dependency
      ,terminated_ind
      ,enhanced_pi_ind
      ,laboratory_ind
      ,move_order_header_id
      ,terminate_reason_id
From   gme_batch_header bh
      ,mtl_parameters p
Where  batch_id In (xxxxxx)
And    bh.organization_id = p.organization_id;


Select   md.batch_id
        ,batch_no
        ,line_type
        ,line_no
        ,material_detail_id
        ,md.inventory_item_id
        ,segment1 As item_number
        ,plan_qty
        ,actual_qty
        ,wip_plan_qty
        ,dtl_um
        ,release_type
        ,md.phantom_id
        ,md.subinventory
        ,md.locator_id
        ,material_requirement_date
        ,md.move_order_line_id
        ,original_primary_qty
        ,cost_alloc
From     gme_material_details md
        ,mtl_system_items_b i
        ,gme_batch_header bh
Where    md.batch_id In (xxxxxx)
And      md.batch_id = bh.batch_id
And      md.inventory_item_id = i.inventory_item_id
And      bh.organization_id = i.organization_id
Order By batch_id
        ,line_type
        ,material_detail_id;



Select   'MMT' As table_name
        ,t.transaction_id As trans_or_rsrv_id
        ,ty.transaction_type_name
        ,h.batch_status
        ,d.batch_id As batch_id
        ,t.transaction_source_id As trans_or_rsrv_source_id
        ,d.line_type
        ,t.trx_source_line_id As material_detail_id
        ,t.organization_id
        ,pa.organization_code
        ,t.inventory_item_id
        ,i.segment1 As item_number
        ,t.subinventory_code
        ,t.locator_id
        ,lt.lot_number As lot_number
        ,t.primary_quantity
        ,t.transaction_quantity As trans_or_rsrv_qty
        ,lt.transaction_quantity As lot_qty
        ,t.transaction_uom As trans_or_rsrv_uom
        ,t.secondary_transaction_quantity As sec_qty
        ,t.secondary_uom_code
        ,TO_CHAR (t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') As trans_or_rsrv_date
        ,t.lpn_id
        ,t.transfer_lpn_id
        ,t.transaction_mode
        ,Null As lock_flag
        ,Null As process_flag
From     mtl_material_transactions t
        ,gme_material_details d
        ,gme_batch_header h
        ,mtl_transaction_lot_numbers lt
        ,mtl_lot_numbers lot
        ,mtl_system_items_b i
        ,mtl_transaction_types ty
        ,mtl_parameters pa
Where    t.transaction_source_type_id = 5
And      h.batch_id In (xxxxxx)
And      t.transaction_source_id = h.batch_id
And      t.organization_id = h.organization_id
And      d.batch_id = h.batch_id
And      d.material_detail_id = t.trx_source_line_id
And      lt.transaction_id(+) = t.transaction_id   -- This join allows us to get the lot number
And      lot.lot_number(+) = lt.lot_number   -- This join allows us to get lot specific info if needed.
And      lot.organization_id(+) = lt.organization_id
And      lot.inventory_item_id(+) = lt.inventory_item_id
And      t.organization_id = i.organization_id
And      t.inventory_item_id = i.inventory_item_id
And      t.transaction_type_id = ty.transaction_type_id
And      t.organization_id = pa.organization_id
Union All
Select   'RSRV' As table_name
        ,reservation_id As trans_or_rsrv_id
        ,Null
        ,h.batch_status
        ,d.batch_id As batch_id
        ,demand_source_header_id As trans_or_rsrv_source_id
        ,d.line_type
        ,demand_source_line_id As material_detail_id
        ,r.organization_id
        ,pa.organization_code
        ,r.inventory_item_id
        ,i.segment1 As item_number
        ,r.subinventory_code
        ,r.locator_id
        ,r.lot_number
        ,primary_reservation_quantity
        ,reservation_quantity As trans_or_rsrv_qty
        ,Null
        ,reservation_uom_code As trans_or_rsrv_uom
        ,secondary_reservation_quantity As sec_qty
        ,r.secondary_uom_code
        ,TO_CHAR (requirement_date, 'DD-MON-YYYY HH24:MI:SS') As trans_or_rsrv_date
        ,lpn_id
        ,Null
        ,Null
        ,Null
        ,Null
From     mtl_reservations r
        ,gme_material_details d
        ,gme_batch_header h
        ,mtl_system_items_b i
        ,mtl_parameters pa
Where    demand_source_type_id = 5
And      h.batch_id In (xxxxxx)
And      demand_source_header_id = h.batch_id
And      r.organization_id = h.organization_id
And      d.batch_id = h.batch_id
And      d.material_detail_id = demand_source_line_id
And      r.organization_id = i.organization_id
And      r.inventory_item_id = i.inventory_item_id
And      r.organization_id = pa.organization_id
Union All
Select   'PPL' As table_name
        ,pending_product_lot_id As trans_or_rsrv_id
        ,Null
        ,h.batch_status
        ,d.batch_id As batch_id
        ,Null
        ,d.line_type
        ,d.material_detail_id
        ,h.organization_id
        ,pa.organization_code
        ,d.inventory_item_id
        ,i.segment1 As item_number
        ,Null
        ,Null
        ,lot_number
        ,Null
        ,quantity As trans_or_rsrv_qty
        ,Null
        ,Null
        ,secondary_quantity As sec_qty
        ,Null
        ,Null
        ,Null
        ,Null
        ,Null
        ,Null
        ,Null
From     gme_pending_product_lots p
        ,gme_material_details d
        ,gme_batch_header h
        ,mtl_system_items_b i
        ,mtl_parameters pa
Where    h.batch_id In (xxxxxx)
And      p.batch_id = h.batch_id
And      d.batch_id = h.batch_id
And      d.material_detail_id = p.material_detail_id
And      h.organization_id = i.organization_id
And      d.inventory_item_id = i.inventory_item_id
And      h.organization_id = pa.organization_id
Union All
-- Note that there should not be any transactions in MMTT. If there are, they are usually "stuck" there and
-- need to be processed or deleted
Select   'MMTT' As table_name
        ,t.transaction_temp_id As trans_or_rsrv_id
        ,ty.transaction_type_name
        ,h.batch_status
        ,d.batch_id As batch_id
        ,t.transaction_source_id As trans_or_rsrv_source_id
        ,d.line_type
        ,t.trx_source_line_id As material_detail_id
        ,t.organization_id
        ,pa.organization_code
        ,t.inventory_item_id
        ,i.segment1 As item_number
        ,t.subinventory_code
        ,t.locator_id
        ,lt.lot_number As lot_number
        ,t.primary_quantity
        ,t.transaction_quantity As trans_or_rsrv_qty
        ,lt.transaction_quantity As lot_qty
        ,t.transaction_uom As trans_or_rsrv_uom
        ,t.secondary_transaction_quantity As sec_qty
        ,t.secondary_uom_code
        ,TO_CHAR (t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') As trans_or_rsrv_date
        ,t.lpn_id
        ,t.transfer_lpn_id
        ,t.transaction_mode
        ,t.lock_flag
        ,t.process_flag
From     mtl_material_transactions_temp t
        ,gme_material_details d
        ,gme_batch_header h
        ,mtl_transaction_lots_temp lt
        ,mtl_system_items_b i
        ,mtl_transaction_types ty
        ,mtl_parameters pa   --mtl_lot_numbers lot
Where    t.transaction_source_type_id = 5
And      h.batch_id In (xxxxxx)
And      transaction_source_id = h.batch_id
And      t.organization_id = h.organization_id
And      d.batch_id = h.batch_id
And      d.material_detail_id = trx_source_line_id
And      lt.transaction_temp_id(+) = t.transaction_temp_id   -- This join allows us to get the lot number
--AND lot.lot_number(+) = lt.lot_number
--AND t.organization_id = lot.organization_id
And      t.organization_id = i.organization_id
And      t.inventory_item_id = i.inventory_item_id
And      t.transaction_type_id = ty.transaction_type_id
And      t.organization_id = pa.organization_id
Union All
Select   'MTI' As table_name
        ,t.transaction_interface_id As trans_or_rsrv_id
        ,ty.transaction_type_name
        ,h.batch_status
        ,d.batch_id As batch_id
        ,t.transaction_source_id As trans_or_rsrv_source_id
        ,d.line_type
        ,t.trx_source_line_id As material_detail_id
        ,t.organization_id
        ,pa.organization_code
        ,t.inventory_item_id
        ,i.segment1 As item_number
        ,t.subinventory_code
        ,t.locator_id
        ,lt.lot_number As lot_number
        ,t.primary_quantity
        ,t.transaction_quantity As trans_or_rsrv_qty
        ,lt.transaction_quantity As lot_qty
        ,t.transaction_uom As trans_or_rsrv_uom
        ,t.secondary_transaction_quantity As sec_qty
        ,t.secondary_uom_code
        ,TO_CHAR (t.transaction_date, 'DD-MON-YYYY HH24:MI:SS') As trans_or_rsrv_date
        ,t.lpn_id
        ,t.transfer_lpn_id
        ,t.transaction_mode
        ,TO_CHAR (t.lock_flag)
        ,TO_CHAR (t.process_flag)
From     mtl_transactions_interface t
        ,gme_material_details d
        ,gme_batch_header h
        ,mtl_transaction_lots_interface lt
        ,mtl_system_items_b i
        ,mtl_transaction_types ty
        ,mtl_parameters pa   --mtl_lot_numbers lot
Where    t.transaction_source_type_id = 5
And      h.batch_id In (xxxxxx)
And      transaction_source_id = h.batch_id
And      t.organization_id = h.organization_id
And      d.batch_id = h.batch_id
And      d.material_detail_id = trx_source_line_id
And      lt.transaction_interface_id(+) = t.transaction_interface_id   -- This join allows us to get the lot number
--AND lot.lot_number(+) = lt.lot_number
--AND t.organization_id = lot.organization_id
And      t.organization_id = i.organization_id
And      t.inventory_item_id = i.inventory_item_id
And      t.transaction_type_id = ty.transaction_type_id
And      t.organization_id = pa.organization_id
Order By batch_id
        ,table_name
        ,line_type
        ,material_detail_id;


Select *
From   gme_transaction_pairs
Where  batch_id In (xxxxxx);


