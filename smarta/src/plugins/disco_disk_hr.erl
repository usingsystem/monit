%%%----------------------------------------------------------------------
%%% File    : disco_disk_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco linux disk by host-resources-mib
%%% Created : 29 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_disk_hr).

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
    {ok, Disks} ->
        Disks1 = 
        lists:filter(fun(Disk) -> 
            {value, Type} = dataset:get_value(type, Disk),
            {value, Total} = dataset:get_value(size, Disk),
            {value, Used} = dataset:get_value(used, Disk),
            Avail = Total - Used,
            NotZero = (Total =/= 0) and (Used =/= 0) and (Avail =/= 0),
            NotZero and (Type == [1,3,6,1,2,1,25,2,1,4])
        end, Disks),
        Summary = "磁盘对象发现成功",
        Services = 
        lists:map(fun(Disk) -> 
            {value, Descr} = dataset:get_value(descr, Disk),
            Descr1 =
            case string:str(Descr, ":\\") of
            0 ->
                Descr;
            Idx ->
                string:substr(Descr, 1, Idx)
            end,
            {value, Total} = dataset:get_value(size, Disk),
            {value, Units} = dataset:get_value(units, Disk),
            {value, Used} = dataset:get_value(used, Disk),
            Usage = (Used * 100) div Total,
            {value, [Index]} = dataset:get_value(tableIndex, Disk),
            Attrs = lists:flatten(["descr=", Descr1, ",total=", integer_to_list(Total * Units)]),
            Entry = {entry, disk, Descr1++"="++integer_to_list(Index), Attrs},
            Params = "host=${host.addr}&port=${host.port}&community=${host.community}&index=" ++ integer_to_list(Index),
            Service = {service, check_disk_hr, "磁盘 - " ++ Descr1, Params, "磁盘使用率 = " ++ integer_to_list(Usage) ++ "%"},
            [Entry, Service]
        end, Disks1),
        {ok, Summary, lists:flatten(Services)};
    {error, _Reason} ->
        {error, "snmp error"}
    end.


