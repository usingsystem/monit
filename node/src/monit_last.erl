%%%----------------------------------------------------------------------
%%% File    : monit_last.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit last data store.
%%% Created : 15 Apr. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_last).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-behavior(gen_server).

-export([start_link/0]).

-export([get_last/1, 
         insert_last/2, 
         remove_last/1]).

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

get_last(Key) ->
    case ets:lookup(monit_last, Key) of
    [{_, Data}] -> {ok, Data};
    [] -> false
    end.

insert_last(Key, Data) ->
    gen_server:call(?MODULE, {insert_last, Key, Data}).

remove_last(Key) ->
    gen_server:cast(?MODULE, {remove_last, Key}).

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
    %key: {uuid, status|metric}
    ets:new(monit_last, [set, named_table, protected]),
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
handle_call({insert_last, Key, Data}, _From, State) ->
    ets:insert(monit_last, {Key, Data}),
    {reply, ok, State};

handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unsupported_req}, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({remove_last, Key}, State) ->
    ets:delete(monit_last, Key),
    {noreply, State};

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

