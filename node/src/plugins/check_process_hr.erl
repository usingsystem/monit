%%%----------------------------------------------------------------------
%%% File    : check_process_hr.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check process's cpu, mem by houst-resources-mib 
%%% Created : 09 Apr 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_process_hr).

-include("elog.hrl").

-include("mib_host_res.hrl").

-import(lists, [concat/1]).

-import(extbif, [to_list/1, to_integer/1, timestamp/0]).

-export([run/1]).

run(Args) ->
    {value, Uuid0} = dataset:get_value(uuid, Args),
    Uuid = to_list(Uuid0),
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, Name} = dataset:get_value(name, Args),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_table(Host, Port, ?hrSWRun, AgentData) of
    {ok, Procs} ->
        Timestamp = timestamp() - 5,
        ProcsGot = 
        lists:filter(fun(Proc) -> 
            {value, PName} = dataset:get_value(runName, Proc),
            string:str(string:to_lower(PName), string:to_lower(Name)) =/= 0
        end, Procs),
        case length(ProcsGot) of
        0 -> 
            Summary = concat(["process count = 0"]),  
            {critical, Summary};
        Count ->
            Memories = [begin {value, Mem} = dataset:get_value(mem, Proc), Mem end || Proc <- ProcsGot],
            MMax = lists:max(Memories) / 1000,
            MAvg = lists:sum(Memories) / (Count * 1000),
            Summary = concat(["process count = ", Count, ", max memory = ", float_to_str(MMax), "M"]),
            Metrics = [{metric, count, Count}, {metric, mmax, MMax}, {metric, mavg, MAvg}],
            case calc_cpus(Uuid, Timestamp, ProcsGot) of
            {ok, UMax, UAvg} ->
                Summary1 = concat([Summary, ", max cpu = ", float_to_str(UMax), "%"]),
                Metrics1 = [{metric, umax, UMax}, {metric, uavg, UAvg} | Metrics],
                {ok, Summary1, Metrics1};
            nodata ->
                {ok, Summary, Metrics}
            end
        end;
    {error, _Reason} ->
        {unknown, "snmp error"}
    end.

calc_cpus(Uuid, Timestamp, ProcsGot) ->
    Usages = 
    lists:map(fun(Proc) -> 
        {value, Cpu} = dataset:get_value(cpu, Proc),
        {value, [Idx]} = dataset:get_value(tableIndex, Proc),
        Key = concat([Uuid, ".", Idx]),
        case monit_last:get_last(Key) of
        {ok, {LastTime, LastCpu}} -> 
            monit_last:insert_last(Key, {Timestamp, Cpu}),
            (Cpu - LastCpu) / (Timestamp - LastTime);
        false ->
            monit_last:insert_last(Key, {Timestamp, Cpu}),
            nodata
        end
    end, ProcsGot),
    Usages1 = [Usage || Usage <- Usages, Usage =/= nodata],
    case length(Usages1) of
    0 -> nodata;
    Count ->
        UMax = lists:max(Usages),
        UAvg = lists:sum(Usages)/Count,
        {ok, UMax, UAvg}
    end.

float_to_str(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

