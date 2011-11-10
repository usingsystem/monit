%%%----------------------------------------------------------------------
%%% File    : monit_object_type.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : management object type: device type, host type, application type
%%% Created : 15 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_object_type).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-export([start_link/0, 
         class_id/1, 
         class_tab/1, 
         class_name/1, 
         parent_types/1,
         stop/0]). 

-behavior(gen_server).

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

class_id(service) -> 0;
class_id(host) -> 1;
class_id(app) -> 2;
class_id(site) -> 3;
class_id(device) -> 4;
class_id(business) -> 5.

class_tab(0) -> services;
class_tab(1) -> hosts;
class_tab(2) -> apps;
class_tab(3) -> sites;
class_tab(4) -> devices;
class_tab(5) -> business.

class_name(0) -> service;
class_name(1) -> host;
class_name(2) -> app;
class_name(3) -> site;
class_name(4) -> device;
class_name(5) -> business.

parent_types(Id) when is_tuple(Id) ->
    parent_types(Id, []).

parent_types(Id, Acc) ->
    case ets:lookup(object_type, Id) of
    [#object_type{parent_id = undefined}] -> 
        Acc;
    [#object_type{parent_id = ParentId}] ->
        parent_types(ParentId, [ParentId | Acc]);
    [] ->
        Acc
    end.

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
    ets:new(object_type, [named_table, {keypos, 2}]),
    load_types(),
    erlang:send_after(300 * 1000, self(), reload_types),
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
    {reply, ok, State}.

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

handle_info(reload_types, State) ->
    load_types(),
    erlang:send_after(300 * 1000, self(), reload_types),
    {noreply, State};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

load_types() ->
    [load_types(Class, Tab) || {Class, Tab} <- [
        {app, app_types},
        {host, host_types},
        {device, device_types}]].

load_types(Class, Tab) ->
    {ok, Records} = mysql:select(Tab),
    lists:foreach(fun(Record) -> 
        {value, Id} = dataset:get_value(id, Record),    
        {value, Name} =dataset:get_value(name, Record),
        {value, ParentId} = dataset:get_value(parent_id, Record, undefined),
        ObjectType = #object_type{id = {Class,Id}, name = Name, parent_id = {Class, ParentId}},
        ets:insert(object_type, ObjectType)
    end, Records).

