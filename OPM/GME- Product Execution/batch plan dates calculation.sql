/* Formatted on 2014/03/17 14:05 (Formatter Plus v4.8.8) rama.koganti*/
--gme_create_step_pvt.CALC_DATEs

Begin
   Gme_common_pvt.G_hour_uom_code := 'HR';
End;

Select Gme_create_step_pvt.Get_max_duration (Gbs.Batchstep_id, Gbs.Batch_id) / 24 Max_days
     , Gbs.*
     , gmd_api_grp.GET_OBJECT_NAME_VERSION ('FORMULA',gbh.formula_id) FROMUAL
     , (GBH.PLAN_CMPLT_DATE- GBH.PLAN_START_DATE) *24  DIFF 
     , GBH.BATCH_NO
     , GBH.PLAN_CMPLT_DATE, GBH.PLAN_START_DATE
From   Gme_batch_steps Gbs
,  gme_batch_header gbh 
Where  1 = 1
and GBS.BATCH_ID=GBH.BATCH_ID
And    Gbs.Batch_id = 697552;


Select *
From   Gme_batch_step_activities Gba
Where  1 = 1
And    Gba.Batch_id = 648635;

Select Batchstep_resource_id
     , Offset_interval
     , Plan_rsrc_usage
     , Plan_rsrc_count
     , Usage_um
From   Gme_batch_step_resources Gbr
Where  1 = 1
And    Gbr.Batch_id = 648635;

--Gmd_auto_step_calc.Load_steps 


Select   Gbh.Plan_cmplt_date - Gbh.Plan_start_date Diff
       , Gbh.*
From     Gme_batch_header_vw Gbh
Where    1 = 1
And      Gbh.Batch_id = 648635
And      Gbh.Batch_status In (2, 3)
--and gbh.BATCH_STATUS
Order By 1 Desc;


Select   Gbh.Plan_cmplt_date - Gbh.Plan_start_date Diff
       , Gbh.Plan_start_date_dt
       , Gbh.Plan_cmplt_date_dt
       , Gbh.Batch_id
       , Gbh.Batch_no
       , Gbh.Recipe_no
       , Gbh.Organization_code Org
--       , Gbh.Batch_status
,        Gbh.Batch_status_desc
       , Gbh.Batch_type
       , Gmd.Plan_qty
       , Gmd.Dtl_um
       , Msi.Primary_uom_code Prim
       , Msi.Lead_time_lot_size Lead_time_lot_size
       , Msi.Preprocessing_lead_time Preprocessing_lead_time
       , Msi.Full_lead_time Processing_lead_time
       , Msi.Postprocessing_lead_time Postprocessing_lead_time
       , Msi.Fixed_lead_time Fixed_lead_time
       , Msi.Variable_lead_time Variable_lead_time
       , Msi.Cum_manufacturing_lead_time Cum_manufacturing_lead_time
       , Msi.Cumulative_total_lead_time Cumulative_total_lead_time
       , Gbh.Fpo_id
From     Gme_batch_header_vw Gbh
       , Gme_material_details_v Gmd
       , Mtl_system_items_kfv Msi
Where    1 = 1
And      Gbh.Creation_date > Trunc (Sysdate)
--and gbh.BATCH_ID=640511
--and gbh.BATCH_TYPE=10
--And      Msi.Segment1 = '80649'
/*STANDARD JOINS */
And      Gmd.Line_type = 1
And      Gmd.Line_no = 1
And      Msi.Inventory_item_id = Gmd.Inventory_item_id
And      Msi.Organization_id = Gmd.Organization_id
And      Gmd.Batch_id = Gbh.Batch_id
--and gbh.BATCH_ID=648635
And      Gbh.Batch_status In (2, 3)
--and gbh.BATCH_STATUS
Order By 2 Desc;


/*
Suggested start date = Suggested Due date - Production Duration
Production Duration days = Fixed lead time + ( Quantity * Variable Lead time ) 


/*Concurrent program*/
--Lead Time Calculator for Process (gmp_lead_time_calculator_pkg.calculate_lead_times)

--The Lead Time Calculator for Process (LTC) concurrent program (in the OPM Process Planning responsibility) can be used to populate the fixed and variable lead times in the Organization Item form, Lead Time tab and, on an estimated basis, this allows an unconstrained plan to mimic routing lead times.

--The LTC first identifies the recipe to use. A product can be made from multiple recipes. The recipe must be production or planning and the preference is used as the tie breaker. Once established the LTC accesses the route and sums all the resource throughputs for the primary resource that are fixed and then again for those that are proportional. The average hours for a working day is established from the organization calendar (we will assume 24 hour for convenience). The summed fixed lead time is then used to populate the Fixed Lead Time on the Organization Item form. The summed proportional lead times is then converted to the amount of time (as a proportion of a day) to make 1 of the product. This is then used as the Variable Lead Time in the Organization Item form.