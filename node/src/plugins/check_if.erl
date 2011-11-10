%%%---------------------------------------------------------------------- %%% File    : check_if.erl %%% Author  : Ery Lee <ery.lee@gmail.com> %%% Purpose : check interface status and traffic
%%% Created : 18 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_if).

-include("elog.hrl").

-include("mib_rfc1213.hrl").

-import(extbif, [to_list/1, to_integer/1, timestamp/0]).

-export([run/1]).

%calc: ifInPkts, ifOutPkts
-define(DEFAULT_METRICS, [{ifInOctets, inoctets}, 
    {ifInPkts, inpkts},
    {ifInUcastPkts,  inucastpkts},
    {ifInMulticastPkts,  inmcastpkts},
    {ifInBroadcastPkts,  inbcastpkts},
    {ifInNUcastPkts, innucastpkts}, 
    {ifInDiscards, indiscards}, 
    {ifInErrors, inerrors}, 
    {ifInUnknownProtos, inunknown}, 
    {ifOutOctets, outoctets}, 
    {ifOutPkts, outpkts},
    {ifOutUcastPkts, outucastpkts}, 
    {ifOutMulticastPkts, outmcastpkts}, 
    {ifOutBroadcastPkts, outbcastpkts}, 
    {ifOutNUcastPkts, outnucastpkts}, 
    {ifOutDiscards, outdiscards}, 
    {ifOutErrors, outerrors}]).

run(Args) ->
    {value, Uuid} = dataset:get_value(uuid, Args),
    {value, Host} = dataset:get_value(host, Args),
    {value, Port0} = dataset:get_value(port, Args, <<"161">>),
    Port = to_integer(Port0),
    {value, IfIndexS} = dataset:get_value(ifindex, Args),
    {value, Community} = dataset:get_value(community, Args, "public"),
    {value, Version} = dataset:get_value(snmp_ver, Args, "v2c"),
    IfIndex = list_to_integer(IfIndexS),
    AgentData = [{community, to_list(Community)}, {vsn, list_to_atom(to_list(Version))}],
    %judge whether support ifxtable?
    SnmpResult = 
    case support_ifxtable(Host, Port, IfIndex, AgentData) of
    true ->
        sesnmp:get_entry(Host, Port, ?ifXEntry, [IfIndex], AgentData);
    false ->
        sesnmp:get_entry(Host, Port, ?ifEntry, [IfIndex], AgentData);
    {error, Reason} ->
        {error, Reason}
    end,
    Timestamp = timestamp() - 1,
    Result = 
    case SnmpResult of
    {ok, Entry} ->
        {value, InUcastPkts} = dataset:get_value(ifInUcastPkts, Entry),
        {value, InNUcastPkts} = dataset:get_value(ifInNUcastPkts, Entry),
        {value, OutUcastPkts} = dataset:get_value(ifOutUcastPkts, Entry),
        {value, OutNUcastPkts} = dataset:get_value(ifOutNUcastPkts, Entry),
        InPkts = to_i(InUcastPkts) + to_i(InNUcastPkts),
        OutPkts = to_i(OutUcastPkts) + to_i(OutNUcastPkts),
        {value, IfInOctets} = dataset:get_value(ifInOctets, Entry),
        {value, IfOutOctets} = dataset:get_value(ifOutOctets, Entry),
        Entry1 = lists:keyreplace(ifInOctets, 1, Entry, {ifInOctets, IfInOctets * 8}),
        Entry2 = lists:keyreplace(ifOutOctets, 1, Entry1, {ifOutOctets, IfOutOctets * 8}),
        Entry3 = [{ifInPkts, InPkts}, {ifOutPkts, OutPkts} | Entry2],
        {ok, Entry3};
    {error, Reason1} ->
        {error, Reason1}
    end,
    case Result of
    {ok, NewEntry} ->
        %{value, IfDescr} = dataset:get_value(ifDescr, NewEntry),
        {value, IfOperStatus} = dataset:get_value(ifOperStatus, NewEntry),
        {value, IfAdminStatus} = dataset:get_value(ifAdminStatus, NewEntry),
        {value, IfSpeed} = dataset:get_value(ifSpeed, NewEntry),
        Bandwidth = integer_to_list(IfSpeed div (1000 * 1000)) ++ "Mbps",
        {Status, Summary} =
        if
        (IfAdminStatus == 2) and (IfOperStatus == 2) ->
            {warning, "operstatus = DOWN, ifspeed = " ++ Bandwidth};
        (IfAdminStatus == 1) and (IfOperStatus == 2) ->
            {warning, "operstatus = DOWN, ifspeed = " ++ Bandwidth};
        (IfAdminStatus == 1) and (IfOperStatus == 1) ->
            {ok, "operstatus = UP, ifspeed = " ++ Bandwidth};
        true ->
            S = lists:flatten(["adminstatus = ", ifstatus(IfAdminStatus),
                               ", operstatus = ", ifstatus(IfOperStatus),
                               ", ifspeed = ", Bandwidth]),
            {warning, S}
        end,
        
        case monit_last:get_last(Uuid) of
        {ok, {LastTime, LastEntry}} -> 
            monit_last:insert_last(Uuid, {Timestamp, NewEntry}),
            Metrics = calc_metrics(LastTime, LastEntry, Timestamp, NewEntry),
            InOctets = find(inoctets, Metrics),
            OutOctets = find(outoctets, Metrics),
            Summary1 = lists:concat([Summary, ", inoctets = ", f(InOctets), ", outoctets = ", f(OutOctets)]),
            {Status, list_to_binary(Summary1), entries(NewEntry) ++ Metrics};
        false ->
            monit_last:insert_last(Uuid, {Timestamp, NewEntry}),
            {Status, list_to_binary(Summary), entries(NewEntry)}
        end;
    {error, _Reason2} ->
        {unknown, "snmp error"}
    end.

support_ifxtable(Host, Port, IfIndex, AgentData) ->
    case sesnmp:get_entry(Host, Port, [?ifHCInOctets], [IfIndex], AgentData) of
    {ok, Entry} ->
        {value, InOctets} = dataset:get_value(ifInOctets, Entry),
        is_integer(InOctets);
    {error, Reason} ->
        {error, Reason}
    end.

entries(IfEntry) ->
    Entries = lists:reverse(entries(IfEntry, [])),
    lists:map(fun({Name, Value}) -> 
        {entry, ifentry, Name, Value}
    end, Entries).

entries([], Acc) ->
    Acc;
entries([{ifIndex, Idx}|IfEntry], Acc) ->
    entries(IfEntry, [{ifIndex, integer_to_list(Idx)}|Acc]);
entries([{ifDescr, Descr}|IfEntry], Acc) ->
    entries(IfEntry, [{ifDescr, Descr}|Acc]);
entries([{ifType, Type}|IfEntry], Acc) ->
    entries(IfEntry, [{ifType, integer_to_list(Type)}|Acc]);
entries([{ifSpeed, IfSpeed}|IfEntry], Acc) ->
    Speed = integer_to_list(IfSpeed div (1000 * 1000)) ++ "Mbps",
    entries(IfEntry, [{ifSpeed, Speed}|Acc]);
entries([{ifOperStatus, OperStatus}|IfEntry], Acc) ->
    entries(IfEntry, [{ifOperStatus, ifstatus(OperStatus)}|Acc]);
entries([{ifAdminStatus, AdminStatus}|IfEntry], Acc) ->
    entries(IfEntry, [{ifAdminStatus, ifstatus(AdminStatus)}|Acc]);
entries([_|IfEntry], Acc) ->
    entries(IfEntry, Acc).


calc_metrics(LastTime, LastEntry, Timestamp, Entry) ->
    Dataset = 
    lists:map(fun({Mib, Name}) -> 
        {value, Value0} = dataset:get_value(Mib, Entry, 0),
        {value, LastValue0} = dataset:get_value(Mib, LastEntry, 0),
        Value = to_i(Value0),
        LastValue = to_i(LastValue0),
        AccVal = (Value - LastValue),
        AccVal1 =
        if
        AccVal < 0 -> 0;
        true -> AccVal
        end,
        MetricValue = AccVal1 / (Timestamp - LastTime),
        MetricValue1 =
        if
        (Mib == ifInOctets) or (Mib == ifOutOctets) ->
            MetricValue / 1000;
        true ->
            MetricValue
        end,
        {Name, MetricValue1}
    end, ?DEFAULT_METRICS),
    {value, IfSpeed} = dataset:get_value(ifSpeed, Entry),
    BandWidth = IfSpeed div (1000 * 1000),
    Dataset1 = [{inband, BandWidth}, {outband, BandWidth}|Dataset],
    Dataset2 = 
    if
    BandWidth == 0 ->
        [{usage, 0}, {inusage, 0}, {outusage, 0} | Dataset1];
    true ->
        {value, InOctets} = dataset:get_value(inoctets, Dataset),
        {value, OutOctets} = dataset:get_value(outoctets, Dataset),
        InUsage = InOctets / (BandWidth * 10),
        OutUsage = OutOctets / (BandWidth * 10),
        [{usage, (InUsage + OutUsage)}, {inusage, InUsage}, {outusage, OutUsage} | Dataset1]
    end,
    [{metric, Name, Val} || {Name, Val} <- Dataset2].

ifstatus(1) -> "UP";
ifstatus(2) -> "DOWN";
ifstatus(3) -> "TEST";
ifstatus(_) -> "UNKNOWN".

f(V) when (V > 1000) ->
    [S] = io_lib:format("~.2f", [V/1000]),
    S ++ "Mbps";
f(V) ->
    [S] = io_lib:format("~.2f", [V]),
    S ++ "Kbps".

find(Name, [{metric, Name, Val}|_]) ->
    Val;
find(Name, [_|Metrics]) ->
    find(Name, Metrics);
find(_Name, []) ->
    throw(cannot_find_metric).
    
to_i(I) when is_integer(I) ->
    I;
to_i(_X) ->
    0.
