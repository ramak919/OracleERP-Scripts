/* Formatted on 2014/09/24 11:07 (Formatter Plus v4.8.8) rama.koganti*/
/*Formula Security Enabled*/
Select Gvs.Active_formula_ind Formul_security_enabled
     , Gvs.Last_update_date
     , Gvs.Last_updated_by
From   Gmd_vpd_security Gvs
Where  1 = 1;

/*What levels the formula security is enabled at*/
Select Inv_detail_util_pvt.Get_organization_code (Gsc.Organization_id) Org
     , Gsc.Object_type
     , Gsc.User_ind
     , Gsc.Responsibility_ind
     , Gsc.Organization_id
From   Gmd_security_control Gsc
Where  1 = 1;


--select mtl.organization_code, mtl.organization_name, mtl.organization_id
--from gmd_security_control gsc, gmd_org_access_vw mtl
--where gsc.organization_id = mtl.organization_id
--order by 1

/* Formatted on 2014/09/24 11:15 (Formatter Plus v4.8.8) rama.koganti*/
/*Security Profiles*/
Select Inv_detail_util_pvt.Get_organization_code (Gsp.Organization_id) Org
     , Fnd_user_ap_pkg.Get_user_name (Gsp.User_id) User_name
     , Om_setup_valid_pkg.Getrespname (Gsp.Responsibility_id) Resp_name
     , Inv_meaning_sel.C_fnd_lookup_vl (Gsp.Assign_method_ind, 'GMD_SECURITY_ASSIGN_METHOD')
                                                                                      Assign_method
     , Inv_meaning_sel.C_fnd_lookup_vl (Gsp.Access_type_ind, 'GMD_SECURITY_ACCESS_LEVEL')
                                                                                       Access_level
     , Inv_detail_util_pvt.Get_organization_code (Gsp.Other_organization_id) Other_org
     , Gsp.Object_type
     , Gsp.Security_profile_id
     ,FND_USER_AP_PKG.get_user_name(gsp.LAST_UPDATED_BY)LAST_UPDATED_BY
     , gsp.LAST_UPDATE_DATE
       ,FND_USER_AP_PKG.get_user_name(gsp.created_BY)CREATED_BY
     , gsp.CREATION_DATE
--     , gsp.
From   Gmd_security_profiles Gsp
Where  1 = 1
order by gsp.LAST_UPDATE_DATE desc
;


/* Formatted on 2014/09/24 11:18 (Formatter Plus v4.8.8) rama.koganti*/
Select Gmd_api_grp.Get_object_name_version ('FORMULA', Gfs.Formula_id) Formula
     , Fnd_user_ap_pkg.Get_user_name (Gfs.User_id) User_name
     , Om_setup_valid_pkg.Getrespname (Gfs.Responsibility_id) Resp_name
     , Inv_meaning_sel.C_fnd_lookup_vl (Gfs.Access_type_ind, 'GMD_SECURITY_ACCESS_LEVEL')
                                                                                       Access_level
     , Inv_detail_util_pvt.Get_organization_code (Gfs.Other_organization_id) Other_org
From   Gmd_formula_security Gfs
Where  1 = 1;

/*Organization Access*/
Select   O.Organization_code
       , O.Organization_name
       , O.Organization_id
       , Om_setup_valid_pkg.Getrespname (O.Responsibility_id)
From     Org_access_view O
       , Mtl_parameters M
Where    M.Organization_id = O.Organization_id
And      Process_enabled_flag = 'Y'
--And      O.Organization_code = 'PA6'
--AND O.RESPONSIBILITY_ID=23200
--and responsibility_id = :parameter.resp_id
Order By O.Organization_code;

--/* Formatted on 2014/09/24 09:51 (Formatter Plus v4.8.8) rama.koganti*/
--Select *
--From   Org_access_v
--Where  1 = 1;

--Select *
--From   Org_access
--Where  1 = 1;

/*User Responsibility Access*/

   /* Formatted on 2014/09/24 09:51 (Formatter Plus v4.8.8) rama.koganti*/
Select   Fu.User_name
       , Fr.Responsibility_name
       , Fu.User_id
       , Fr.Responsibility_id Resp_id
       , Furg.Responsibility_application_id Resp_appl_id
       , Furg.Security_group_id Sec_group_id
From     Fnd_user_resp_groups Furg
       , Fnd_user Fu
       , Fnd_responsibility_vl Fr
Where    Furg.User_id = Fu.User_id
And      Upper (Fu.User_name) = 'RAMA.KOGANTI'
And      Furg.Responsibility_id = Fr.Responsibility_id
Order By 1;

Sfw fm_form_mst