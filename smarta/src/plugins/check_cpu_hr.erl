%%%----------------------------------------------------------------------
%%% File    : check_cpu_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check cpu load by host-resources-mib
%%% Created : 09 Apr 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_cpu_hr).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port} = dataset:get_value(port, Args, <<"161">>),
    {value, Index} = dataset:get_value(index, Args),
    {value, Community} = dataset:get_value(community, Args, <<"public">>),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_entry(Host, to_integer(Port), [?hrProcessorLoad], [list_to_integer(Index)], AgentData) of
    {ok, Cpu} ->
        {value, Load} = dataset:get_value(load, Cpu),
        Summary = lists:flatten(["cpu load = ", integer_to_list(Load), "%"]),
        Metric = {metric, load, Load},
        {ok, Summary, [Metric]};
    {error, _Reason} ->
        {unknown, "snmp error"}
    end.

