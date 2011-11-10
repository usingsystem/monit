%%%----------------------------------------------------------------------
%%% File    : check_diskio_ucd.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check linux disk io by ucd-snmp-mib
%%% Created : 26 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_diskio_ucd).

-include("elog.hrl").

-include("mib_ucd_diskio.hrl").

-import(extbif, [to_list/1, to_integer/1, timestamp/0]).

-export([run/1]).

run(Args) ->
    {value, Uuid} = dataset:get_value(uuid, Args),
    {value, Port} = dataset:get_value(port, Args, <<"161">>),
    {value, Host} = dataset:get_value(host, Args),
    {value, IoIndex} = dataset:get_value(index, Args),
    {value, Community} = dataset:get_value(community, Args, <<"public">>),
    {value, Version} = dataset:get_value(snmp_ver, Args, <<"v2c">>),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    case sesnmp:get_entry(Host, to_integer(Port), ?diskIO, [list_to_integer(IoIndex)], AgentData) of
    {ok, DiskIO} ->
        Timestamp = timestamp() - 1,
        case monit_last:get_last(Uuid) of
        {ok, {LastTime, LastDiskIO}} -> 
            monit_last:insert_last(Uuid, {Timestamp, DiskIO}),
            {Summary, Metrics} = calc_metrics(LastTime, LastDiskIO, Timestamp, DiskIO),
            {ok, Summary, Metrics};
        false ->
            monit_last:insert_last(Uuid, {Timestamp, DiskIO}),
            {ok, "reads = N/A, writes = N/A"}
        end;
    {error, _Reason} ->
        {unknown, "snmp error"}
    end.

calc_metrics(LastTime, LastDiskIO, Timestamp, DiskIO) ->
    %{value, Dev} = dataset:get_value(device, DiskIO),

    {value, LastRBytes} = dataset:get_value(rbytes, LastDiskIO),
    {value, LastWBytes} = dataset:get_value(wbytes, LastDiskIO),
    {value, LastReads} = dataset:get_value(reads, LastDiskIO),
    {value, LastWrites} = dataset:get_value(writes, LastDiskIO),

    {value, RBytes} = dataset:get_value(rbytes, DiskIO),
    {value, WBytes} = dataset:get_value(wbytes, DiskIO),
    {value, Reads} = dataset:get_value(reads, DiskIO),
    {value, Writes} = dataset:get_value(writes, DiskIO),

    Interval = (Timestamp - LastTime),

    MRBytes = unify(RBytes - LastRBytes) / (Interval * 1000),
    MWBytes = unify(WBytes - LastWBytes) / (Interval * 1000),
    MReads = unify(Reads - LastReads) / Interval,
    MWrites = unify(Writes - LastWrites) / Interval,

    Summary = lists:flatten(["reads = ", float_to_str(MRBytes), "KB/s",
            ", writes = ", float_to_str(MWBytes), "KB/s"]),
    DiskData = lists:zip([rbytes, wbytes, reads, writes], [MRBytes, MWBytes, MReads, MWrites]),
    Metrics = [{metric, Name, Val} || {Name, Val} <- DiskData],
    {Summary, Metrics}.

float_to_str(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

unify(I) when I < 0 -> 0;
unify(I) -> I.


