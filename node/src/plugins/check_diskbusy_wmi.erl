%%%----------------------------------------------------------------------
%%% File    : check_diskbusy_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check window disk busy by wmi
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_diskbusy_wmi).

%%% http://IP:8135/Win32_PerfRawData_PerfDisk_PhysicalDisk/_Total?select=PercentIdleTime,TimeStamp_Sys100NS

-include("elog.hrl").

-import(lists, [concat/1]).
-import(extbif, [timestamp/0]).
-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Uuid} = get_value(uuid, Args),
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfDisk_PhysicalDisk", 
        "_Total", ["PercentIdleTime", "Timestamp_Sys100NS"]) of
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
            {ok, "busy = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

calc_metrics(LastData, Data) ->
    {value, Ts} = get_value("Timestamp_Sys100NS", Data),
    {value, LastTs} = get_value("Timestamp_Sys100NS", LastData),

    {value, NIdleTime} = dataset:get_value("PercentIdleTime", Data),
    {value, OIdleTime} = dataset:get_value("PercentIdleTime", LastData),

    Busy = (1 - (NIdleTime - OIdleTime) / (Ts - LastTs)) * 100,

    {concat(["busy = ", fstr(Busy), "%"]), [{metric, busy, Busy}]}.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.
