%%%----------------------------------------------------------------------
%%% File    : disco_routes.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco routes of host
%%% Created : 28 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_routes).

-import(extbif, [to_list/1, to_integer/1]).

-include("elog.hrl").

-include("mib_rfc1213.hrl").

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(Host, Port, ?ipRoute, AgentData) of
    {ok, Routes} ->
        Entries = 
        lists:map(fun(Route) -> 
            {value, Dest} = dataset:get_value(routeDest, Route),
            {entry, ipRoute, ipstr(Dest), attrs(Route)}
        end, Routes),
        {ok, "found routes", Entries};
    {error, _Reason} ->
        {error, "snmp error"}
    end.

attrs(Route) ->
    string:join([to_list(Name) ++ "=" ++ to_list(Val) || 
        {Name, Val} <- lists:reverse(attrs(Route, []))], ",").
    
attrs([], Acc) ->
    Acc;
attrs([{routeDest, Dest}|T], Acc) ->
    attrs(T, [{routeDest, ipstr(Dest)}|Acc]);
attrs([{routeNextHop, NextHop}|T], Acc) ->
    attrs(T, [{routeNextHop, ipstr(NextHop)}|Acc]);
attrs([{routeMask, Mask}|T], Acc) ->
    attrs(T, [{routeMask, ipstr(Mask)}|Acc]);
attrs([{tableIndex, _}|T], Acc) ->
    attrs(T, Acc);
attrs([{N, V}|T], Acc) ->
    attrs(T, [{N, V}|Acc]).

ipstr(L) when is_list(L) and (length(L) == 4)->                                             
    string:join(io_lib:format("~.10B~.10B~.10B~.10B", L), ".");                             
                                                 
ipstr(_) ->                                  
    "".  
