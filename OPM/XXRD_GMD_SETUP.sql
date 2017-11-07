
/*Responsibility: Product Development Security Manager*/
/* Formatted on 1/12/2015 2:13:20 PM (QP5 v5.256.13226.35510) */
SELECT
       Inv_detail_util_pvt.Get_organization_code (Gph.Organization_id) Org
      ,INV_meaning_sel.c_fnd_lookup_vl (gph.Lab_ind, 'GMI_YES_NO') Lab
      ,INV_meaning_sel.c_fnd_lookup_vl (Gph.Plant_ind, 'GMI_YES_NO') plant
      ,DECODE (Gpd.Parameter_type,  1, 'Formula',  2, 'Operation',  3, 'Routing',  4, 'Recipe',  5, 'Substitution',  6, 'Lab',  Gpd.Parameter_type)
          Param_type
      ,Gl.Meaning param_name
      --      ,Gpd.Parameter_value
      ,NVL (
          INV_meaning_sel.c_fnd_lookup_vl (
             GPD.PARAMETER_VALUE
            ,DECODE (GPD.PARAMETER_NAME
                    ,'FM$DEFAULT_RELEASE_TYPE', 'GMD_MATERIAL_RELEASE_TYPE'
                    ,'GMD_ZERO_INGREDIENT_QTY', 'GMD_ZERO_INGREDIENT_QTY'
                    ,'GMD_BYPRODUCT_ACTIVE', 'GMI_YES_NO'
                    ,'GMD_FORMULA_VERSION_CONTROL', 'GMF_YESNO_FLAG'
                    ,'GMI_LOTGENE_ENABLE_FMSEC', 'GMI_YES_NO'
                    ,'GMD_AUTO_PROD_CALC', 'GMF_YESNO_FLAG'
                    ,'GMD_OPERATION_VERSION_CONTROL', 'GMF_YESNO_FLAG'
                    ,'GMD_ENFORCE_STEP_DEPENDENCY', 'GMI_YES_NO'
                    ,'GMD_ROUTING_VERSION_CONTROL', 'GMF_YESNO_FLAG'
                    ,'STEPRELEASE_TYPE', 'STEPRELEASE_TYPE'
                    ,'GMD_RECIPE_VERSION_CONTROL', 'GMF_YESNO_FLAG'
                    ,'GMD_SUBS_VERSION_CONTROL', 'GMF_YESNO_FLAG'
                    ,'GMD_RECIPE_TYPE', 'GMD_RECIPE_TYPE'))
         ,Gpd.Parameter_value)
          param_value
      ,Fnd_user_ap_pkg.Get_user_name (Gpd.Created_by) Created_by
      ,Gpd.Creation_date
      ,Fnd_user_ap_pkg.Get_user_name (Gpd.Last_updated_by) Last_updated_by
      ,Gpd.Last_update_date
      ,DECODE (GPD.PARAMETER_NAME
              ,'FM$DEFAULT_RELEASE_TYPE', 'GMD_MATERIAL_RELEASE_TYPE'
              ,'GMD_ZERO_INGREDIENT_QTY', 'GMD_ZERO_INGREDIENT_QTY'
              ,'GMD_BYPRODUCT_ACTIVE', 'GMI_YES_NO'
              ,'GMD_FORMULA_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMI_LOTGENE_ENABLE_FMSEC', 'GMI_YES_NO'
              ,'GMD_AUTO_PROD_CALC', 'GMF_YESNO_FLAG'
              ,'GMD_OPERATION_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_ENFORCE_STEP_DEPENDENCY', 'GMI_YES_NO'
              ,'GMD_ROUTING_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'STEPRELEASE_TYPE', 'STEPRELEASE_TYPE'
              ,'GMD_RECIPE_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_SUBS_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_RECIPE_TYPE', 'GMD_RECIPE_TYPE')
          lookup_code
      ,Gpd.Parameter_name
      ,Gpd.Parameter_type
      ,Gph.Organization_id
      ,Gpd.Parameter_id
      ,Gpd.Parameter_line_id
FROM
       Gmd_parameters_dtl Gpd, Gmd_parameters_hdr Gph, Gem_lookups Gl
WHERE
       1 = 1
--AND    GPH.ORGANIZATION_ID IS NULL
--AND    GPD.PARAMETER_TYPE = 4
--And      Gph.Organization_id = 377
AND    Gl.Lookup_code = Gpd.Parameter_name
AND    Gl.Lookup_type IN ('GMD_FORMULA_PARAMETER'
                         ,'GMD_OPERATION_PARAMETER'
                         ,'GMD_ROUTING_PARAMETER'
                         ,'GMD_RECIPE_PARAMETER'
                         ,'GMD_SUBSTITUTION_PARAMETER'
                         ,'GMD_LAB_PARAMETER')
AND    Gph.Parameter_id = Gpd.Parameter_id
UNION
SELECT
       MTP.ORGANIZATION_CODE org
      ,INV_meaning_sel.c_fnd_lookup_vl (gph.Lab_ind, 'GMI_YES_NO') Lab
      ,INV_meaning_sel.c_fnd_lookup_vl (Gph.Plant_ind, 'GMI_YES_NO') plant
      ,DECODE (l.Lookup_type
              ,'GMD_FORMULA_PARAMETER', 'Formula'
              ,'GMD_OPERATION_PARAMETER', 'Operation'
              ,'GMD_ROUTING_PARAMETER', 'Routing'
              ,'GMD_RECIPE_PARAMETER', 'Recipe'
              ,'GMD_SUBSTITUTION_PARAMETER', 'Substitution'
              ,'GMD_LAB_PARAMETER', 'Lab')
          Param_type
      --      ,lookup_code parameter_name
      ,L.MEANING param_name
      ,NULL PARAMETER_VALUE
      ,Fnd_user_ap_pkg.Get_user_name (Gph.Created_by) Created_by
      ,Gph.Creation_date
      ,Fnd_user_ap_pkg.Get_user_name (Gph.Last_updated_by) Last_updated_by
      ,Gph.Last_update_date
      ,DECODE (L.LOOKUP_CODE
              ,'FM$DEFAULT_RELEASE_TYPE', 'GMD_MATERIAL_RELEASE_TYPE'
              ,'GMD_ZERO_INGREDIENT_QTY', 'GMD_ZERO_INGREDIENT_QTY'
              ,'GMD_BYPRODUCT_ACTIVE', 'GMI_YES_NO'
              ,'GMD_FORMULA_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMI_LOTGENE_ENABLE_FMSEC', 'GMI_YES_NO'
              ,'GMD_AUTO_PROD_CALC', 'GMF_YESNO_FLAG'
              ,'GMD_OPERATION_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_ENFORCE_STEP_DEPENDENCY', 'GMI_YES_NO'
              ,'GMD_ROUTING_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'STEPRELEASE_TYPE', 'STEPRELEASE_TYPE'
              ,'GMD_RECIPE_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_SUBS_VERSION_CONTROL', 'GMF_YESNO_FLAG'
              ,'GMD_RECIPE_TYPE', 'GMD_RECIPE_TYPE')
          lookup_code
      ,NULL Parameter_name
      ,NULL Parameter_type
      ,Gph.Organization_id
      ,NULL Parameter_id
      ,NULL Parameter_line_id
FROM
       gem_lookups l, mtl_parameters mtp, Gmd_parameters_hdr Gph
WHERE
       1 = 1
--AND    GPH.ORGANIZATION_ID IS NULL
/*standard Joins*/
AND    GPH.ORGANIZATION_ID = MTP.ORGANIZATION_ID(+)
AND    l.Lookup_type IN ('GMD_FORMULA_PARAMETER'
                        ,'GMD_OPERATION_PARAMETER'
                        ,'GMD_ROUTING_PARAMETER'
                        ,'GMD_RECIPE_PARAMETER'
                        ,'GMD_SUBSTITUTION_PARAMETER'
                        ,'GMD_LAB_PARAMETER')
AND    ENABLED_FLAG = 'Y'
AND    NOT EXISTS
          (SELECT
                  1
           FROM
                  gmd_parameters_dtl d, gmd_parameters_hdr h
           WHERE
                  d.parameter_id = h.parameter_id
           AND    ( (h.organization_id = mtp.organization_id)
           OR      ( (h.organization_id IS NULL)))
           AND    d.parameter_name = l.lookup_code)
ORDER BY
       ORGANIZATION_ID, Param_type, PARAM_NAME;
       
       
--   GMD_PARAMETERS_DTL_PKG.GET_PARAMETER_LIST

--gmd_api_grp.FETCH_PARM_VALUES

/* Formatted on 2014/08/19 10:44 (Formatter Plus v4.8.8) rama.koganti*/
/*Formula Security Control*/
Select Ood.Organization_code
     , Gsc.Object_type
     , Gsc.User_ind
     , Gsc.Responsibility_ind
     , Gsc.Created_by
     , Gsc.Creation_date
     , Gsc.Last_update_date
     , Gsc.Last_update_login
     , Gsc.Last_updated_by
From   Gmd_security_control Gsc
     , Org_organization_definitions Ood
Where  1 = 1
And    Gsc.Organization_id = Ood.Organization_id;


/* Formatted on 1/13/2015 4:12:53 PM (QP5 v5.256.13226.35510) */
SELECT
       INV_detail_util_pvt.get_organization_code (GSP.ORGANIZATION_ID) org
      ,INV_detail_util_pvt.get_organization_code (GSP.OTHER_ORGANIZATION_ID) other_org
      ,FND_USER_AP_PKG.get_user_name (GSP.USER_ID) User_name
      ,OM_SETUP_VALID_PKG.GETRESPNAME (GSP.RESPONSIBILITY_ID) responsibility
      ,INV_meaning_sel.c_fnd_lookup_vl (GSP.ASSIGN_METHOD_IND, 'GMD_SECURITY_ASSIGN_METHOD') Assign_Method
      ,INV_meaning_sel.c_fnd_lookup_vl (GSP.ACCESS_TYPE_IND, 'GMD_SECURITY_ACCESS_LEVEL') Access_Level
      ,GSP.OBJECT_TYPE
--      ,GSP.ORGN_CODE
--      ,GSP.OTHER_ORGN
      ,GSP.SECURITY_PROFILE_ID
      ,GSp.RESPONSIBILITY_ID
      ,GSP.USER_ID
      ,GSP.ORGANIZATION_ID
      ,gsp.OTHER_ORGANIZATION_ID
      ,GSP.CREATED_BY
      ,GSP.CREATION_DATE
      ,GSP.LAST_UPDATE_DATE
      ,GSP.LAST_UPDATED_BY
FROM
       GMD_SECURITY_PROFILES gsp
WHERE
       1 = 1;


/*Recipe Generation Rules*/
/* Formatted on 1/12/2015 2:27:46 PM (QP5 v5.256.13226.35510) */
SELECT
       GRG.ORGANIZATION_ID
      /*Recipe use*/
      ,GRG.RECIPE_USE_PROD
      ,GRG.RECIPE_USE_PLAN
      ,GRG.RECIPE_USE_COST
      ,GRG.RECIPE_USE_REG
      ,GRG.RECIPE_USE_TECH
      /*Recipe use*/
      ,GRG.START_DATE 
      ,decode(GRG.START_DATE_TYPE,0,'Formula Date', 'Start Date') start_date_type
      /*End Date*/
      ,GRG.END_DATE_TYPE
      ,GRG.END_DATE
      ,GRG.NUM_OF_DAYS
      ,GRG.COST_CALENDAR
      /*other*/
      ,Decode (GRG.CREATION_TYPE,0,'User Initiated',1,'Automatic',2,'Optional') creation_type
      ,Decode (GRG.MANAGING_VALIDITY_RULES,0,'Next Preference',1,'First Reference',2,'End Date') Manage_validity_rules      
      ,Decode (GRG.RECIPE_NAMING_CONVENTION,1,'Formula',0,'Product') Recipe_naming_convention 
FROM
       GMD_RECIPE_GENERATION grg
WHERE
       1 = 1;


GMD_TECH_PARAMETERS_VL

GMD_RECIPE_PROCESS_PARAMETERS

GMD_OPRN_PROCESS_PARAMETERS
/* Formatted on 1/15/2015 1:19:11 PM (QP5 v5.256.13226.35510) */
/*Process Quality Parameters*/

SELECT
       Mtp.Organization_code Org
      ,Gqc.Quality_lab_ind
      /*Specs*/
      ,Inv_meaning_sel.C_fnd_lookup_vl (NVL (Gqc.Spec_version_control_ind, 'N'), 'GMD_SPEC_VERSION_CONTROL') Spec_version_control_ind
      ,GQC.EXACT_SPEC_MATCH_IND
      ,GQC.RETEST_ACTION_CODE
      ,GQC.RESAMPLE_ACTION_CODE
      /*End of Specs*/
      ,'Spec VR ->' Spec_VR
      /*Spec Validity Rules*/
      ,Gqc.Auto_sample_ind
      ,Gqc.Lot_optional_on_sample
      ,Gqc.Delayed_lot_entry
      ,Gqc.Delayed_lpn_entry
      ,Gqc.Control_batch_step_ind
      ,Gqc.Auto_complete_batch_step
      ,apps.Wms_rules_workbench_pvt.Get_reason_name (Gqc.Transaction_reason_id) Trx_reason
      ,Gqc.Sample_inv_trans_ind Update_inv_qty
      ,Gqc.Control_lot_attrib_ind
      ,Gqc.In_spec_lot_status
      --      ,Gqc.In_spec_lot_status_id
      ,Gqc.Out_of_spec_lot_status
      --      ,Gqc.Out_of_spec_lot_status_id
      /*End of Spec Validity Rules*/
      ,'Samples ->' Samples
      /*Samples*/
      ,NVL (GQC.CHOOSE_SPEC, 'N') manual_spec_selection
      ,GQC.INCLUDE_OPTIONAL_TEST_RSLT_IND Consider_optional_test_results
      ,GMF_UTILITIES_GRP.GET_ACCOUNT_CODE (NVL (GQC.DISTRIBUTION_ACCOUNT_Id, -1), OOD.LEGAL_ENTITY) acct
      ,DECODE (Gqc.Sample_assignment_type, 2, 'Automatic', 'Manual') sample_numbering
      ,Gqc.Sample_last_assigned
      /*End of Samples*/
      ,'Results->' results
      /*Results*/
      ,DECODE (GQC.API_ROUND_TRUN_IND, 'R', 'Round', 'Truncate') API_Decimal_precision
      /*End of Results*/
      ,'Stability ->' stability
      /*Stability Studies*/
      ,DECODE (GQC.SS_ASSIGNMENT_TYPE, 2, 'Automatic', 'Manual') Stabiltiy_numbering
      ,GQC.SS_LAST_ASSIGNED
      /*End of Stability Studies*/
      /*Search and replace*/
      ,GQC.DEFAULT_SPECIFICATION_STATUS
      ,Inv_meaning_sel.C_fnd_lookup_vl (GQC.MANAGE_VALIDITY_RULES_IND, 'GMD_QM_MANAGING_VALIDITY_RULES') manage_validity_rules
      /*End of Search and replace*/
      ,Gqc.Organization_id
      ,gqc.*
FROM
       Gmd_quality_config Gqc, Mtl_parameters Mtp, ORG_ORGANIZATION_DEFINITIONS ood
WHERE
       1 = 1
AND    (OOD.DISABLE_DATE IS NULL
OR      OOD.DISABLE_DATE > SYSDATE)
AND    Gqc.Quality_lab_ind IS NOT NULL
AND    OOD.ORGANIZATION_ID = gqc.ORGANIZATION_ID
AND    Mtp.Organization_id = Gqc.Organization_id;


/*GMD Status Setup*/
SELECT 
  gsn.CURRENT_STATUS ||'- '||gsc.meaning Current_Status,
  gsn.TARGET_STATUS  ||'- '||gst.meaning TARGET_STATUS,
  gsn.REWORK_STATUS  ||'- '||gsr.meaning REWORK_STATUS,
  gsn.PENDING_STATUS  ||'- '||gsp.meaning PENDING_STATUS,
  decode (gsn.WORKFLOW_INDICATOR,3,'No Workflow Approval' ,1,'Enable or Disable Workflow',2,'Workflow Approval', gsn.WORKFLOW_INDICATOR) Workflow
  /*LAST_UPDATE_DATE,
  LAST_UPDATE_LOGIN,
  LAST_UPDATED_BY,
  CREATED_BY,
  CREATION_DATE
  */
FROM GMD_STATUS_NEXT gsn
,apps.GMD_STATUS_VL gsc
,apps.GMD_STATUS_VL gst
,apps.GMD_STATUS_VL gsr
,apps.GMD_STATUS_VL gsp
WHERE 1=1
--and (CURRENT_STATUS='100')
/*Standard Joins*/
and gsn.CURRENT_STATUS=gsc.STATUS_CODE
and gsn.target_STATUS=gst.STATUS_CODE(+)
and gsn.rework_STATUS=gsr.STATUS_CODE(+)
and gsn.PENDING_STATUS=gsp.STATUS_CODE(+)
 order by gsn.CURRENT_STATUS
;

Select  gs.status_code, gs.meaning,gs.UPDATEABLE,gs.status_type,gs.version_enabled
--,gmd.delete_mark
from  apps.GMD_STATUS_VL gs
where  1=1
;


