%%%----------------------------------------------------------------------
%%% File    : smarta_entry.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Smarta managed entries container.
%%% Created : 03 Apr. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_entry).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [timestamp/0, to_list/1]).

-behavior(gen_server).

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

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
    smarta:callback(smarta_state, self()),
    smarta:callback({iq, 'monit:iq:service#info'}, self()),
    smarta:callback({iq, 'monit:iq:service#items'}, self()),
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
handle_info({smarta_state, connected, _S}, State) ->
    ?DEBUG("smarta is connected.", []),
    {noreply, State};

handle_info({smarta_state, established, Session}, State) ->
    Query = exmpp_xml:element('monit:iq:service#items', 'query'),
    QueryId = "service_query_" ++ integer_to_list(smarta:random_seq()),
    IQ = exmpp_iq:get(?NS_JABBER_CLIENT, Query, QueryId),
    IQ1 = exmpp_xml:set_attribute(IQ, to, <<"cloud.monit.cn">>),
    exmpp_session:send_packet(Session, IQ1),
    {noreply, State};

handle_info({smarta_state, unestablished, _S}, State) ->
    ?INFO("smarta is unestablished.", []),
    {noreply, State};

handle_info({smarta_state, disconnected}, State) ->
    ?INFO("smarta is disconnected.", []),
    {noreply, State};

handle_info({iq, {'monit:iq:service#items', result, _, _Id, IQ}, Session}, State) ->
    Query = exmpp_iq:get_payload(IQ),
    Items = exmpp_xml:get_elements(Query, item),
    try process_service_items(Items, Session) 
    catch 
    _:Err -> ?WARNING("~p", [Err])
    end,
    {noreply, State};

handle_info({iq, {'monit:iq:service#items', set, _, _Id, IQ}, Session}, State) ->
    %%reply
    exmpp_session:send_packet(Session, exmpp_iq:result(IQ)),
    %%process service items
    Items = exmpp_xml:get_elements(exmpp_iq:get_payload(IQ), item),
    [process_service_item(Item) || Item <- Items],
    {noreply, State};

handle_info({iq, {'monit:iq:service#info', result, _, _Id, IQ}, _Session}, State) ->
    Items = exmpp_xml:get_elements(exmpp_iq:get_payload(IQ), item),
    [process_service_item(Item) || Item <- Items],
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
process_service_items(Items, Session) ->
    Uuids0 = [exmpp_xml:get_attribute(Item, uuid, undefined) || Item <- Items],
    Uuids = [Uuid || Uuid <- Uuids0, Uuid =/= undefined],
    %%should remove the services that will not be scheduled!
    DeletedIds = smarta_sched:get_taskids() -- Uuids,
    [unsched_service(Id) || Id <- DeletedIds],
    [begin query_service(Uuid, Session), timer:sleep(10) end || Uuid <- Uuids].

query_service(Uuid, Session) ->
    Attrs = [exmpp_xml:attribute(uuid, Uuid)],
    QueryId = "query_service_" ++ integer_to_list(smarta:random_seq()),
    Query = exmpp_xml:element('monit:iq:service#info', 'query', Attrs, []),
    IQ = exmpp_iq:get(?NS_JABBER_CLIENT, Query, QueryId),
    IQ1 = exmpp_xml:set_attribute(IQ, to, <<"cloud.monit.cn">>),
    exmpp_session:send_packet(Session, IQ1).

process_service_item(Item) ->
    Uuid = exmpp_xml:get_attribute(Item, uuid, undefined),
    Action = exmpp_xml:get_attribute(Item, action, undefined),
    case Action of
    <<"remove">> ->
        unsched_service(Uuid);
    _ -> 
        try sched_service(Uuid, Item)
        catch
        _:Err -> ?WARNING("~p", [Err])
        end
    end.

sched_service(Uuid, Item) when is_record(Item, xmlel) ->
    case smarta_sched:get_task(Uuid) of
    [_Task] ->
        Id = exmpp_xml:get_attribute_as_list(Item, id, "0"),
        Name = exmpp_xml:get_attribute(Item, name, ""),
        CheckInterval = exmpp_xml:get_attribute_as_list(Item, check_interval, "300"),
        AttemptInterval = exmpp_xml:get_attribute_as_list(Item, attempt_interval, "60"),
        MaxAttempts = exmpp_xml:get_attribute_as_list(Item, max_attempts, "3"),
        Command = exmpp_xml:get_attribute_as_list(Item, command, "undefined"),
        External = exmpp_xml:get_attribute_as_list(Item, external, "true"),
        Params = exmpp_xml:get_attribute_as_list(Item, params, ""),
        IsCollect = exmpp_xml:get_attribute_as_list(Item, is_collect, "true"),
        Warning = exmpp_xml:get_attribute_as_list(Item, threshold_warning, ""),
        Critical = exmpp_xml:get_attribute_as_list(Item, threshold_critical, ""),
        Args = parse_params(Params),
        TaskAttrs = [{name, Name}, 
            {sid, list_to_integer(Id)},
            {check_interval, list_to_integer(CheckInterval)}, 
            {max_attempts, list_to_integer(MaxAttempts)}, 
            {attempt_interval, list_to_integer(AttemptInterval)},
            {command, Command},
            {external, boolean(External)},
            {is_collect, boolean(IsCollect)},
            {warning, parse_thresh(Warning)}, 
            {critical, parse_thresh(Critical)},
            {args, Args}],
        smarta_sched:update_task(Uuid, TaskAttrs);
    [] ->
        Id = exmpp_xml:get_attribute_as_list(Item, id, "0"),
        Name = exmpp_xml:get_attribute_as_list(Item, name, ""),
        CheckInterval = exmpp_xml:get_attribute_as_list(Item, check_interval, "300"),
        AttemptInterval = exmpp_xml:get_attribute_as_list(Item, attempt_interval, "60"),
        MaxAttempts = exmpp_xml:get_attribute_as_list(Item, max_attempts, "3"),
        Command = exmpp_xml:get_attribute_as_list(Item, command, "undefined"),
        External = exmpp_xml:get_attribute_as_list(Item, external, "true"),
        Params = exmpp_xml:get_attribute_as_list(Item, params, ""),
        IsCollect = exmpp_xml:get_attribute_as_list(Item, is_collect, "true"),
        Warning = exmpp_xml:get_attribute_as_list(Item, threshold_warning, ""),
        Critical = exmpp_xml:get_attribute_as_list(Item, threshold_critical, ""),
        Args = parse_params(Params),
        Task = #monit_task{
            taskid = Uuid,
            sid = list_to_integer(Id),
            name = Name,
            status = pending,
            status_type = permanent,
            summary = "",
            check_interval = list_to_integer(CheckInterval),
            attempt_interval = list_to_integer(AttemptInterval),
            max_attempts = list_to_integer(MaxAttempts),
            command = Command,
            external = boolean(External),
            args = Args,
            is_collect = boolean(IsCollect),
            warning = parse_thresh(Warning),
            critical = parse_thresh(Critical),
            created_at = timestamp()
        },
        Delay = 120 + random:uniform(300),
        smarta_sched:schedule(Task, list_to_integer(CheckInterval), Delay)
    end.

unsched_service(Uuid) ->
    smarta_sched:unschedule(Uuid).

parse_params(Params0) ->
    Params = string:tokens(to_list(Params0), "&"),
    [begin 
        Idx = string:chr(Param, $=),
        Arg = string:substr(Param, 1, Idx -1),
        Val = string:substr(Param, Idx + 1),
        {list_to_atom(Arg), Val}
     end || Param <- Params].

parse_thresh(S) when length(S) == 0 ->
    undefined;

parse_thresh(S) ->
    case catch prefix_exp:parse(S) of
    {ok, Exp} -> 
        Exp;
    Error -> 
        ?WARNING("invalid threshod: ~p ~p", [S, Error]),
        undefined
    end.

boolean(0) -> false;
boolean(1) -> true;
boolean("false") -> false;
boolean("true") -> true.
