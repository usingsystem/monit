%%%----------------------------------------------------------------------
%%% File    : monit_last.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit last  status, metric 
%%% Created : 20 May. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_last).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-export([start_link/0]).

-export([lookup/1, 
        insert/1]).

-behavior(gen_server).

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
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% Key: {status, Dn} | {metric, Dn}
lookup(Key) ->
    case mnesia:dirty_read(monit_last, Key) of
    [#monit_last{data = Data}] -> {ok, Data};
    [] -> false
    end.

insert(Last) when is_record(Last, monit_last) ->
    gen_server:cast({global, ?MODULE}, {insert, Last}).

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
    mnesia:create_table(monit_last, 
        [{ram_copies, [node()]}, {index, [dn]},
        {attributes, record_info(fields, monit_last)}]),
    mnesia:add_table_copy(monit_last, node(), ram_copies),
    monit_object_event:attach({deleted, service}, self()),
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
handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unexpected_request}, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({insert, Last}, State) ->
    mnesia:dirty_write(Last),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected message: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({deleted, service, Dn}, State) ->
    delete_last(Dn),
    {noreply, State};

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
    monit_object_event:detach({deleted, service}, self()),
    ok.
    
%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

delete_last(Dn) ->
    [ mnesia:dirty_delete_object(O) || O <- 
        mnesia:dirty_index_read(monit_last, Dn, #monit_last.dn)].
