%%%----------------------------------------------------------------------
%%% File    : check_uptime.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check uptime
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_uptime).

-include("elog.hrl").

-include("mib_rfc1213.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

%%TODO: snmp version?
run(Args) ->
	{value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
	{value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_group(Host, Port, [?sysDescr, ?sysObjectID, ?sysUpTime], AgentData) of
    {ok, Values} ->
        {value, SysDescr} = dataset:get_value(sysDescr, Values),
        {value, SysOid} = dataset:get_value(sysObjectID, Values),
        {value, SysUptime} = dataset:get_value(sysUpTime, Values),
        SysOid1 = string:join([integer_to_list(I) || I <- SysOid], "."),
        Summary = lists:flatten(["sysUptime = ", integer_to_list(SysUptime), 
                ", sysDescr = ", SysDescr, ", sysOid = ", SysOid1]),
        {ok, Summary};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {unknown, "snmp error"}
    end.
    
