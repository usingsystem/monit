%%%----------------------------------------------------------------------
%%% File    : monit_flap.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit flapping detection
%%% Created : 03 Apr. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_flap).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-behavior(gen_server).

-export([start_link/0]).

-export([check/1]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {flap_low_threshold = 20, 
    flap_high_threshold = 30}).

-define(MAX_HISTORY_ENTRIES, 20).
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

check({status, Status}) ->
    gen_server:call(?MODULE, {check, Status}).

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
handle_call({check, StatusData}, _From, State) ->
    {value, Dn} = dataset:get_value(dn, StatusData),
    {value, Status} = dataset:get_value(status, StatusData),
    {value, StatusType} = dataset:get_value(status_type, StatusData, permanent),
    % if this is a soft service state and not a soft recovery, don't record this in the history 
    % only hard states and soft recoveries get recorded for flap detection.
    if
    (Status =/= ok) and (StatusType == transient) ->
        {reply, ignore, State};
    true ->
        {reply, check_flapping(Dn, Status, State), State}
    end;

handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unsupported_req}, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.
%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
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
check_flapping(Dn, Status, State) ->
    case monit_last:lookup({flap, Dn}) of
    {ok, {IsFlapping, Q}} ->
        check_flapping1(Dn, Status, {IsFlapping, Q}, State);
    false -> 
        monit_last:insert(#monit_last{key = {flap, Dn}, dn = Dn, data = {false, queue:from_list([Status])}}), 
        ignore
    end.

check_flapping1(Dn, Status, {OldIsFlapping, Q}, #state{flap_low_threshold = LowThreshold, 
    flap_high_threshold = HighThreshold} = _State) ->
    case queue:len(Q) < ?MAX_HISTORY_ENTRIES of
    true ->
        monit_last:insert(#monit_last{key = {flap, Dn}, dn = Dn, data = {false, queue:in(Status, Q)}}), 
        ignore;
    false ->
        History = [Status | lists:reverse(queue:to_list(Q))],
        {_, Q0} = queue:out(Q),
        Q1 = queue:in(Status, Q0),
        Changes = calc_changes(History, 0),
        Percent = (Changes * 100) div length(History),
        IsFlapping =
        if
        (Percent >= HighThreshold) -> true;
        (Percent < LowThreshold) -> false;
        true -> OldIsFlapping
        end,
        monit_last:insert(#monit_last{key = {flap, Dn}, dn = Dn, data = {IsFlapping, Q1}}), 
        {ok, IsFlapping, Percent}
    end.

calc_changes([S, S|T], Changes) ->
    calc_changes([S|T], Changes);

calc_changes([_S1, S2|T], Changes) ->
    calc_changes([S2|T], Changes+1);

calc_changes([_S], Changes) ->
    Changes.

