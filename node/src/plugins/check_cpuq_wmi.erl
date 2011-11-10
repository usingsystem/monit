%%%----------------------------------------------------------------------
%%% File    : check_cpuq_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check cpu queue by wmi
%%% Created : 26 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_cpuq_wmi).

%%%curl http://IP:8135/Win32_PerfRawData_PerfOS_System?select=ProcessorQueueLength

-include("elog.hrl").

-import(dataset, [get_value/2]).

-export([run/1]).

run(Args) ->
    {value, Host} = get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_System", 
        ["ProcessorQueueLength"]) of
    {ok, Result} ->
        Dataset  = wmiproxy:parse(Result),
        {value, Len} = get_value("ProcessorQueueLength", Dataset),
        Summary = lists:concat(["length = ", Len]),
        Metrics = [{metric, length, list_to_integer(Len)}],
        {ok, Summary, Metrics};
    {error, Reason} ->
        ?WARNING("~p", [Reason]),
        {unknown, "wmi access error"}
    end.

