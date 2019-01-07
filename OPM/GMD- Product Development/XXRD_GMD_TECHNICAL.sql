/* Formatted on 2014/09/02 10:39 (Formatter Plus v4.8.8) rama.koganti*/
Select Inv_detail_util_pvt.Get_organization_code (Gtp.Organization_id) Org
     , Gtp.Tech_parm_name
     , Gtp.Parm_description
     , Gtp.Qcassy_typ_id Quality_test_id
     , Gtp.Data_type
     , Gtp.Lm_unit_code
     /*Numeric*/
,      Gtp.Lowerbound_num
     , Gtp.Upperbound_num
     , Gtp.Signif_figures Decimal_precision
     /*End of Numeric*/
     /*Character*/
,      Gtp.Lowerbound_char
     , Gtp.Upperbound_char
     , Gtp.Max_length
     /*End of Character*/
,      Gtp.Expression_char
     /*Derived Cost*/
,      Gtp.Cost_source
     , Gtp.Cost_type
     , Gtp.Cost_function
     , Gtp.Default_cost_parameter
     /*End of Derived Cost*/
,      Gtp.Orgn_code
     , Gtp.Created_by
     , Gtp.Creation_date
     , Gtp.Last_update_date
     , Gtp.Last_update_login
     , Gtp.Last_updated_by
     , Gtp.Delete_mark
     , Gtp.In_use
     , Gtp.Tech_parm_id
     , Gtp.Organization_id
--     ,gtp.*
From   Gmd_tech_parameters_vl Gtp
Where  1 = 1;


--lm_prlt_asc

select test_code, test_desc, test_type, test_id from gmd_qc_tests where delete_mark = 0 order by 1

select COST_MTHD_CODE, COST_MTHD_DESC 
from cm_mthd_mst



--GMD_TECHNICAL_SEQUENCE_VL

/*Technical Sequences*/
/* Formatted on 2014/09/02 10:59 (Formatter Plus v4.8.8) rama.koganti*/
Select *
From   Gmd_technical_sequence_hdr Gtsh
Where  1 = 1;

Select *
From   Gmd_technical_sequence_dtl gtsd
Where  1 = 1;

GMD_TECHNICAL_DATA_VL

/* Formatted on 2014/08/20 10:22 (Formatter Plus v4.8.8) rama.koganti*/
Select   Fl.*
From    Fnd_lookup_values Fl
Where    1 = 1
and upper(fl.LOOKUP_TYPE) like upper('GMD%%%%')
/*
And    (   Upper (Fl.Lookup_code) Like Upper ('2%')
    and  Upper (Fl.MEANING ) Like Upper ('%val%')
       )
*/
Order By Fl.Lookup_type
       , Fl.Lookup_code;