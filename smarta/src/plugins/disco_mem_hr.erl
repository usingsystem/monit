%%%----------------------------------------------------------------------
%%% File    : disco_mem_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco window memory by host-resources-mib
%%% Created : 29 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_mem_hr).

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
    case sesnmp:get_table(Host, Port, ?hrStorage, AgentData) of
    {ok, Storages} ->
        Memories = 
        lists:filter(fun(Disk) -> 
            {value, Type} = dataset:get_value(type, Disk),
            ?INFO("~p", [Type]),
            Type == [1,3,6,1,2,1,25,2,1,2]
        end, Storages),
        Summary = "Discover physical memory success!",
        Services = 
        lists:map(fun(Mem) -> 
            %{value, Descr} = dataset:get_value(descr, Mem),
            {value, Total} = dataset:get_value(size, Mem),
            {value, Used} = dataset:get_value(used, Mem),
            {value, [Index]} = dataset:get_value(tableIndex, Mem),
            Usage = 
            if
            Total == 0 -> 0;
            true -> (Used * 100) div Total
            end,
            Params = "host=${host.addr}&port=${host.port}&community=${host.community}&index=" ++ integer_to_list(Index),
            {service, check_mem_hr, <<"物理内存">>, Params, "内存使用率 = " ++ integer_to_list(Usage) ++ "%"}
        end, Memories),
        {ok, Summary, Services};
    {error, _Reason} ->
        {error, "snmp access error！"}
    end.


