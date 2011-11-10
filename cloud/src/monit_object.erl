%%%----------------------------------------------------------------------
%%% File    : monit_object.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : management object: device, host, application, site, service
%%% Created : 13 May 2010
%%% Created : 17 Nov 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_object).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(monit_object_type, [class_name/1]).

-export([start_link/0, 
        stop/0]). 

%%mit operation
-export([load/1,
        add/1,
        lookup/1, 
        update/1,
        delete/1,
        parents/1]).

-behavior(gen_server).

%callback
-export([init/1, 
		 handle_call/3, 
		 handle_cast/2, 
		 handle_info/2, 
		 terminate/2, 
		 code_change/3]).

-define(SERVER, ?MODULE).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%create service object
load({service, Id}) ->
    {ok, [Service]} = mysql:select(services, {id, Id}),
    {value, Rdn} = dataset:get_value(rdn, Service),
    {value, ObjectId} = dataset:get_value(object_id, Service),
    {value, ObjectType} = dataset:get_value(object_type, Service),
    Bdn = lists:concat([class_name(ObjectType), "=", ObjectId]),
    Dn = list_to_binary([Bdn, <<",">>, Rdn]),
    Parent = {class_name(ObjectType), ObjectId},
    #monit_object{id = {service, Id}, dn = Dn, parent = Parent, 
        class = service, attrs = Service};

%%add device
load({device, Id}) -> 
    {ok, [Device]} = mysql:select(devices, {id, Id}),
    Dn = list_to_binary(["device=", integer_to_list(Id)]),
    #monit_object{id = {device, Id}, dn = Dn, class = device, attrs = Device};

%%add host
load({host, Id}) -> 
    {ok, [Host]} = mysql:select(hosts, {id, Id}),
    Dn = list_to_binary(["host=", integer_to_list(Id)]),
    #monit_object{id = {host, Id}, dn = Dn, class = host, attrs = Host};

%%add site
load({site, Id}) -> 
    {ok, [Site]} = mysql:select(sites, {id, Id}),
    Dn = list_to_binary(["site=", integer_to_list(Id)]),
    #monit_object{id = {site, Id}, dn = Dn, class = site, attrs = Site};

%%add application
load({app, Id}) ->
    {ok, [App]} = mysql:select(apps, {id, Id}),
    Dn = lists:concat(["app=", Id]),
    case dataset:get_value(host_id, App) of
    {value, HostId} ->
        #monit_object{id = {app, Id}, dn = list_to_binary(Dn), 
            parent = {host, HostId}, class = app, attrs = App};
    false ->
        #monit_object{id = {app, Id}, dn = list_to_binary(Dn),
            class = app, attrs = App}
    end.

lookup({Class, Id}) ->
    case mnesia:dirty_read(monit_object, {Class, Id}) of
    [Object] -> 
        {ok, Object};
    [] ->
        false
    end;

lookup(Dn) when is_list(Dn) ->
    lookup(list_to_binary(Dn));

lookup(Dn) when is_binary(Dn) ->
    case mnesia:dirty_index_read(monit_object, Dn, #monit_object.dn) of
    [Object] ->
        {ok, Object};
    [] ->
        false
    end.

add(Object) when is_record(Object, monit_object) ->
    gen_server:call(?MODULE, {add, Object}).

update(Object) when is_record(Object, monit_object) ->
    gen_server:call(?MODULE, {update, Object}).

delete({Class, Id}) -> 
    gen_server:call(?MODULE, {delete, {Class, Id}});

delete(Dn) when is_list(Dn) ->
    delete(list_to_binary(Dn));

delete(Dn) when is_binary(Dn) ->
    gen_server:call(?MODULE, {delete, Dn}).

parents({Class, Id}) ->
    case mnesia:dirty_read(monit_object, {Class, Id}) of
    [Object] -> parents1(Object, []);
    [] -> []
    end.

parents1(#monit_object{parent = undefined}, Acc) ->
    lists:reverse(Acc);

parents1(#monit_object{parent = ParentId}, Acc) ->
     case mnesia:dirty_read(monit_object, ParentId) of
     [Parent] -> parents1(Parent, [Parent|Acc]);
     [] -> lists:reverse(Acc)
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
    mnesia:create_table(monit_object,
        [{ram_copies, [node()]}, {index, [dn, parent]},
         {attributes, record_info(fields, monit_object)}]),
    mnesia:add_table_copy(monit_object, node(), ram_copies),
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
handle_call({add, Object}, _From, State) ->
    mnesia:dirty_write(Object),
    {reply, ok, State};

handle_call({update, Object}, _From, State) ->
    mnesia:dirty_write(Object),
    {reply, ok, State};

handle_call({delete, {Class, Id}}, _From, State) ->
    mnesia:dirty_delete(monit_object, {Class, Id}),
    {reply, ok, State};

handle_call({delete, Dn}, _From, State) ->
    Objects = mnesia:dirty_index_read(monit_object, Dn, #monit_object.dn),
    [mnesia:dirty_delete_object(Object) || Object <- Objects],
    {reply, ok, State};

handle_call(stop, _From, State) ->
	{stop, normal, ok, State};

handle_call(Req, _From, State) ->
	?ERROR("unexpected requrest: ~p", [Req]),
    {reply, ok, State}.
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
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

