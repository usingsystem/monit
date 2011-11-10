%%%----------------------------------------------------------------------
%%% File    : check_load_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux load by ucd_snmp_mib
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_load_ucd).

-include("elog.hrl").

-include("mib_ucd_snmp.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
	{value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
	{value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(to_list(Host), Port, [?laNames, ?laLoad], AgentData) of
    {ok, [Entry1, Entry2, Entry3 | _]} ->
        {value, La1S} = dataset:get_value(load, Entry1),
        {value, La5S} = dataset:get_value(load, Entry2),
        {value, La15S} = dataset:get_value(load, Entry3),
        Summary = lists:flatten(["load1 = ", La1S, ", load5 = ", La5S, ", load15 = ", La15S]),
        Metrics = [{load1, La1S}, {load5, La5S}, {load15, La15S}],
        Metrics1 = [{metric, Name, list_to_float(Val)} || {Name, Val} <- Metrics],
        {ok, Summary, Metrics1};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {unknown, "snmp error"}
    end.
    
