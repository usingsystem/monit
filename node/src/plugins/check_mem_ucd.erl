%%%----------------------------------------------------------------------
%%% File    : check_mem_usd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux memory by ucd-snmp-mib
%%% Created : 14 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_mem_ucd).

-include("elog.hrl").

-include("mib_ucd_snmp.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
	{value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
	{value, Community} = dataset:get_value(community, Args, <<"public">>),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_group(to_list(Host), Port, ?memOids, AgentData) of
    {ok, Dataset} ->
        {value, Total} = dataset:get_value(total, Dataset),
        {value, Free} = dataset:get_value(free, Dataset),
        %{value, Shared} = dataset:get_value(shared, Dataset),
        {value, Buffers} = dataset:get_value(buffers, Dataset),
        {value, Cached} = dataset:get_value(cached, Dataset),
        Used = Total - Free,
        Usage = 
        if
        Total == 0 -> 0;
        true -> (Used * 100) div Total
        end,
        AppUsed = Used - (Buffers + Cached),
        AppUsage = 
        if
        Total == 0 -> 0;
        true -> (AppUsed * 100) div Total
        end,
        Summary = lists:concat(["memory usage = ", Usage, "%, app usage = ", AppUsage, "%"]),
        Metrics = [{metric, Name, Val*1024} || {Name, Val} <- 
            [{used, Used}, {appused, AppUsed} | Dataset] ],
        Metrics1 = [{metric, usage, Usage}, {metric, appusage, AppUsage} | Metrics],
        {ok, Summary, Metrics1};
    {error, _Reason} ->
        {unknown, "snmp error"}
    end.

