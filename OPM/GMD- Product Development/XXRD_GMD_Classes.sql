/* Formatted on 12/23/2014 3:11:59 PM (QP5 v5.256.13226.35510) */
/*Formula classes*/
SELECT
       FFC.FORMULA_CLASS, FFC.FORMULA_CLASS_DESC, FFC.DELETE_MARK
FROM
       FM_FORM_CLS ffc
WHERE
       1 = 1
ORDER BY
       FFC.FORMULA_CLASS;

/*Operation Classes*/
SELECT
       FOC.OPRN_CLASS, FOC.OPRN_CLASS_DESC, FOC.DELETE_MARK
FROM
       FM_OPRN_CLS foc
WHERE
       1 = 1;

/*Routing Classes*/
SELECT
       FRC.ROUTING_CLASS
      ,FRC.ROUTING_CLASS_DESC
      ,FRC.ROUTING_CLASS_UOM
      ,FRC.FIXED_PROCESS_LOSS
      ,FRC.UOM
      ,FRC.DELETE_MARK
FROM
       FM_ROUT_CLS frc
WHERE
       1 = 1;

/*Routing Classes Details */
SELECT
       GPL.ROUTING_CLASS, GPL.MAX_QUANTITY, GPL.PROCESS_LOSS
FROM
       GMD_PROCESS_LOSS GPl, FM_ROUT_CLS frc
WHERE
       1 = 1
AND    FRC.ROUTING_CLASS = GPL.ROUTING_CLASS;


/*Resource Classes*/
SELECT
       crc .* 
       FROM
       CR_RSRC_CLS crc
WHERE
       1 = 1;
