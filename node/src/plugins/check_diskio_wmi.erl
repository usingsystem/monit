%%%----------------------------------------------------------------------
%%% File    : check_diskio_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux disk io by ucd-snmp-mib
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_diskio_wmi).

%%% http://IP:8135/Win32_PerfRawData_PerfDisk_PhysicalDisk/_Total?select=Name,DiskReadsPerSec,DiskWritesPerSec,TimeStamp_Sys100NS,Frequency_Sys100NS

-include("elog.hrl").

-import(extbif, [timestamp/0]).
-import(dataset, [get_value/2]).

-export([run/1]).

-define(METRICS, [
    {"DiskReadsPerSec", reads}, 
    {"DiskWritesPerSec", writes}, 
    {"DiskReadBytesPerSec", rbytes}, 
    {"DiskWriteBytesPerSec", wbytes}]).

run(Args) ->
    {value, Uuid} = get_value(uuid, Args),
    {value, Host} = get_value(host, Args),
    Attrs = [A || {A, _} <- ?METRICS],
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfDisk_PhysicalDisk", 
        "_Total", ["Timestamp_Sys100NS","Frequency_Sys100NS" | Attrs]) of
    {ok, Result} ->
        DiskIO  = wmiproxy:parse2(Result),
        Timestamp = timestamp() - 2,
        case monit_last:get_last(Uuid) of
        {ok, {_LastTime, LastDiskIO}} -> 
            monit_last:insert_last(Uuid, {Timestamp, DiskIO}),
            {Summary, Metrics} = calc_metrics(LastDiskIO, DiskIO),
            {ok, Summary, Metrics};
        false ->
            monit_last:insert_last(Uuid, {Timestamp, DiskIO}),
            {ok, "reads = N/A, writes = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

calc_metrics(LastDiskIO, DiskIO) ->
    {value, Ts} = get_value("Timestamp_Sys100NS", DiskIO),
    {value, LastTs} = get_value("Timestamp_Sys100NS", LastDiskIO),
    {value, Frequency} = get_value("Frequency_Sys100NS", DiskIO),

    Interval = Ts - LastTs,

    Metrics = 
    lists:map(fun({WmiAttr, MetricName}) ->
        {value, Val} = get_value(WmiAttr, DiskIO),
        {value, LastVal} = get_value(WmiAttr, LastDiskIO),
        MetricVal = (Val - LastVal) * Frequency / Interval,
        {MetricName, MetricVal}
    end, ?METRICS), 

    Metrics1 = [begin
        if
        (N == rbytes) or (N == wbytes) ->
            {N, V/1000};
        true ->
            {N, V}
        end
    end || {N, V} <- Metrics],

    {value, RBytesPerS} = get_value(rbytes, Metrics1),
    {value, WBytesPerS} = get_value(wbytes, Metrics1),

    Summary = lists:flatten(["reads = ", fstr(RBytesPerS), "KB/s",
            ", writes = ", fstr(WBytesPerS), "KB/s"]),
    {Summary, [{metric, Name, Val} || {Name, Val} <- Metrics1]}.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

