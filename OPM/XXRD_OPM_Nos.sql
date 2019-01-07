/* Formatted on 1/23/2015 1:23:02 PM (QP5 v5.256.13226.35510) */
SELECT
       (SELECT
               COUNT (*)
        FROM
               apps.ORG_ORGANIZATION_DEFINITIONS ood, apps.mtl_parameters mtp
        WHERE
               1 = 1
        AND    (OOD.DISABLE_DATE IS NULL
        OR      OOD.DISABLE_DATE > SYSDATE)
        AND    OOD.ORGANIZATION_id = MTP.ORGANIZATION_ID
        AND    MTP.PROCESS_ENABLED_FLAG = 'Y')
          OPM_orgs
      , (SELECT
                'Plant : ' || SUM (GPH.PLANT_IND) || ', Lab : ' || SUM (GPH.LAB_IND) plant_lab
         FROM
                apps.Gmd_parameters_hdr gph, apps.ORG_ORGANIZATION_DEFINITIONS ood
         WHERE
                1 = 1
         AND    (OOD.DISABLE_DATE IS NULL
         OR      OOD.DISABLE_DATE > SYSDATE)
         AND    GPh.ORGANIZATION_ID = OOD.ORGANIZATION_ID)
          plant_lab_orgs
      , (SELECT
                LISTAGG (OOD.ORGANIZATION_CODE, ',') WITHIN GROUP (ORDER BY OOD.ORGANIZATION_CODE)
         FROM
                apps.ORG_ORGANIZATION_DEFINITIONS ood, apps.mtl_parameters mtp
         WHERE
                1 = 1
         AND    (OOD.DISABLE_DATE IS NULL
         OR      OOD.DISABLE_DATE > SYSDATE)
         AND    OOD.ORGANIZATION_id = MTP.ORGANIZATION_ID
         AND    MTP.PROCESS_ENABLED_FLAG = 'Y'
         AND    NOT EXISTS
                   (SELECT
                           *
                    FROM
                           Gmd_parameters_hdr gph
                    WHERE
                           1 = 1
                    AND    GPH.ORGANIZATION_ID = OOD.ORGANIZATION_ID))
          not_plant_orgs
      , (SELECT
                COUNT (*)
         FROM
                apps.Gmd_quality_config gqc, apps.ORG_ORGANIZATION_DEFINITIONS ood
         WHERE
                1 = 1
         AND    Gqc.Quality_lab_ind = 'Y'
         AND    (OOD.DISABLE_DATE IS NULL
         OR      OOD.DISABLE_DATE > SYSDATE)
         AND    gqc.ORGANIZATION_ID = OOD.ORGANIZATION_ID)
          Quality_org
      , (                                                                                                                             /*Formula classes*/
         SELECT
                COUNT (*)
         FROM
                apps.FM_FORM_CLS
         WHERE
                1 = 1)
          formula_clas
      , (                                                                                                                           /*Operation Classes*/
         SELECT
                COUNT (*)
         FROM
                apps.FM_OPRN_CLS
         WHERE
                1 = 1)
          Oprn_class
      , (SELECT
                COUNT (*)
         FROM
                apps.FM_ROUT_CLS
         WHERE
                1 = 1)
          routing_class
      , (SELECT
                COUNT (*)
         FROM
                apps.cr_rsrc_cls
         WHERE
                1 = 1)
          resource_class
      ,                                                                                                                                    /*Activities*/
        (SELECT
                COUNT (*)
         FROM
                apps.gmd_activities_vl
         WHERE
                1 = 1)
          Activities
      , (SELECT
                COUNT (*)
         FROM
                apps.CR_RSRC_MST_VL crm
         WHERE
                1 = 1)
          resources
      , (SELECT
                COUNT (*)
         FROM
                apps.GMP_RESOURCE_PARAMETERS grp
         WHERE
                1 = 1)
          resource_parmeters                                                                                         /*Parmeters assigned to resources */
      , (SELECT
                COUNT (*)
         FROM
                apps.GMP_PROCESS_PARAMETER_SET_VL gpps
         WHERE
                1 = 1)
          Process_param_set                                                                                            /*Generic Parametes sets defined*/
      , (SELECT
                COUNT (*)
         FROM
                apps.GMP_PROCESS_PARAMETERS_VL
         WHERE
                1 = 1)
          Process_parameters
      , (SELECT
                COUNT (*)
         FROM
                apps.gmd_tech_parameters_vl
         WHERE
                1 = 1)
          lab_technical_parameters
      , (SELECT
                COUNT (*)
         FROM
                apps.MTL_DEFAULT_CATEGORY_SETS_FK_V mdcs
         WHERE
                1 = 1
         AND    MDCS.FUNCTIONAL_AREA_DESC = 'Process Technical Class'
         AND    MDCS.FUNCTIONAL_AREA_ID = 16
         AND    MDCS.CATEGORY_SET_NAME IS NOT NULL)
          technical_classes
      , (SELECT
                COUNT (*)
         FROM
                apps.Gme_parameters gph, apps.ORG_ORGANIZATION_DEFINITIONS ood
         WHERE
                1 = 1
         AND    (OOD.DISABLE_DATE IS NULL
         OR      OOD.DISABLE_DATE > SYSDATE)
         AND    GPh.ORGANIZATION_ID = OOD.ORGANIZATION_ID)
          GME_orgs
      , (SELECT
                COUNT (*)                                                                                                         /*make to order rules*/
         FROM
               apps. GME_MTO_RULES gmr
         WHERE
                1 = 1)
          MTO_RULES
      , (SELECT
                COUNT (*)
         FROM
                apps.Gmd_security_control Gsc, apps.Org_organization_definitions Ood
         WHERE
                1 = 1
         AND    (OOD.DISABLE_DATE IS NULL
         OR      OOD.DISABLE_DATE > SYSDATE)
         AND    Gsc.Organization_id = Ood.Organization_id)
          Formula_security
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_SECURITY_PROFILES gps
         WHERE
                1 = 1)
          Formula_security_profiles
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_GENERATION
         WHERE
                1 = 1)
          RECIPE_GENERATION_rules
FROM
       DUAL
WHERE
       1 = 1;


/*Need to chec if the components are in valid organizaitons*/

SELECT
       (SELECT
               COUNT (*)
        FROM
               apps.FM_FORM_MST_VL ffm
        WHERE
               1 = 1
        AND    FFM.FORMULA_STATUS <> 1000)
          formula
      ,'routing ->' rout
      , (SELECT
                COUNT (*)
         FROM
                apps.fm_rout_hdr frh
         WHERE
                1 = 1
         AND    (FRH.EFFECTIVE_END_DATE IS NULL
         OR      FRH.EFFECTIVE_END_DATE > SYSDATE)
         AND    FRH.ROUTING_STATUS <> 1000)
          routings
      , (SELECT
                COUNT (*)
         FROM
                apps.FM_ROUT_DEP frd, apps.fm_rout_hdr frh
         WHERE
                1 = 1
         AND    FRD.ROUTING_ID = FRH.ROUTING_ID
         AND    FRH.ROUTING_STATUS <> 1000
         AND    (FRH.EFFECTIVE_END_DATE IS NULL
         OR      FRH.EFFECTIVE_END_DATE > SYSDATE))
          routing_step_dependecies
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_OPERATIONS_VL go
         WHERE
                1 = 1
         AND    GO.OPERATION_STATUS <> 1000)
          Operations
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_OPRN_PROCESS_PARAMETERS
         WHERE
                1 = 1)
          OPRN_process_param
      , (SELECT
                COUNT (*)
         FROM
                apps.fm_text_tbl
         WHERE
                1 = 1)
          instruction_txt
      ,'Recipe ->' RCP
      , (SELECT
                COUNT (*)
         FROM
                apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GR.RECIPE_STATUS <> 1000)
          recipe
      , (SELECT
                'Prod:'||sum(decode( grvr.RECIPE_USE,0,1,0)) 
 || ', Plan:'||sum(decode( grvr.RECIPE_USE,1,1,0)) 
  || ', Cost:'||sum(decode( grvr.RECIPE_USE,2,1,0)) 
  || ', Reg:'||sum(decode( grvr.RECIPE_USE,3,1,0)) 
  || ', Tech:'||sum(decode( grvr.RECIPE_USE,4,1,0)) Recipe_use
         FROM
                apps.gmd_recipe_validity_rules grvr
         WHERE
                1 = 1
         AND    (GRVR.END_DATE IS NULL
         OR      GRVR.END_DATE > SYSDATE)
         AND    GRVR.VALIDITY_RULE_STATUS <> 1000
		 group by grvr.RECIPE_USE
		 )
          validity_rule
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_STEP_MATERIALS grsm, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GR.RECIPE_ID = GRSM.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000)
          RCP_step_mtrl_assoc
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_PROCESS_LOSS t1, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    T1.PROCESS_LOSS <> 0
         AND    t1.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          RCP_process_Loss
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_CUSTOMERS grrs, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GRRS.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          RCP_CUSTOMERS
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_ROUTING_STEPS grrs, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GRRS.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          RCP_routing_steps
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_ORGN_RESOURCES grrs, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GRRS.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          Rcp_resoruces
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_ORGN_ACTIVITIES grrs, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GRRS.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          RCP_ORGN_Activities
      , (SELECT
                COUNT (*)
         FROM
                apps.GMD_RECIPE_PROCESS_PARAMETERS grrs, apps.gmd_recipes gr
         WHERE
                1 = 1
         AND    GRRS.RECIPE_ID = GR.RECIPE_ID
         AND    GR.RECIPE_STATUS <> 1000
         AND    GR.DELETE_MARK <> 1)
          RCP_PROcess_Param
      ,'Resources ->' Rsrc
      , (SELECT
                COUNT (*)
         FROM
                apps.CR_RSRC_MST_VL crm
         WHERE
                1 = 1)
          resources
      , (SELECT
                COUNT (*)
         FROM
                apps.GMP_RESOURCE_PARAMETERS grp
         WHERE
                1 = 1)
          Rsrc_param_association                                                                                     /*Parmeters assigned to resources */
      , (SELECT
                COUNT (*)
         FROM
                apps.CR_ARES_MST
         WHERE
                1 = 1)
          Alternative_resources
      , (SELECT
                COUNT (*)
         FROM
                apps.gmp_resource_instances gri
         WHERE
                1 = 1)
          resource_instances
FROM
       DUAL
WHERE
       1 = 1;

/*GMF Numbers*/

SELECT
       (SELECT
               COUNT (*)
        FROM
               apps.CM_MTHD_MST cmm
			   where nvl(cmm.delete_mark,0)=0)
          cost_types
      , (SELECT
                COUNT (*)
         FROM
                apps.CM_CMPT_GRP cmm)
          cost_component_group
      , (SELECT
                COUNT (*)
         FROM
                apps.CM_CMPT_MST_VL cmm)
          cost_component_classes
      , (SELECT
                COUNT (*)
         FROM
                apps.CM_ALYS_MST cmm)
          cost_analysis_code
      , (SELECT
                COUNT (*)
         FROM
                apps.GMF_BURDEN_CODES
         WHERE
                1 = 1)
          burden_codes
      , (SELECT
                COUNT (*)
         FROM
                apps.GMF_FISCAL_POLICIES
         WHERE
                1 = 1)
          fiscal_policies
      , (SELECT
                COUNT (*)
         FROM
                apps.CM_WHSE_ASC cwa
         WHERE
                1 = 1
         AND    CWA.EFF_END_DATE > SYSDATE)
          cost_org_assoc
FROM
       DUAL
WHERE
       1 = 1;


/* Formatted on 12/23/2014 3:28:26 PM (QP5 v5.256.13226.35510) */
SELECT
       INV_EBI_UTIL.GET_MASTER_ORGANIZATION (MSI.ORGANIZATION_ID) master_org
      ,SUM (DECODE (NVL (MSI.process_execution_enabled_flag, 'N'), 'Y', 1, 0)) OPM_GME
      ,SUM (DECODE (NVL (MSI.RECIPE_ENABLED_FLAG, 'N'), 'Y', 1, 0)) OPM_Recipe
      ,SUM (DECODE (NVL (MSI.process_quality_enabled_flag, 'N'), 'Y', 1, 0)) OPM_quality
      ,SUM (DECODE (NVL (MSI.process_costing_enabled_flag, 'N'), 'Y', 1, 0)) OPM_Costing
      ,SUM (DECODE (NVL (MSI.LOT_CONTROL_CODE, '1'), '2', 1, 0)) Lot_control  
      ,SUM (DECODE (NVL (MSI.child_lot_flag, 'N'), 'Y', 1, 0))child_lot_flag
      ,SUM (DECODE (NVL (MSI.grade_control_flag, 'N'), 'Y', 1, 0))grade_control
      ,SUM (DECODE (NVL (MSI.must_use_approved_vendor_flag, 'N'), 'Y', 1, 0)) ASL
      ,SUM (DECODE (NVL (MSI.purchasing_enabled_flag, 'N'), 'Y', 1, 0)) Purchaseable
      ,SUM (DECODE (NVL (MSI.INVENTORY_PLANNING_CODE, 6), 6, 0, 1)) inventory_Planning      
      ,SUM (DECODE ( length (MSI.SECONDARY_UOM_CODE), 0, 0, 1)) Second_Uom
FROM
       mtl_system_items_b msi
WHERE
       1 = 1
--       and MSI.SEGMENT1='80859'
AND    MSI.INVENTORY_ITEM_FLAG = 'Y'
AND    MSI.STOCK_ENABLED_FLAG = 'Y'
AND    MSI.ORGANIZATION_ID = INV_EBI_UTIL.GET_MASTER_ORGANIZATION (MSI.ORGANIZATION_ID)
GROUP BY
       INV_EBI_UTIL.GET_MASTER_ORGANIZATION (MSI.ORGANIZATION_ID);


