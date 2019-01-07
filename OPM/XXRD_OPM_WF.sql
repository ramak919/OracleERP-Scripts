/* Formatted on 2014/12/26 00:47 (Formatter Plus v4.8.8) rama.koganti*/
Select   We.Owner_tag
       , We.Name
       , We.Owner_name
       , We.Description
       , We.Type
       , We.Status
       , We.Customization_level
       , We.Licensed_flag
       , We.Generate_function
       , We.Java_generate_func
--       , We.Irep_annotation
From     Wf_events_vl We
Where    1 = 1
and we.OWNER_TAG in ('GMD', 'GME', 'GML', 'GMI', 'GMO','GMF','GMP','GMA')
--and we.OWNER_TAG  like 'GM%'
--and we.OWNER_NAME like 
Order By We.Owner_tag;

/* Formatted on 2014/12/26 01:25 (Formatter Plus v4.8.8) rama.koganti*/


Select   Evt.Owner_tag Owner
       , Evt.Name Event_name
       , Evt.Owner_name
       , Evt.Status Event_status
       , Evt.Description Event_desc
 , Sub.Owner_tag Sub_owner
       , Sub.Status Sub_status
       , Sub.Description Sub_desc
      , Sub.Source_type
       , Sub.Phase
       , Sub.Rule_data
       , Sub.Priority
       , Sub.Rule_function
       , Sub.Wf_process_type || '.' || Sub.Wf_process_name Wf_process
       , Sub.Parameters
       , Sub.Customization_level
       , Sub.Licensed_flag
       , Sub.Expression
       , Sub.Security_group_id
       , Sub.Invocation_id
       , Sub.Map_code
       , Sub.Standard_code
       , Sub.Standard_type
       , Sub.Java_rule_func
       , Sub.On_error_code
       , Sub.Action_code
       , Sub.Out_agent_guid
       , Sub.To_agent_guid
--     , Sub.*
From     Wf_event_subscriptions Sub
       , Wf_events_vl Evt
Where    1 = 1
And      Evt.Owner_tag In ('GMD', 'GME', 'GML', 'GMI', 'GMO','GMF','GMP','GMA')
--and upper(t1.EVENT_NAME) like upper('%inv%i%')
And      Evt.Licensed_flag = 'Y'
And      Sub.Event_filter_guid = Evt.Guid
Order By Evt.Owner_tag
       , Evt.Name;
