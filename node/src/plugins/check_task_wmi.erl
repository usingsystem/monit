%%%----------------------------------------------------------------------
%%% File    : check_task_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check windows uptime by wmi
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_task_wmi).

%%%curl http://IP:8135/Win32_PerfRawData_PerfOS_System?select=SystemUpTime,Frequency_Sys100NS

-include("elog.hrl").

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_System", 
        ["Processes","Threads"]) of
    {ok, Result} ->
        Dataset  = wmiproxy:parse2(Result),
        {value, Threads} = dataset:get_value("Threads", Dataset),
        {value, Processes} = dataset:get_value("Processes", Dataset),
        Summary = lists:concat(["processes = ", Processes, ", threads = ", Threads]),
        Metrics = [{metric, threads, Threads},
            {metric, processes, Processes}],
        {ok, Summary, Metrics};
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

