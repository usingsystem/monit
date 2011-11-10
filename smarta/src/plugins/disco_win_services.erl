%%%----------------------------------------------------------------------
%%% File    : disco_win_services.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco window services
%%% Created : 29 Jun 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_win_services).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(Host, Port, ?svSvc, AgentData) of
    {ok, WinServices} ->
        Entries = 
        lists:map(fun(Service) ->
            {value, Name} = dataset:get_value(name, Service),
            {value, OperState} = dataset:get_value(operatingState, Service),
            Attrs = [{name, Name}, {operatingState, integer_to_list(OperState)}],
            {entry, winservice, Name, to_str(Attrs)}
         end, WinServices),
        {ok, "find " ++ integer_to_list(length(Entries)) ++ " window services", Entries};
    {error, Reason} ->
        io:format("~p", [Reason]),
        {error, "snmp error"}
    end.

to_str(Attrs) ->
    string:join([atom_to_list(Name) ++ "=" ++ Val || {Name, Val} <- Attrs], ",").
    
