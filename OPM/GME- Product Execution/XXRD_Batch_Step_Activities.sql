       /*Batch Activities*/
SELECT
       GBSA.ACTIVITY
      ,GBSA.ACTIVITY_DESC
      ,GBSA.OFFSET_INTERVAL offset_hrs
      ,GBSA.PLAN_ACTIVITY_FACTOR
      ,GBSA.PLAN_START_DATE
      ,GBSA.PLAN_CMPLT_DATE
      ,GBSA.ACTUAL_START_DATE
      ,GBSA.ACTUAL_CMPLT_DATE
FROM
       GME_BATCH_STEP_ACTIVITIES_V gbsa
WHERE
       1 = 1;