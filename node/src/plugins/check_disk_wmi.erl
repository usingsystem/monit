%%%----------------------------------------------------------------------
%%% File    : check_disk_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check windows disk space by wmi
%%% Created : 29 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_disk_wmi).

%%% http://222.66.142.20:8135/Win32_LogicalDisk?select=Name,Size,FreeSpace,DriveType

-include("elog.hrl").

-import(lists, [concat/1]).
-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Host} = get_value(host, Args),
    {value, Name} = get_value(name, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_LogicalDisk", Name, ["Size", "FreeSpace"]) of
    {ok, Result} ->
        Disk = wmiproxy:parse2(Result),
        {value, Total} = get_value("Size", Disk),
        {value, Free} = get_value("FreeSpace", Disk),
        Used = Total - Free,
        Usage = Used * 100 / Total,
        Summary = concat(["disk usage = ", fstr(Usage), "%, disk total = ", f(Total)]),
        Metrics = [
            {metric, usage, Usage},
            {metric, total, Total},
            {metric, avail, Free},
            {metric, used, Used}],
        {ok, Summary, Metrics};
    {error, _Reason} ->
        {error, "wmi access error"}
    end.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

f(Size) when (Size > 1000000000) ->
    integer_to_list(Size div 1000000000) ++ "G";
f(Size) when (Size > 1000000) ->
    integer_to_list(Size div 1000000) ++ "M";
f(Size) when (Size > 1000) ->
    integer_to_list(Size div 1000) ++ "K";
f(Size) ->
    integer_to_list(Size) ++ "B".
