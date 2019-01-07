/*
	Rel 12 : Is There A Report To Show Formulas Where An Ingredient Is Used? [ID 1336342.1]	
Modified:Feb 4, 2013Type:HOWTOStatus:PUBLISHEDPriority:3

In this Document
Goal
Fix
References
Applies to:

Oracle Process Manufacturing Systems - Version 12.0.0 to 12.1.3 [Release 12 to 12.1]
Information in this document applies to any platform.
***Checked for relevance on 04-Feb-2013***
Goal


Given an Ingredient Item Number, we are looking for an inquiry or report which will look at 
Formulas and show all Products where the Ingredient is used.

(Note that this is not the same as Lot Genealogy - we want to see which Products the Ingredient
is DESIGNED to be used in, not which Products it has actually been used to make).

The report should continue to explode upwards to the ultimate Product if there are multiple levels.

Is there any such report available in the standard application?



Fix

No, there is no report available at the moment which will give the information you are looking for.

The following SQL scripts, run from the 'APPS' SQL*Plus username, will show an indented
multi-level explosion either for one named Ingredient, or for all Formulas.

Please note that these scripts may give 'false positives' as - although they do only look at Formula /
Version combinations which are effective 'today' - they do not take into account the Recipe Validity
Rule Usage (for example 'Production', 'Costing').

Any implied results will need to be verified from within the Application.

The scripts can also be used incidentally as a starting point for finding Circular References in
your Formulas.
*/


-- to avoid error in case table already exists
drop table ora_formula_hrchy;    

-- Script #1 : Build working table

create table ora_formula_hrchy as
SELECT DISTINCT h.formula_id
               ,h.formula_no
               ,prod.inventory_item_id prod_id
               ,prod.organization_id prod_org
               ,i1.concatenated_segments prod_no
               ,ingr.inventory_item_id ingr_id
               ,ingr.organization_id ingr_org
               ,i2.concatenated_segments ingr_no
               ,ingr.qty
               ,h.formula_vers vers
FROM            fm_form_mst h
               ,fm_matl_dtl prod
               ,fm_matl_dtl ingr
               ,mtl_system_items_kfv i1
               ,mtl_system_items_kfv i2
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
                   FROM   gmd_recipes r
                         ,fm_form_eff fe
                   WHERE  r.formula_id = h.formula_id
                   AND    r.recipe_id = fe.recipe_id
                   AND    fe.inventory_item_id = prod.inventory_item_id
                   AND    fe.start_date < SYSDATE
                   AND    (   fe.end_date > SYSDATE
                           OR fe.end_date IS NULL))
ORDER BY        1
               ,3
               ,6

--  For performance reasons:
create index ora_formula_hrchy_n1 on
ora_formula_hrchy (ingr_no);

create index ora_formula_hrchy_n2 on
ora_formula_hrchy (ingr_id, ingr_org);

create index ora_formula_hrchy_n3 on
ora_formula_hrchy (prod_id, prod_org);

-- Script #2
-- The next script prompts for an Ingredient Number and shows all
-- Products which use this Ingredient, exploding all the way up to
-- the highest end-product in the hierarchy.
-- (Note that the lines are displayed 'upside down' - the first row
-- shows the Ingredient which you entered and a Product to which
-- it directly contributes, the next indented line shows that Product
-- as an Ingredient. The line with the most indented Ingredient Number
-- has the top-level Product in the Product Number column) 

select lpad(' ', 2*(LEVEL-1)) || ingr_no ingredient, ingr_org,
prod_no, prod_org, level, formula_no, vers
from ora_formula_hrchy
start with ingr_no = '&Ingredient'
connect by prior prod_id = ingr_id and prod_org = ingr_org;


-- Script #3
--  This is the same as the above script, but does not prompt for an 
--   Ingredient and therefore shows an Ingredient-to-Product explosion 
--   for every Ingredient or Intermediate used in any Formula.	

select lpad(' ', 2*(LEVEL-1)) || ingr_no ingredient, ingr_org,
prod_no, prod_org, level, formula_no, vers
from ora_formula_hrchy
connect by prior prod_id = ingr_id and prod_org = ingr_org;


/*
PLEASE NOTE that where there is a circular reference anywhere above the given Ingredient,
the last two scripts will fail with "ORA-01436: CONNECT BY loop in user data"

Circular References can be of three types:
- Item 'A' is both an Ingredient and a Product in the same Formula
- Item 'A' is an Ingredient of Item 'B', and in another Formula Item 'B' is an Ingredient of Item 'A'
- Item 'A' is an Ingredient of 'B' which is an Ingredient of 'C', and 'C' is an Ingredient of 'A'

The first two examples will be found with the following script:
*/

SELECT FORMULA_NO, VERS, PROD_NO, PROD_ORG, INGR_NO, INGR_ORG
FROM ORA_FORMULA_HRCHY H1
WHERE EXISTS
(SELECT 'X' FROM ORA_FORMULA_HRCHY H2
WHERE H1.PROD_NO = H2.INGR_NO AND H1.INGR_NO = H2.PROD_NO
AND H1.PROD_ORG = H2.INGR_ORG AND H1.INGR_ORG = H2.PROD_ORG);

/*
If the problem is with Items which are direct Ingredients of themselves and if this is a legitimate
situation, then we can simply remove those rows from the working table and then retry one
of the two 'explosion' scripts #2 or #3 (above) :
*/

DELETE FROM ORA_FORMULA_HRCHY
WHERE INGR_NO = PROD_NO AND INGR_ORG = PROD_ORG;

/*
If three or more Formulas separate the Ingredient from itself as a
Product then it is not so easy to find the loop.

One method would be to recursively extract rows from ORA_FORMULA_HRCHY
(working table created above) into another new table starting with
rows where INGR_NO is the Ingredient which causes the 'CONNECT BY' error,
then moving on to rows where INGR_NO is equal to the values of PROD_NO
just extracted and so on until all levels have been processed.

*/

drop table ora_loop_extract;

create table ora_loop_extract as
select * from ora_formula_hrchy 
where ingr_no = '&IngredientNo';

-- Adding LEVEL_NO column, and setting first Level to '1'
alter table ora_loop_extract add (level_no number);

update ora_loop_extract set level_no = 1;

--  Run the following repeatedly until no new rows are inserted
insert into ora_loop_extract ole
(select FORMULA_ID, FORMULA_NO, PROD_ID, PROD_ORG, PROD_NO,
INGR_ID, INGR_ORG, INGR_NO, QTY, VERS, &Level
from ora_formula_hrchy ofh
where (ofh.ingr_no, ofh.ingr_org) in
(select prod_no, prod_org from ora_loop_extract ole2)
and not exists (select 'x' from ora_loop_extract ole3
where ole3.ingr_no = ofh.ingr_no and ole3.ingr_org = ofh.ingr_org
and ole3.prod_no = ofh.prod_no and ole3.prod_org = ofh.prod_org
and ole3.formula_no = ofh.formula_no
and ole3.vers = ofh.vers))

/*
We are building up a level-by-level picture of the Bill, so it is VERY IMPORTANT that when
you run the above script for the first time you enter Level as '2' when prompted, then the 
next time enter '3' and so on.

Eventually you will execute the script, enter the next number in sequence when prompted, 
and the result will be similar to:


SQL> /
Enter value for level: 7
old 3: PROD_NO, INGR_ID, INGR_NO, QTY, VERS, &Level
new 3: PROD_NO, INGR_ID, INGR_NO, QTY, VERS, 7

0 rows created.


Now every row in the new table needs to be checked to find the case where the value in 
PROD_NO exists anywhere else in the same table as INGR_NO, but more than one Level
away.
*/

select ole1.formula_no, ole1.vers, ole1.prod_no, ole1.ingr_no, ole1.level_no,
ole2.formula_no, ole2.vers, ole2.prod_no, ole2.ingr_no, ole2.level_no
from ora_loop_extract ole1, ora_loop_extract ole2
where ole1.ingr_no = ole2.prod_no
and ole2.level_no - ole1.level_no > 1;

/*
Each row output by the above contains two Formula Numbers and Versions.
In one Formula an Item is the Product, and in the other the same Item is the Ingredient.

We have found both of these Formulas by working upwards through the Bill of Materials
from the one Ingredient which you specified earlier right up to all of the eventual end-products
to which it contributes.

The two Formulas constitute a circular reference of the third type described above, and so
if this is unexpected then some action is required.

If it is not becoming clear from the above output where the Circular Reference is coming
from, it can be helpful to look at all the rows in the 'extract' table for a given Level:
*/

select * from ora_loop_extract where level_no = 1;

select * from ora_loop_extract where level_no = 2;

..and so on
/*
This will make it easier to see if there is an Item which you thought was a top-level Product
being used as an Ingredient - the output also shows the Formula Number and Version.

Note that any Circular Reference in the bill of materials will cause Standard Cost Rollup to fail.

If you use Actual Costing this can cope with Circular References, but its behaviour is
controlled by two Profile Options : 
  GMF: Actual Costing Maximum Iteration Limit for Circular Reference
  GMF: Costing Tolerance Percent

See Note 1319329.1 ("OPM: Profiles Which Affect Costing of Batches with Circular 
Reference") for further details.

Footnote:
If you know a Product Number which is suspected of having a Circular Reference somewhere
in its structure but you have not been able to verify this, the GMD Indented Bill of Materials
report (form ICR01USR.fmb) can be used to see where there is a loop.

The report does not give any message that a loop has been detected, but you can tell if one
is present if, within any one indented explosion, the Product Item in the Header information also
appears as an Ingredient, or if the same Ingredient Item appears twice with different values in the 
'Level' column.


References

NOTE:1319329.1 - OPM: Profiles Which Affect Costing of Batches with Circular Reference

*/