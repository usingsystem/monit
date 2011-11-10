%%%----------------------------------------------------------------------
%%% File    : smarta_disco.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Smarta discovery server
%%% Created : 02 Apr 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_disco).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [to_list/1]).

-behavior(gen_server).

-export([start_link/0]).

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

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    smarta:callback(smarta_state, self()),
    smarta:callback({iq, 'monit:iq:disco#tasks'}, self()),
    smarta:callback({iq, 'monit:iq:disco#services'}, self()),
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
handle_info({smarta_state, connected, _S}, State) ->
    ?INFO("smarta is connected.", []),
    {noreply, State};

handle_info({smarta_state, established, Session}, State) ->
    Query = exmpp_xml:element('monit:iq:disco#tasks', 'query'),
    QueryId = "disco_tasks_" ++ integer_to_list(smarta:random_seq()),
    IQ = exmpp_iq:get(?NS_JABBER_CLIENT, Query, QueryId),
    IQ1 = exmpp_xml:set_attribute(IQ, to, <<"cloud.monit.cn">>),
    exmpp_session:send_packet(Session, IQ1),
    {noreply, State};

handle_info({smarta_state, unestablished, _Session}, State) ->
    ?INFO("smarta is unestablished.", []),
    {noreply, State};

handle_info({smarta_state, disconnected}, State) ->
    ?INFO("smarta is disconnected.", []),
    {noreply, State};

handle_info({iq, {'monit:iq:disco#tasks', Type, _, _Id, IQ}, Session}, State) ->
    case Type of
    set ->
        exmpp_session:send_packet(Session, exmpp_iq:result(IQ));
    result ->
        ok
    end,
    Items = exmpp_xml:get_elements(exmpp_iq:get_payload(IQ), item),
    spawn(fun() -> disco_services(Items, Session) end),
    {noreply, State};

handle_info({iq, {'monit:iq:disco#services', result, _, Id, _IQ}}, State) ->
    ?INFO("disco#services result: ~p", [Id]),
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
    smarta:uncallback(smarta_state, self()),
    smarta:uncallback(iq, 'monit:iq:disco#tasks', self()),
    smarta:uncallback(iq, 'monit:iq:disco#services', self()),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

disco_services(Items, Session) ->
    lists:foreach(fun(Item) -> 
        ?INFO("~p", [Item]),
        TaskIdS = exmpp_xml:get_attribute(Item, id, <<"">>),
        ?INFO("~p", [TaskIdS]),
        TaskId = binary_to_list(TaskIdS),
        Cmd = exmpp_xml:get_attribute(Item, command, <<"">>),
        Params = exmpp_xml:get_attribute(Item, params, <<"">>),
        External0 = exmpp_xml:get_attribute(Item, external, <<"0">>),
        External = boolean(list_to_integer(binary_to_list(External0))),
        Args = parse_params(Params),
        Result = 
        case External of
        true ->
            catch smarta_plugin:run(to_list(Cmd), TaskId, Args);
        false ->
            catch apply(list_to_atom(to_list(Cmd)), run, [Args])
        end,
        DiscoResult = 
        case Result of
        {'EXIT', Error} ->
            ?ERROR("disco error: ~p", [Error]),
            {TaskId, error, "Internal Error!"};
        {error, Summary} ->
            {TaskId, error, Summary}; 
        {error, Summary, _} ->
            {TaskId, error, Summary}; 
        {ok, Summary, Services} ->
            {TaskId, ok, Summary, Services}
        end,
        ?INFO("~p", [DiscoResult]),
        Query = exmpp_xml:element('monit:iq:disco#services', 'query', 
            [], [new_disco_result(DiscoResult)]),
        IQ = exmpp_iq:set(?NS_JABBER_CLIENT, Query, "set_" ++ integer_to_list(smarta:random_seq())),
        IQ1 = exmpp_xml:set_attribute(IQ, to, <<"cloud.monit.cn">>),
        exmpp_session:send_packet(Session, IQ1)
    end, Items).

new_disco_result({TaskId, error, Summary}) ->
    Item = exmpp_xml:element(item),
    Attrs = [exmpp_xml:attribute(id, TaskId),
             exmpp_xml:attribute(status, "error"),
             exmpp_xml:attribute(summary, Summary)],
    exmpp_xml:set_attributes(Item, Attrs);

new_disco_result({TaskId, ok, Summary, Items}) ->
    Attrs = [exmpp_xml:attribute(id, TaskId),
             exmpp_xml:attribute(status, "ok"),
             exmpp_xml:attribute(summary, Summary)],
    Children = 
    lists:map(
        fun({service, C, N, P, S}) -> 
            Service = [{name, N},
                {command, to_list(C)}, 
                {params, P},
                {summary, S}],
            exmpp_xml:set_attributes(exmpp_xml:element(service), 
                [exmpp_xml:attribute(Name, Val) || {Name, Val} <- Service]);
           ({entry, G, N, V}) ->
            Entry = [{group, to_list(G)},
                {name, to_list(N)},
                {value, V}],
            exmpp_xml:set_attributes(exmpp_xml:element(entry), 
                [exmpp_xml:attribute(Name, Val) || {Name, Val} <- Entry])
    end, Items),
    exmpp_xml:element(undefined, item, Attrs, Children).

parse_params(Params0) ->
    Params = string:tokens(to_list(Params0), "&"),
    [begin 
        Idx = string:chr(Param, $=),
        Arg = string:substr(Param, 1, Idx -1),
        Val = string:substr(Param, Idx + 1),
        {list_to_atom(Arg), Val}
     end || Param <- Params].

boolean(0) -> false;
boolean(1) -> true;
boolean("false") -> false;
boolean("true") -> true.

