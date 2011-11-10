%%%----------------------------------------------------------------------
%%% File    : monit_agent_hub.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit agents
%%% Created : Feb. 16 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_agent_hub).

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [to_list/1, to_binary/1]).

-export([start_link/1, connect/0, stop/0]).

-export([find_agent/1, 
         find_agent/2,
         send_packet/1]).

%%callback
-export([callback/2,
        uncallback/2]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {jid, password, host, port, session}).

start_link(Args) -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Args], []).

connect() ->
    gen_server:call(?MODULE, connect).

send_packet(Packet) ->
    gen_server:cast(?MODULE, {send, Packet}).

stop() ->
    gen_server:call(?MODULE, stop).

callback(Hook, Pid) ->
    gen_server:call(?MODULE, {callback, Hook, Pid}).

uncallback(Hook, Pid) ->
    gen_server:cast(?MODULE, {uncallback, Hook, Pid}).

init([Args]) ->
    case catch do_init(Args) of
    {ok, State} -> 
        cache_agents(),
        add_listeners(),
        {ok, State};
    {error, Reason} -> 
        {stop, Reason};
    {'EXIT', Error} -> 
        {stop, Error}
    end.

do_init(Args) ->
    {A1, A2, A3} = now(),
    random:seed(A1, A2, A3),
    JID = proplists:get_value(name, Args),
    Password = proplists:get_value(password, Args),
    Host = proplists:get_value(host, Args, "localhost"),
    Port = proplists:get_value(port, Args, 5288),
    ets:new(callback, [bag, protected, named_table]),
    {ok, #state{jid = JID, password = Password, host = Host, port = Port}}.

cache_agents() ->
    mnesia:create_table(monit_agent,
        [{ram_copies, [node()]}, {type, set}, {index, [username, id]},
         {attributes, record_info(fields, monit_agent)}]),
    mysql:update(agents, [{presence, <<"unavailable">>}], {'>', id, 0}),
    {ok, Agents} = mysql:select(agents, [id, username, tenant_id]),
    lists:foreach(fun(Agent) -> 
        {value, Id} = dataset:get_value(id, Agent),
        {value, UserName} = dataset:get_value(username, Agent),
        {value, TenantId} = dataset:get_value(tenant_id, Agent),
        Bjid = <<UserName/binary, <<"@agent.monit.cn">>/binary>>,
        mnesia:sync_dirty(fun() -> 
            mnesia:write(#monit_agent{bjid = Bjid, id = Id, 
                username = UserName, tenant_id = TenantId, 
                presence = <<"unavailable">>}) 
        end)
    end, Agents).

add_listeners() ->
    monit_object_event:attach({agent, added, service}, self()),
    monit_object_event:attach({agent, updated, service}, self()),
    monit_object_event:attach({agent, deleted, service}, self()).

handle_call(connect, _From, #state{jid = JID, password = Password, 
    host = Host, port = Port} = State) ->
    Session = exmpp_component:start(),
    exmpp_component:auth(Session, JID, Password),
    {ok, _StreamId} = exmpp_component:connect(Session, Host, Port),
    ok = exmpp_component:handshake(Session),
    erlang:send_after(1000, self(), avail),
    {reply, ok, State#state{session = Session}};

handle_call(stop, _From, #state{session = Session} = State) ->
    exmpp_component:stop(Session),
    {stop, normal, ok, State};

handle_call({callback, Hook, Pid}, _From, State) ->
    ets:insert(callback, {Hook, Pid}),
    {reply, ok, State};
    
handle_call(Req, _From, State) ->
   ?ERROR("unexpected request: ~p", [Req]),
    {reply, ok, State}.

handle_cast({uncallback, Hook, Pid}, State) ->
    ets:delete_object(callback, {Hook, Pid}),
    {noreply, State};

handle_cast({send, Packet}, #state{session = Session} = State) ->
    exmpp_component:send_packet(Session, Packet),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

handle_info(avail, #state{jid = JID, session = Session} = State) ->
    Avail = exmpp_presence:available(),
    Avail1 = exmpp_xml:set_attribute(Avail, from, JID),
    Avail2 = exmpp_xml:set_attribute(Avail1, to, JID),
    exmpp_component:send_packet(Session, Avail2),
    spawn(fun() -> probe_all_agents(JID, Session) end),
    {noreply, State};

handle_info({added, service, #monit_object{attrs = Service}, AgentId}, 
    #state{jid = JID, session = Session} = State) ->
    case find_agent(AgentId) of
    {ok, Agent} ->
        inform_service_update(Agent, Service, JID, Session);
    false ->
        ?WARNING("cannot find agent with id: ~p", [AgentId])
    end,
    {noreply, State};

handle_info({updated, service, #monit_object{attrs = Service}, AgentId}, 
    #state{jid = JID, session = Session} = State) ->
    case find_agent(AgentId) of
    {ok, Agent} ->
        inform_service_update(Agent, Service, JID, Session);
    false ->
        ?WARNING("cannot find agent with id: ~p", [AgentId])
    end,
    {noreply, State};

handle_info({deleted, service, Uuid, AgentId}, 
    #state{jid = JID, session = Session} = State) ->
    case find_agent(AgentId) of
    {ok, Agent} ->
        inform_service_delete(Agent, Uuid, JID, Session);
    false ->
        ?WARNING("cannot find agent with id: ~p", [AgentId])
    end,
    {noreply, State};
    
handle_info(#received_packet{packet_type=presence, 
    type_attr = Type, from = FromJID}, State) ->
    process_presence({list_to_atom(Type), FromJID}, State),
	{noreply, State};

handle_info(#received_packet{packet_type=message, 
    type_attr = Type, from = FromJID, raw_packet = Packet}, State) ->
    process_message({list_to_atom(Type), FromJID, Packet}, State),
	{noreply, State};

handle_info(#received_packet{packet_type=iq, type_attr = Type, 
    from = FromJID, id = Id, raw_packet=IQ}, State) ->
    Payload = exmpp_iq:get_payload(IQ),
    if
    Payload == undefined ->
        pass;
    true ->
        NS = exmpp_xml:get_ns_as_atom(exmpp_iq:get_payload(IQ)),
        process_iq({NS, list_to_atom(Type), FromJID, Id, IQ}, State)
    end,
	{noreply, State};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    monit_object_event:detach({agent, added, service}, self()),
    monit_object_event:detach({agent, updated, service}, self()),
    monit_object_event:detach({agent, deleted, service}, self()),
    ok.

%-----------------------------------------------
%presence from self.
process_presence({_Type, {_Node, <<"cloud.monit.cn">>, _Res}}, _State) ->
    ignore;

process_presence({probe, {Node, Domain, _}}, #state{jid = JID, session = Session}) ->
    case find_agent(Node, Domain) of
    {ok, _Agent} ->
        From = exmpp_jid:to_binary(Node, Domain),
        Attrs = [exmpp_xml:attribute(from, JID), 
                 exmpp_xml:attribute(to, From)],
        Avail = exmpp_xml:set_attributes(exmpp_presence:available(), Attrs),
        exmpp_component:send_packet(Session, Avail),
        update_agent(<<"available">>, Node, Domain);
    false ->
        ?WARNING("security alert: unexpected probe from agent ~p@~p", [Node, Domain])
    end;

process_presence({available, {Node, Domain, _Res}}, _State) ->
    update_agent(<<"available">>, Node, Domain);

process_presence({unavailable, {Node, Domain, _}}, _State) ->
    update_agent(<<"unavailable">>, Node, Domain);

process_presence({error, {Node, Domain, _}}, _State) ->
    update_agent(<<"unavailable">>, Node, Domain);

process_presence({Type, FromT}, _State) ->
    From = exmpp_jid:to_binary(exmpp_jid:make(FromT)),
    ?WARNING("unexpected '~p' presence from ~p", [Type, From]).

process_message({normal, FromJID, Packet}, _State) ->
    Body = exmpp_xml:get_cdata(exmpp_xml:get_element(Packet, body)),
    try process_data(FromJID, Body)
    catch
    _:Err ->
        ?ERROR("failed to process normal message, err: ~p, body: ~n~p", [Err, Body])
    end;

process_message({chat, FromJID, Packet}, _State) ->
    From = exmpp_jid:to_binary(exmpp_jid:make(FromJID)),
    ?WARNING("chat message from ~p packet: ~n~p", [From, Packet]);

process_message({_Type, FromJID, Packet}, _State) ->
    From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
    ?WARNING("unexpected message from ~p packet: ~n~p", [From, Packet]).

process_iq({'monit:iq:time', get, {Node, Domain, _}, _Id, IQ} = _Packet, _State) -> 
    ?INFO("iq:time from ~p@~p", [Node, Domain]),
    T3 = T2 = extbif:timestamp(),
    Attrs = [exmpp_xml:attribute(Name, integer_to_list(Time)) || 
        {Name, Time} <- [{t3, T3}, {t2, T2}]],
    Item = exmpp_xml:set_attributes(exmpp_xml:element(item), Attrs),
    Query = exmpp_xml:element('monit:iq:time', 'query', [], [Item]),
    Result = exmpp_iq:result(IQ, Query),
    send_packet(Result);

process_iq({NS, error, {Node, Domain, _}, _Id, IQ} = _Packet, _State) -> 
    ?INFO("error iq: ~p ~p ~p ~n ~p", [NS, Node, Domain, IQ]);

process_iq({NS, _Type, {Node, Domain, _}, _Id, _IQ} = Packet, _State) -> 
    case find_agent(Node, Domain) of
    {ok, Agent} ->
        Callbacks = ets:lookup(callback, {iq, NS}),
        [Pid ! {iq, Agent, Packet} || {_Hook, Pid} <- Callbacks];
    false ->
        ?WARNING("security alert, unexpected agent: ~p@~p", [Node, Domain])
    end;

process_iq(IQ, _State) ->
    ?WARNING("unexpected iq: ~p", [IQ]).

inform_service_update(Agent, Service, JID, Session) ->
    Item = monit_service:to_xml_item(Service),
    Query = exmpp_xml:element('monit:iq:service#items', 'query', [], [Item]),
    IQ = exmpp_iq:set(?NS_COMPONENT_ACCEPT, Query, "set_" ++ integer_to_list(random_seq())),
    IQ1 = exmpp_xml:set_attribute(IQ, from, JID),
    To = Agent#monit_agent.bjid,
    IQ2 = exmpp_xml:set_attribute(IQ1, to, <<To/binary, "/smarta">>),
    inform_agent(Agent, IQ2, Session).

inform_service_delete(Agent, Uuid, JID, Session) ->
    ?INFO("inform service delete: ~p, ~p", [Uuid, Agent]),
    Attrs = [exmpp_xml:attribute(uuid, Uuid), 
             exmpp_xml:attribute(action, <<"remove">>)],
    Item = exmpp_xml:set_attributes(exmpp_xml:element(item), Attrs),
    Query = exmpp_xml:element('monit:iq:service#items', 'query', [], [Item]),
    IQ = exmpp_iq:set(?NS_COMPONENT_ACCEPT, Query, "set_" ++ integer_to_list(random_seq())),
    IQ1 = exmpp_xml:set_attribute(IQ, from, JID),
    To = Agent#monit_agent.bjid,
    IQ2 = exmpp_xml:set_attribute(IQ1, to, <<To/binary, "/smarta">>),
    inform_agent(Agent, IQ2, Session).

inform_agent(Agent, IQ, Session) ->
    case Agent#monit_agent.presence of
    <<"available">> ->
        exmpp_component:send_packet(Session, IQ);
    _Other ->
        ?INFO("agent '~p' presence: ~p", [Agent#monit_agent.bjid, 
            Agent#monit_agent.presence]),
        ok
    end.

process_data({Node, Domain, _}, Body) ->
    From = exmpp_jid:to_binary(Node, Domain),
    case mnesia:dirty_read(monit_agent, From) of
    [_Agent] ->
        case binary_to_term(base64:decode(Body)) of
        {status, Status} ->
            monit_status ! {status, Status};
        Other ->
            ?WARNING("unexpected data: ~p", [Other])
        end;
    [] -> 
        ?WARNING("security alert, unknown agent: ~p", [From])
    end.

find_agent(Id) when is_integer(Id) ->
    case mnesia:dirty_index_read(monit_agent, Id, #monit_agent.id) of
    [] ->
        case mysql:select(agents, {id, Id}) of
        {ok, [Record|_]} ->
            {value, Id} = dataset:get_value(id, Record),
            {value, UserName} = dataset:get_value(username, Record),
            {value, TenantId} = dataset:get_value(tenant_id, Record),
            Bjid = <<UserName/binary, <<"@agent.monit.cn">>/binary>>,
            Agent = #monit_agent{bjid = Bjid, id = Id, username = UserName, 
                tenant_id = TenantId, presence = <<"unavailable">>},
            mnesia:sync_dirty(fun() -> mnesia:write(Agent) end),
            {ok, Agent};
        {ok, []} -> 
            false
        end;
    [Agent|_] ->
        {ok, Agent}
    end.

find_agent(Node, Domain) ->
    case mnesia:dirty_read(monit_agent, exmpp_jid:to_binary(Node, Domain)) of
    [] ->
        case mysql:select(agents, {username, Node}) of
        {ok, [Record|_]} ->
            {value, Id} = dataset:get_value(id, Record),
            {value, UserName} = dataset:get_value(username, Record),
            {value, TenantId} = dataset:get_value(tenant_id, Record),
            Bjid = <<UserName/binary, <<"@agent.monit.cn">>/binary>>,
            Agent = #monit_agent{bjid = Bjid, id = Id, username = UserName, 
                tenant_id = TenantId, presence = <<"unavailable">>},
            mnesia:sync_dirty(fun() -> mnesia:write(Agent) end),
            {ok, Agent};
        {ok, []} -> 
            false
        end;
    [Agent] ->
        {ok, Agent}
    end.

probe_all_agents(JID, Session) ->
    Keys = mnesia:all_keys(monit_agent),
    probe_agent(Keys, JID, Session).

probe_agent([Bjid|T], JID, Session) ->
    Probe = exmpp_presence:probe(),
    Attrs = [exmpp_xml:attribute(from, JID),
        exmpp_xml:attribute(to, Bjid)],
    exmpp_component:send_packet(Session,
        exmpp_xml:set_attributes(Probe, Attrs)),
    timer:sleep(5),
    probe_agent(T, JID, Session);

probe_agent([], _JID, _Session) ->
    ok.

update_agent(Presence, Node, Domain) ->
    ?INFO("update presence: ~p, ~p, ~p", [Presence, Node, Domain]),
    case find_agent(Node, Domain) of
    {ok, Agent} ->
        UpdatedAt = {datetime, {date(), time()}},
        mysql:update(agents, [{presence, Presence}, {updated_at, UpdatedAt}], {username, Node}),
        mnesia:sync_dirty(fun() -> 
            mnesia:write(Agent#monit_agent{presence = Presence}) 
        end);
    false ->
        ?WARNING("security alert, unexpected agent: ~p@~p", [Node, Domain])
    end.
    
random_seq() ->
    random:uniform(100000000).


