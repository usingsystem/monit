%%%----------------------------------------------------------------------
%%% File    : smarta_sched.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monitor Task Scheduler
%%% Created : 12 Jan. 2010
%%% License : http://www.opengoss.com
%%%
%%% Copyright (C) 2007-2010, www.opengoss.com 
%%%----------------------------------------------------------------------
-module(smarta_sched).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [timestamp/0]).

-behavior(gen_server).

-export([start_link/0]).

-export([schedule/2, 
         schedule/3, 
         unschedule/1, 
         reschedule/2, 
         get_task/1,
         get_taskids/0,
         update_task/2, 
         clear_tasks/0,
         task_num/0]).

-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2, 
         terminate/2, 
         code_change/3]).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

schedule(Task, Interval) ->
    schedule(Task, Interval, 0).

schedule(Task, Interval, Delay) ->
    gen_server:call(?MODULE, {schedule, Task, Interval, Delay}).

unschedule(TaskId) ->
    gen_server:call(?MODULE, {unschedule, TaskId}).

update_task(TaskId, TaskAttrs) ->
    gen_server:call(?MODULE, {update_task, TaskId, TaskAttrs}).

clear_tasks() ->
    gen_server:call(?MODULE, clear_tasks).

reschedule(TaskId, Interval) ->
    gen_server:cast(?MODULE, {reschedule, TaskId, Interval}).

get_taskids() ->
    Tasks = ets:match(monit_task, '$1'),
    [Id || [#monit_task{taskid = Id}] <- Tasks].

get_task(TaskId) ->
    ets:lookup(monit_task, TaskId).

task_num() ->
    ets:info(monit_task, size).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    %chash_pg:create(monit_sched),
    %chash_pg:join(monit_sched, self()),
    ets:new(monit_task, [set, named_table, protected, {keypos, 2}]),
    erlang:send_after(300 * 1000, self(), introspect),
    {ok, state}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({schedule, #monit_task{taskid= TaskId} = Task, _Interval, Delay}, _From, State) -> 
    NextCheckAt = timestamp() + Delay, %+ Interval 
    ?INFO("schedule task: ~p, next_check_at: ~p", [TaskId, NextCheckAt]),
    TRef = erlang:send_after(Delay * 1000, self(), {run, TaskId}),
    ets:insert(monit_task, Task#monit_task{tref = TRef, next_check_at = NextCheckAt}),
    {reply, ok, State};

handle_call({unschedule, TaskId}, _From, State) ->
    case ets:lookup(monit_task, TaskId) of
    [#monit_task{tref = TRef} = _Task] ->
        ?INFO("unschedule task: ~p", [TaskId]),
        cancel_timer(TRef),
        ets:delete(monit_task, TaskId);
    [] ->
        ?WARNING("cannot find task: ~p", [TaskId])
    end,
    {reply, ok, State};

handle_call({update_task, TaskId, TaskAttrs}, _From, State) ->
    case ets:lookup(monit_task, TaskId) of
    [Task] ->
        NewTask = merge_attrs(TaskAttrs, Task),
        ets:insert(monit_task, NewTask);
    [] ->
        ?WARNING("cannot find task: ~p", [TaskId])
    end,
    {reply, ok, State};

handle_call(clear_tasks, _From, State) ->
    clear_task(ets:first(monit_task)),
    ets:delete_all_objects(monit_task),
    {reply, ok, State};

handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unexpected_request}, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({reschedule, TaskId, Interval}, State) ->
    case ets:lookup(monit_task, TaskId) of
    [Task] ->
        ?INFO("reschedule task: ~p ", [TaskId]),
        TRef = erlang:send_after(Interval * 1000, self(), {run, TaskId}),
        ets:insert(monit_task, Task#monit_task{tref = TRef});
    [] ->
        ?WARNING("cannot find task: ~p", [TaskId])
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({run, TaskId}, State) ->
    case ets:lookup(monit_task, TaskId) of
    [Task] -> 
        spawn(fun() -> smarta_task:run(Task) end);
    [] ->
        ?WARNING("task '~p' is not existed", [TaskId])
    end,
    {noreply, State};

handle_info(introspect, State) ->
    Size = ets:info(monit_task, size),
    {_, QueueLen} = process_info(self(), message_queue_len),
    if
    QueueLen > 20 ->
        ?WARNING("task_size=~p, queue_len: ~p", [Size, QueueLen]);
    true ->
        ok
    end,
    erlang:send_after(300 * 1000, self(), introspect),
    {noreply, State};
    
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ets:delete(monit_task),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

clear_task('$end_of_table') ->
    ok;

clear_task(TaskId) -> 
    case ets:lookup(monit_task, TaskId) of
    [#monit_task{tref=TRef} = _Task] -> 
        cancel_timer(TRef);
    [] -> 
        ok
    end,
    clear_task(ets:next(monit_task, TaskId)).

cancel_timer(undefined) ->
    ok;

cancel_timer(TRef) ->
    erlang:cancel_timer(TRef).

merge_attrs(Attrs, #monit_task{name = OldName, 
        status = Status,
        status_type = StatusType,
        current_attempts = CurrentAttempts,
        duration = Duration,
        latency = Latency,
        last_check_at = LastCheckAt,
        next_check_at = NextCheckAt,
        check_interval = OldCheckInterval, 
        max_attempts = OldMaxAttempts, 
        attempt_interval = OldAttemptInterval,
        command = OldCommand, 
        is_collect = OldIsCollect, 
        warning = OldWarning, 
        critical = OldCritical, 
        args = OldArgs} = Task) ->

    {value, NewStatus} = dataset:get_value(status, Attrs, Status),
    {value, NewStatusType} = dataset:get_value(status_type, Attrs, StatusType),
    {value, NewCurrentAttempts} = dataset:get_value(current_attempts, Attrs, CurrentAttempts),
    {value, NewDuration} = dataset:get_value(duration, Attrs, Duration),
    {value, NewLatency} = dataset:get_value(latency, Attrs, Latency),
    {value, NewLastCheckAt} = dataset:get_value(last_check_at, Attrs, LastCheckAt),
    {value, NewNextCheckAt} = dataset:get_value(next_check_at, Attrs, NextCheckAt),

    {value, NewName} = dataset:get_value(name, Attrs, OldName),
    {value, NewCheckInterval} = dataset:get_value(check_interval, Attrs, OldCheckInterval),
    {value, NewMaxAttempts} = dataset:get_value(max_attempts, Attrs, OldMaxAttempts),
    {value, NewAttemptInterval} = dataset:get_value(attempt_interval, Attrs, OldAttemptInterval),
    {value, NewCommand} = dataset:get_value(command, Attrs, OldCommand),
    {value, NewIsCollect} = dataset:get_value(is_collect, Attrs, OldIsCollect),
    {value, NewWarning} = dataset:get_value(warning, Attrs, OldWarning),
    {value, NewCritical} = dataset:get_value(critical, Attrs, OldCritical),
    {value, NewArgs} = dataset:get_value(args, Attrs, OldArgs),
    Task#monit_task{name = NewName,
        status = NewStatus,
        status_type = NewStatusType,
        current_attempts = NewCurrentAttempts,
        duration = NewDuration,
        latency = NewLatency,
        last_check_at = NewLastCheckAt,
        next_check_at = NewNextCheckAt,
        check_interval = NewCheckInterval,
        max_attempts = NewMaxAttempts,
        attempt_interval = NewAttemptInterval,
        command = NewCommand,
        is_collect = NewIsCollect,
        warning = NewWarning,
        critical = NewCritical,
        args = NewArgs}.

