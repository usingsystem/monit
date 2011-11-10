%%%----------------------------------------------------------------------
%%% File    : check_swap_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux swap by ucd-snmp-mib
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_swap_ucd).

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
    case sesnmp:get_group(to_list(Host), Port, ?swapOids, AgentData) of
    {ok, Dataset} ->
        {value, Total} = dataset:get_value(total, Dataset),
        {value, Free} = dataset:get_value(free, Dataset),
        Used = Total - Free,
        Usage = 
        if
        Total == 0 -> 0;
        true -> (Used * 100) div Total
        end,
        Metrics = [{metric, Name, Val*1024} || {Name, Val} <- [{used, Used} | Dataset] ],
        Metrics1 = [{metric, usage, Usage} | Metrics],
        Summary = lists:flatten(["swap usage = ", integer_to_list(Usage), "%"]),
        {ok, Summary, Metrics1};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {unknown, "snmp error"}
    end.


