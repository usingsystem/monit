%%%----------------------------------------------------------------------
%%% File    : check_uptime_wmi.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check windows uptime by wmi
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_uptime_wmi).

%%% http://IP:8135/Win32_PerfRawData_PerfOS_System?select=SystemUpTime,Frequency_Sys100NS

-include("elog.hrl").

-import(lists, [concat/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    case wmiproxy:fetch(Host, 8135, "Win32_PerfRawData_PerfOS_System",
        ["SystemUpTime","Frequency_Sys100NS"]) of
    {ok, Result} ->
        Dataset  = wmiproxy:parse2(Result),
        {value, UpTime} = dataset:get_value("SystemUpTime", Dataset),
        {value, Frequency} = dataset:get_value("Frequency_Sys100NS", Dataset),
        {ok, concat(["sysUptime = ", (UpTime div Frequency)])};
    {error, _Reason} ->
        {unknown, "wmi access error"}
    end.

