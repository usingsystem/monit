%%%----------------------------------------------------------------------
%%% File    : disco_system.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco mib-2 system information of device and host
%%% Created : 28 Jun 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_system).

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
    case sesnmp:get_group(Host, Port, [?sysDescr,?sysObjectID,?sysContact,?sysName,?sysLocation], AgentData) of
    {ok, System} ->
        {value, Oid} = dataset:get_value(sysObjectID, System),
        System1 = dataset:key_replace(sysObjectID, System, {sysObjectID, oidstr(Oid)}),
        Entries = [{entry, system, atom_to_list(N), f(V)} || {N, V} <- System1],
        {ok, "got system info", Entries};
    {error, _Reason} ->
        {error, "snmp error"}
    end.

oidstr(L) when is_list(L) ->
    string:join([integer_to_list(X) || X <- L], ".");

oidstr(_) ->
    "".

f(noSuchName) ->
    "";
f(noSuchObject) ->
    "";
f(V) ->
    V.

