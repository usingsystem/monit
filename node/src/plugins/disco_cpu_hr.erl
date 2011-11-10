%%%----------------------------------------------------------------------
%%% File    : disco_cpu_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco linux disk by host-resources-mib
%%% Created : 29 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_cpu_hr).

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
    case sesnmp:get_table(Host, Port, [?hrProcessorLoad], AgentData) of
    {ok, Cpus} ->
        Summary = integer_to_list(length(Cpus)) ++ " cpu found",
        Services = 
        lists:map(fun(Cpu) -> 
            {value, [Index]} = dataset:get_value(tableIndex, Cpu),
            IdxS = integer_to_list(Index),
            {value, Load} = dataset:get_value(load, Cpu),
            Name = "CPU - " ++ IdxS,
            Entry = {entry, cpu, "CPU"++IdxS++"="++IdxS, "name=" ++ Name},
            Service = {service, check_cpu_hr, Name, "host=${host.addr}&port=${host.port}&community=${host.community}&index=" ++ IdxS, "CPU负载 = " ++ integer_to_list(Load)},
            [Entry, Service]
        end, Cpus),
        {ok, Summary, lists:flatten(Services)};
    {error, _Reason} ->
        {error, "snmp error"}
    end.


