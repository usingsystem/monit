%%%----------------------------------------------------------------------
%%% File    : check_mempage_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check windows mem page by wmi
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_mempage_wmi).

%%%curl http://IP:8135/Win32_PerfRawData_PerfOS_Memory?select=PageReadsPerSec,PageWritesPerSec,PagesInputPerSec,PagesOutputPerSec,TimeStamp_Sys100NS,Frequency_Sys100NS
 
-import(extbif, [timestamp/0]).

-include("elog.hrl").

-import(dataset, [get_value/2]).

-export([run/1]).

-define(METRICS, [
    {"PageReadsPerSec", pagereads},
    {"PageWritesPerSec", pagewrites},
    {"PagesInputPerSec", pagesinput},
    {"PagesOutputPerSec", pagesoutput}]).

run(Args) ->
    {value, Uuid} = get_value(uuid, Args),
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_Memory", 
        ["Timestamp_Sys100NS", "Frequency_Sys100NS" | [N || {N, _} <- ?METRICS]]) of
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
            {ok, "reads = N/A, writes = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

calc_metrics(LastData, Data) ->
    {value, Ts} = get_value("Timestamp_Sys100NS", Data),
    {value, LastTs} = get_value("Timestamp_Sys100NS", LastData),
    {value, Frequency} = get_value("Frequency_Sys100NS", Data),

    Interval = Ts - LastTs,

    Metrics = 
    lists:map(fun({WmiAttr, MetricName}) ->
        {value, Val} = get_value(WmiAttr, Data),
        {value, LastVal} = get_value(WmiAttr, LastData),
        MetricVal = (Val - LastVal) * Frequency / Interval,
        {MetricName, MetricVal}
    end, ?METRICS), 

    {value, PagesInput} = get_value(pagesinput, Metrics),
    {value, PagesOutput} = get_value(pagesoutput, Metrics),
    PagesTotal = PagesInput + PagesOutput,

    Summary = lists:flatten(["pagesinput = ", fstr(PagesInput),
            ", pagesoutput = ", fstr(PagesOutput)]),
    Metrics1 = [{metric, Name, Val} || {Name, Val} <- Metrics],
    {Summary, [{metric, pagestotal, PagesTotal} | Metrics1]}.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.
