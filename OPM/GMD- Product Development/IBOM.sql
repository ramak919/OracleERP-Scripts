/* Formatted on 2014/06/10 10:22 (Formatter Plus v4.8.8) rama.koganti*/
Select Fih.Top_formula_id
     , Ffm.Formula_desc1
     , Fih.Inventory_item_id
     , Fih.Organization_id
     , Fih.Max_explode_levels
From   Fm_ibom_hdr Fih
     , Fm_form_mst Ffm
Where  1 = 1
And    Fih.Top_formula_id = Ffm.Formula_id
And    Fih.Top_formula_id = :P_formula_id;
       
    /* Formatted on 2014/06/10 10:19 (Formatter Plus v4.8.8) rama.koganti*/

Select Distinct F.Inventory_item_id Item_id
              , I.Concatenated_segments Ingredient
              , I.Description Item_desc
              , Null Scale_qty
              , I.Primary_uom_code
              ,
                Sum (Apps.Inv_convert.Inv_um_convert (F.Inventory_item_id
                                                    , 2
                                                    , I.Organization_id
                                                    , Null
                                                    , F.Scale_qty
                                                    , F.I_qty_uom
                                                    , I.Primary_uom_code
                                                    , Null
                                                    , Null
                                                     )) Qty_needed
                                                     ,
                Sum (Apps.Inv_convert.Inv_um_convert (F.Inventory_item_id
                                                    , 2
                                                    , I.Organization_id
                                                    , Null
                                                    , F.FORMULA_QTY
                                                    , F.I_qty_uom
                                                    , I.Primary_uom_code
                                                    , Null
                                                    , Null
                                                     )) fmQty_needed
              , F.Line_type
              , F.Top_formula_id
--           i.organization_id
From            Fm_ibom_dtl F
              , Mtl_system_items_vl I
              , Fm_form_mst Ffm1
Where           I.Inventory_item_id = F.Inventory_item_id
And             F.Formula_id = Ffm1.Formula_id
And             F.Line_type Not In (1, 2)
And             F.Top_formula_id = :P_formula_id
Group By        F.Inventory_item_id
              ,
                --  f.i_qty_uom,
                I.Concatenated_segments
              , I.Description
              ,
                --    f.scale_qty,
                F.Line_type
              , F.Top_formula_id
              , I.Primary_uom_code
              , I.Organization_id
Order By        2