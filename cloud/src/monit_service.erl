%%%----------------------------------------------------------------------
%%% File    : monit_service.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit service management
%%% Created : 12 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_service).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-behavior(gen_server).

-export([start_link/0]).

-export([to_xml_item/1]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {consumer_tag}).

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
    amqp:queue("service"),
    {ok, Tag} = amqp:consume("service", self()),
    monit_agent_hub:callback({iq, 'monit:iq:service#items'}, self()),
    monit_agent_hub:callback({iq, 'monit:iq:service#info'}, self()),
    {ok, #state{consumer_tag = Tag}}.
%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

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
handle_info({iq, Agent, {'monit:iq:service#items', get, {Node, Domain, _Res}, _Id, IQ}}, State) ->
    AgentId = Agent#monit_agent.id,
    TenantId = Agent#monit_agent.tenant_id,
    {ok, Services} = mysql:select(services, [uuid], {'and', {agent_id, AgentId}, {tenant_id, TenantId}}),
    Items = 
    lists:map(fun(Service) -> 
        {value, Uuid} = dataset:get_value(uuid, Service),
        exmpp_xml:set_attribute(exmpp_xml:element(item), 
            exmpp_xml:attribute(uuid, Uuid))
    end, Services),
    Result = exmpp_iq:result(IQ, exmpp_xml:element('monit:iq:service#items', 'query', [], Items)),
    monit_agent_hub:send_packet(Result),
    {noreply, State};

handle_info({iq, Agent, {'monit:iq:service#info', get, {Node, Domain, _Res}, _Id, IQ}}, State) ->
    Query = exmpp_iq:get_payload(IQ),
    Uuid = exmpp_xml:get_attribute(Query, uuid, ""),
    case mysql:select(services, {'and', {agent_id, Agent#monit_agent.id}, {uuid, Uuid}}) of
    {ok, [Service|_]} ->
        Item = to_xml_item(Service),
        Result = exmpp_iq:result(IQ, exmpp_xml:element('monit:iq:service#info', 'query', [], [Item])),
        monit_agent_hub:send_packet(Result);
    {ok, []} ->
        ?WARNING("cannot find service: ~p", [Uuid])
        %%TODO: IQ Error??
        %Result = exmpp_iq:error(IQ, exmpp_xml:element('monit:iq:service#info', 'query', [], [Item])),
        %exmpp_component:send_packet(Session, Result)
    end,
    {noreply, State};

handle_info({deliver, <<"serivce">>, _Props, Payload}, State) ->
    case binary_to_term(Payload) of
    {update, Service} ->
        {value, Uuid} = dataset:get_value(uuid, Service),
        mysql:update(services, Service, {uuid, Uuid});
    Other ->
        ?ERROR("unknown payload: ~p", [Other])
    end,
    {noreply, State};

handle_info(Info, State) ->
    ?WARNING("~p", [Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, #state{consumer_tag = Tag} = _State) ->
    amqp:cancel(Tag),
    monit_agent_hub:uncallback({iq, 'monit:iq:service#items'}, self()),
    monit_agent_hub:uncallback({iq, 'monit:iq:service#info'}, self()),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

to_xml_item(Service) ->
    Item = exmpp_xml:element(item),
    {value, Id} = dataset:get_value(id, Service),
    {value, Uuid} = dataset:get_value(uuid, Service),
    {value, Name} = dataset:get_value(name, Service),
    {value, CheckInterval} = dataset:get_value(check_interval, Service, 300),
    {value, AttemptInterval} = dataset:get_value(attempt_interval, Service, 60),
    {value, MaxAttempts} = dataset:get_value(max_attempts, Service, 3),
    {value, Command} = dataset:get_value(command, Service),
    {value, External} = dataset:get_value(external, Service, 1),
    {value, Params} = dataset:get_value(params, Service, ""),
    {value, IsCollect} = dataset:get_value(is_collect, Service, 1),
    {value, Warning} = dataset:get_value(threshold_warning, Service, ""),
    {value, Critical} = dataset:get_value(threshold_critical, Service, ""),
    Attrs = [exmpp_xml:attribute(uuid, Uuid),
             exmpp_xml:attribute(id, integer_to_list(Id)),
             exmpp_xml:attribute(name, Name),
             exmpp_xml:attribute(check_interval, integer_to_list(CheckInterval)),
             exmpp_xml:attribute(attempt_interval, integer_to_list(AttemptInterval)),
             exmpp_xml:attribute(max_attemps, integer_to_list(MaxAttempts)),
             exmpp_xml:attribute(command, Command),
             exmpp_xml:attribute(external, boolean_s(External)),
             exmpp_xml:attribute(params, parse_params(Id, Params)),
             exmpp_xml:attribute(is_collect, boolean_s(IsCollect)),
             exmpp_xml:attribute(threshold_warning, Warning),
             exmpp_xml:attribute(threshold_critical, Critical)],
    exmpp_xml:set_attributes(Item, Attrs).

parse_params(Id, Params) ->
    try monit_node_hub:parse_params({service, Id}, Params)
    catch
    _:Ex ->
        ?ERROR("~p, ~p, ~p", [Ex, Id, Params]),
        ""
    end.

boolean_s(0) -> "false";

boolean_s(1) -> "true".

