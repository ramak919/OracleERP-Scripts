Select  gbh.
from gme_batch_header_vw gbh
where  1=1
and gbh.BATCH_NO='70051000032'
;


Select   Ood.Organization_code||'-'||
        Gbh.Batch_no batch
        , (SELECT flv.meaning
                 FROM   apps.fnd_lookup_values_vl flv
                 WHERE      1 = 1
                        AND flv.lookup_code = GBH.Batch_status
                        AND (flv.lookup_type = 'GME_BATCH_STATUS'
                             AND gbh.batch_type = 0)
                      )current_status
                       , (SELECT flv.meaning
                 FROM   apps.fnd_lookup_values_vl flv
                 WHERE      1 = 1
                        AND flv.lookup_code = GBHi.Orig_status
                        AND (flv.lookup_type = 'GME_BATCH_STATUS'
                             AND gbh.batch_type = 0)
                      )Orig_status
                         , (SELECT flv.meaning
                 FROM   apps.fnd_lookup_values_vl flv
                 WHERE      1 = 1
                        AND flv.lookup_code = GBHi.New_status
                        AND (flv.lookup_type = 'GME_BATCH_STATUS'
                             AND gbh.batch_type = 0)
                      )New_status
       --, Inv_meaning_sel.C_fnd_lookup_vl (Gbh.batch_status, 'GME_BATCH_STATUS')||' - '||gbh.BATCH_STATUS current_status
       --, Inv_meaning_sel.C_fnd_lookup_vl (Gbhi.Orig_status, 'GME_BATCH_STATUS') || ' - ' ||gbhi.ORIG_STATUS Orig_status
      -- , Inv_meaning_sel.C_fnd_lookup_vl (Gbhi.New_status, 'GME_BATCH_STATUS') || ' - ' ||gbhi.new_STATUS New_status       
       ,  to_char ( Gbhi.LAST_UPDATE_DATE , 'DD-Mon-YYYY') status_change_date
      -- , fnd_user_ap_pkg.get_user_name(gbhi.LAST_UPDATED_BY) status_changed_by       
      ,(select fu.description  from apps.fnd_user fu where 1=1
      and fu.user_id=gbhi.LAST_UPDATED_BY  )status_changed_by
       , (Select Count (*)
          From  apps. Mtl_material_transactions Mmt
               , apps.Gme_material_details Gmd
               , apps.Gme_batch_header Gbh2
               , apps.Org_organization_definitions Ood2
          Where  1 = 1
          And    Mmt.Transaction_date >= Gbhi.Creation_date
          And    Gmd.Line_type = 1
          and gmd.LINE_NO=1
          And    Mmt.Transaction_source_type_id = 5
          And    Gbh.Organization_id = Ood2.Organization_id
          And    Mmt.Trx_source_line_id = Gmd.Material_detail_id
          And    Mmt.Transaction_source_id = Gbh.Batch_id
          And    Gmd.Batch_id = Gbh2.Batch_id
          And    Gbh2.Batch_id = Gbh.Batch_id) yield_After_completion
          , Gbh.Batch_id
     , Gbhi.event_id
From     apps.Gme_batch_history Gbhi
       , apps.Gme_batch_header Gbh
       , apps.Org_organization_definitions Ood
Where    1 = 1
and gbh.batch_id=386971
And      Gbh.Batch_id = Gbhi.Batch_id
And      Gbh.Organization_id = Ood.Organization_id
Order By 1
       , 2 Desc
       ,gbhi.LAST_UPDATE_DATE desc
       ;