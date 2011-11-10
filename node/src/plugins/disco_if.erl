%%%----------------------------------------------------------------------
%%% File    : disco_if.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco interfaces
%%% Created : 28 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_if).

-import(extbif, [to_list/1, to_integer/1]).

-include("elog.hrl").

-include("mib_rfc1213.hrl").

-export([run/1]).

run(Args) ->
    ?INFO("~p", [Args]),
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(Host, Port, [?ifIndex,?ifDescr,?ifType,?ifSpeed,?ifAdminStatus,?ifOperStatus], AgentData) of
    {ok, IfEntries} ->
        IfEntries1 = 
        lists:filter(fun(IfEntry) -> 
            {value, IfType} = dataset:get_value(ifType, IfEntry),
            IfType =/= 24 %loopback
        end, IfEntries),
        Services = 
        lists:map(fun(IfEntry) -> 
            {value, IfIndex} = dataset:get_value(ifIndex, IfEntry),
            {value, IfDescr} = dataset:get_value(ifDescr, IfEntry),
            {value, IfSpeed} = dataset:get_value(ifSpeed, IfEntry),
            {value, OperStatus} = dataset:get_value(ifOperStatus, IfEntry),
            Bandwidth = integer_to_list(IfSpeed div (1000 * 1000)) ++ "Mbps",
            Summary = 
            if
            OperStatus == 1 ->
                "端口状态 = UP, 端口带宽 = " ++ Bandwidth;
            OperStatus == 2 ->
                "端口状态 = DOWN, 端口带宽 = " ++ Bandwidth;
            true ->
                "端口状态 = 未知, 端口带宽 = " ++ Bandwidth
            end,
            Params = "host=${host.addr}&port=${host.port}&community=${host.community}&ifindex=" ++ integer_to_list(IfIndex),
            Entry = {entry, ifentry, IfDescr++"="++integer_to_list(IfIndex), attrs(IfEntry)},
            Service = {service, check_if, "接口-" ++ IfDescr, Params, list_to_binary(Summary)},
            [Entry, Service]
        end, IfEntries1),
        {ok, "found interfaces", lists:flatten(Services)};
    {error, _Reason} ->
        {error, "snmp error"}
    end.

attrs(IfEntry) ->
    string:join([atom_to_list(Name) ++ "=" ++ Val || {Name, Val} <- lists:reverse(attrs(IfEntry, []))], ",").

attrs([], Acc) ->
    Acc;
attrs([{ifIndex, Idx}|IfEntry], Acc) ->
    attrs(IfEntry, [{ifIndex, integer_to_list(Idx)}|Acc]);
attrs([{ifDescr, Descr}|IfEntry], Acc) ->
    attrs(IfEntry, [{ifDescr, Descr}|Acc]);
attrs([{ifType, Type}|IfEntry], Acc) ->
    attrs(IfEntry, [{ifType, integer_to_list(Type)}|Acc]);
attrs([{ifSpeed, IfSpeed}|IfEntry], Acc) ->
    Speed = integer_to_list(IfSpeed div (1000 * 1000)) ++ "Mbps",
    attrs(IfEntry, [{ifSpeed, Speed}|Acc]);
attrs([{ifOperStatus, OperStatus}|IfEntry], Acc) ->
    attrs(IfEntry, [{ifOperStatus, ifstatus(OperStatus)}|Acc]);
attrs([{ifAdminStatus, AdminStatus}|IfEntry], Acc) ->
    attrs(IfEntry, [{ifAdminStatus, ifstatus(AdminStatus)}|Acc]);
attrs([_|IfEntry], Acc) ->
    attrs(IfEntry, Acc).

ifstatus(1) -> "UP";
ifstatus(2) -> "DOWN";
ifstatus(3) -> "TEST";
ifstatus(_) -> "UNKNOWN".


