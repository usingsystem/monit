%%%----------------------------------------------------------------------
%%% File    : check_win_service.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check if the window service is alive
%%% Created : 29 Jun 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_win_service).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(lists, [concat/1]).

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Name} = dataset:get_value(name, Args),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_entry(Host, Port, ?svSvc, [length(Name)|Name], AgentData) of
    {ok, Service} ->
        {value, OperatingState} = dataset:get_value(operatingState, Service),
        result(OperatingState);
    {error, {noSuchName, _Idx, _Varbinds}} ->
        {critical, "service is not running"};
    {error, Reason} ->
        io:format("~p~n", [Reason]),
        {unknown, "snmp error"}
    end.

result(noSuchName) ->
    {critical, "service is not running"};

result(1) ->
    {ok, "operatingState = Active"};
    
result(2) ->
    {warning, "operatingState = Continue Pending"};

result(3) ->
    {warning, "operatingState = Pause Pending"};

result(4) ->
    {critical, "operatingState = Paused"};

result(I) ->
    {unknown, "operatingState = " ++ to_list(I)}.
    
