%%%----------------------------------------------------------------------
%%% File    : disco_load_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : discover linux load by ucd_snmp_mib
%%% Created : 26 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_load_ucd).

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
        Summary = lists:flatten(["1分钟平均负载 = ", La1S, ", 5分钟平均负载 = ", La5S, ", 15分钟平均负载 = ", La15S]),
        Service = {service, check_load_ucd, <<"系统负载">>, "host=${host.addr}&port=${host.port}&community=${host.community}", Summary},
        {ok, "disco load success", [Service]};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {error, "snmp failure"}
    end.
    
