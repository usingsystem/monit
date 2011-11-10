%%%----------------------------------------------------------------------
%%% File    : disco_disk_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : disco windows disk by wmi
%%% Created : 29 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(disco_disk_wmi).

%%% http://222.66.142.20:8135/Win32_LogicalDisk?select=Name,Size,FreeSpace,DriveType

-include("elog.hrl").

-import(lists, [concat/1]).
-import(string, [tokens/2]).
-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_LogicalDisk", 
        ["Name", "Size", "FreeSpace", "DriveType"]) of
    {ok, Result} ->
        Disks = parse(Result),
        Disks1 =
        lists:filter(fun(Disk) -> 
            {value, Type} = get_value("DriveType", Disk),
            Type == "3"
        end, Disks),
        Summary = "ok",
        Services = 
        lists:map(fun(Disk) -> 
            {value, Name} = get_value("Name", Disk),
            {value, Size} = get_value("Size", Disk),
            {value, Free} = get_value("FreeSpace", Disk),
            Usage = 100 - (list_to_integer(Free) * 100) div list_to_integer(Size),
            Params = "host=${host.addr}&name=" ++ Name,
            {service, check_disk_wmi, concat(["磁盘-", Name]), Params, 
                concat(["磁盘使用率 = ", integer_to_list(Usage), "%"])}
        end, Disks1),
        {ok, Summary, lists:flatten(Services)};
    {error, _Reason} ->
        {error, "wmi access error"}
    end.

parse(Result) ->
    [begin
        Kvs = tokens(Line, ","),
        [list_to_tuple(tokens(Kv, "=")) || Kv <- Kvs]
    end || Line <- tokens(Result, "\r\n")].

