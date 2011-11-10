%%%----------------------------------------------------------------------
%%% File    : disco_diskio_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco linux disk io by ucd-snmp-mib
%%% Created : 29 Mar 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_diskio_ucd).

-include("mib_ucd_diskio.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    %{value, IoIndex} = dataset:get_value(index, Args),
    {value, Community} = dataset:get_value(community, Args, <<"public">>),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(Host, Port, ?diskIO, AgentData) of
    {ok, DiskIOs} ->
        DiskIOs1 =
        lists:filter(fun(DiskIO) -> 
            {value, Reads} = dataset:get_value(reads, DiskIO),
            {value, Writes} = dataset:get_value(writes, DiskIO),
            not ((Reads == 0) and (Writes == 0))
        end, DiskIOs),
        Summary = "disco successfully.",
        Services = 
        lists:map(fun(DiskIO) -> 
            {value, Dev} = dataset:get_value(device, DiskIO),
            {value, [Index]} = dataset:get_value(tableIndex, DiskIO),
            Entry = {entry, diskio, Dev++"="++integer_to_list(Index), "dev=" ++ Dev},
            Params = "host=${host.addr}&port=${host.port}&community=${host.community}&index=" ++ integer_to_list(Index),
            Service = {service, check_diskio_ucd, "磁盘IO - " ++ Dev, Params, "磁盘IO名称 = " ++ Dev},
            [Entry, Service]
        end, DiskIOs1),
        {ok, Summary, lists:flatten(Services)};
    {error, _Reason} ->
        {error, "snmp error"}
    end.

