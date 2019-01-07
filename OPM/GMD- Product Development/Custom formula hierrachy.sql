Rel 12 : Is There A Report To Show Formulas Where An Ingredient Is Used? (Doc ID 1336342.1)
Drop table ora_formula_hrchy;

Create table ora_formula_hrchy as
SELECT DISTINCT h.formula_id
               ,h.formula_no
               ,prod.inventory_item_id prod_id
               ,prod.organization_id prod_org
               ,i1.concatenated_segments prod_no
               ,i1.DESCRIPTION prod_Desc
               ,ingr.inventory_item_id ingr_id
               ,ingr.organization_id ingr_org
               ,i2.concatenated_segments ingr_no
               ,i2.DESCRIPTION ingR_desc
               ,ingr.qty
               ,h.formula_vers vers
               ,i1.ITEM_TYPE ingr_item_typ
               ,i2.ITEM_TYPE prd_item_typ
FROM            apps.fm_form_mst h
               ,apps.fm_matl_dtl prod
               ,apps.fm_matl_dtl ingr
               ,apps.mtl_system_items_kfv i1
               ,apps.mtl_system_items_kfv i2
WHERE         1=1
and             h.formula_id = prod.formula_id
AND             h.formula_id = ingr.formula_id
AND             (    prod.inventory_item_id = i1.inventory_item_id
                 AND prod.organization_id = i1.organization_id)
AND             (    ingr.inventory_item_id = i2.inventory_item_id
                 AND ingr.organization_id = i2.organization_id)
AND             h.delete_mark = 0
AND             prod.line_type = 1
AND             ingr.line_type = -1
AND             EXISTS (
                   SELECT 'x'
                   FROM   apps.gmd_recipes r
                         ,apps.fm_form_eff fe
                   WHERE  r.formula_id = h.formula_id
                   AND    r.recipe_id = fe.recipe_id
                   AND    fe.inventory_item_id = prod.inventory_item_id
                   AND    fe.start_date < SYSDATE
                   AND    (   fe.end_date > SYSDATE
                           OR fe.end_date IS NULL))
ORDER BY        1
               ,3
               ,6
               
create index ora_formula_hrchy_n1 on
ora_formula_hrchy (ingr_no);

create index ora_formula_hrchy_n2 on
ora_formula_hrchy (ingr_id, ingr_org);

create index ora_formula_hrchy_n3 on
ora_formula_hrchy (prod_id, prod_org);


Select  * 
from ora_formula_hrchy t1 
where  1=1
and t1.PROD_NO='10411'
;

/* Formatted on 2013/05/13 15:07 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Select     LPAD (' ', 2 * (Level - 1)) || ingr_no ingredient
          ,ingr_org
          ,ingr_item_typ ||' { '||ingr_desc||' } 'INGR_INfo
          ,prod_no
          ,prd_item_typ ||'(' || prod_desc||' } 'PROD_info
           , CONNECT_BY_ROOT prod_no as Final_Prod
          ,prod_org
          ,Level
          ,formula_no
          ,vers
         ,SYS_CONNECT_BY_PATH(prod_NO, '/') pat
--          ,sys_connect_by_path
From       ora_formula_hrchy
--Start With ingr_no = '&Ingredient'
start with prod_NO  = '&prod'
Connect By  prod_id =Prior ingr_id
And        prod_org = ingr_org
and level<3
--and prod_org='367'
;


Select  * 
from ora_formula_hrchy t1 
where  1=1
and t1.PROD_NO ='80914'
;

Select  * 
from xxrd_GMD_formula t1 
where  1=1
and t1.FORMULA_NO like '%80859 MR1301 PA5%'
--and t1.ITEM='80859'
--and t1.LINE_TYPE='Product'
--and t1.FORM_STAT in ('Approved for General Use','Frozen')
order by 1,2
;

/* Formatted on 2013/05/13 15:36 (Formatter Plus v4.8.8) by ramak919@gmail.com*/
Select formula_no
      ,vers
      ,prod_no
      ,prod_org
      ,ingr_no
      ,ingr_org
From   ora_formula_hrchy h1
Where  Exists (Select 'X'
               From   ora_formula_hrchy h2
               Where  h1.prod_no = h2.ingr_no
               And    h1.ingr_no = h2.prod_no
               And    h1.prod_org = h2.ingr_org
               And    h1.ingr_org = h2.prod_org);