%%%----------------------------------------------------------------------
%%% File    : monit_bot.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit xmpp robot: send notifications and respond commands
%%% Created : Feb. 16 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_bot).

-include("elog.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [to_list/1]).

-export([start_link/1, 
        stop/0]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3 ]).

-record(state, {jid, password, host, port, session, last_notification_id = 99999999}).

-record(xmpp_user, {bjid, username, id, tenant_id, presence}).

start_link(Args) -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Args], []).

stop() ->
    gen_server:call(?MODULE, stop).

init([Args]) ->
    case catch do_init(Args) of
    {ok, State} -> 
        mnesia:create_table(xmpp_user,
            [{ram_copies, [node()]}, {type, set}, {index, [username, id]},
             {attributes, record_info(fields, xmpp_user)}]),
        {ok, [Record|_]} = mysql:select(notifications, ['max(id) as max_id']),
        {value, MaxId} = dataset:get_value(max_id, Record),
        erlang:send_after(200 * 1000, self(), check_notifications),
        {ok, State#state{last_notification_id = MaxId}};
    {error, Reason} -> 
        {stop, Reason};
    {'EXIT', Error} -> 
        {stop, Error}
    end.

do_init(Args) ->
    JID = proplists:get_value(name, Args),
    Password = proplists:get_value(password, Args),
    Host = proplists:get_value(host, Args, "localhost"),
    Port = proplists:get_value(port, Args, 5288),
    Session = exmpp_component:start(),
    exmpp_component:auth(Session, JID, Password),
    {ok, _StreamId} = exmpp_component:connect(Session, Host, Port),
    ok = exmpp_component:handshake(Session),
    send_avail_presence(Session, JID, JID),
    {ok, #state{jid = JID, password = Password, 
                host = Host, port = Port, 
                session = Session}}.

handle_call(stop, _From, State) ->
    {stop, normal, ok, State};
    
handle_call(Req, _From, State) ->
    ?ERROR("unexpected request: ~p", [Req]),
    {reply, ok, State}.

handle_cast(stop, #state{session = Session} = State) ->
    exmpp_component:stop(Session),
    {stop, normal, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

handle_info(check_notifications, #state{session = Session, last_notification_id = MaxId} = State) ->
    {ok, Notifications} = mysql:select(notifications, {'and', {'>', id, MaxId}, {type_id, 1}}),
    LastId = 
    lists:foldl(fun(Notification, _Acc) -> 
        {value, Id} = dataset:get_value(id, Notification),
        send_notification(Session, Notification),
        Id
    end, MaxId, Notifications),
    erlang:send_after(200 * 1000, self(), check_notifications),
    {noreply, State#state{last_notification_id = LastId}};
    
handle_info(#received_packet{packet_type=message, type_attr="chat", 
        from=FromJID, raw_packet=Packet} = _ReceivedPacket,
        #state{jid = JID, session = Session} = State) ->
    try process_message(FromJID, Packet, State)
    catch
    _:Error ->
        ?WARNING("~p", [Error]),
        To = exmpp_xml:get_attribute(Packet, to, JID),
        From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
        Msg = exmpp_message:make_chat(?NS_COMPONENT_ACCEPT, "internal error!"),
        Msg1 = exmpp_xml:set_attribute(Msg, from, To),
        Msg2 = exmpp_xml:set_attribute(Msg1, to, From),
        exmpp_component:send_packet(Session, Msg2)
    end,
    {noreply, State};

handle_info(#received_packet{packet_type=presence, 
    type_attr=Type, from = FromJID} = _, State) ->
    process_presence(list_to_atom(Type), FromJID, State),
    {noreply, State};

handle_info(#received_packet{packet_type=iq, from = FromJID, 
        raw_packet = Packet} = _, State) ->
    process_iq(FromJID, Packet, State),
    {noreply, State};

handle_info(#received_packet{raw_packet=Packet} = _, State) ->
    ?WARNING("unexpected packet: ~p", [Packet]),
    {noreply, State};
    
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

process_message(FromJID, Packet, #state{jid = JID, session = Session} = _State) ->
    {User, <<"monit.cn">>, _} = FromJID,
    From = exmpp_jid:to_binary(exmpp_jid:make(FromJID)),
    Body = to_list(
             exmpp_xml:get_cdata(
                exmpp_xml:get_element(Packet, body))),
    ?INFO("~p", [Body]),
    Args = string:tokens(Body, "\t "),
    Output = 
    try monit_ctl:action(User, Args)
    catch 
    _:Err ->
        ?WARNING("~p", [Err]),
        "Internal Error!"
    end,
    Msg = exmpp_message:make_chat(?NS_COMPONENT_ACCEPT, Output),
    Msg1 = exmpp_xml:set_attribute(Msg, from, JID),
    Msg2 = exmpp_xml:set_attribute(Msg1, to, From),
    exmpp_component:send_packet(Session, Msg2).

process_presence(_Type, {_Node, <<"bot.monit.cn">>, _}, _State) ->
    ignore;

process_presence(probe, {Node, Domain, _} = FromJID, 
    #state{jid = JID, session = Session}) ->
    From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
    ?INFO("probe presence from ~p", [From]),
    update_user(available, Node, Domain),
    send_avail_presence(Session, JID, From);

process_presence(available, {Node, Domain, _Res}, _State) ->
    update_user(available, Node, Domain);

process_presence(unavailable, {Node, Domain, _}, _State) ->
    update_user(unavailable, Node, Domain);

process_presence(error, {Node, Domain, _}, _State) ->
    update_user(unavailable, Node, Domain);

process_presence(Type, FromJID, _State) ->
    From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
    ?INFO("~p presence from ~p", [Type, From]).
    
process_iq(FromJID, IQ, _State) ->
    From = exmpp_jid:to_list(exmpp_jid:make(FromJID)),
    Payload = exmpp_iq:get_payload(IQ),
    ?INFO("iq from ~p, payload: ~n ~p", [From, Payload]).

send_avail_presence(Session, From, To) ->
    Avail = exmpp_presence:available(),
    Avail1 = exmpp_xml:set_attribute(Avail, from, From),
    Avail2 = exmpp_xml:set_attribute(Avail1, to, To),
    exmpp_component:send_packet(Session, Avail2).

send_notification(Session, Notification) ->
    {value, UserId} = dataset:get_value(user_id, Notification),
    ?INFO("send notification: ~p", [UserId]),
    {value, Summary} = dataset:get_value(summary, Notification),
    case find_user(UserId) of
    {ok, #xmpp_user{bjid = JID, presence = available} = _User} ->
        Msg = exmpp_message:make_chat(?NS_COMPONENT_ACCEPT, Summary),
        Msg1 = exmpp_xml:set_attribute(Msg, from, <<"bot@bot.monit.cn">>),
        Msg2 = exmpp_xml:set_attribute(Msg1, to, JID),
        exmpp_component:send_packet(Session, Msg2);
    {ok, _} ->
        pass;
    false ->
        pass
    end.
     
update_user(Presence, Node, Domain) ->
    %?INFO("update presence: ~p, ~p, ~p", [Presence, Node, Domain]),
    case find_user(Node, Domain) of
    {ok, User} ->
        mnesia:sync_dirty(fun() -> 
            mnesia:write(User#xmpp_user{presence = Presence}) 
        end);
    false ->
        ?WARNING("security alert, unexpected user: ~p@~p", [Node, Domain])
    end.

find_user(Node, Domain) ->
    case mnesia:dirty_read(xmpp_user, exmpp_jid:to_binary(Node, Domain)) of
    [] ->
        case mysql:select(users, {username, Node}) of
        {ok, [Record|_]} ->
            {value, Id} = dataset:get_value(id, Record),
            {value, UserName} = dataset:get_value(username, Record),
            {value, TenantId} = dataset:get_value(tenant_id, Record),
            Bjid = <<UserName/binary, <<"@monit.cn">>/binary>>,
            User = #xmpp_user{bjid = Bjid, id = Id, username = UserName, 
                tenant_id = TenantId, presence = unavailable},
            mnesia:sync_dirty(fun() -> mnesia:write(User) end),
            {ok, User};
        {ok, []} -> 
            false
        end;
    [User] ->
        {ok, User}
    end.

find_user(Id) when is_integer(Id) ->
    case mnesia:dirty_index_read(xmpp_user, Id, #xmpp_user.id) of
    [User|_] ->
        {ok, User};
    [] ->
        false
    end.

