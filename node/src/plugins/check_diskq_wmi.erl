%%%----------------------------------------------------------------------
%%% File    : check_diskq_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check window disk queue by wmi
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_diskq_wmi).

%%% http://IP:8135/Win32_PerfRawData_PerfDisk_PhysicalDisk/_Total?select=AvgDiskQueueLength,AvgDiskReadQueueLength,AvgDiskWriteQueueLength,TimeStamp_Sys100NS

-include("elog.hrl").

-import(extbif, [timestamp/0]).
-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Uuid} = get_value(uuid, Args),
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfDisk_PhysicalDisk", "_Total",
        ["Timestamp_Sys100NS","AvgDiskReadQueueLength", "AvgDiskWriteQueueLength"]) of
    {ok, Result} ->
        Data  = wmiproxy:parse2(Result),
        Timestamp = timestamp() - 2,
        case monit_last:get_last(Uuid) of
        {ok, {_LastTime, LastData}} -> 
            monit_last:insert_last(Uuid, {Timestamp, Data}),
            {Summary, Metrics} = calc_metrics(LastData, Data),
            {ok, Summary, Metrics};
        false ->
            monit_last:insert_last(Uuid, {Timestamp, Data}),
            {ok, "read_queue = N/A, write_queue = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

calc_metrics(LastData, Data) ->

    {value, Ts} = get_value("Timestamp_Sys100NS", Data),
    {value, LastTs} = get_value("Timestamp_Sys100NS", LastData),

    Interval = Ts - LastTs,

    {value, OReadQueue} = get_value("AvgDiskReadQueueLength", LastData),
    {value, OWriteQueue} = get_value("AvgDiskWriteQueueLength", LastData),

    {value, NReadQueue} = get_value("AvgDiskReadQueueLength", Data),
    {value, NWriteQueue} = get_value("AvgDiskWriteQueueLength", Data),

    ReadQueue = (NReadQueue - OReadQueue) / Interval,
    WriteQueue = (NWriteQueue - OWriteQueue) / Interval, 

    Summary = lists:flatten(["read_queue = ", fstr(ReadQueue),
            ", write_queue = ", fstr(WriteQueue)]),

    Metrics = [{metric, read_queue, ReadQueue},
               {metric, write_queue, WriteQueue},
               {metric, total_queue, ReadQueue + WriteQueue}],
    {Summary, Metrics}.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.
