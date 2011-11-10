%%%--------------------------------------------------
%%% File    : monit_status.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : receive status from node
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_status).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [to_list/1]).

-behavior(gen_server).

-export([start_link/0, 
        max/2, 
        status_id/1, 
        status_name/1]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {consumer_tag}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

max(Status1, Status2) ->
   Max = lists:max([status_id(Status1), status_id(Status2)]), 
   status_name(Max).

%%====================================================================
%% gen_server callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    %%connect amqp
    amqp:queue("status"),
    {ok, ConsumerTag} = amqp:consume("status", self()),
    {ok, #state{consumer_tag = ConsumerTag}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(Request, _From, State) ->
    ?ERROR("badreq: ~p", [Request]),
    {reply, {error, badreq}, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(Msg, State) ->
    ?ERROR("bagmsg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({deliver, <<"status">>, _Props, Payload}, State) ->
    case binary_to_term(Payload) of
    {status, StatusData, DataList} ->
        try process_status(StatusData, DataList, State)
        catch
        _:Err -> ?ERROR("~p, ~n~p", [Err, erlang:get_stacktrace()])
        end;
    Other ->
        ?ERROR("unknown payload: ~p", [Other])
    end,
    {noreply, State};

handle_info(Info, State) ->
    ?ERROR("badinfo: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, #state{consumer_tag = Tag} = _State) ->
    amqp:cancel(Tag),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

process_status(StatusData, DataItems, State) ->
    {value, Dn} = dataset:get_value(dn, StatusData),
    {value, Timestamp} = dataset:get_value(timestamp, StatusData),
    case monit_object:lookup(Dn) of
    {ok, #monit_object{attrs = Service} = ServiceObject} ->
        StatusData1 = check_i18n(Service, StatusData),
        StatusData2 = check_flapping(StatusData1), 
        insert_into_cf(ServiceObject, StatusData2, State),
        insert_into_db(Dn, Service, StatusData2, State),
        save_metrics(Dn, Service, Timestamp, DataItems);
    false ->
        ?ERROR("no service available: ~p, ~n ~p", [Dn, StatusData])
    end.

    
find_metric([], Acc) ->
    Acc;

find_metric([{metric, Name, Val}|Items], Acc) ->
    find_metric(Items, [{Name, Val}|Acc]);

find_metric([_|T], Acc) ->
    find_metric(T, Acc).
    
save_metrics(Dn, Service, Timestamp, Items) ->
    Metrics = find_metric(Items, []),
    case length(Metrics) of
    0 -> ok;
    _ -> monit_metric:insert(Dn, Timestamp, Metrics)
    end.

check_i18n(Service, StatusData) ->
    {value, Command} = dataset:get_value(command, Service),
    {value, Summary} = dataset:get_value(summary, StatusData),
    Parts = re:split(Summary, ", "), 
    LocaleParts =
    lists:map(fun(Part) -> 
        case re:split(Part, " = ") of
        [Name, Val] ->
            LName = localize(Command, Name),
            <<LName/binary, " = ", Val/binary>>;
        [_] -> 
            localize(Command, Part);
        _ -> 
            Part
        end
    end, Parts),
    LocaleSummary = string:join([binary_to_list(B) || B <- LocaleParts], ", "),
    dataset:key_replace(summary, StatusData, {summary, list_to_binary(LocaleSummary)}).

check_flapping(StatusData) ->
    case monit_flap:check({status, StatusData}) of
    ignore ->
        StatusData;
    {ok, IsFlapping, Percent} ->
        [{is_flapping, boolean_val(IsFlapping)}, {flap_percent_state_change, Percent} | StatusData]
    end.

insert_into_cf(#monit_object{dn = Dn, parent = ParentId, attrs = Service}, StatusData, _State) ->
    {value, CtrlState} = dataset:get_value(ctrl_state, Service, 0),
    {value, Status} = dataset:get_value(status, StatusData),
    %{value, Summary} = dataset:get_value(summary, StatusData),
    {value, Ts} = dataset:get_value(timestamp, StatusData),
    {value, CheckInterval} = dataset:get_value(check_interval, Service, 300), %%TODO: retries???
    %calculate status duration time.
    StatusTime = 
    case monit_last:lookup({status, Dn}) of
    false ->
        CheckInterval;
    {ok, LastTimestamp} ->
        min(CheckInterval, (Ts - LastTimestamp))
    end,
    monit_last:insert(#monit_last{key = {status, Dn}, dn = Dn, data = Ts}),
    StatusId = lists:concat([binary_to_list(Dn), ":", Ts]),
    Record = [{"_id", StatusId}, {dn, Dn}, {ts, Ts}, {Status, StatusTime}],
    emongo:insert(monit, <<"status">>, Record),
    if
    CtrlState == 1 -> 
        case monit_object:lookup(ParentId) of
        {ok, #monit_object{dn = ParentDn}} ->
            StatusId1 = lists:concat([binary_to_list(ParentDn), ":", Ts]),
            Record1 = [{"_id", StatusId1}, {dn, ParentDn}, {ts, Ts}, {Status, StatusTime}],
            emongo:insert(monit, <<"status">>, Record1);
        false ->
            ok
        end;
    true ->
        pass
    end.

insert_into_db(_Dn, Service, StatusData, _State) ->
    {value, ServiceId} = dataset:get_value(id, Service),
    {value, Status} = dataset:get_value(status, StatusData),
    {value, Summary} = dataset:get_value(summary, StatusData),
    {value, StatusType} = dataset:get_value(status_type, StatusData, permanent),
    {value, LastCheck} = dataset:get_value(last_check_at, StatusData, 0),
    {value, NextCheck} = dataset:get_value(next_check_at, StatusData, 0),
    {value, Duration} = dataset:get_value(duration, StatusData, 0),
    {value, Latency} = dataset:get_value(latency, StatusData, 0),
    {value, CurrentAttempts} = dataset:get_value(current_attempts, StatusData, 1),
    UpdatedAt = CreatedAt = {date(), time()},
    Record = [{service_id, ServiceId}, 
        {status, status_id(Status)},
        {status_type, status_type_id(StatusType)},
        {summary, Summary},
        {last_check, LastCheck},
        {next_check, NextCheck},
        {duration, Duration},
        {latency, Latency},
        {current_attempts, CurrentAttempts},
        {created_at, CreatedAt},
        {updated_at, UpdatedAt}],
    mysql:insert(checked_status, Record).
    
status_id(ok) -> 0;
status_id(warning) -> 1;
status_id(critical) -> 2;
status_id(unknown) -> 3;
status_id(pending) -> 4.

status_name(0) -> ok;
status_name(1) -> warning;
status_name(2) -> critical;
status_name(3) -> unknown;
status_name(4) -> pending.

status_type_id(transient) -> 1;
status_type_id(permanent) -> 2.

boolean_val(true) -> 1;
boolean_val(false) -> 0.

localize(Command, Key) ->
    monit_i18n:get_locale(zh, cn, Command, Key).
