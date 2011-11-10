%%%----------------------------------------------------------------------
%%% File    : disco_task_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco task total number by host-resources-mib
%%% Created : 29 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_task_hr).

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
        Summary = "发现成功, 进程总数: " ++ integer_to_list(Total),
        Service = {service, check_task_hr, <<"进程总数">>, "host=${host.addr}&port=${host.port}&community=${host.community}", "进程总数 = "  ++ integer_to_list(Total)},
        {ok, Summary, [Service]};
    {error, _Reason} ->
        {error, "SNMP访问错误！"}
    end.

