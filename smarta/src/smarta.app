{application, smarta, [
    {description, "smart agent"},
    {vsn, "0.2.0"},
    {id, "smarta.app 2010-04-01 erylee"},
    {modules, [
        smarta, 
        smarta_app, 
        smarta_sup, 
        smarta_ctl, 
        smarta_disco, 
        smarta_plugin, 
        smarta_sched, 
        smarta_task
    ]},
    {registered, [
        smarta, 
        smarta_sup, 
        smarta_disco, 
        smarta_plugin, 
        smarta_sched
    ]},
    {applications, [
        kernel, 
        stdlib,
        sasl, 
        crypto, 
        mnesia, 
        exmpp
    ]},
    {env, []},
    {mod, {smarta_app, []}}
]}.

%vim:ft=erlang:ts=8:
