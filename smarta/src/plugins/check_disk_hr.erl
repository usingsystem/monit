%%%----------------------------------------------------------------------
%%% File    : check_disk_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux disk by host-resources-mib
%%% Created : 14 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_disk_hr).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port} = dataset:get_value(port, Args, <<"161">>),
    {value, Index} = dataset:get_value(index, Args),
    {value, Community} = dataset:get_value(community, Args, <<"public">>),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_entry(Host, to_integer(Port), ?hrStorage, [list_to_integer(Index)], AgentData) of
    {ok, Disk} ->
        %{value, Descr} = dataset:get_value(descr, Disk),
        {value, Total} = dataset:get_value(size, Disk),
        {value, Units} = dataset:get_value(units, Disk),
        {value, Used} = dataset:get_value(used, Disk),
        Avail = Total - Used,
        Usage = 
        if
        Total == 0 -> 0;
        true -> (Used * 100) div Total
        end,
        %Descr1 =
        %case string:str(Descr, ":\\") of
        %0 ->
        %    Descr;
        %Idx ->
        %    string:substr(Descr, 1, Idx)
        %end,
        Summary = lists:flatten(["disk usage = ", integer_to_list(Usage), "%, disk total = ", f(Total * Units)]),
        DiskData = lists:zip([total, used, avail], [Total, Used, Avail]),
        Metrics = [{metric, Name, Val*Units} || {Name, Val} <- DiskData],
        Metrics1 = [{metric, usage, Usage} | Metrics],
        {ok, Summary, Metrics1};
    {error, _Reason} ->
        {unknown, "snmp error", []}
    end.

f(Size) when (Size > 1000000000) ->
    integer_to_list(Size div 1000000000) ++ "G";
f(Size) when (Size > 1000000) ->
    integer_to_list(Size div 1000000) ++ "M";
f(Size) when (Size > 1000) ->
    integer_to_list(Size div 1000) ++ "K";
f(Size) ->
    integer_to_list(Size) ++ "B".

