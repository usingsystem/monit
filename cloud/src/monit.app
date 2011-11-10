{application, monit, [
  {description, "monit cloud"},
  {vsn, "0.2"},
  {id, "monit.app 2010-04-04 erylee"},
  {modules, [
      monit,
      monit_app,
      monit_sup,
      monit_alert,
      monit_bot,
      monit_ctl,
      monit_datalog,
      monit_disco,
      monit_object,
      monit_object_type,
      monit_object_event,
      monit_host,
      monit_nodes,
      monit_metric,
      monit_status
  ]},
  {registered, [
      monit_object, 
      monit_object_type, 
      monit_object_event, 
      monit_disco,
      monit_status,
      monit_datalog
  ]},
  {applications, [
      kernel, 
      stdlib
  ]},
  {env, []},
  {mod, {monit_app, []}}]}.
