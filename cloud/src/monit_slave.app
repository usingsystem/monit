{application, monit_slave, [
  {description, "monit slave"},
  {vsn, "0.2"},
  {id, "monit_slave.app 2010-05-20 erylee"},
  {modules, [
      monit_slave,
      monit_slave_sup,
      monit_object,
      monit_metric,
      monit_status
  ]},
  {registered, [
      monit_object, 
      monit_status
  ]},
  {applications, [
      kernel, 
      stdlib
  ]},
  {env, []},
  {mod, {monit_slave, []}}]}.
