/*From  [ID 1059974.1]*/
Formulas                     : GMD_FORMULA_PUB , GMD_FORMULA_DETAIL_PUB
Recipes                      : GMD_RECIPE_HEADER , GMD_RECIPE_DETAIL
Routings                     : GMD_ROUTINGS_PUB
Routing Steps / Dependencies : GMD_ROUTING_STEPS_PUB
Operations                   : GMD_OPERATIONS_PUB
Activities                   : GMD_ACTIVITIES_PUB 
Resources                    : GMP_RESOURCES_PUB (Generic) , GMP_RESOURCE_DTL_PUB (Plant)
Operation Activities         : GMD_OPERATION_ACTIVITIES_PUB
Operation Resources          : GMD_OPERATION_RESOURCES_PUB 


Batch 
Example 1: Creation of batch   gme_api_pub.create_batch
Example 4: Release  Batch (    gme_api_pub.release_batch  )   and Save Batch  ( gme_api_pub.save_batch)
Example 5: Create a batch and insert an additional material line     (gme_api_pub.insert_material_line &  gme_api_pub.save_batch )
Example 6: Insert_line_allocation API   (gme_api_pub.insert_line_allocation  )
Example 7: Close (Complete)  Batch   (gme_api_pub.certify_batch)
Example 8: Release, Record Usage and Complete Step  (gme_api_pub.release_step , gme_api_pub.update_actual_rsrc_usage,    gme_api_pub.certify_step)
Related Documents

/*Get Item costs for item by periods or transaction date.*/
gmf_cmcommon.process_item_unit_cost 

/*calculation logic of batch Planned start/complettion dates */
gme_create_step_pvt.CALC_DATES

/*Concurrent program to calculate the fixed and variable lead times and update item master*/
Lead Time Calculator for Process (gmp_lead_time_calculator_pkg.calculate_lead_times)

-- First Turn off the formula security
 gmd_p_fs_context.set_additional_attr ;
 
 /*Get FORMULA/FORMULA/ROUTING/OPERATION/VALIDITY */
gmd_api_grp.GET_OBJECT_NAME_VERSION ('FORMULA',formula_id)

/*Scaling formulas*/
GMD_COMMON_SCALE.SCALE
gmd_formula_designer_pkg.SCALE_FORMULA