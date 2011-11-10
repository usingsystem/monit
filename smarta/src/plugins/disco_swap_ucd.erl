%%%----------------------------------------------------------------------
%%% File    : disco_swap_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : discover linux swap by ucd_snmp_mib
%%% Created : 26 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_swap_ucd).

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
    case sesnmp:get_group(to_list(Host), Port, ?swapOids, AgentData) of
    {ok, Dataset} ->
        {value, Total} = dataset:get_value(total, Dataset),
        {value, Free} = dataset:get_value(free, Dataset),
        Summary = "SWAP总容量 = " ++ f(Total) ++ ", SWAP剩余 = " ++ f(Free),
        Service = {service, check_swap_ucd, <<"SWAP监测">>, "host=${host.addr}&port=${host.port}&community=${host.community}", Summary},
        {ok, "disco swap success", [Service]};
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
    
