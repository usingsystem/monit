%%%----------------------------------------------------------------------
%%% File    : check_cpu_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check cpu by wmi
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------

%%% http://IP:8135/Win32_PerfRawData_PerfOS_Processor/_Total?select=Name,DiskReadsPerSec,DiskWritesPerSec,TimeStamp_Sys100NS,Frequency_Sys100NS

-module(check_cpu_wmi).

-include("elog.hrl").

-import(lists, [concat/1]).

-import(extbif, [timestamp/0]).

-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Uuid} = get_value(uuid, Args),
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_Processor", "_Total",
        ["PercentPrivilegedTime","PercentUserTime","PercentProcessorTime","Timestamp_Sys100NS"]) of
    {ok, Result} ->
        CpuData = wmiproxy:parse2(Result),
        Timestamp = timestamp() - 2,
        case monit_last:get_last(Uuid) of
        {ok, {_LastTime, LastCpuData}} -> 
            monit_last:insert_last(Uuid, {Timestamp, CpuData}),
            {Summary, Metrics} = calc_metrics(LastCpuData, CpuData),
            {ok, Summary, Metrics};
        false ->
            monit_last:insert_last(Uuid, {Timestamp, CpuData}),
            {ok, "priv = N/A, user = N/A, proc = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

calc_metrics(LastCpuData, CpuData) ->
    {value, Ts} = get_value("Timestamp_Sys100NS", CpuData),
    {value, LastTs} = get_value("Timestamp_Sys100NS", LastCpuData),

    {value, NPrivilege} = get_value("PercentPrivilegedTime", CpuData),
    {value, NUser} = get_value("PercentUserTime", CpuData),
    {value, NProcessor} = get_value("PercentProcessorTime", CpuData),

    {value, OPrivilege} = get_value("PercentPrivilegedTime", LastCpuData),
    {value, OUser} = get_value("PercentUserTime", LastCpuData),
    {value, OProcessor} = get_value("PercentProcessorTime", LastCpuData),

    Priv = (NPrivilege - OPrivilege) * 100 / (Ts - LastTs),
    User = (NUser - OUser) * 100 / (Ts - LastTs),
    Proc = (1 - (NProcessor - OProcessor) / (Ts - LastTs)) * 100,

    Summary = concat(["priv = ", fstr(Priv), "%, user = ", fstr(User), "%, proc = ", fstr(Proc), "%"]),
    {Summary, [{metric, priv, Priv}, {metric, user, User}, {metric, proc, Proc}]}.

fstr(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

