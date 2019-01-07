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