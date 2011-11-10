%%%----------------------------------------------------------------------
%%% File    : check_mem_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check windows mem by wmi
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_mem_wmi).

%%%curl http://IP:8135/Win32_PerfRawData_PerfOS_System?select=ProcessorQueueLength

-include("elog.hrl").

-import(dataset, [get_value/2]).

-export([run/1]).

-define(METRICS, [
    {"CommittedBytes", committed},
    {"AvailableBytes", avail},
    {"CacheBytes", cache},
    {"PoolNonpagedBytes", poolnonpage},
    {"PoolPagedBytes", poolpage}]).

run(Args) ->
    {value, Host} = get_value(host, Args),
    {ok, TotalMem} = fetch_totalmem(Host),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_Memory", 
        [N || {N, _} <- ?METRICS]) of
    {ok, Result} ->
        Dataset  = wmiproxy:parse2(Result),
        {value, Avail} = get_value("AvailableBytes", Dataset),
        Summary = lists:concat(["free = ", Avail]),
        Metrics = 
        lists:map(fun({WmiAttr, Metric}) -> 
            {value, Val} = get_value(WmiAttr, Dataset),
            {metric, Metric, Val}
        end, ?METRICS),
        {ok, Summary, [{metric, total, TotalMem}|Metrics]};
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

fetch_totalmem(Host) ->
    case wmiproxy:fetch(Host, 8135, "Win32_ComputerSystem", 
        ["TotalPhysicalMemory"]) of
    {ok, Result} ->
        {value, TotalMem} = get_value("TotalPhysicalMemory", wmiproxy:parse2(Result)),
        {ok, TotalMem};
    {error, Reason} ->
        {error, Reason}
    end.

