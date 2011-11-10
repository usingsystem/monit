%%%----------------------------------------------------------------------
%%% File    : monit_task.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Schedulable Monitor Task
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_task).

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [to_list/1, timestamp/0]).

-export([run/1]).

run(#monit_task{taskid = TaskId, command = Cmd, external = External, args = Args} = Task) -> 
    SchedTime = timestamp(),
    Result = 
    case External of
    true ->
        catch monit_plugin:run(to_list(Cmd), TaskId, Args);
    false ->
        catch run_plugin(list_to_atom(to_list(Cmd)), [{uuid, TaskId}|Args])
    end,
    case Result of
    {error, Reason} -> 
        ?WARNING("plugin error: command=~p,  reason=~p", [Cmd, Reason]),
        reschedule(SchedTime, Task);
    {'EXIT', Error} ->
        ?ERROR("plugin exit: ~p ~n~p ~n~p", [Error, erlang:get_stacktrace(), Args]),
        reschedule(SchedTime, Task);
    {Status, Summary, DataList} when is_atom(Status), is_list(DataList) -> 
        Metrics = find_metrics(DataList, []),
        NewStatus = 
        try check_thresh(Status, Metrics, Task)
        catch
        _:Err -> 
            ?ERROR("~p~n~p ~n~p", [Err, Metrics, Task]),
            Status
        end,
        {StatusType, CurrentAttempts} = check_status_type(NewStatus, Task),
        NewTask = Task#monit_task{status = NewStatus, current_attempts = CurrentAttempts, status_type = StatusType},
        NewTask1 = reschedule(SchedTime, NewTask),
        emit_status(NewStatus, Summary, DataList, NewTask1);
    Other ->
        ?ERROR("unexpected result: ~p", [Other])
    end.

run_plugin(Cmd, Args) ->
    case apply(Cmd, run, [Args]) of
    {Status, Summary} -> {Status, Summary, []};
    {Status, Summary, Items} -> {Status, Summary, Items}
    end.

reschedule(SchedTime, #monit_task{taskid= Uuid, 
        status = Status, 
        status_type = StatusType, 
        check_interval = CheckInterval, 
        attempt_interval = AttemptInterval,
        current_attempts = CurrentAttempts,
        next_check_at = CurrentCheckAt} = Task) ->
    Period = 
    case StatusType of
    transient -> AttemptInterval;
    permanent -> CheckInterval
    end,
    FinishTime = timestamp(),
    Duration = FinishTime - SchedTime,
    Latency = SchedTime - CurrentCheckAt,
    Interval = Period - Duration,
    Interval1 = 
    if 
    Interval =< 0 ->
        ?WARNING("duration is longer than check_interval: ~p, taskid: ~p", [Duration, Uuid]),
        Period;
    Interval < 30 ->
        ?WARNING("interval is too short: ~p, taskid: ~p", [Interval, Uuid]),
        Period;
    true ->
        Interval
    end,
    NextCheckAt = (FinishTime + Interval1),
    monit_sched:update_task(Uuid, [{status, Status}, 
            {status_type, StatusType},
            {current_attempts, CurrentAttempts},
            {duration, Duration},
            {latency, Latency},
            {last_check_at, SchedTime},
            {next_check_at, NextCheckAt}]),
    monit_sched:reschedule(Uuid, Interval1),
    Task#monit_task{duration = Duration, latency = Latency, 
        last_check_at = SchedTime, next_check_at = NextCheckAt}.

emit_status(Status, Summary, DataList, #monit_task{taskid = Uuid, 
        %status = Status,
        status_type = StatusType,
        current_attempts = CurrentAttempts,
        last_check_at = LastCheckAt, 
        next_check_at = NextCheckAt,
        latency = Latency,
        duration = Duration} = _NewTask1) ->
    Timestamp = LastCheckAt + (Duration div 2),
    StatusData = [{uuid, Uuid}, 
        {timestamp, Timestamp}, 
        {status, Status},
        {summary, Summary},
        {status_type, StatusType},
        {latency, Latency},
        {duration, Duration},
        {next_check_at, NextCheckAt},
        {last_check_at, LastCheckAt},
        {current_attempts, CurrentAttempts}],
    monit_node:send({status, StatusData, DataList}).

check_thresh(Status, Metrics, Task) ->
    NewStatus = check_thresh(Status, Metrics, warning, Task#monit_task.warning),
    check_thresh(NewStatus, Metrics, critical, Task#monit_task.critical).

%%check thresholds
check_thresh(Status, Metrics, _ThreshStatus, ThreshExp) when 
    (length(Metrics) == 0) or (ThreshExp == undefined) ->
    Status;

check_thresh(Status, Metrics, ThreshStatus, ThreshExp) ->
    %?INFO("check_thresh: ~p, ~p", [ThreshExp, Values]),
    case prefix_exp:eval(ThreshExp, Metrics) of
    true -> max_status(ThreshStatus, Status);
    false -> Status
    end.

find_metrics([], Acc) ->
    Acc;
find_metrics([{metric, Name, Val}|T], Acc) ->
    find_metrics(T, [{Name, Val}|Acc]);

find_metrics([_|T], Acc) ->
    find_metrics(T, Acc).

%%check status type
check_status_type(NewStatus, #monit_task{status = OldStatus, status_type = OldStatusType, 
    max_attempts = MaxAttempts, current_attempts = LastAttemps} = _Task) ->
    IsOK = ok(NewStatus),
    case {ok(OldStatus), OldStatusType} of
    {ok, transient} ->
        transient_ok(IsOK, LastAttemps, MaxAttempts);
    {non_ok, transient} ->
        transient_nonok(IsOK, LastAttemps, MaxAttempts);
    {ok, permanent} ->
        permanent_ok(IsOK, LastAttemps, MaxAttempts);
    {non_ok, permanent} ->
        permanent_nonok(IsOK, LastAttemps, MaxAttempts)
    end.

%%finite state machine.
%%Stat: {transient, ok}, Event: ok 
transient_ok(ok, _LastAttemps, _MaxAttempts) ->
    {permanent, 1};

%%Stat: {transient, ok}, Event: non-ok 
transient_ok(non_ok, _LastAttemps, _MaxAttempts) ->
    {transient, 1}.

%%State: {transient, non-ok}, Event: ok
transient_nonok(ok, LastAttemps, _MaxAttempts) ->
    {transient, LastAttemps + 1};

%%State: {transient, non-ok}, Event: non-ok and (currentAttempts = MaxAttempts)
transient_nonok(non_ok, LastAttemps, MaxAttempts) 
    when (LastAttemps + 1) == MaxAttempts ->
    {permanent, LastAttemps + 1};

%%State: {transient, non-ok}, Event: non-ok and (currentAttempts < MaxAttempts)
transient_nonok(non_ok, LastAttemps, MaxAttempts) 
    when (LastAttemps + 1) < MaxAttempts ->
    {transient, LastAttemps + 1}.

%%State: {permanent, ok}, Event: non-ok 
permanent_ok(non_ok, _LastAttemps, _MaxAttempts) ->
    {transient, 1};

%%State: {permanent, ok}, Event: ok 
permanent_ok(ok, _LastAttemps, _MaxAttempts) ->
    {permanent, 1}.

%%State: {permanent, nonok}, Event: ok 
permanent_nonok(ok, _LastAttemps, _MaxAttempts) ->
    {permanent, 1};

%%State: {permanent, nonok}, Event: nonok
permanent_nonok(non_ok, _LastAttemps, _MaxAttempts) ->
    {permanent, 1}.

ok(ok) ->
    ok;

ok(_) ->
    non_ok.

max_status(Status1, Status2) ->
   Max = lists:max([status_id(Status1), status_id(Status2)]), 
   status_name(Max).

status_id(ok) -> 0;
status_id(warning) -> 1;
status_id(critical) -> 2;
status_id(unknown) -> 3;
status_id(pending) -> 4.

status_name(0) -> ok;
status_name(1) -> warning;
status_name(2) -> critical;
status_name(3) -> unkown;
status_name(4) -> pending.

