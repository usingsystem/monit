%%%----------------------------------------------------------------------
%%% File    : disco_mem_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : discover linux mem by ucd_snmp_mib
%%% Created : 26 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_mem_ucd).

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
    case sesnmp:get_group(to_list(Host), Port, ?memOids, AgentData) of
    {ok, Dataset} ->
        {value, Total} = dataset:get_value(total, Dataset),
        {value, Free} = dataset:get_value(free, Dataset),
        %{value, Buffers} = dataset:get_value(buffers, Dataset),
        %{value, Cached} = dataset:get_value(cached, Dataset),
        Summary = "内存总容量 = " ++ f(Total) ++ ", 剩余内存 = " ++ f(Free),
        Service = {service, check_mem_ucd, <<"内存监测">>, "host=${host.addr}&port=${host.port}&community=${host.community}", Summary},
        {ok, "disco mem success", [Service]};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {error, "snmp failure"}
    end.
    
f(KSize) when KSize > (1000000) ->
    integer_to_list(KSize div 1000000) ++ "G";

f(KSize) when KSize > 1000 ->
    integer_to_list(KSize div 1000) ++ "M";

f(KSize) ->
    integer_to_list(KSize) ++ "K".

