%%%----------------------------------------------------------------------
%%% File    : monit_node.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit node core module.
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_node).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [timestamp/0, to_list/1]).

-export([send/1]).

-export([start_link/0, 
         cluster/1,
         stop/0]).

-behavior(gen_server).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3 ]).

-record(state, {consumer_tag}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

cluster(Node) ->
    case net_adm:ping(Node) of
    pong -> {ok, nodes()};
    pang -> {error, "ping node failure."}
    end.

send({status, StatusData, DataItems}) ->
    amqp:send("status", term_to_binary({status, StatusData, DataItems}));

send({event, Event}) ->
    amqp:send("event", term_to_binary({event, Event})).

stop() ->
    gen_server:call(?MODULE, stop).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    chash_pg:create(monet_sched),
    amqp:queue("task"),
    {ok, Tag} = amqp:consume("task", self()),
    {ok, #state{consumer_tag = Tag}}.

handle_call(stop, _From, State) ->
    {stop, normal, ok, State};

handle_call(Req, _From, State) ->
    ?ERROR("unexpected request: ~p", [Req]),
    {reply, ok, State}.

handle_cast(Msg, State) ->
    ?ERROR("unexpected message: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}, 
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({deliver, <<"task">>, _Properties, Payload}, State) ->
    case binary_to_term(Payload) of
    {add, Service} ->
        {value, Uuid} = dataset:get_value(uuid, Service),
        {value, Interval} = dataset:get_value(check_interval, Service),
        Task = new_task(Service),
        Delay = 120 + random:uniform(300),
        Pid = chash_pg:get_pid(monit_sched, Uuid),
        rpc:call(node(Pid), monit_sched, schedule, [Task, Interval, Delay]);
    {update, Service} ->
        {value, Uuid} = dataset:get_value(uuid, Service),
        TaskAttrs = task_attrs(Service),
        Pid = chash_pg:get_pid(monit_sched, Uuid),
        rpc:call(node(Pid), monit_sched, update_task, [Uuid, TaskAttrs]);
    {delete, Uuid} ->
        Pid = chash_pg:get_pid(monit_sched, Uuid),
        rpc:call(node(Pid), monit_sched, unschedule, [Uuid]);
    Other ->
        ?ERROR("unknown packet: ~p", [Other])
	end,
    {noreply, State};
    
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, #state{consumer_tag = Tag}) ->
    amqp:cancel(Tag),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

new_task(Service) ->
    {value, Uuid} = dataset:get_value(uuid, Service),
    {value, Name} = dataset:get_value(name, Service),
    {value, CheckInterval} = dataset:get_value(check_interval, Service, 300),
    {value, AttemptInterval} = dataset:get_value(attempt_interval, Service, 60),
    {value, MaxAttempts} = dataset:get_value(max_attempts, Service, 3),
    {value, Command} = dataset:get_value(command, Service),
    {value, External} = dataset:get_value(external, Service),
    {value, Params} = dataset:get_value(params, Service, ""),
    {value, IsCollect} = dataset:get_value(is_collect, Service),
    {value, Warning} = dataset:get_value(threshold_warning, Service, ""),
    {value, Critical} = dataset:get_value(threshold_critical, Service, ""),
    Args = parse_params(Params),
    #monit_task{
        taskid = Uuid,
        name = Name,
        status = pending,
        status_type = permanent,
        summary = "",
        check_interval = CheckInterval,
        attempt_interval = AttemptInterval,
        max_attempts = MaxAttempts,
        command = Command,
        external = boolean(External),
        args = Args,
        is_collect = boolean(IsCollect),
        warning = parse_thresh(Warning),
        critical = parse_thresh(Critical),
        created_at = timestamp()
    }.

task_attrs(Service) ->
    {value, Name} = dataset:get_value(name, Service),
    {value, CheckInterval} = dataset:get_value(check_interval, Service, 300),
    {value, AttemptInterval} = dataset:get_value(attempt_interval, Service, 60),
    {value, MaxAttempts} = dataset:get_value(max_attempts, Service, 3),
    {value, Command} = dataset:get_value(command, Service),
    {value, External} = dataset:get_value(external, Service),
    {value, Params} = dataset:get_value(params, Service, ""),
    {value, IsCollect} = dataset:get_value(is_collect, Service),
    {value, Warning} = dataset:get_value(threshold_warning, Service, undefined),
    {value, Critical} = dataset:get_value(threshold_critical, Service, undefined),
    Args = parse_params(Params),
    [{name, Name}, 
     {check_interval, CheckInterval}, 
     {max_attempts, MaxAttempts}, 
     {attempt_interval, AttemptInterval},
     {command, Command},
     {external, boolean(External)},
     {is_collect, boolean(IsCollect)},
     {warning, parse_thresh(Warning)}, 
     {critical, parse_thresh(Critical)},
     {args, Args}].
   
boolean(0) -> false;

boolean(1) -> true.
    
parse_params(Params0) ->
    Params = string:tokens(to_list(Params0), "&"),
    [begin 
        Idx = string:chr(Param, $=),
        Arg = string:substr(Param, 1, Idx -1),
        Val = string:substr(Param, Idx + 1),
        {list_to_atom(Arg), Val}
     end || Param <- Params].

parse_thresh(undefined) ->
    undefined;
parse_thresh(<<>>) ->
    undefined;
parse_thresh("") ->
    undefined;
parse_thresh(S) ->
    case catch prefix_exp:parse(S) of
    {ok, Exp} -> 
        Exp;
    Error -> 
        ?WARNING("invalid threshod: ~p ~p", [S, Error]),
        undefined
    end.

