%%%----------------------------------------------------------------------
%%% File    : monit_metric.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit Metric Processor
%%% Created : 03 Apr. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_metric).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-export([start_link/0]).

-export([insert/3]).

-behavior(gen_server).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%Ts: timestamp
insert(Dn, Ts, Metrics) ->
    gen_server:cast(?MODULE, {insert, {Dn, Ts, Metrics}}).
    
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
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(Req, _From, State) ->
    ?ERROR("bagreq: ~p", [Req]),
    {reply, {error, badreq}, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({insert, {Dn, Ts, Metrics}}, State) ->
    MetricId = lists:concat([binary_to_list(Dn), ":", Ts]),
    Record = [{"_id", MetricId}, {dn, Dn}, {ts, Ts} | Metrics],
    emongo:insert(monit, "metric", Record),
    aggregate_hourly(Dn, Ts, Metrics),
    monit_last:insert(#monit_last{key = {metric, Dn}, dn = Dn, data = Ts}),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("bagmsg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.
    
%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
aggregate_hourly(Dn, Ts, Metrics) ->
    case check_last(Dn) of
    {ok, LastTime} ->
        LastHour = LastTime div 3600,
        ThisHour = Ts div 3600,
        case ThisHour > LastHour of
        true ->
            Fields = [Name || {Name, _Val} <- Metrics],
            monit_aggre:hourly({Dn, ThisHour*3600, Fields});
        false ->
            ok
        end;
    none -> 
        ok
    end.

check_last(Dn) ->
    case monit_last:lookup({metric, Dn}) of
    false -> 
        case emongo:find_one(monit, "metric", [{dn, Dn}]) of
        [Record] ->
            case dataset:get_value(<<"ts">>, Record) of
            {value, Ts} -> {ok, Ts};
            false -> none
            end;
        [] -> 
            none;
        {error, _Err} ->
            none
        end;
    {ok, LastTime} -> 
        {ok, LastTime}
    end.

