%%%----------------------------------------------------------------------
%%% File    : smarta.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Smarta Agent.
%%% Created : 14 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [timestamp/0, to_list/1]).

%utilities
-export([random_seq/0]).

%%start and stop
-export([start_link/1, 
        go/0,
        stop/0, 
        get_state/0,
        get_jid/0,
        get_roster/0]).

%%send 
-export([send/1]).

%%callback
-export([callback/2,
        uncallback/2]).

-behavior(gen_fsm).

%% gen_fsm callbacks
-export([init/1,
	 code_change/4,
	 handle_info/3,
	 handle_event/3,
	 handle_sync_event/4,
	 terminate/3]).

%%fsm States.
-export([initialized/2,
        connected/2,  %%connected to xmpp server
        established/2, %%session established with monit cloud
        disconnected/2]). %%disconnected from xmpp server.

-record(roster, {jid, subscription = both, presence}).

%-record(iq_req, {id, ns, iq, timer_ref}).

-record(state, {
        jid, 
        password, 
        host, 
        port, 
        session, 
        stream, 
        retries = 0,
        time1, %ntp t1
        timedelta = 0}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the fsm
%%--------------------------------------------------------------------
start_link(Opts) ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [Opts], []).

go() ->
    gen_fsm:send_event(?MODULE, go).

stop() ->
    gen_fsm:sync_send_all_state_event(?MODULE, stop).

get_state() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_state).

get_jid() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_jid).

get_roster() ->
    gen_fsm:sync_send_all_state_event(?MODULE, get_roster).

send({status, StatusData, DataItems}) ->
    gen_fsm:send_event(?MODULE, {send, status, StatusData, DataItems}).

callback(Hook, Pid) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {callback, Hook, Pid}).

uncallback(Hook, Pid) ->
    gen_fsm:send_all_state_event(?MODULE, {uncallback, Hook, Pid}).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([Args]) ->
    case catch do_init(Args) of
    {ok, State} ->
        timer:apply_after(6000, ?MODULE, go, []),
        {ok, initialized, State};
    {error, Reason} ->
        {stop, Reason};
    {'EXIT', Error} ->
        {stop, Error}
    end.

do_init(Args) ->
    process_flag(trap_exit, true),
    JID = make_jid(proplists:get_value(name, Args)),
    Password = proplists:get_value(password, Args),
    Host = proplists:get_value(server, Args, "localhost"),
    Port = proplists:get_value(port, Args, 5222),
    ets:new(alert, [set, protected, named_table]),
    ets:new(callback, [bag, protected, named_table]),
    ets:new(roster, [set, protected, named_table, {keypos, 2}]),
    {ok, #state{jid = JID, password = Password, host = Host, port = Port}}.

initialized(go, #state{jid = JID, password = Password, host = Host, port = Port} = State) ->
    Session = exmpp_session:start_link(),
    exmpp_session:auth_basic_digest(Session, JID, Password),
    {ok, StreamId} = exmpp_session:connect_TCP(Session, Host, Port),
    _ = exmpp_session:login(Session),
    {next_state, connected, State#state{session = Session, stream = StreamId}, 0};

initialized(Event, StateData) ->
    ?ERROR("unexpected event got in initialized state: ~p", [Event]),
    {next_state, initialized, StateData}.
    
connected(timeout, #state{session = Session} = State) ->
    %query roster
    Query = exmpp_xml:element(?NS_ROSTER, 'query'),
    IQ = exmpp_iq:get(?NS_JABBER_CLIENT, Query, "roster_" ++ integer_to_list(random_seq())),
    exmpp_session:send_packet(Session, IQ),
    %send available presence.
    exmpp_session:send_packet(Session, exmpp_presence:available()),
    %timer to probe cloud
    erlang:send_after(1000, self(), probe),
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, connected, Session} || {_, Pid} <- Callbacks],
    {next_state, connected, State}.

established({send, status, StatusData, DataItems}, #state{session = Session, timedelta = Timedelta} = StateData) ->
    StatusData1 = amend_timedelta(StatusData, Timedelta),
    Body = base64:encode(term_to_binary({status, StatusData1, DataItems})),
    Msg = exmpp_message:make_normal(?NS_JABBER_CLIENT, Body),
    Msg1 = exmpp_xml:set_attribute(Msg, to, <<"status.monit.cn">>),
    exmpp_session:send_packet(Session, Msg1),
    send_alert(StatusData, Session),
    {next_state, established, StateData}.

disconnected(Event, StateData) ->
    ?WARNING("smarta is disconnected with cloud, cannot send the event: ~p", [Event]),
    {next_state, disconnected, StateData}.
    
handle_event({uncallback, Hook, Pid}, StateName, State) ->
    ets:delete_object(callback, {Hook, Pid}),
    {next_state, StateName, State};

handle_event(Event, StateName, State) ->
    ?WARNING("unexpected event got: ~p", [Event]),
    {next_state, StateName, State}.

handle_sync_event(get_state, _From, StateName, State) ->
    {reply, StateName, StateName, State};

handle_sync_event(get_jid, _From, StateName, #state{jid = JID} = State) ->
    {reply, exmpp_jid:to_list(JID), StateName, State};

handle_sync_event(get_roster, _From, StateName, State) ->
    Roster = ets:match(roster, {'_', '$1', '$2', '$3'}),
    {reply, Roster, StateName, State};

handle_sync_event({callback, Hook, Pid}, _From, StateName, State) ->
    ets:insert(callback, {Hook, Pid}),
    {reply, ok, StateName, State};

handle_sync_event(stop, _From, _StateName, #state{session = Session} = StateData) ->
    exmpp_session:stop(Session),
    {stop, normal, ok, StateData}.

handle_info(#received_packet{packet_type=presence, type_attr = Type, from = FromJID}, 
    StateName, StateData) ->
    process_presence({list_to_atom(Type), FromJID}, StateName, StateData);

handle_info(#received_packet{packet_type=message, type_attr = Type, 
    from = FromJID, raw_packet=Packet}, StateName, StateData) ->
    process_message({list_to_atom(Type), FromJID, Packet}, StateName, StateData);

handle_info(#received_packet{packet_type=iq, type_attr = Type, 
    from = FromJID, id = Id, raw_packet=IQ}, StateName, StateData) ->
    Payload = exmpp_iq:get_payload(IQ),
    if 
    Payload == undefined ->
        {next_state, StateName, StateData};
    true ->
        NS = exmpp_xml:get_ns_as_atom(Payload),
        process_iq({NS, list_to_atom(Type), FromJID, Id, IQ}, StateName, StateData)
    end;

handle_info(probe, StateName, #state{session = Session} = StateData) ->
    Probe = exmpp_presence:probe(),
    Probe1 = exmpp_xml:set_attribute(Probe, to, <<"cloud.monit.cn">>),
    exmpp_session:send_packet(Session, Probe1),
    if 
    StateName == connected -> 
        erlang:send_after(60 * 1000, self(), probe);
    StateName == established -> 
        erlang:send_after(300 * 1000, self(), probe);
    true -> %disconnected or others
        pass
    end,
    {next_state, StateName, StateData};

handle_info(synchronize_time, StateName, #state{session = Session} = StateData) ->
    ?INFO("synchronize clock with cloud.monit.cn", []),
    Query = exmpp_xml:element('monit:iq:time', 'query'),
    QueryId = "time_query_" ++ integer_to_list(random_seq()),
    IQ = exmpp_iq:get(?NS_JABBER_CLIENT, Query, QueryId),
    IQ1 = exmpp_xml:set_attribute(IQ, to, <<"cloud.monit.cn">>),
    exmpp_session:send_packet(Session, IQ1),
    {next_state, StateName, StateData#state{time1 = timestamp()}};

handle_info({'EXIT', Session, tcp_closed}, _StateName, 
    #state{session = Session} = State) ->
    ?ERROR("xmpp: tcp_closed", []),
    ets:delete_all_objects(roster),
    erlang:send_after(10000, self(), {reconnect, 1}),
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, disconnected} || {_, Pid} <- Callbacks],
    {next_state, disconnected, State#state{session = undefined}};

handle_info({reconnect, N}, disconnected, #state{jid = JID, 
    password = Password, host = Host, port = Port} = State) ->
    ?WARNING("reconnect ~p", [N]),
    N1 = 
    if
        N > 3 -> 1;
        true -> N
    end,
    Session = exmpp_session:start_link(),
    exmpp_session:auth_basic_digest(Session, JID, Password),
    try exmpp_session:connect_TCP(Session, Host, Port) of
    {ok, StreamId} ->
        _ = exmpp_session:login(Session),
        {next_state, connected, State#state{session = Session, stream = StreamId}, 0}
    catch 
    _:Error ->
        ?WARNING("reconnect failure: ~p", [Error]),
        erlang:send_after(30000 * (2 bsl N), self(), {reconnect, N1 + 1}),
        {next_state, disconnected, State}
    end;

handle_info(Info, StateName, StateData) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {next_state, StateName, StateData}.

%%first available of cloud!
process_presence({available, {_, <<"cloud.monit.cn">>, _}}, 
    connected, #state{session = Session} = StateData) ->
    %timer to synchronize time
    erlang:send_after(3000, self(), synchronize_time),
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, established, Session} || {_, Pid} <- Callbacks],
    {next_state, established, StateData};

process_presence({available, {_, <<"cloud.monit.cn">>, _}}, 
    established, StateData) ->
    %ignore
    {next_state, established, StateData};

process_presence({available, {Node, Domain, _}}, 
    StateName, #state{jid = JID} = StateData) ->
    case exmpp_jid:bare_compare(JID, exmpp_jid:make(Node, Domain)) of
    false ->
        From = exmpp_jid:to_binary(Node, Domain),
        case ets:lookup(roster, From) of
        [] ->
            ?WARNING("unexpected available presence from ~p", [From]);
        [Roster] ->
            Callbacks = ets:lookup(callback, presence),
            [Pid ! {presence, available, From} || {_, Pid} <- Callbacks],
            ets:insert(roster, Roster#roster{presence = available})
        end;
    true -> 
        pass
    end,
    {next_state, StateName, StateData};

process_presence({unavailable, {_, <<"cloud.monit.cn">>, _}}, 
    established, #state{session = Session} = StateData) ->
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, unestablished, Session} || {_, Pid} <- Callbacks],
    {next_state, connected, StateData};

process_presence({unavailable, {_, <<"cloud.monit.cn">>, _}}, 
    _StateName, StateData) ->
    {next_state, connected, StateData};

process_presence({unavailable, {Node, Domain, _}}, StateName, StateData) ->
    From = exmpp_jid:to_binary(Node, Domain),   
    case ets:lookup(roster, From) of
    [Roster] ->
        Callbacks = ets:lookup(callback, presence),
        [Pid ! {presence, unavailable, From} || {_, Pid} <- Callbacks],
        ets:insert(roster, Roster#roster{presence = unavailable});
    [] ->
        ?WARNING("unavailable presence from ~p", [From])
    end,
    {next_state, StateName, StateData};

process_presence({probe, {_Node, <<"cloud.monit.cn">>, _}}, 
    _StateName, #state{session = Session} = StateData) ->
    exmpp_session:send_packet(Session, exmpp_presence:available()),
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, established, Session} || {_, Pid} <- Callbacks],
    {next_state, established, StateData};

process_presence({probe, {Node, Domain, _}}, StateName, 
    #state{session = Session} = StateData) ->
    From = exmpp_jid:to_binary(Node, Domain),   
    case ets:lookup(roster, From) of
    [_Roster] ->
        exmpp_session:send_packet(Session, exmpp_presence:available());
    [] ->
        ?WARNING("unavailable presence from ~p", [From])
    end,
    {next_state, StateName, StateData};

process_presence({error, {_Node, <<"clou.monit.cn">>, _}}, 
    established, #state{session = Session} = State) ->
    Callbacks = ets:lookup(callback, smarta_state),
    [Pid ! {smarta_state, unestablished, Session} || {_, Pid} <- Callbacks],
    {next_state, connected, State};

process_presence({error, {_Node, <<"clou.monit.cn">>, _}}, 
    _StateName, State) ->
    {next_state, connected, State};

process_presence({Type, FromJID}, StateName, StateData) ->
    From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
    ?WARNING("unexpected presence '~p' from ~p", [Type, From]),
    {next_state, StateName, StateData}.

process_message({normal, {_, <<"cloud.monit.cn">>, _}, Packet}, 
    established, StateData) ->
    Body = exmpp_xml:get_cdata(exmpp_xml:get_element(Packet, body)),
    ?WARNING("unexpected normal msg: ~p", [Body]),
    {next_state, established, StateData};

process_message({chat, {Node, Domain, _}, Packet}, 
    StateName, #state{session = Session} = StateData) ->
    From = exmpp_jid:to_binary(Node, Domain),
    case ets:lookup(roster, From) of
    [_Roster] ->
        Body = exmpp_xml:get_cdata(exmpp_xml:get_element(Packet, body)),
        Callbacks = ets:lookup(callback, {message, chat}),
        [Pid ! {message, From, Body, Session} || {_, Pid} <- Callbacks];
    [] ->
        ?WARNING("unexpected chat from ~p", [From])
    end,
    {next_state, StateName, StateData};

process_message({_Type, FromJID, _Packet}, StateName, StateData) ->
    From = exmpp_jid:to_binary(exmpp_jid:make(FromJID)),
    ?WARNING("unexpected message from: ~p", [From]),
    {next_state, StateName, StateData}.

process_iq({?NS_ROSTER, result, _, _Id, IQ}, StateName, StateData) -> 
    Query = exmpp_iq:get_payload(IQ),
    Items = exmpp_xml:get_elements(Query, item),
    lists:foreach(fun(Item) -> 
        JID = exmpp_xml:get_attribute(Item, jid, undefined),
        Subscription = exmpp_xml:get_attribute(Item, subscription, <<"none">>),
        ets:insert(roster, #roster{jid = JID, subscription = extbif:binary_to_atom(Subscription)})
    end, Items),
    {next_state, StateName, StateData};

process_iq({'monit:iq:time', result, _, _Id, IQ}, StateName, 
    #state{time1 = T1} = StateData) ->
    T4 = timestamp(),
    [Item|_] = exmpp_xml:get_elements(exmpp_iq:get_payload(IQ), item),
    T2 = exmpp_xml:get_attribute_as_list(Item, t2, integer_to_list(T1)),
    T3 = exmpp_xml:get_attribute_as_list(Item, t3, integer_to_list(T4)),
    Timedelta = ((list_to_integer(T2) - T1) - (T4 - list_to_integer(T3))) div 2,
    ?INFO("time delta: ~p", [Timedelta]),
    {next_state, StateName, StateData#state{time1 = undefined, timedelta = Timedelta}};

process_iq({NS, Type, {_, <<"cloud.monit.cn">>, _}, _Id, IQ} = Packet, 
    StateName, #state{session = Session} = StateData) -> 
    ?DEBUG("process iq: ~p ~p ~n~p", [NS, Type, IQ]),
    Callbacks = ets:lookup(callback, {iq, NS}),
    [Pid ! {iq, Packet, Session} || {_Hook, Pid} <- Callbacks],
    {next_state, StateName, StateData};

process_iq(IQ, StateName, StateData) -> %, {NS, Type, FromJID, Id, IQ}
    ?INFO("unexpected iq: ~p", [IQ]),
    {next_state, StateName, StateData}.
    
terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

send_alert(StatusData, Session) ->
    {value, Status} = dataset:get_value(status,StatusData),
    send_alert(Status, StatusData, Session).

send_alert(ok, StatusData, Session) ->
    {value, Uuid} = dataset:get_value(uuid, StatusData),
    case ets:lookup(alert, Uuid) of
    [] ->
        pass;
    [_] ->
        send_recovery_alert(Session, StatusData),
        ets:delete(alert, Uuid)
    end;

send_alert(critical, StatusData, Session) ->
    {value, Uuid} = dataset:get_value(uuid, StatusData),
    case ets:lookup(alert, Uuid) of
    [] ->
        send_critical_alert(Session, StatusData),
        ets:insert(alert, {Uuid, critical});
    [_] ->
        pass
    end;

send_alert(_, _, _) ->
    pass.

send_recovery_alert(Session, StatusData) ->
    {value, Uuid} = dataset:get_value(uuid, StatusData),
    case smarta_sched:get_task(Uuid) of
    [#monit_task{name = Name, sid = Sid} = _Task] ->
        {value, Summary} = dataset:get_value(summary, StatusData),
        Body = [to_list(Name), " 恢复正常: ", to_list(Summary), "\n查看详细: http://www.monit.cn/services/", integer_to_list(Sid)],
        Msg = exmpp_message:make_chat(?NS_JABBER_CLIENT, lists:concat(Body)),
        Roster = ets:match(roster, {'_', '$1', '$2', '$3'}),
        lists:foreach(
            fun([Jid, _, available]) -> 
                ?INFO("send recovery alert to: ~p", [Jid]),
                exmpp_session:send_packet(Session, exmpp_xml:set_attribute(Msg, to, Jid));
               (_) ->
                pass
        end, Roster);
    [] ->
        pass
    end.

send_critical_alert(Session, StatusData) ->
    {value, Uuid} = dataset:get_value(uuid, StatusData),
    case smarta_sched:get_task(Uuid) of
    [#monit_task{name = Name, sid = Sid} = _Task] ->
        {value, Summary} = dataset:get_value(summary, StatusData),
        Body = [to_list(Name), " 故障: ", to_list(Summary), "\n查看详细: http://www.monit.cn/services/", integer_to_list(Sid)],
        Msg = exmpp_message:make_chat(?NS_JABBER_CLIENT, lists:concat(Body)),
        Roster = ets:match(roster, {'_', '$1', '$2', '$3'}),
        lists:foreach(
            fun([Jid, _, available]) -> 
                ?INFO("send fault alert to: ~p", [Jid]),
                exmpp_session:send_packet(Session, exmpp_xml:set_attribute(Msg, to, Jid));
               (_) ->
                pass
        end, Roster);
    [] ->
        pass
    end.

%%internal functions.
make_jid(Name) ->
    {Node, Domain} = 
    case string:chr(Name, $@) of
    0 -> 
        {Name, <<"agent.monit.cn">>};
    Idx -> 
        {string:substr(Name, 1, Idx-1), string:substr(Name, Idx+1)}
    end,
    exmpp_jid:make(Node, Domain, <<"smarta">>).

amend_timedelta(Status, Timedelta) ->
    amend_timedelta(Status, Timedelta, []).

amend_timedelta([], _Timedelta, Acc) -> 
    Acc;
amend_timedelta([{timestamp, Timestamp}|T], Timedelta, Acc) ->
    amend_timedelta(T, Timedelta, [{timestamp, Timestamp + Timedelta}|Acc]);
amend_timedelta([{next_check_at, NextCheckAt}|T], Timedelta, Acc) ->
    amend_timedelta(T, Timedelta, [{next_check_at, NextCheckAt + Timedelta}|Acc]);
amend_timedelta([{last_check_at, LastCheckAt}|T], Timedelta, Acc) ->
    amend_timedelta(T, Timedelta, [{last_check_at, LastCheckAt + Timedelta}|Acc]);
amend_timedelta([H|T], _Timedelta, Acc) ->
    amend_timedelta(T, _Timedelta, [H|Acc]).

random_seq() ->
    random:uniform(1000000000).

