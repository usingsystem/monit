%%%----------------------------------------------------------------------
%%% File    : check_mem_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check mem usage by host-resources-mib
%%% Created : 09 Apr. 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_mem_hr).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(extbif, [to_list/1, to_integer/1]).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Index} = dataset:get_value(index, Args),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_entry(Host, Port, ?hrStorage, [list_to_integer(Index)], AgentData) of
    {ok, Disk} ->
        {value, Total} = dataset:get_value(size, Disk),
        {value, Units} = dataset:get_value(units, Disk),
        {value, Used} = dataset:get_value(used, Disk),
        Avail = Total - Used,
        Usage = 
        if
        Total == 0 -> 0;
        true -> (Used * 100) div Total
        end,
        Summary = lists:flatten(["physical memory usage = ", integer_to_list(Usage), "%"]),
        MemData = lists:zip([total, used, avail], [Total, Used, Avail]),
        Metrics = [{metric, Name, Val*Units} || {Name, Val} <- MemData],
        {ok, Summary, [{metric, usage, Usage} | Metrics]};
    {error, _Reason} ->
        {unknown, "snmp error", []}
    end.


