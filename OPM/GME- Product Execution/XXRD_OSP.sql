Data Collection scripts for Outside processing (OSP) and OPM (Doc ID 2305461.1)
1) List of Queries from Purchasing Module .


a)
SELECT 'PO/REQ Linked'
FROM po_releases_all pr,
po_headers_all ph,
po_distributions_all pd,
po_line_locations_all pll
WHERE pd.po_line_id IS NOT NULL
AND pd.line_location_id IS NOT NULL
AND pd.wip_entity_id = XXXXX
AND pd.destination_organization_id = XXXXX
AND ph.po_header_id = pd.po_header_id
AND pll.line_location_id = pd.line_location_id
AND pr.po_release_id (+) = pd.po_release_id
AND (pll.cancel_flag IS NULL OR pll.cancel_flag = 'N')
AND (nvl(pll.closed_code,'OPEN') NOT IN ('FINALLY CLOSED','CLOSED FOR
RECEIVING') OR
(nvl(pll.closed_code,'OPEN') = 'CLOSED FOR RECEIVING'
AND (NVL(pll.quantity_received,0) <>
(SELECT
NVL(SUM(NVL(pd2.quantity_delivered,0)),0)
FROM po_distributions_all pd2
WHERE pd2.line_location_id =
pll.line_location_id
AND pd2.line_location_id IS NOT NULL
AND pd2.po_line_id IS NOT NULL))));


b).
SELECT prl.*
FROM po_requisition_lines_all prl
WHERE prl.wip_entity_id = XXXXX
AND prl.destination_organization_id = XXXXX
AND nvl(prl.cancel_flag, 'N') = 'N'
AND prl.line_location_id is NULL;


c).
SELECT pri.*
FROM po_requisitions_interface_all pri
WHERE pri.wip_entity_id = XXXXX
AND pri.destination_organization_id = XXXXX;


d) select * from APPS.PO_DISTRIBUTIONS_ALL where WIP_ENTITY_ID = XXXXX;

e) select * from APPS.PO_HEADERS_ALL where PO_HEADER_ID in (select PO_HEADER_ID
from APPS.PO_DISTRIBUTIONS_ALL where WIP_ENTITY_ID = XXXXX)

f).
select * from APPS.PO_LINE_LOCATIONS_ALL where LINE_LOCATION_ID in (select
LINE_LOCATION_ID from APPS.PO_DISTRIBUTIONS_ALL where WIP_ENTITY_ID = XXXXX)

Note: Replace wip_entity_id with Batch _id value.

2) List of Queries from OPM Process Execution Module.

a) select batch_id, batch_no, bh.organization_id, organization_code, batch_type, batch_status, recipe_validity_rule_id, formula_id, routing_id, to_char (plan_start_date, 'DD-MON-YYYY HH24:MI:SS') as plan_start_date, to_char(actual_start_date, 'DD-MON-YYYY HH24:MI:SS') as actual_start_date, to_char (plan_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as plan_cmplt_date, to_char (actual_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as actual_cmplt_date, to_char (due_date, 'DD-MON-YYYY HH24:MI:SS') as due_date, to_char (batch_close_date, 'DD-MON-YYYY HH24:MI:SS') as batch_close_date, actual_cost_ind, update_inventory_ind, to_char (bh.last_update_date, 'DD-MON-YYYY HH24:MI:SS') as last_update_date, bh.last_updated_by, to_char (bh.creation_date, 'DD-MON-YYYY HH24:MI:SS') as creation_date, bh.created_by, bh.last_update_login, bh.delete_mark, text_code, parentline_id, fpo_id, automatic_step_calculation, gl_posted_ind, firmed_ind, finite_scheduled_ind, order_priority, migrated_batch_ind, enforce_step_dependency, terminated_ind, enhanced_pi_ind, laboratory_ind, move_order_header_id, terminate_reason_id
FROM gme_batch_header bh, mtl_parameters p
WHERE batch_id in (XXXXXX)
AND bh.organization_id = p.organization_id;


b) select md.batch_id, batch_no, line_type, line_no, material_detail_id, md.inventory_item_id, segment1 as item_number, plan_qty, actual_qty, wip_plan_qty, dtl_um, release_type, md.phantom_id, md.phantom_line_id, md.subinventory, md.locator_id, material_requirement_date, md.move_order_line_id, original_qty, original_primary_qty, cost_alloc, scrap_factor, scale_type, contribute_yield_ind, contribute_step_qty_ind, to_char (md.creation_date, 'DD-MON-YYYY HH24:MI:SS') as creation_date, to_char (md.last_update_date, 'DD-MON-YYYY HH24:MI:SS') as last_update_date, formulaline_id
FROM gme_material_details md, mtl_system_items_b i, gme_batch_header bh
WHERE md.batch_id IN (XXXXXX)
AND md.batch_id = bh.batch_id
AND md.inventory_item_id = i.inventory_item_id
AND bh.organization_id = i.organization_id
ORDER BY batch_id, line_type, material_detail_id;


c) SELECT batch_id, batchstep_no, batchstep_id, step_status, gbt.oprn_id, oprn_no, oprn_vers, plan_step_qty, actual_step_qty, step_qty_um, to_char(plan_start_date, 'DD-MON-YYYY HH24:MI:SS') as plan_start_date, to_char(actual_start_date, 'DD-MON-YYYY HH24:MI:SS') as actual_start_date, to_char(plan_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as plan_cmplt_date, to_char(actual_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as actual_cmplt_date, steprelease_type, max_step_capacity, max_step_capacity_um, plan_charges, actual_charges, quality_status, routingstep_id
FROM gme_batch_steps gbt, gmd_operations_b gob
WHERE batch_id in (XXXXXX)
And gbt.oprn_id = gob.oprn_id
ORDER BY batch_id, batchstep_no;


d) SELECT batch_id, batchstep_id, batchstep_activity_id, batchstep_resource_id, resources, scale_type, plan_rsrc_count, actual_rsrc_count, plan_rsrc_usage, actual_rsrc_usage, usage_um, plan_rsrc_qty, actual_rsrc_qty, resource_qty_um, to_char(plan_start_date, 'DD-MON-YYYY HH24:MI:SS') as plan_start_date, to_char(actual_start_date, 'DD-MON-YYYY HH24:MI:SS') as actual_start_date, to_char(plan_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as plan_cmplt_date, to_char(actual_cmplt_date, 'DD-MON-YYYY HH24:MI:SS') as actual_cmplt_date, offset_interval, min_capacity, max_capacity, capacity_um, calculate_charges, prim_rsrc_ind
FROM gme_batch_step_resources
WHERE batch_id in (XXXXXX)
ORDER BY batch_id, batchstep_id, batchstep_activity_id, batchstep_resource_id;


e) SELECT doc_id as batch_id, line_id as batchstep_resource_id, poc_trans_id, resources, resource_usage, trans_qty_um, to_char(trans_date, 'DD-MON-YYYY HH24:MI:SS') as trans_date, to_char(start_date, 'DD-MON-YYYY HH24:MI:SS') as start_date, to_char(end_date, 'DD-MON-YYYY HH24:MI:SS') as end_date, completed_ind, posted_ind, overrided_protected_ind, reverse_id, delete_mark
FROM gme_resource_txns
WHERE doc_id in (XXXXXX)
ORDER BY doc_id, line_id, poc_trans_id;