{application, monit_node,
 [{description, "monit node"},
  {vsn, "0.1"},
  {modules, [monit_node, monit_node_app, monit_node_sup]},
  {registered, []},
  {applications, [kernel, stdlib]},
  {env, []},
  {mod, {monit_node_app, []}}]}.
