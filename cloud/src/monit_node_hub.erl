%%%----------------------------------------------------------------------
%%% File    : monit_node_hub.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : hub to connect with all nodes.
%%% Created : 13 Jan 2010
%%% Updated : 18 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_node_hub).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-behavior(gen_server).

-export([start_link/0, 
        parse_params/2,
        stop/0]). 

%callback
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

%% @spec () -> ok
%% @doc Stop the mit server.
stop() ->
	gen_server:call(?MODULE, stop).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    amqp:queue("task"),
    monit_object_event:attach({added, service}, self()),
    monit_object_event:attach({updated, service}, self()),
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
handle_call(stop, _From, State) ->
	{stop, normal, ok, State};

handle_call(Req, _From, State) ->
	?ERROR("unexpected requrest: ~p", [Req]),
    {reply, {unexpected_request}, State}.
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
handle_info({added, service, Object}, State) ->
    try dispatch(add, Object)
    catch
    _:Err ->
        Parents = monit_object:parents(Object#monit_object.id),
        ?ERROR("~p~n~p~n~p~n~p", [Err, Object, Parents, erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_info({updated, service, Object}, State) ->
    try dispatch(update, Object)
    catch
    _:Err ->
        Parents = monit_object:parents(Object#monit_object.id),
        ?ERROR("~p~n~p~n~p~n~p", [Err, Object, Parents, erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_info({deleted, service, Dn}, State) ->
    amqp:send(<<"task">>, term_to_binary({delete, Dn})),
    {noreply, State};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    monit_object_event:detach({added, service}, self()),
    monit_object_event:detach({updated, service}, self()),
    monit_object_event:detach({deleted, service}, self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
dispatch(Type, #monit_object{id = ObjectId, dn = Dn, attrs = Service}) ->
    ?INFO("dispatch service: ~p", [Dn]),
    {value, Params} = dataset:get_value(params, Service, undefined),
    NewParams = parse_params(ObjectId, Params),
    NewService = dataset:key_replace(params, Service, {params, NewParams}),
    amqp:send("task", term_to_binary({Type, Dn, NewService})).

parse_params(_ObjectId, undefined) ->
    undefined;

parse_params(ObjectId, Params) ->
    ParamList = [parse_param(ObjectId, S) || S <- string:tokens(to_list(Params), "&")],
    string:join([lists:concat([Key, "=", Val]) || {Key, Val} <- ParamList], "&").

parse_param(ObjectId, S) ->
    Idx = string:chr(S, $=),
    Key = string:substr(S, 1, Idx -1),
    Val = string:substr(S, Idx + 1),
    Val1 = 
    case Val of
    "${" ++ Var ->
        Var1 = string:substr(Var, 1, length(Var) - 1),
        parse_var(ObjectId, Var1);
    _ -> 
        Val
    end,
    {Key, Val1}.

parse_var(ObjectId, Var) ->
    Parents = monit_object:parents(ObjectId),
    Idx = string:chr(Var, $.),
    Class = list_to_atom(string:substr(Var, 1, Idx -1)),
    Attr = list_to_atom(string:substr(Var, Idx + 1)),
    #monit_object{attrs = Attrs} = find_object(Class, Parents),
    {value, Val} = dataset:get_value(Attr, Attrs),
    to_list(Val).

find_object(_Class, []) ->
    undefined;
find_object(Class, [#monit_object{class = Class} = Object | _T]) ->
    Object;
find_object(Class, [_H|T]) ->
    find_object(Class, T).
     
to_list(I) when is_integer(I) ->
    integer_to_list(I);

to_list(F) when is_float(F) ->
    float_to_list(F);

to_list(B) when is_binary(B) ->
    binary_to_list(B);

to_list(L) when is_list(L) ->
    L.

