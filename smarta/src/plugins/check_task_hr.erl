-module(check_task_hr).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_group(Host, Port, [?hrSystemProcesses], AgentData) of
    {ok, Result} ->
        {value, Total} = dataset:get_value(sysProcesses, Result),
        Summary = lists:flatten(["total processes = ", integer_to_list(Total)]),
        {ok, Summary, [{metric, total, Total}]};
    {error, _Reason} ->
        {unknown, "snmp error"}
    end.


