%%%----------------------------------------------------------------------
%%% File    : smarta_bot.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Smarta bot to handle user commands.
%%% Created : 02 Apr 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_bot).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-behavior(gen_server).

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
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
    smarta:callback({message, chat}, self()),
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
handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unsupported_req}, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.
%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info({message, FromJID, Body, Session}, State) ->
    ?INFO("message bot: ~p", [Body]),
    From = exmpp_jid:to_binary(exmpp_jid:make(FromJID)),
    Args = string:tokens(to_string(Body), "\t "),
    Output = process_cmd(Args),
    Msg = exmpp_message:make_chat(?NS_JABBER_CLIENT, Output),
    Msg1 = exmpp_xml:set_attribute(Msg, to, From),
    exmpp_session:send_packet(Session, Msg1),
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
process_cmd(["list", "services"]) ->
    TaskIds = smarta_sched:get_taskids(),
    Lines = 
    lists:map(fun(TaskId) -> 
        case smarta_sched:get_task(TaskId) of
        [Task] ->
            to_line(Task);
        [] ->
            ""
        end
    end, TaskIds),
    Total = "Total services: " ++ integer_to_list(length(TaskIds)) ++"\n",
    Head = "Status\t\tName\t\tSummary\n",
    lists:flatten([Total, Head | Lines]);

process_cmd(_Body) ->
    usage().

usage() ->
    "Welcome to agent bot! Available Commands:
    list services".

to_line(#monit_task{name = Name, status = Status, summary = Summary}) ->
    [string:to_upper(atom_to_list(Status)), "\t", to_string(Name), "\t", to_string(Summary), "\n"].

to_string(undefined) -> "";
to_string(B) when is_binary(B) -> binary_to_list(B);
to_string(L) when is_list(L) -> L.
    
