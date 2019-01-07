select * 
from gmd_recipes_b  t1
where recipe_no  like '%80932%' 
and t1.RECIPE_STATUS <>1000
--and recipe_version = 'version' ;

--specify the recipe and version for the product 

--2) 

select t1.VALIDITY_RULE_STATUS,t1.*
from gmd_recipe_validity_rules  t1
where 1=1
 and recipe_id  in (3111,4719,4720)
and recipe_use = 0 
aND validity_rule_status IN ('700', '900') 
AND nvl (end_date, (sysdate + 1)) > sysdate 
;

--This should only return 1 row, if it does not please just pick one to use. 
--3) 

/* Formatted on 2014/08/19 13:43 (Formatter Plus v4.8.8) rama.koganti*/
Select *
From   Fm_form_mst_b
Where  Formula_id In (Select Formula_id
                      From   Gmd_recipes_b
                      Where  Recipe_id In (Select Recipe_id
                                           From   Gmd_recipe_validity_rules
                                           Where  Recipe_validity_rule_id In (4743, 6877, 6879)));

--4) 

select * 
from fm_matl_dtl 
where formula_id in 
(Select Formula_id
                      From   Gmd_recipes_b
                      Where  Recipe_id In (Select Recipe_id
                                           From   Gmd_recipe_validity_rules
                                           Where  Recipe_validity_rule_id In (4743, 6877, 6879)));

--5) 

select * 
from gmd_material_effectivities_vw 
where formula_id in (
Select Formula_id
                      From   Gmd_recipes_b
                      Where  Recipe_id In (Select Recipe_id
                                           From   Gmd_recipe_validity_rules
                                           Where  Recipe_validity_rule_id In (4743, 6877, 6879)));

/* Formatted on 2014/08/19 13:47 (Formatter Plus v4.8.8) rama.koganti*/
--6) 
Select Inventory_item_id
     , Segment1
     , Organization_id
     , Enabled_flag
     , Description
     , Bom_enabled_flag
     , Build_in_wip_flag
     , Planning_time_fence_code
     , Lead_time_lot_size
     , Planning_time_fence_days
     , Demand_time_fence_days
     , Planning_exception_set
     , Bom_item_type
     , Fixed_lead_time
     , Variable_lead_time
     , Primary_unit_of_measure
     , Planner_code
     , Planning_make_buy_code
     , Fixed_lot_multiplier
     , Rounding_control_type
     , Postprocessing_lead_time
     , Preprocessing_lead_time
     , Full_lead_time
     , Mrp_safety_stock_percent
     , Mrp_safety_stock_code
     , Min_minmax_quantity
     , Max_minmax_quantity
     , Minimum_order_quantity
     , Fixed_order_quantity
     , Fixed_days_supply
     , Maximum_order_quantity
     , Safety_stock_bucket_days
     , Mrp_planning_code
     , Dual_uom_control
     , Secondary_uom_code
     , Planned_inv_point_flag
     , Critical_component_flag
     , Continous_transfer
     , Convergence
     , Divergence
     , Hold_days
     , Maturity_days
     , Process_execution_enabled_flag
     , Process_yield_subinventory
     , Recipe_enabled_flag
     , Allowed_units_lookup_code
From   Mtl_system_items
Where  Inventory_item_id In (
                      Select Inventory_item_id
                      From   Fm_matl_dtl
                      Where  Formula_id In (
                                            Select Formula_id
                                            From   Gmd_recipes_b
                                            Where  Recipe_id in
                                                             (Select Recipe_id
                                                              From   Gmd_recipe_validity_rules
                                                              Where  Recipe_validity_rule_id In (4743, 6877, 6879))));
                                                              
--7)  /*NO data starting point*

select * 
from GMD_RECIPE_ORGN_ACTIVITIES 
where recipe_id in 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in (4743, 6877, 6879)) ;


--8) 
select * 
from GMD_RECIPE_ORGN_RESOURCES 
where recipe_id in 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id  in(4743, 6877, 6879));

--9) 
select * 
from GMD_RECIPE_ROUTING_STEPS 
where recipe_id in 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in(4743, 6877, 6879));

--10) 
select * 
from GMD_RECIPE_STEP_MATERIALS 
where recipe_id in 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in(4743, 6877, 6879));

--11) 
select * 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id in 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in(4743, 6877, 6879)));

--12) 
select * 
from fm_rout_dtl 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id in
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in(4743, 6877, 6879))));

--13) 
select * 
from gmd_operations_b 
where oprn_id in 
(select oprn_id 
from fm_rout_dtl 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id IN
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id in(4743, 6877, 6879)))));

--14) 
select * 
from fm_rout_dep 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>))) 

--15) 
select * 
from gmd_operation_activities 
where oprn_id in 
(select oprn_id 
from fm_rout_dtl 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>)))) 

--16) 

select * 
from gmd_operation_resources 
where oprn_line_id in 
(select oprn_line_id 
from gmd_operation_activities 
where oprn_id in 
(select oprn_id 
from fm_rout_dtl 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>))))) 

--17) 
select * 
from cr_rsrc_dtl 
where resources in 
(select resources 
from gmd_operation_resources 
where oprn_line_id in 
(select oprn_line_id 
from gmd_operation_activities 
where oprn_id in 
(select oprn_id 
from fm_rout_dtl 
where routing_id in 
(select routing_id 
from gmd_routings_b 
where routing_id in 
(select routing_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>)))))) 

--18) 
select * 
from MTL_UOM_CLASS_CONVERSIONS 
where inventory_item_id = 0 

--19) 
select * 
from MTL_UOM_CONVERSIONS 
where inventory_item_id = 0 

--20) 
select * 
from MTL_UOM_CONVERSIONS 
where inventory_item_id in 
(SELECT inventory_item_id 
from fm_matl_dtl 
where formula_id in 
(select formula_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>)) 

--21) 

select * 
from MTL_UOM_CLASS_CONVERSIONS 
where inventory_item_id in 
(SELECT inventory_item_id 
from fm_matl_dtl 
where formula_id in 
(select formula_id 
from gmd_recipes_b 
where recipe_id = 
(select recipe_id 
from gmd_recipe_validity_rules 
where recipe_validity_rule_id = < recipe_validity_rule_id from 2) above>)) 

--22) 
Select * 
From cr_ares_mst 

--23) 
Select * 
From GMP_ALTRESOURCE_PRODUCTS 

--24) 
select * 
from GMD_PARAMETERS_HDR 

--25) 
select * 
from GMD_PARAMETERS_DTL 

--26) 

select fpo.profile_option_name Profile, 
fpov.profile_option_value Value, 
decode(fpov.level_id,10001, 
'SITE',10002, 
'APPLICATION',10003, 
'RESPONSIBILITY', 
10004,'USER')"LEVEL", 
fa.application_short_name App, 
fr.responsibility_name Responsibility, 
fu.user_name "USER" 
from fnd_profile_option_values fpov, 
fnd_profile_options fpo, 
fnd_application fa, 
fnd_responsibility_vl fr, 
fnd_user fu, 
fnd_logins fl 
where fpo.profile_option_id=fpov.profile_option_id 
and fa.application_id(+)=fpov.level_value 
and fr.application_id(+)=fpov.level_value_application_id 
and fr.responsibility_id(+)=fpov.level_value 
and fu.user_id(+)=fpov.level_value 
and fl.login_id(+) = fpov.LAST_UPDATE_LOGIN 
and fpo.profile_option_name LIKE ('%BOM:HOUR_UOM_CODE%') 
order by 1,3 
;